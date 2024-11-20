//
//  PhotoModel.swift
//  ContactSaver
//
//  Created by mac on 20/11/2024.
//

import Foundation
import SwiftUI

struct NamedPhoto: Identifiable, Codable, Comparable {
    let id: UUID
    let name: String
    let savePath: String
    
    // Conformance to Comparable for sorting by name
    static func < (lhs: NamedPhoto, rhs: NamedPhoto) -> Bool {
        lhs.name < rhs.name
    }
}

@Observable
class PhotoLibrary {
    var photos: [NamedPhoto] = []
    private let savePathURL: URL
    
    init() {
        // Get the documents directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        // Create a 'Photos' subdirectory if it doesn't exist
        let photosDirectory = documentsDirectory.appendingPathComponent("Photos")
        if !FileManager.default.fileExists(atPath: photosDirectory.path) {
            try? FileManager.default.createDirectory(at: photosDirectory, withIntermediateDirectories: true)
        }
        
        // Set up the path for our JSON file
        savePathURL = documentsDirectory.appendingPathComponent("PhotoLibrary.json")
        
        loadPhotos()
    }
    
    // Load photos from JSON file
    private func loadPhotos() {
        guard let data = try? Data(contentsOf: savePathURL) else { return }
        photos = (try? JSONDecoder().decode([NamedPhoto].self, from: data)) ?? []
    }
    
    // Save photos to JSON file
    private func savePhotos() {
        guard let data = try? JSONEncoder().encode(photos) else { return }
        try? data.write(to: savePathURL)
    }
    
    // Add a new photo
    func addPhoto(name: String, originalImage: UIImage) throws {
        // Get the documents directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent("Photos")
        
        // Create a unique filename
        let filename = UUID().uuidString + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        // Convert image to data and save it
        guard let imageData = originalImage.jpegData(compressionQuality: 0.8) else {
            throw PhotoError.imageConversionFailed
        }
        
        try imageData.write(to: fileURL)
        
        // Create and add the new NamedPhoto
        let photo = NamedPhoto(id: UUID(), name: name, savePath: filename)
        photos.append(photo)
        photos.sort() // Sort the array after adding new photo
        savePhotos()
    }
    
    // Load an image from disk
    func loadImage(photo: NamedPhoto) -> UIImage? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent("Photos")
        let fileURL = documentsDirectory.appendingPathComponent(photo.savePath)
        
        guard let imageData = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: imageData)
    }
    
    // Delete a photo
    func deletePhoto(photo: NamedPhoto) {
        // Remove the image file
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0].appendingPathComponent("Photos")
        let fileURL = documentsDirectory.appendingPathComponent(photo.savePath)
        try? FileManager.default.removeItem(at: fileURL)
        
        // Remove from array and save
        photos.removeAll { $0.id == photo.id }
        savePhotos()
    }
}

// Custom errors
enum PhotoError: Error {
    case imageConversionFailed
}
