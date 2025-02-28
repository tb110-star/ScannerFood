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
    var favoriteItems: [HistoryModel] {
           historyItems.filter { $0.isFavorite }
       }
     var selectedTab: Int = 0
    func observeHistoryUpdates() {
        guard AuthManager.shared.isUserSignedIn else {
            print("⚠️User is not signed in. HistoryItem will not be activated.")
            return
        }
        storeManager.observe { [weak self] updatedItems in
            guard let self = self else { return }
            self.historyItems = updatedItems
            print("✅ data is updated.")
            print(favoriteItems.isEmpty)
        }
    }
 
    func fetchHistory() async {
        do {
            guard let userID = AuthManager.shared.userID else { return }
            let fetchedItems = try await storeManager.findAll(byCreator: userID)
            historyItems = fetchedItems
            print("✅ Successfully upload histories from Firestore!")
        } catch {
            print("❌ error to find the histoey \(error.localizedDescription)")
        }
    }
    func toggleFavorite(item: HistoryModel) async throws {
        let newValue = !item.isFavorite
        try await storeManager.updateIsFavorite(by: item.id, isFavorite: newValue)
        if let index = historyItems.firstIndex(where: {$0.id == item.id}) {
            historyItems[index].isFavorite = newValue
        }
        observeHistoryUpdates()

    }
}
