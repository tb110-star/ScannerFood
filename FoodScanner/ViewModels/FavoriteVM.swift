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
    var targetCalories: Double = 2000
    var todayCalories: Double = 0
    var errorMessage: String?
    func calculateTodayCalories() {
        let today = Calendar.current.startOfDay(for: Date())

        todayCalories = historyItems
            .filter {  $0.timestamp >= today }
            .reduce(0) { total, item in
                total + (Double(item.nutritionData.calories) ?? 0)
            }
        print("🟢 today's Calories: \(todayCalories)")
    }

    func updateData() {
        Task {
            await fetchHistory()
            calculateTodayCalories()
        }
    }
    
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
            calculateTodayCalories()
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
    func deleteHistory(_ historyItem: HistoryModel) {
            guard let id = historyItem.id else {
                   errorMessage = "Invalid history ID"
                print("❌ Error deleting id: \(errorMessage as Any)")
                   return
               }
            Task {
                do {
                    try await storeManager.delete(by: id)
                    
                    print("deleting")
                } catch {
                    errorMessage = error.localizedDescription
                    print(errorMessage as Any)
                    print("❌ Error deleting : \(errorMessage as Any)")


                }
            }
        }
}

