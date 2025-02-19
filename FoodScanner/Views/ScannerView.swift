//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//
//import SwiftUI
//import PhotosUI
//
//struct ScanView: View {
//    @State private var selectedItem: PhotosPickerItem? = nil
//    private var viewModel = ScanViewModel()
//    
//    var body: some View {
//        VStack {
//            PhotosPicker("Select From Gallery", selection: $selectedItem, matching: .images)
//                .padding()
//            
//            if let uiImage = viewModel.selectedUIImage {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 200)
//                    .cornerRadius(10)
//                    .padding()
//            } else if viewModel.isLoading {
//                ProgressView("Processing...")
//                    .padding()
//            }
//            
//            Button("Ingredient Detection") {
//                viewModel.recognizeFood()
//            }
//            .buttonStyle(.borderedProminent)
//            .padding()
//            .disabled(viewModel.selectedImageURL == nil)
//            if let errorMessage = viewModel.errorMessage {
//                Text("⚠️ \(errorMessage)")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            
//            if !viewModel.foodItems.isEmpty {
//                List(viewModel.foodItems) { item in
//                    HStack {
//                        Text(item.name)
//                            .font(.headline)
//                        Spacer()
//                        Text("\(String(format: "%.2f", item.confidence * 100))%")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//        }
//        .onChange(of: selectedItem) { oldItem, newItem in
//            Task {
//                if let data = try? await newItem?.loadTransferable(type: Data.self) {
//                    viewModel.setSelectedImage(data)
//                }
//            }
//        }
//        
//    }
//}

import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Bindable var viewModel : ScanViewModel
    var body: some View {
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
                viewModel.recognizeFood()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(viewModel.selectedImageURL == nil || viewModel.isLoading)

            if viewModel.selectedFoodItems.isEmpty {
                Text("No ingredients detected yet.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach($viewModel.selectedFoodItems) { $item in
                        HStack {
                            Toggle("", isOn: Binding(
                                get: { !item.amount.isEmpty },
                                set: { isSelected in
                                    item.amount = isSelected ? "1" : ""
                                }
                            ))
                            
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
            }

            Button("Get Nutrition Info") {
                viewModel.fetchNutritionData()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(viewModel.selectedFoodItems.allSatisfy { $0.amount.isEmpty })

            if let nutritionData = viewModel.nutritionResults {
                Text("Nutrition Data Received: \(nutritionData)")
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

#Preview {
    ScanView(viewModel: ScanViewModel())
}
