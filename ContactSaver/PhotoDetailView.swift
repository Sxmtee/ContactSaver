//
//  PhotoDetailView.swift
//  ContactSaver
//
//  Created by mac on 20/11/2024.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: NamedPhoto
    let image: UIImage?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var photoLibrary = PhotoLibrary()
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            
            Text(photo.name)
                .font(.title2)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Photo Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(role: .destructive) {
                photoLibrary.deletePhoto(photo: photo)
                dismiss()
            } label: {
                Image(systemName: "trash")
            }
        }
    }
}

//#Preview {
//    PhotoDetailView()
//}
