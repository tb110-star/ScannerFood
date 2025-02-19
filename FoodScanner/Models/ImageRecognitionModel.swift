//
//  ImageRecognitionModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 18.02.25.
//

import Foundation
struct RecognizedIngredient: Identifiable, Codable {
    let id: String
    let name: String
    let confidence: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case confidence = "value"
    }
}
