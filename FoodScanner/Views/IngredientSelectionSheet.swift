//
//  IngredientSelectionSheet.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 21.02.25.
//

import SwiftUI
import SwiftUI

struct IngredientSelectionSheet: View {
    @Bindable var viewModel: ScanViewModel
    @Binding var isPresented: Bool
    
    @State private var newIngredientName = ""
    @State private var newIngredientAmount = ""
    @State private var newIngredientUnit: MeasurementUnit = .gram
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Detected Ingredients")) {
                        ForEach(viewModel.recognizedIngredients) { ingredient in
                            HStack {
                                Button(action: {
                                    viewModel.toggleIngredientSelection(ingredient: ingredient)
                                }) {
                                    Image(systemName: viewModel.selectedIngredients.contains { $0.name == ingredient.name } ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.blue)
                                }
                                
                                Text(ingredient.name)
                                    .font(.headline)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Section(header: Text("Selected Ingredients")) {
                        ForEach($viewModel.selectedIngredients) { $item in
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                
                                Spacer()
                                
                                TextField("Amount", text: $item.amount)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 70)
                                
                                Picker("Unit", selection: $item.unit) {
                                    ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                                        Text(unit.rawValue).tag(unit)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                    }
                    
                    Section(header: Text("Add Custom Ingredient")) {
                        HStack {
                            TextField("Ingredient Name", text: $newIngredientName)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField("Amount", text: $newIngredientAmount)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 70)
                            
                            Picker("Unit", selection: $newIngredientUnit) {
                                ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(.menu)
                            
                            Button("Add") {
                                viewModel.addCustomIngredient(name: newIngredientName, amount: newIngredientAmount, unit: newIngredientUnit)
                                newIngredientName = ""
                                newIngredientAmount = ""
                            }
                        }
                    }
                }
                
                Button("Done") {
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Edit Ingredients")
        }
    }
}

#Preview {
    // IngredientSelectionSheet(viewModel: <#ScanViewModel#>, isPresented: <#Binding<Bool>#>)
}
