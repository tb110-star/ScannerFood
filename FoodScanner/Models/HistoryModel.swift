//
//  Untitled.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 20.02.25.
//

import Foundation
import FirebaseFirestore
struct HistoryModel: Codable, Identifiable {
    @DocumentID var id: String?
    let timestamp: Date
    let finalIngredients: [SelectedIngredient]
    let nutritionData: NutritionResponse
    var isFavorite: Bool
    let imageUrl: String
    var creatorID: String
}
