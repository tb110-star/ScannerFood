//
//  GoogleVisionAPIManager.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 06.02.25.
//

import Foundation
final class VisionAPIManager: ObservableObject {
    static func testJSONPath() {
            if let path = Bundle.main.path(forResource: "foodScanner", ofType: "json") {
                print("✅ JSON path is found \(path)")
            } else {
                print("❌ JSON path is NOT found")
            }
        }
    
    
    
}
