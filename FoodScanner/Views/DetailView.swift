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
            Color.timberwolf.opacity(0.6).ignoresSafeArea()
            
            VStack {
                if let url = URL(string: favoriteItem.imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            .padding()
                            .padding(.top)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(favoriteItem.finalIngredients) { ingredient in
                            VStack {
                                Text(ingredient.name)
                                    .font(.subheadline)
                                    .bold()
                                
                                Text("\(ingredient.amount) \(ingredient.unit.rawValue)")
                                    .font(.caption)
                            }
                            //   .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            //.shadow(radius: 1)
                        }
                        .padding(3)
                    }
                    .padding(.horizontal,5)
                    
                }
                .frame(height: 120)
                .padding(.horizontal)

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
                .padding(.horizontal)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .scrollContentBackground(.hidden)
                .padding()
                
            }
        }
    }
}

#Preview {
  //  DetailView(item: <#HistoryModel#>)
}
