//
//  Note.swift
//  SwiftUIFirebaseApp
//
//  Created by Jens Legarth Ryge on 14/02/2023.
//

import Foundation

class Note:Identifiable {
    var id: String
    var title: String
    var body: String
    
    init(id: String, title: String, body: String){
        self.id = id
        self.title = title
        self.body = body
    }
}
