//
//  DetailView.swift
//  MyNotebook
//
//  Created by Jens Legarth Ryge on 07/02/2023.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var noteEntry:NoteEntry
    @Binding var noteEntries:[NoteEntry]
    
    var body: some View {
        VStack {
            TextField("Title", text: $noteEntry.title)
                .padding()
                .padding(.bottom, -30.0)
                .frame(maxWidth: .infinity, alignment: .top)
                .font(.title)
                .fontWeight(.bold)
            TextField("Body", text: $noteEntry.body)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .onDisappear {
            // Save the updated noteEntries array to UserDefaults when the view disappears
            let data = try! JSONEncoder().encode(noteEntries)
            UserDefaults.standard.set(data, forKey: "noteEntries")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let noteEntries = [NoteEntry(title: "Preview", body: "This is a preview")]
                return DetailView(noteEntry: .constant(noteEntries[0]), noteEntries: .constant(noteEntries))
    }
}
