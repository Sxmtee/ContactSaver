//
//  ContentView.swift
//  ContactSaver
//
//  Created by mac on 18/11/2024.
//

import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var photoLibrary = PhotoLibrary()
    @State private var isShowingPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var isShowingNameDialog = false
    @State private var newPhotoName = ""
    @State private var temporaryImage: UIImage?
    
    var body: some View {
        NavigationStack {
            List(photoLibrary.photos.sorted()) { photo in
                NavigationLink(
                    destination: PhotoDetailView(
                        photo: photo,
                        image: photoLibrary.loadImage(photo: photo)
                    )
                ) {
                    PhotoRowView(
                        photo: photo,
                        image: photoLibrary.loadImage(photo: photo)
                    )
                }
            }
            .navigationTitle("My Photos")
            .toolbar {
                Button {
                    isShowingPhotoPicker = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .photosPicker(
                isPresented: $isShowingPhotoPicker,
                selection: $selectedItem,
                matching: .images
            )
            .onChange(of: selectedItem) {
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        temporaryImage = image
                        isShowingNameDialog = true
                    }
                }
            }
            .alert("Name this photo", isPresented: $isShowingNameDialog) {
                TextField("Photo name", text: $newPhotoName)
                Button("Save") {
                    if let image = temporaryImage {
                        try? photoLibrary.addPhoto(name: newPhotoName, originalImage: image)
                        newPhotoName = ""
                        temporaryImage = nil
                    }
                }
                Button("Cancel", role: .cancel) {
                    newPhotoName = ""
                    temporaryImage = nil
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
