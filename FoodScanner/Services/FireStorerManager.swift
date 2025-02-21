//
//  FireBaseManager.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 20.02.25.
//

import Foundation
import FirebaseFirestore

final class FireStorerepository {
    private let db = Firestore.firestore().collection("Image detection")
    func insertHistory(recognizedItems: [String], imageUrl: String, timestamp: Date = Date()) async throws {
          let historyEntry: [String: Any] = [
              "timestamp": Timestamp(date: timestamp),
              "recognizedItems": recognizedItems,
              "imageUrl": imageUrl
          ]
          
          do {
              try await db.addDocument(data: historyEntry)
              print("✅ Successfully saved recognized food items to Firestore!")
          } catch {
              print("❌ Error saving recognized food items: \(error.localizedDescription)")
              throw error
          }
      }
   
}
