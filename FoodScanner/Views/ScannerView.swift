//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.

//
import SwiftUI
import PhotosUI
import TipKit
struct ScanView: View {
    @Environment(SettingVM.self) private var settingVM
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @Bindable var viewModel: ScanViewModel
    @State private var isScanOptionsPresented = false
    @State private var isGallerySelected = false
    @State private var isCameraSelected = false
    @State private var showGalleryPicker = false
    @State private var showCameraPicker = false
    @State private var selectedImage: UIImage?
    @State private var isNutritionSheetPresented = false
    @State private var scannerPosition: CGFloat = -100
    @State private var isAnimating = false
    @State private var isExpanded = false
    @Namespace private var animationNamespace
    var body: some View {
        NavigationStack {
            ZStack {
                Color.timberwolf.ignoresSafeArea()
                VStack() {
                    imagePreview(viewModel: viewModel, selectedImage: selectedImage)
                        .padding(.top, 20)
                    if !viewModel.selectedIngredients.isEmpty {
                        editedIngredientsPreview(viewModel: viewModel, isIngredientSheetPresented: $viewModel.isIngredientSheetPresented)
                    } else {
                        scanningAnimationView()
                    }
                    Spacer()
                    HStack{
                        Button(action: {
                            Task {
                                viewModel.recognizeFood()
                                viewModel.onDetectButtton.invalidate(reason: .actionPerformed)
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
                        // ///////////////TipKit
                        .popoverTip(
                            viewModel.onDetectButtton
                        ).tipViewStyle(MyButtonTipStyle())

                            .scaleEffect(viewModel.isDetectEnabled ? 1.0 : 0.95)
                            .disabled(!viewModel.isDetectEnabled)
                        Button(action: {
                            isScanOptionsPresented = true
                            viewModel.onScannButton.invalidate(reason: .actionPerformed)
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .background(Color.pinkLavender.gradient)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        // ///////////////TipKit
                        .popoverTip(
                            viewModel.onScannButton
                        ).tipViewStyle(MyButtonTipStyle())
                            .confirmationDialog("Choose an option", isPresented: $isScanOptionsPresented, titleVisibility: .visible) {
                                Button("📷 Camera") {
                                    isCameraSelected = true
                                }
                                Button("🖼 Gallery") {
                                    isGallerySelected = true
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                            .presentationBackground(.ultraThinMaterial)
                        Button(action: {
                            Task {
                                if viewModel.nutritionResults == nil {
                                    viewModel.fetchNutritionData()
                                }

                                isNutritionSheetPresented = true
                            }
                            viewModel.onNutritionButton.invalidate(reason: .actionPerformed)

                        }) {
                            Text("Nutrition")
                                .font(.headline)
                                .frame(width: 120, height: 45)
                                .background(viewModel.isNutritionEnabled ? Color.manatee : Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        // ///////////////TipKit
                        .popoverTip(
                            viewModel.onNutritionButton
                        ).tipViewStyle(MyButtonTipStyle())
                            .scaleEffect(viewModel.isNutritionEnabled ? 1.0 : 0.95)
                            .disabled(!viewModel.isNutritionEnabled)
                    }
                    .padding(.bottom)
                    .ignoresSafeArea(edges: .bottom)
                }

                .navigationTitle("")
                .toolbarBackground(.ultraThinMaterial.opacity(0.5), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
                            
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)) {
                                isExpanded = true
                            }
                        }
                    }
                }
                .photosPicker(isPresented: $showGalleryPicker, selection: $selectedItem, matching: .images)
                .sheet(isPresented: $showCameraPicker) {
                    ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.ultraThinMaterial.opacity(0.4))
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
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.ultraThinMaterial.opacity(0.4))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView(settingVM: settingVM, authViewModel: AuthViewModel())

                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.gray)
                    }

                }
                ToolbarItem(placement: .topBarLeading) {
                    if let user = authViewModel.user {
                        Text("Hi,Dear \(user.userName) 👋")
                            .font(.custom("AvenirNext", size: 18))
                            .foregroundColor(Color(.darkGray))

                    } else{
                        Text("Hi,Dear Guest 😊").font(.custom("AvenirNext", size: 18))
                            .foregroundColor(Color(.darkGray))


                    }
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showError, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            Text("Oops! Something went wrong. Please refresh and try again.")
        })
    }

    @MainActor
    private func imagePreview(viewModel: ScanViewModel, selectedImage: UIImage?) -> some View {
        ZStack {
            if let uiImage = viewModel.selectedUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: isExpanded ? 350 : 350, height: isExpanded ? 250 : 50)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .matchedGeometryEffect(id: "imageBox", in: animationNamespace)

            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .background(.ultraThinMaterial)
                        .frame(width: isExpanded ? 350 : 350, height: isExpanded ? 250 : 50)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            VStack(spacing: 20) {
//                                Image(systemName: "viewfinder.circle")
//                                    .font(.system(size: 80, weight: .ultraLight))
//                                    .foregroundStyle(.gray.opacity(0.6))
//                                    .shadow(radius: 5)

                                Text("No Image to Scann")
                                    .font(.title2)
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        )
                        .matchedGeometryEffect(id: "imageBox", in: animationNamespace)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)) {
                                isExpanded.toggle()
                            }
                        }
                        .shadow(radius: 1)
                }
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
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(3)
                }
                .padding(.horizontal,5)
            }
            .frame(height: 160)
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
    @MainActor
    private func scanningAnimationView() -> some View {
        ZStack {
            Image(uiImage: UIImage(named: "scanViewImage") ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .opacity(0.5)

            Rectangle()
                .fill(Color.white.opacity(0.4))
                .frame(width: 300, height: 4)
                .offset(y: scannerPosition)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        scannerPosition = 100
                    }
                }

            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .clipShape(RoundedRectangle(cornerRadius: 15))

                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white.opacity(0.5)))
                            .scaleEffect(2)
                            .padding()

                        Text("Loading...")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 350, height: 280)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .frame(width: 350, height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }

}
#Preview {
    ScanView(viewModel: ScanViewModel(isMock: false))
        .environment(SettingVM())
}


#Preview {
    ScanView(viewModel: ScanViewModel(isMock: false))
        .environment(SettingVM())
}
