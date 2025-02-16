//
//  ScanViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 13.02.25.
//
import Foundation

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
    
    //....
    var visionResponse: VisionResponse? = nil
    var detectedFoodItems: [LabelAnnotation] = []
    var estimatedQuantities: [String: String] = [:]
    var jsonData: [String: Any] = [:]
    private let visionAPIRepository = VisionAPIRepository()
    //....
    init() {
        loadMIDJSON()
    }
    
    func loadAndConvertImage() async {
        guard let item = selectedItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data),
               let imageData = image.jpegData(compressionQuality: 0.9) {
                
                self.selectedImage = image
                self.base64String = imageData.base64EncodedString()
                
                print("✅ Image selected and converted to Base64 successfully!")
                await analyzeSelectedImage()
            } else {
                print("⚠️ Failed to process image")
            }
        } catch {
            print("❌ Error loading image: \(error.localizedDescription)")
        }
    }
    func analyzeSelectedImage() async {
            guard let base64String = self.base64String else {
                print("⚠️ No image data to analyze")
                return
            }
            do {
                let response = try await visionAPIRepository.analyzeImage(base64String: base64String)
                self.visionResponse = response
                self.detectedFoodItems = response.labelAnnotations ?? []
                
                print("✅ Successfully received API response")
                print("🔍 Detected Food Items: \(self.detectedFoodItems.map { $0.description })")
            } catch {
                print("❌ Error analyzing image: \(error.localizedDescription)")
            }
        }

    func loadMIDJSON() {
        // Locate the JSON file in the app bundle
        guard let url = Bundle.main.url(forResource: "midjson", withExtension: "json") else {
            print("❌ JSON file not found!")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            self.jsonData = json ?? [:]
            print("✅ JSON (mid) successfully loaded:", jsonData)
        } catch {
            print("❌ Error loading JSON (mid): \(error)")
        }
    }
}
