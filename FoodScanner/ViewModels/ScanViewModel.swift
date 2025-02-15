//
//  ScanViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 13.02.25.
//
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import Observation

@MainActor
@Observable
final class ScanViewModel {
    var selectedItem: PhotosPickerItem? = nil
    var selectedImage: UIImage? = nil
    var base64String: String? = nil

    func loadAndConvertImage() async {
        guard let item = selectedItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data),
               let imageData = image.jpegData(compressionQuality: 0.9) {
                
                self.selectedImage = image
                self.base64String = imageData.base64EncodedString()
                
                print("✅ Image selected and converted to Base64 successfully!")
            } else {
                print("⚠️ Failed to process image")
            }
        } catch {
            print("❌ Error loading image: \(error.localizedDescription)")
        }
    }
}
