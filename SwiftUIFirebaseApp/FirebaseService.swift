//
//  FirebaseService.swift
//  SwiftUIFirebaseApp
//
//  Created by Jens Legarth Ryge on 14/02/2023.
//

import Foundation
import Firebase

class FirebaseService{
    private var db = Firestore.firestore() // holds the database object
    private let notes = "notes"
    var notesColl = [Note]()
    
    
    
    
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
