//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.


import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Bindable var viewModel : ScanViewModel
    @State private var newIngredientName = ""
    @State private var newIngredientAmount = ""
    @State private var newIngredientUnit: MeasurementUnit = .gram
    @State private var isIngredientSheetPresented = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                Color.timberwolf.ignoresSafeArea()
                VStack {
/* ! Mock */      if !viewModel.isMock {
                    PhotosPicker("Select From Gallery", selection: $selectedItem, matching: .images)
                        .padding()
                }
                    if let uiImage = viewModel.selectedUIImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    if viewModel.isLoading {
                        ProgressView("Processing...")
                            .padding()
                    }
                    
                    Button("Ingredient Detection") {
                        Task {
                            viewModel.recognizeFood()
                            
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .disabled(viewModel.selectedImageURL == nil)
                    if viewModel.recognizedIngredients.isEmpty {
                        Text("No ingredients detected yet.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                   
                    
                    Button("Get Nutrition Info") {
                        Task {
                            viewModel.fetchNutritionData()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    

                    if let nutritionData = viewModel.nutritionResults {
                        Text("Nutrition Data: \(nutritionData)")
                            .padding()
                    }
                }
                .onChange(of: selectedItem) { oldItem, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.setSelectedImage(data)
                        }
                    }
                }
                .onChange(of: viewModel.recognizedIngredients) { oldValue, newValue in
                    if !newValue.isEmpty {
                        isIngredientSheetPresented = true
                    }
                }
            }
            .sheet(isPresented: $isIngredientSheetPresented) {
                IngredientSelectionSheet(viewModel: viewModel, isPresented: $isIngredientSheetPresented)
                
            }
        }
    }
    
}

#Preview {
    ScanView(viewModel: ScanViewModel(isMock: true))
}//
/*
import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Bindable var viewModel : ScanViewModel
    @State private var newIngredientName = ""
    @State private var newIngredientAmount = ""
    @State private var newIngredientUnit: MeasurementUnit = .gram
    
    
    var body: some View {
        ZStack {
          Color.timberwolf.ignoresSafeArea()
        VStack {
            PhotosPicker("Select From Gallery", selection: $selectedItem, matching: .images)
                .padding()
            
            if let uiImage = viewModel.selectedUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
            }
            
            if viewModel.isLoading {
                ProgressView("Processing...")
                    .padding()
            }
            
            Button("Ingredient Detection") {
                Task {
                    viewModel.recognizeFood()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(viewModel.selectedImageURL == nil)
            if viewModel.recognizedIngredients.isEmpty {
                Text("No ingredients detected yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
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
            
            Button("Get Nutrition Info") {
                Task {
                    viewModel.fetchNutritionData()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            if let nutritionData = viewModel.nutritionResults {
                Text("Nutrition Data: \(nutritionData)")
                    .padding()
            }
        }
        .onChange(of: selectedItem) { oldItem, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    viewModel.setSelectedImage(data)
                }
            }
        }
    }
    
}
    
}

#Preview {
    ScanView(viewModel: ScanViewModel())
}
*/
