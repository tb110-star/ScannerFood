//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//
import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    private var viewModel = ScanViewModel()
    
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
            } else if viewModel.isLoading {
                ProgressView("Processing...")
                    .padding()
            }
            
            Button("Ingredient Detection") {
                viewModel.recognizeFood()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .disabled(viewModel.selectedImageURL == nil)
            if let errorMessage = viewModel.errorMessage {
                Text("⚠️ \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !viewModel.foodItems.isEmpty {
                List(viewModel.foodItems) { item in
                    HStack {
                        Text(item.name)
                            .font(.headline)
                        Spacer()
                        Text("\(String(format: "%.2f", item.confidence * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
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
    ScanView()
}
