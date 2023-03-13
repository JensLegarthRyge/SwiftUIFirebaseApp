//
//  FirebaseService.swift
//  SwiftUIFirebaseApp
//
//  Created by Jens Legarth Ryge on 14/02/2023.
//

import Foundation
import Firebase
import FirebaseStorage
//handles images and stuff
import UIKit

class FirebaseService: ObservableObject{
    private var db = Firestore.firestore() // holds the database object
    private var storage = Storage.storage()
    private let notes = "notes"
    @Published var notesColl = [Note]()
    private let hasImage = "hasImage"
    
    func createImage(note:Note){
        if let img = note.image{
            let data = img.jpegData(compressionQuality: 1)!
            let imageRef = storage.reference().child(note.id)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            imageRef.putData(data, metadata: metaData) { meta, error in
                if error != nil {
                    print("An error occured uploading image: \(error.debugDescription)")
                }
            }
        }
    }
    
    func readImage(note: Note, completion: @escaping (UIImage?) -> Void){
        let imageRef = storage.reference(withPath: note.id)
        imageRef.getData(maxSize: 7000000){ data, error in
            if error == nil {
                completion(UIImage(data: data!))
            }else{
                print("An error occured downloading image: \(error.debugDescription)")
            }
        }
    }
    
    func deleteImage(note:Note){
        let imageRef = storage.reference().child(note.id)
        imageRef.delete { error in
            if error == nil {
                print("deleted image \(note.id)")
            } else {
                print("failed to deleted image \(note.id) with error \(error.debugDescription)")
            }
        }
    }

    
    func createNote(title:String, body:String){
        let doc = db.collection(notes).document() // creates a new empty document
        var data = [String:Any]() // creates a new empty dictionary
        data["title"] = title
        data["body"] = body
        data[hasImage] = false
        doc.setData(data) // saves to Firestore.
    }
    
    func readNotes(){
        db.collection(notes).addSnapshotListener { snap, error in
            if let e = error {
                print("An error occured while loading data \(e)")
            } else {
                if let snap = snap {
                    self.notesColl.removeAll()
                    for doc in snap.documents {
                        if let body = doc.data()["body"] as? String, let title = doc.data()["title"] as? String, let hasImage = doc.data()[self.hasImage] as? Bool {
                            let note = Note(id:doc.documentID, title: title, body: body, hasImage: hasImage)
                            self.notesColl.append(note)
                        }
                    }
                }
            }
        }
    }
    
    func updateNote(noteToUpdate: Note) {
        if noteToUpdate.image != nil{
            createImage(note: noteToUpdate)
        }
        if !noteToUpdate.hasImage{
            deleteImage(note: noteToUpdate)
        }
        let referencedNote = db.collection(notes).document(noteToUpdate.id)
        referencedNote.updateData(["title": noteToUpdate.title, "body": noteToUpdate.body, "hasImage": noteToUpdate.hasImage]) { error in
            if let error = error {
                print("An error occurred while updating the note: \(error)")
            } else {
                print("Note updated successfully")
            }
        }
    }
}
