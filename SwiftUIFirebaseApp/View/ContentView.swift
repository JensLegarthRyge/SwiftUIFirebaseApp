//
//  ContentView.swift
//  SwiftUIFirebaseApp
//
//  Created by Jens Legarth Ryge on 14/02/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var firebaseService = FirebaseService()
    
    //Visual representation
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 200.0) {
                    EditButton()
                        .frame(width: 80, height: 30)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(30)
                    Button("Add"){
                        firebaseService.createNote(title: "New Note", body:"Preview")
                    }.frame(width: 80, height: 30)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(30)
                }
                List($firebaseService.notesColl){item in
                    NavigationLink(destination: DetailViewDemo(displayedNote: item)){
                        Text(item.title.wrappedValue)
                    }

                }
            }.onAppear(){
                firebaseService.readNotes()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
