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
    //File storage
    private var storage = Storage.storage()
    private let notes = "notes"
    @Published var notesColl = [Note]()
    
    func downloadImage(){
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
    
    func uploadImage(){
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
    
    func addNote(title:String, body:String){
        let doc = db.collection(notes).document() // creates a new empty document
        var data = [String:String]() // creates a new empty dictionary
        data["title"] = title
        data["body"] = body
        doc.setData(data) // saves to Firestore.
    }
    
    func startListener(){
        db.collection(notes).addSnapshotListener { snap, error in
            if let e = error {
                print("An error occured while loading data \(e)")
            } else {
                if let snap = snap {
                    self.notesColl.removeAll()
                    for doc in snap.documents {
                        if let body = doc.data()["body"] as? String, let title = doc.data()["title"] as? String {
                            let note = Note(id:doc.documentID, title: title, body: body)
                            self.notesColl.append(note)
                        }
                    }
                }
            }
        }
    }
    
}
