/*
//  ScanViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 13.02.25.
//
import SwiftUI
import SwiftData
import FirebaseFirestore

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
    private let db = Firestore.firestore()
// loading image from Gallery and upload it to get public url
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
    // call the API With url and catch the resault
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
    
// user can add the ingrediant by self
     func addCustomIngredient(name: String, amount: String, unit: MeasurementUnit) {
         let newIngredient = SelectedIngredient(name: name, amount: amount, unit: unit,isChecked: true)
         selectedIngredients.append(newIngredient)
         print("✅ Manually added item: \(name) - \(amount) \(unit.rawValue)")
     }
    // selecting the relevent recognised ingrediant
   func toggleIngredientSelection(ingredient: RecognizedIngredient) {
            if let index = selectedIngredients.firstIndex(where: { $0.name == ingredient.name }) {
                selectedIngredients.remove(at: index)
            } else {
                let newIngredient = SelectedIngredient(name: ingredient.name, amount: "", unit: .gram, isChecked: true)
                selectedIngredients.append(newIngredient)
            }
        }
    // creating a list to sent to nutrition API
    func generateFinalList() {
            finalIngredients = selectedIngredients.filter { $0.isChecked || !$0.amount.isEmpty }
            print("✅ Final List Ready: \(finalIngredients.count) items")
        }
  // generating an acceptable format string of list to sent to API
    func createNutritionInput() -> String {
           let descriptions = finalIngredients
               .map { "\($0.amount) \($0.unit.rawValue) of \($0.name)" }
           
           return descriptions.joined(separator: ", ")
       }
    // recieving data from Nutrition API
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
                   saveHistory()
              } catch {
                  self.errorMessage = "❌ Failed to fetch nutrition data: \(error.localizedDescription)"
                  print("❌ Error fetching nutrition data: \(error.localizedDescription)")
              }

              isLoading = false
          }
      }
    
    private func saveHistory() {
           guard let imageUrl = selectedImageURL, let nutritionData = nutritionResults else {
               print("⚠️ Cannot save history: Missing image URL or nutrition data.")
               return
           }

           let historyRef = db.collection("userHistory")
           let historyEntry = HistoryModel(
               timestamp: Date(),
               imageUrl: imageUrl,
               finalIngredients: selectedIngredients,
               nutritionData: nutritionData,
               isFavorite: false
           )

           do {
               try historyRef.addDocument(from: historyEntry)
               print("✅ History saved successfully!")
           } catch {
               print("❌ Failed to save history: \(error.localizedDescription)")
           }
       }


}
 */

 
 
 //  ScanViewModel.swift
 //  FoodScanner
 //
 //  Created by tarlan bakhtiari on 13.02.25.
 //
 import SwiftUI
 import SwiftData
 import FirebaseFirestore

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
     private let storeManager = FireStoreManeger()
     
     // /* Mock
     let isMock: Bool 
        
       
        init(isMock: Bool = false) {
            self.isMock = isMock
            if isMock {
                self.recognizedIngredients = mockRecognizedIngredients
                self.nutritionResults = mockNutritionResponse
                self.selectedUIImage = UIImage(named: "MockImage")
            }
        }
        
    // */ Mock
     
 // loading image from Gallery and upload it to get public url
    
     func setSelectedImage(_ data: Data) {
         // /* Mock
         if isMock {
                    print("⚠️ Using mock image instead of real selection.")
                    self.selectedUIImage = UIImage(named: "MockImage")
                    return
                }

         // */ Mock
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
     // call the API With url and catch the resault
     func recognizeFood() {
         // /* Mock
         if isMock {
                    print("⚠️ Using mock data for food recognition.")
                    self.recognizedIngredients = mockRecognizedIngredients
                    return
                }
         // */ Mock
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
     
 // user can add the ingrediant by self
      func addCustomIngredient(name: String, amount: String, unit: MeasurementUnit) {
          let newIngredient = SelectedIngredient( name: name, amount: amount, unit: unit,isChecked: true)
          selectedIngredients.append(newIngredient)
          print("✅ Manually added item: \(name) - \(amount) \(unit.rawValue)")
      }
     // selecting the relevent recognised ingrediant
    func toggleIngredientSelection(ingredient: RecognizedIngredient) {
             if let index = selectedIngredients.firstIndex(where: { $0.name == ingredient.name }) {
                 selectedIngredients.remove(at: index)
             } else {
                 let newIngredient = SelectedIngredient(name: ingredient.name, amount: "", unit: .gram, isChecked: true)
                 selectedIngredients.append(newIngredient)
             }
         }
     // creating a list to sent to nutrition API
     func generateFinalList() {
             finalIngredients = selectedIngredients.filter { $0.isChecked || !$0.amount.isEmpty }
             print("✅ Final List Ready: \(finalIngredients.count) items")
         }
   // generating an acceptable format string of list to sent to API
     func createNutritionInput() -> String {
            let descriptions = finalIngredients
                .map { "\($0.amount) \($0.unit.rawValue) of \($0.name)" }
            
            return descriptions.joined(separator: ", ")
        }
     // recieving data from Nutrition API
     func fetchNutritionData() {
         // /* Mock
         if isMock {
                    print("⚠️ Using mock data for nutrition API.")
                    self.nutritionResults = mockNutritionResponse
                    return
                }
         // */ Mock
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
                   try await storeManager.insertHistory(nutritionData:nutritionData ,finalIngredients: finalIngredients, imageUrl: selectedImageURL ?? "", timestamp:Date())
               } catch {
                   self.errorMessage = "❌ Failed to fetch nutrition data: \(error.localizedDescription)"
                   print("❌ Error fetching nutrition data: \(error.localizedDescription)")
               }

               isLoading = false
           }
       }
    

 }


