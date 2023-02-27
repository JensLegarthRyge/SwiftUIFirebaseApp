//
//  DetailView.swift
//  MyNotebook
//
//  Created by Jens Legarth Ryge on 07/02/2023.
//

import SwiftUI

struct DetailViewDemo: View {
    @Binding var note:Note
    
    var body: some View {
        VStack {
            TextField("Title", text: $note.title)
                .padding()
                .padding(.bottom, -30.0)
                .frame(maxWidth: .infinity, alignment: .top)
                .font(.title)
                .fontWeight(.bold)
            TextField("", text: $note.body)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .onDisappear {
            // Save the updated noteEntries array to UserDefaults when the view disappears
        }
    }
}

struct DetailViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        let note = Note(id:"12",title:"Preview",body:"Preview")
        return DetailViewDemo(note:.constant(note))
    }
}
