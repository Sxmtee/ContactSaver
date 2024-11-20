//
//  PhotoRowView.swift
//  ContactSaver
//
//  Created by mac on 20/11/2024.
//

import SwiftUI


struct PhotoRowView: View {
    let photo: NamedPhoto
    let image: UIImage?
    
    var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            } else {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
            }
            
            Text(photo.name)
                .font(.body)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

//#Preview {
//    PhotoRowView()
//}
