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
    
    func readImage(){
        let imageRef = storage.reference(withPath: "mountain.jpeg")
        imageRef.getData(maxSize: 5000000){ data, error in
            if error == nil {
                let image = UIImage(data: data!)
                print(image.debugDescription)
            } else{
                print("ERROR: An error occured downloading image \(error.debugDescription)")
            }
        }
    }
    
    func createImage(){
        if let img = UIImage(named:"mountain"){
            let data = img.jpegData(compressionQuality: 1.0)! //Forcefully unwrap
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            let ref = storage.reference().child("mountain.jpeg")
            ref.putData(data, metadata: metaData){meta, error in
                if error == nil {
                    print("OK: Uploading image...")
                } else {
                    print("ERROR: An error occured uploading image")
                }
            }
        }
    }
    
    func createNote(title:String, body:String){
        let doc = db.collection(notes).document() // creates a new empty document
        var data = [String:String]() // creates a new empty dictionary
        data["title"] = title
        data["body"] = body
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
        let referencedNote = db.collection(notes).document(noteToUpdate.id)
        referencedNote.updateData(["title": noteToUpdate.title, "body": noteToUpdate.body]) { error in
            if let error = error {
                print("An error occurred while updating the note: \(error)")
            } else {
                print("Note updated successfully")
            }
        }
    }
}
