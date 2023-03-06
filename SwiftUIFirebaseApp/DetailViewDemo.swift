//
//  DetailView.swift
//  MyNotebook
//
//  Created by Jens Legarth Ryge on 07/02/2023.
//

import SwiftUI
import PhotosUI

struct DetailViewDemo: View {
    @Binding var displayedNote:Note
    @ObservedObject var firebaseService = FirebaseService()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var picture: UIImage?
    
    var body: some View {
        VStack {
            TextField("Title", text: $displayedNote.title)
                .padding()
                .padding(.bottom, -30.0)
                .frame(maxWidth: .infinity, alignment: .top)
                .font(.title)
                .fontWeight(.bold)
            TextField("", text: $displayedNote.body)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            Image(uiImage: picture ?? UIImage(systemName: "photo.circle.fill")!)
                .resizable()
                .frame(width: 250, height: 250)
                .padding(.bottom, 30)
            HStack(spacing: 100){
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select photo")
                }
                Button("Save note"){
                    firebaseService.updateNote(noteToUpdate: displayedNote)
                }
            }
        }.onChange(of: selectedItem) { item in
            Task(priority: .background) {
                print("image ready")
                if let data = try? await item?.loadTransferable(type: Data.self){
                    displayedNote.image = UIImage(data: data)
                    picture = displayedNote.image
                    displayedNote.hasImage = true
                }
            }
        }.onAppear(){
            if displayedNote.hasImage{
                //functionality that loads image into container
            }
        }
    }
}

struct DetailViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        let previewNote = Note(id: "12", title:"Preview", body:"Preview", hasImage: false)
        return DetailViewDemo(displayedNote:.constant(previewNote))
    }
}
