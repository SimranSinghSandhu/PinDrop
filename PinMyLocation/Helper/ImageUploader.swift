//
//  ImageUploader.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 06/04/25.
//

import UIKit

func prepareImageForUpload(_ image: UIImage, targetSize: CGSize = CGSize(width: 400, height: 400)) -> URL? {
    // Resize the image
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    let resizedImage = renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: targetSize))
    }
    
    // Compress the resized image to JPEG with quality 0.7
    guard let jpegData = resizedImage.jpegData(compressionQuality: 0.7) else {
        return nil
    }
    
    // Save to a temp file
    let tempURL = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString)
        .appendingPathExtension("jpg")
    
    do {
        try jpegData.write(to: tempURL)
        return tempURL
    } catch {
        print("Error writing image to disk: \(error)")
        return nil
    }
}
