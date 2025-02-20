
//  ScanViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 13.02.25.
//
import SwiftUI
import SwiftData
@MainActor
@Observable
final class ScanViewModel {
    var selectedIngredients: [SelectedIngredient] = []
    var recognizedIngredients: [RecognizedIngredient] = []
    var finalIngredients: [SelectedIngredient] = []
    var isLoading = false
    var errorMessage: String?
    var selectedUIImage: UIImage?
    var selectedImageURL: String?
    private let repository = FoodRecognitionRepository()
    var nutritionResults: NutritionResponse?
    private let nutritionRepository = NutritionRepository()
    var manuallyAddedFoodItems:[SelectedIngredient] = []

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
                self.recognizedIngredients = recognizedItems
              
                print("✅ Food recognition successful: \(recognizedItems.count) items detected")
            } catch {
                errorMessage = error.localizedDescription
                print("❌ Error during food recognition: \(error.localizedDescription)")
            }
            
            isLoading = false
        }
    }
    

     func addCustomIngredient(name: String, amount: String, unit: MeasurementUnit) {
         let newIngredient = SelectedIngredient(name: name, amount: amount, unit: unit,isChecked: true)
         selectedIngredients.append(newIngredient)
         print("✅ Manually added item: \(name) - \(amount) \(unit.rawValue)")
     }
   func toggleIngredientSelection(ingredient: RecognizedIngredient) {
            if let index = selectedIngredients.firstIndex(where: { $0.name == ingredient.name }) {
                selectedIngredients.remove(at: index)
            } else {
                let newIngredient = SelectedIngredient(name: ingredient.name, amount: "", unit: .gram, isChecked: true)
                selectedIngredients.append(newIngredient)
            }
        }
    func generateFinalList() {
            finalIngredients = selectedIngredients.filter { $0.isChecked || !$0.amount.isEmpty }
            print("✅ Final List Ready: \(finalIngredients.count) items")
        }
  
    func createNutritionInput() -> String {
           let descriptions = finalIngredients
               .map { "\($0.amount) \($0.unit.rawValue) of \($0.name)" }
           
           return descriptions.joined(separator: ", ")
       }
    func fetchNutritionData() {
        generateFinalList()
          Task {
              let inputText = createNutritionInput()
              if inputText.isEmpty {
                              print("⚠️ Nutrition input is empty. Aborting request.")
                              return
                          }

              do {
                  isLoading = true
                  
                  let requestData = NutritionRequest(input: inputText)
                  print("📤 Sending request to Nutrition API with data: \(requestData)")
                  let nutritionData = try await nutritionRepository.getNutritionInfo(requestData)
                  self.nutritionResults = nutritionData
                  print("✅ Nutrition data received successfully: \(nutritionData)")
              } catch {
                  self.errorMessage = "❌ Failed to fetch nutrition data: \(error.localizedDescription)"
                  print("❌ Error fetching nutrition data: \(error.localizedDescription)")
              }

              isLoading = false
          }
      }

}
