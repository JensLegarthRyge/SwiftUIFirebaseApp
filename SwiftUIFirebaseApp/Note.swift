//
//  Note.swift
//  SwiftUIFirebaseApp
//
//  Created by Jens Legarth Ryge on 14/02/2023.
//

import Foundation
import UIKit

class Note:Identifiable {
    var id: String
    var title: String
    var body: String
    var image:UIImage? = nil
    var hasImage: Bool
    
    init(id: String, title: String, body: String, hasImage: Bool){
        self.id = id
        self.title = title
        self.body = body
        self.hasImage = hasImage
    }
}
