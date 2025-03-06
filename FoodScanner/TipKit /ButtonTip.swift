//
//  ButtonTip.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 06.03.25.
//
import Foundation
import TipKit
struct ScannButtonTip: Tip {
    static var scanButtonTapped = Event(id: "scanButtonTapped")

    var title: Text {
        Text("Scann an Image")
    }
    
    var message: Text? {
        Text("Press the button to select an image")
    }
    var rules: [Rule] {
        #Rule(ScannButtonTip.scanButtonTapped) { event in
            event.donations.count == 0
        }
        }
}
struct DetectButtonTip: Tip {
    static var detectButtonTapped = Event(id: "detectButtonTapped")

    var title: Text {
        Text("Detect an Image")
    }
    
    var message: Text? {
        Text("Press the button to detect ingredients")
    }
    var rules: [Rule] {
        #Rule(DetectButtonTip.detectButtonTapped) { event in
            event.donations.count > 0

        }
        }

}

struct NutritionButtonTip: Tip {
    static var nutritionButtonTapped = Event(id: "nutritionButtonTapped")

    var title: Text {
        Text("Nutrition facts")
    }
    
    var message: Text? {
        Text("Press the button to recieve nutrition facts")
    }
    var rules: [Rule] {
        #Rule(NutritionButtonTip.nutritionButtonTapped) { event in
            event.donations.count > 0
        }
        }

}

