//
//  NutritionDetailView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 25.02.25.
//

import SwiftUI

struct NutritionDetailView: View {
    @Bindable var viewModel: ScanViewModel

    var body: some View {
        ZStack {
            Color.white.opacity(0.1).ignoresSafeArea()
            
            VStack {
                Text("Nutrition Information")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                
                if let nutrition = viewModel.nutritionResults {
                    List {
                        VStack{
                            NutritionRow(title: "Calories", value: "\(nutrition.calories) kcal", icon: "🔥")
                            NutritionRow(title: "Protein", value: "\(nutrition.protein) g", icon: "💪")
                            NutritionRow(title: "Total Fat", value: "\(nutrition.totalFat) g", icon: "💧")
                            NutritionRow(title: "Saturated Fat", value: "\(nutrition.saturatedFat) g", icon: "🥑")
                            NutritionRow(title: "Trans Fat", value: "\(nutrition.transFat) g", icon: "❌")
                            NutritionRow(title: "Cholesterol", value: "\(nutrition.cholesterol) mg", icon: "❤️")
                            NutritionRow(title: "Sodium", value: "\(nutrition.sodium) mg", icon: "⚡️")
                            NutritionRow(title: "Total Carbs", value: "\(nutrition.totalCarbohydrate) g", icon: "🍞")
                            NutritionRow(title: "Dietary Fiber", value: "\(nutrition.dietaryFiber) g", icon: "🌿")
                            NutritionRow(title: "Total Sugars", value: "\(nutrition.totalSugars) g", icon: "🍬")
                            NutritionRow(title: "Added Sugars", value: "\(nutrition.addedSugars) g", icon: "➕")
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.white.opacity(0.5))

                    .listStyle(.insetGrouped)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .padding()
                } else {
                    Text("No Data Available")
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct NutritionRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title3)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .bold()
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    NutritionDetailView(viewModel: ScanViewModel(isMock: true))
}
