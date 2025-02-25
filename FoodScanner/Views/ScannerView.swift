//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.

/*
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
*/
import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Bindable var viewModel: ScanViewModel
    @State private var isIngredientSheetPresented = false
    @State private var isEditEnabled = false
    @State private var isNutritionEnabled = false
    
    @State private var isScanOptionsPresented = false
    @State private var isGallerySelected = false
    @State private var isCameraSelected = false
    @State private var showGalleryPicker = false
    @State private var showCameraPicker = false
    @State private var selectedImage: UIImage?
   
    var body: some View {
        NavigationStack {
            ZStack {
                Color.timberwolf.ignoresSafeArea()

                VStack() {
                    
                    imagePreview(viewModel: viewModel, selectedImage: selectedImage)

                    Button(action: {
                        isScanOptionsPresented = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Color.pinkLavender.gradient)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    .confirmationDialog("Choose an option", isPresented: $isScanOptionsPresented, titleVisibility: .visible) {
                        Button("📷 Camera") {
                            isCameraSelected = true
                        }
                        
                        Button("🖼 Gallery") {
                            isGallerySelected = true
                        }
                        
                        Button("Cancel", role: .cancel) { }
                    }

                    Button("Ingredient Detection") {
                        Task {
                            viewModel.recognizeFood()
                            isEditEnabled = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue.opacity(isEditEnabled ? 1 : 0.5))
                    .disabled(!isEditEnabled)
                    .padding()
                    
                    if !viewModel.selectedIngredients.isEmpty {
                        ingredientPreview(viewModel: viewModel, isIngredientSheetPresented: $isIngredientSheetPresented)
                    }
                    
                    Button("Get Nutrition Info") {
                        Task {
                            viewModel.fetchNutritionData()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green.opacity(isNutritionEnabled ? 1 : 0.5))
                    .disabled(!isNutritionEnabled)
                    .padding()
                    
                    if viewModel.nutritionResults != nil {
                        nutritionPreview(viewModel: viewModel)
                    }
                    
                }
                .onChange(of: isGallerySelected, initial: false) { oldValue, newValue in
                    if newValue {
                        isGallerySelected = false
                        showGalleryPicker = true
                    }
                }

                .onChange(of: isCameraSelected) { oldValue, newValue in
                    if newValue {
                        isCameraSelected = false
                        showCameraPicker = true
                    }
                }
                .photosPicker(isPresented: $showGalleryPicker, selection: $selectedItem, matching: .images)
                .sheet(isPresented: $showCameraPicker) {
                    ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                }
                .sheet(isPresented: $isIngredientSheetPresented) {
                    IngredientSelectionSheet(viewModel: viewModel, isPresented: $isIngredientSheetPresented)
                        .onDisappear {
                            if !viewModel.selectedIngredients.isEmpty {
                                isNutritionEnabled = true
                            }
                        }
                }
            }
        }
    }
}

@MainActor

private func imagePreview(viewModel: ScanViewModel, selectedImage: UIImage?) -> some View {
    ZStack {
        if let uiImage = viewModel.selectedUIImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .cornerRadius(15)
                .shadow(radius: 5)
        } else {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 250)
                .overlay(
                    VStack {
                        Image(systemName: "photo.on.rectangle")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                    }
                )
        }
    }
    .padding(.horizontal)
}
@MainActor
private func ingredientPreview(viewModel: ScanViewModel, isIngredientSheetPresented: Binding<Bool>) -> some View {
    VStack {
        Text("Selected Ingredients")
            .font(.headline)
            .padding(.top, 5)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.selectedIngredients) { ingredient in
                    VStack {
                        Text(ingredient.name)
                            .font(.subheadline)
                            .bold()
                        
                        Text("\(ingredient.amount) \(ingredient.unit.rawValue)")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
        }
        
        Button("Edit Ingredients") {
            isIngredientSheetPresented.wrappedValue = true
        }
        .buttonStyle(.bordered)
        .padding(.top, 5)
    }
    .padding()
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 15))
    .shadow(radius: 5)
}
@MainActor
private func nutritionPreview(viewModel: ScanViewModel) -> some View {
    VStack {
        Text("Nutrition Data")
            .font(.headline)
        
        if let nutrition = viewModel.nutritionResults {
            VStack(alignment: .leading, spacing: 5) {
                Text("Calories: \(nutrition.calories) kcal")
                Text("Protein: \(nutrition.protein) g")
                Text("Total Fat: \(nutrition.totalFat) g")
                Text("Carbohydrates: \(nutrition.totalCarbohydrate) g")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Text("No Data")
                .foregroundColor(.gray)
        }
    }
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 15))
    .shadow(radius: 5)
    .padding()

}




#Preview {
    ScanView(viewModel: ScanViewModel(isMock: true))
}
