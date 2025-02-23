



//
//  MockData.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 23.02.25.
//
import Foundation

let mockRecognizedIngredients: [RecognizedIngredient] = [
    RecognizedIngredient(id: "1", name: "Tomato", confidence: 0.95),
    RecognizedIngredient(id: "2", name: "Lettuce", confidence: 0.89),
    RecognizedIngredient(id: "3", name: "Chicken", confidence: 0.99)
]

let mockNutritionResponse = NutritionResponse(
    servings: "1",
    calories: "120",
    totalFat: "5.0",
    saturatedFat: "2.0",
    transFat: "0.0",
    cholesterol: "15",
    sodium: "100",
    totalCarbohydrate: "10",
    dietaryFiber: "3",
    totalSugars: "2",
    addedSugars: "1",
    protein: "8",
    reasoning: "Mock nutrition data for testing"
)


