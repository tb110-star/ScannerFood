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

        let historyDoc =  HistoryModel(timestamp: Date(), finalIngredients: finalIngredients, nutritionData: nutritionData, isFavorite: false, imageUrl: imageUrl, creatorID: creatorID)
          do {
              try  db.addDocument(from: historyDoc )
              print("✅ Successfully saved recognized food items to Firestore!")
          } catch {
              print("❌ Error saving recognized food items: \(error.localizedDescription)")
              throw .failedDeleting(reason: error.localizedDescription)
          }
      }
    @MainActor
    func observe(onChange: @escaping ([HistoryModel]) -> Void) {
        guard let creatorID = AuthManager.shared.userID else { return }
        db.whereField("creatorID", isEqualTo:creatorID).addSnapshotListener(includeMetadataChanges: false) { snapshot, error in
                    if error != nil { return }
                    guard let snapshot = snapshot else { return }
                    
                    let histories = snapshot.documents.compactMap { document in
                        try? document.data(as: HistoryModel.self)
                    }
                    
            onChange(histories)
                }
    }
    func findAll(byCreator id: String) async throws(Error) -> [HistoryModel] {
        do {
            let documents = try await db.whereField("creatorID", isEqualTo: id).getDocuments()
            let his = documents.documents.compactMap { document in
                try? document.data(as: HistoryModel.self)
            }
            return his
        } catch {
            throw .findAllFailed(reason: error.localizedDescription)
        
        }
    }
    func updateIsFavorite(by id: HistoryModel.ID, isFavorite: Bool) async throws(Error) {
        guard let id = id else { throw .noHistoryID
        }
        let updateData = ["isFavorite": isFavorite]
        do {
            try await db.document(id).updateData(updateData)
            print("✅ Successfully updated favorite status.")
        } catch {
            throw .failedUpdating(reason: error.localizedDescription)
        }
    }
    func delete(by id: String) async throws(Error) {
        do {
            print("🟡 Deleting document with ID: \(id)")

            try await db.document(id).delete()
            print("✅ History successfully deleted from Firestore!")
        } catch {
            print("❌ Error deleting from FireStore")

            throw .failedDeleting(reason: error.localizedDescription)
        }
    }
    enum Error: LocalizedError {
        case notAuthenticated
        case noHistoryID
        case failedCreation(reason: String)
        case failedFinding(reason: String)
        case failedDeleting(reason: String)
        case failedUpdating(reason: String)
        case findAllFailed(reason: String)
        
        var errorDescription: String? {
            switch self {
            case .notAuthenticated:
                "You are not authenticated."
            case .noHistoryID:
                "The history does not exist yet."
            case .failedCreation(let reason):
                "The history could not be created: \(reason)"
            case .failedFinding(let reason):
                "The history could not be found: \(reason)"
            case .failedDeleting(let reason):
                "The history could not be deleted: \(reason)"
            case .failedUpdating(let reason):
                "The history could not be updated: \(reason)"
            case .findAllFailed(let reason):
                "Your history could not be loaded: \(reason)"
            }
        }
    }
}
