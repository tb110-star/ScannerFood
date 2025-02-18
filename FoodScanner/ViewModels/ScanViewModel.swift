//
//  ScanViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 13.02.25.
//
//
//  ScanViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 13.02.25.
//
import SwiftUI

@MainActor
@Observable
final class ScanViewModel {
    var foodItems: [FoodItem] = []
    var isLoading = false
    var errorMessage: String?
    var selectedUIImage: UIImage?
    var selectedImageURL: String?
    private let repository = FoodRecognitionRepository()
    
    func setSelectedImage(_ data: Data) {
        self.selectedUIImage = UIImage(data: data)
        print("✅ Image selected from gallery.")
        
        Task {
            do {
                self.isLoading = true
                let imageUrl = try await repository.uploadImageToImgBB(imageData: data)
                self.selectedImageURL = imageUrl
                print("✅ Image uploaded: \(imageUrl)")
            } catch {
                self.errorMessage = "❌ Image upload failed: \(error.localizedDescription)"
                print(error.localizedDescription)
            }
            self.isLoading = false
        }
    }
    
    func recognizeFood() {
        Task {
            guard let imageUrl = selectedImageURL else {
                
                errorMessage = "No Image Selected!"
                print("❌ No image URL found!")
                return
            }
            
            print("📤 Sending image URL to API for recognition...: \(imageUrl)")
            
            do {
                isLoading = true
                let recognizedItems = try await repository.recognizeFood(from: imageUrl)
                self.foodItems = recognizedItems
                print("✅ Food recognition successful: \(recognizedItems.count) items detected")
            } catch {
                errorMessage = error.localizedDescription
                print("❌ Error during food recognition: \(error.localizedDescription)")
            }
            
            isLoading = false
        }
    }
}
