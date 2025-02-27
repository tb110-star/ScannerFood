//
//  FavoriteVM.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 27.02.25.
//
//
import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
@Observable
final class FavoriteVM {
    private let storeManager = FireStoreManeger()
    var historyItems: [HistoryModel] = []
    
    func observeHistoryUpdates() {
        guard AuthManager.shared.isUserSignedIn else {
                   print("User is not signed in. HistoryItem will not be activated.")
                   return
               }
        storeManager.observe { [weak self] updatedItems in
                self?.historyItems = updatedItems
            }
        }
    func fetchHistory() async {
            do {
                guard let userID = AuthManager.shared.userID else { return }
                let fetchedItems = try await storeManager.findAll(byCreator: userID)
                historyItems = fetchedItems
                print("✅ Successfully saved histories from Firestore!")
            } catch {
                print("❌ error to find the histoey \(error.localizedDescription)")
            }
        }
}
