//
//  ContentView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jens Legarth Ryge on 14/02/2023.
//

import SwiftUI

//Object that represents a note entry
struct NoteEntry:Decodable, Encodable, Identifiable{
    var id = UUID()
    var title:String
    var body:String
}

struct ContentView: View {
    var fService = FirebaseService()
    @State var noteEntries: [NoteEntry] = []
    //Visual representation
    var body: some View {
        NavigationView{
            VStack{
                HStack(spacing: 200.0) {
                    EditButton()
                        .frame(width: 80, height: 30)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                    Button("Add"){
                        fService.addNote(title: "New Note", body:"Preview")
                        fService.startListener()
                    }.frame(width: 80, height: 30)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                }
                List(noteEntries.indices, id: \.self) { index in
                    NavigationLink(destination: DetailView(noteEntry: self.$noteEntries[index], noteEntries: $noteEntries)) {
                        Text(self.noteEntries[index].title)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
