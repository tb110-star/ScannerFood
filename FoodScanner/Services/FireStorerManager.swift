//
//  FireBaseManager.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 20.02.25.
//

import Foundation
import FirebaseFirestore
@Observable

final class FireStoreManeger {
    static let fireStoreManager = FireStoreManeger()
    private var db : CollectionReference{
        Firestore.firestore().collection("Image detection")
    }
    
    func insertHistory(nutritionData: NutritionResponse,finalIngredients:[SelectedIngredient],imageUrl: String, timestamp: Date = Date()) async throws (Error){
        guard let creatorID = await AuthManager.shared.userID else {
            throw .notAuthenticated
        }
//          let historyEntry: [String: Any] = [
//              "timestamp": Timestamp(date: timestamp),
//              "NutritionData": nutritionData,
//              "recognizedItems": recognizedItems,
//              "imageUrl": imageUrl
//              
//          ]
        let historyDoc =  HistoryModel(timestamp: Date(), finalIngredients: finalIngredients, nutritionData: nutritionData, isFavorite: false, imageUrl: imageUrl, creatorID: creatorID)
          do {
              try  db.addDocument(from: historyDoc )
              print("✅ Successfully saved recognized food items to Firestore!")
          } catch {
              print("❌ Error saving recognized food items: \(error.localizedDescription)")
              throw .failedDeleting(reason: error.localizedDescription)
          }
      }
  
    enum Error: LocalizedError {
        case notAuthenticated
        case noSnippetID
        case failedCreation(reason: String)
        case failedFinding(reason: String)
        case failedDeleting(reason: String)
        case failedUpdating(reason: String)
        case findAllFailed(reason: String)
        
        var errorDescription: String? {
            switch self {
            case .notAuthenticated:
                "You are not authenticated."
            case .noSnippetID:
                "The snippet does not exist yet."
            case .failedCreation(let reason):
                "The snippet could not be created: \(reason)"
            case .failedFinding(let reason):
                "The snippet could not be found: \(reason)"
            case .failedDeleting(let reason):
                "The snippet could not be deleted: \(reason)"
            case .failedUpdating(let reason):
                "The snippet could not be updated: \(reason)"
            case .findAllFailed(let reason):
                "Your snippet could not be loaded: \(reason)"
            }
        }
    }
}
