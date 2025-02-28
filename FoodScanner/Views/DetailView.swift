//
//  DetailView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 28.02.25.
//

import SwiftUI

struct DetailView: View {
    @Environment(FavoriteVM.self) private var favoriteVM
    var favoriteItem: HistoryModel
    var body: some View {
        
        ZStack {
            Color.white.opacity(0.1).ignoresSafeArea()
            
            VStack {
                
                List {
                    VStack{
                        NutritionRow(title: "Calories", value: "\(favoriteItem.nutritionData.calories) kcal", icon: "🔥")
                        NutritionRow(title: "Protein", value: "\(favoriteItem.nutritionData.protein) g", icon: "💪")
                        NutritionRow(title: "Total Fat", value: "\(favoriteItem.nutritionData.totalFat) g", icon: "💧")
                        NutritionRow(title: "Saturated Fat", value: "\(favoriteItem.nutritionData.saturatedFat) g", icon: "🥑")
                        NutritionRow(title: "Trans Fat", value: "\(favoriteItem.nutritionData.transFat) g", icon: "❌")
                        NutritionRow(title: "Cholesterol", value: "\(favoriteItem.nutritionData.cholesterol) mg", icon: "❤️")
                        NutritionRow(title: "Sodium", value: "\(favoriteItem.nutritionData.sodium) mg", icon: "⚡️")
                        NutritionRow(title: "Total Carbs", value: "\(favoriteItem.nutritionData.totalCarbohydrate) g", icon: "🍞")
                        NutritionRow(title: "Dietary Fiber", value: "\(favoriteItem.nutritionData.dietaryFiber) g", icon: "🌿")
                        NutritionRow(title: "Total Sugars", value: "\(favoriteItem.nutritionData.totalSugars) g", icon: "🍬")
                    }
                    .listRowBackground(Color.clear)
                }
            }
        }
    }
}

#Preview {
  //  DetailView(item: <#HistoryModel#>)
}
