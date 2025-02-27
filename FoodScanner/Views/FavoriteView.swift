////
////  FavoriteView.swift
////  FoodScanner
////
////  Created by tarlan bakhtiari on 04.02.25.
////
//import SwiftUI
//import SwiftData
//
//struct FavoriteView: View {
//    @Environment(FavoriteVM.self) private var favoriteVM
//    @State private var selectedItem: FavoriteItem?
//    @State private var showSheet = false
//    var body: some View {
//        NavigationStack {
//            ZStack{
//            Color.timberwolf.ignoresSafeArea()
//            
//            VStack {
//                List {
//                    ForEach(favoriteVM.favorites) { item in
//                        Button {
//                            selectedItem = item
//                            showSheet.toggle()
//                        } label: {
//                            HStack(spacing: 12) {
//                                AsyncImage(url: URL(string: item.imageUrl)) { image in
//                                    image.resizable()
//                                        .scaledToFit()
//                                        .frame(width: 50, height: 50)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                                } placeholder: {
//                                    ProgressView()
//                                        .frame(width: 50, height: 50)
//                                }
//                                
//                                VStack(alignment: .leading) {
//                                    Text(item.ingredients.first?.name ?? "Unknown")
//                                        .font(.headline)
//                                    Text("\(item.nutrition.calories) kcal")
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                }
//                                
//                                Spacer()
//                                
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding(.vertical, 5)
//                        }
//                    }
//                    .listRowBackground(Color.clear)
//                }
//                .scrollContentBackground(.hidden)
//            }
//            .navigationTitle("Favorites")
//            .sheet(isPresented: $showSheet) {
//                if let selectedItem = selectedItem {
//                    // FavoriteDetailView(favoriteItem: selectedItem)
//                }
//            }
//        }
//        }
//    }
//}
//
//#Preview {
//
//    FavoriteView()
//        .environment(FavoriteVM())
//        .environment(ScanViewModel(isMock: true))
//}

import SwiftUI

struct FavoriteView: View {
    @Bindable var favoriteVM : FavoriteVM
    @State private var selectedItem: HistoryModel? = nil
    @State private var showSheet = false

    var body: some View {
            NavigationStack {
                ZStack{
                Color.timberwolf.ignoresSafeArea()
    
                VStack {
                    List {
                        ForEach(favoriteVM.historyItems) { item in
                            Button {
                                selectedItem = item
                                showSheet.toggle()
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: item.imageUrl)) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
    
                                    VStack(alignment: .leading) {
                                        Text(item.finalIngredients.first?.name ?? "Unknown")
                                            .font(.headline)
                                        Text("\(item.nutritionData.calories) kcal")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
    
                                    Spacer()
    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                }
                .onAppear {
                                favoriteVM.observeHistoryUpdates()
                }
                .navigationTitle("Favorites")
                .sheet(item: $selectedItem) { selected in
                         //   FavoriteDetailView(favoriteItem: selected)
                        
                    }
                }
            }
            }
        }



#Preview {
    HomeView()
}
