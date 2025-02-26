//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.


import SwiftUI
import PhotosUI

struct ScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Bindable var viewModel: ScanViewModel
   // @State private var isIngredientSheetPresented = false
   // @State private var isDetectEnabled = false
    //@State private var isNutritionEnabled = false
    
    @State private var isScanOptionsPresented = false
    @State private var isGallerySelected = false
    @State private var isCameraSelected = false
    @State private var showGalleryPicker = false
    @State private var showCameraPicker = false
    @State private var selectedImage: UIImage?
    @State private var isNutritionSheetPresented = false
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.timberwolf.ignoresSafeArea()
                ScrollView {
                VStack() {
                    
                    imagePreview(viewModel: viewModel, selectedImage: selectedImage)
                        .padding(.top, 20)
                    //Spacer()
                    HStack{
                        Button(action: {
                            Task {
                                viewModel.recognizeFood()
                                
                            }
                        }) {
                            Text("Detect")
                                .font(.headline)
                                .frame(width: 120, height: 45)
                                .background(viewModel.isDetectEnabled ? Color.manatee : Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .scaleEffect(viewModel.isDetectEnabled ? 1.0 : 0.95)
                        .disabled(!viewModel.isDetectEnabled)
                        
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
                        Button(action: {
                            Task {
                                if viewModel.nutritionResults == nil {
                                     viewModel.fetchNutritionData()
                                }
                                isNutritionSheetPresented = true
                            }
                        }) {
                            Text("Nutrition")
                                .font(.headline)
                                .frame(width: 120, height: 45)
                                .background(viewModel.isNutritionEnabled ? Color.manatee : Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .scaleEffect(viewModel.isNutritionEnabled ? 1.0 : 0.95)
                        .disabled(!viewModel.isNutritionEnabled)
                    }
                    .padding(.top)
                    Spacer()
                    
                    if !viewModel.selectedIngredients.isEmpty {
                        editedIngredientsPreview(viewModel: viewModel, isIngredientSheetPresented: $viewModel.isIngredientSheetPresented)
                    }
                
                }
            }
                .navigationTitle("Scan Food")
                .toolbar{
//                    ToolbarItem(placement: .topBarTrailing){
//                        NavigationLink(destination: SettingView()) {
//                                                 Image(systemName: "gearshape.fill")
//                                                     .font(.system(size: 22, weight: .bold))
//                                                     .foregroundColor(.gray)
//                                             }
//                    }
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
                .onChange(of: selectedItem) { oldItem, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.setSelectedImage(data)
                        }
                    }
                }
                .photosPicker(isPresented: $showGalleryPicker, selection: $selectedItem, matching: .images)
                .sheet(isPresented: $showCameraPicker) {
                    ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.ultraThinMaterial.opacity(0.5))
                }
                .sheet(isPresented: $viewModel.isIngredientSheetPresented) {
                    IngredientSelectionSheet(viewModel: viewModel, isPresented: $viewModel.isIngredientSheetPresented)
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.ultraThinMaterial.opacity(0.9))
                        .onDisappear {
                            if !viewModel.selectedIngredients.isEmpty {
                                viewModel.isNutritionEnabled = true
                            }
                        }
                }
                .sheet(isPresented: $isNutritionSheetPresented) {
                    NutritionDetailView(viewModel: viewModel)
                        .presentationDetents([.medium, .large])   .presentationDragIndicator(.visible)
                        .presentationBackground(.ultraThinMaterial.opacity(0.4))
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
                .frame(width:350, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 5)
        } else {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.2))
                .frame(width:350, height: 300)
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
private func editedIngredientsPreview(viewModel: ScanViewModel, isIngredientSheetPresented: Binding<Bool>) -> some View {
    VStack(alignment: .leading) {
        HStack{
            Text("Edited Ingredients")
                .font(.headline)
                .padding()
            
            Spacer()
            
            Button(action: {
                isIngredientSheetPresented.wrappedValue = true
            }) {
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.pink.opacity(0.5))
            }
            .padding(.trailing)
        }
        Divider()
        ScrollView(.vertical, showsIndicators: true) {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(viewModel.selectedIngredients) { ingredient in
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
        .frame(height: 200)

    }
    .background(
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.white.opacity(0.2))
            .background(.ultraThinMaterial)
            .blur(radius: 1)
    )
    .cornerRadius(15)
    .padding(20)

}




#Preview {
    ScanView(viewModel: ScanViewModel(isMock: true))
}
