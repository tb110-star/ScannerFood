//
//  NutritionRequestModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 19.02.25.
//

import Foundation
struct NutritionRequest: Codable {
    let input: String
}
struct SelectedIngredient: Identifiable,Codable {
    var id : UUID = UUID()
    let name: String
    var amount: String
    var unit: MeasurementUnit
    var isChecked : Bool
}
enum MeasurementUnit: String, CaseIterable, Codable {
    case gram = "g"
    case cup = "cup"
    case tablespoon = "tbsp"
    case teaspoon = "tsp"
    case halfCup = "1/2 cup"
    case thirdCup = "1/3 cup"
    case quarterCup = "1/4 cup"
}
struct NutritionResponse:Identifiable, Codable {
    let id : String = UUID().uuidString
    let servings: String
    let calories: String
    let totalFat: String
    let saturatedFat: String
    let transFat: String
    let cholesterol: String
    let sodium: String
    let totalCarbohydrate: String
    let dietaryFiber: String
    let totalSugars: String
    let addedSugars: String
    let protein: String
    let reasoning: String
    static let noDataVal = NutritionResponse(
        
        servings: "1",
        calories: "0",
        totalFat: "0",
        saturatedFat: "0",
        transFat: "0",
        cholesterol: "0",
        sodium: "0",
        totalCarbohydrate: "0",
        dietaryFiber: "0",
        totalSugars: "0",
        addedSugars: "0",
        protein: "0",
        reasoning: "No data available"
    )

    enum CodingKeys: String, CodingKey {
        case servings
        case calories = "calories in kcal"
        case totalFat = "total fat in g"
        case saturatedFat = "saturated fat in g"
        case transFat = "trans fat in g"
        case cholesterol = "cholesterol in mg"
        case sodium = "sodium in mg"
        case totalCarbohydrate = "total carbohydrate in g"
        case dietaryFiber = "dietary fiber in g"
        case totalSugars = "total sugars in g"
        case addedSugars = "added sugars in g"
        case protein = "protein in g"
        case reasoning
    }
}
