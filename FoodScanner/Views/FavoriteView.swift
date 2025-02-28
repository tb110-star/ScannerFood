////
////  FavoriteView.swift
////  FoodScanner
////
////  Created by tarlan bakhtiari on 04.02.25.
////
//import SwiftUI
//import SwiftData
//


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
                    TabView(selection: $favoriteVM.selectedTab) {
                        Text("All History")
                            .tag(1)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                        
                        Text("Favorites")
                            .tag(0)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                    //                    TabView(selection: $favoriteVM.selectedTab) {
                    //                            List(favoriteVM.historyItems, id: \.id) { item in
                    //                            Button {
                    //                                selectedItem = item
                    //                                showSheet.toggle()
                    //                            } label: {
                    //                                HStack(spacing: 12) {
                    //                                    AsyncImage(url: URL(string: item.imageUrl)) { image in
                    //                                        image.resizable()
                    //                                            .scaledToFit()
                    //                                            .frame(width: 50, height: 50)
                    //                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    //                                    } placeholder: {
                    //                                        ProgressView()
                    //                                            .frame(width: 50, height: 50)
                    //                                    }
                    //
                    //                                    VStack(alignment: .leading) {
                    //                                        Text(item.finalIngredients.first?.name ?? "Unknown")
                    //                                            .font(.headline)
                    //                                        Text("\(item.nutritionData.calories) kcal")
                    //                                            .font(.subheadline)
                    //                                            .foregroundColor(.gray)
                    //                                    }
                    //
                    //                                    Spacer()
                    //                                    Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                    //                                        .foregroundColor(.red)
                    //                                        .onTapGesture {
                    //                                            Task {
                    //                                                try? await favoriteVM.toggleFavorite(item: item)
                    //                                            }
                    //                                        }
                    //                                    Image(systemName: "chevron.right")
                    //                                        .foregroundColor(.gray)
                    //                                }
                    //                                .padding(.vertical, 5)
                    //                            }
                    //                            .listRowBackground(Color.clear)
                    //                        }
                    //
                    if favoriteVM.selectedTab == 1 {
                        List(favoriteVM.historyItems, id: \.id) { item in
                            historyRow(for: item)
                        }
                        .listStyle(.plain)
                    } else {
                        List(favoriteVM.favoriteItems, id: \.id) { item in
                            historyRow(for: item)
                        }
                        .listStyle(.plain)
                    }
                }
            }
            //                        .scrollContentBackground(.hidden)
            //                        .tabItem {
            //                                Label("All History", systemImage: "clock")
            //                            }
            //                            .tag(1)
            //                        List(favoriteVM.favoriteItems, id: \.id) { item in
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
            //                                    Text(item.finalIngredients.first?.name ?? "Unknown")
            //                                        .font(.headline)
            //                                    Text("\(item.nutritionData.calories) kcal")
            //                                        .font(.subheadline)
            //                                        .foregroundColor(.gray)
            //                                }
            //
            //                                Spacer()
            //                                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
            //                                    .foregroundColor(.red)
            //                                    .onTapGesture {
            //                                        Task {
            //                                            try? await favoriteVM.toggleFavorite(item: item)
            //                                        }
            //                                    }
            //                                Image(systemName: "chevron.right")
            //                                    .foregroundColor(.gray)
            //                            }
            //                            .padding(.vertical, 5)
            //                        }
            //                        .listRowBackground(Color.clear)
            //                    }
            //
            //
            //                    .scrollContentBackground(.hidden)
            //                    .tabItem {
            //                            Label("Favorites", systemImage: "heart.fill")
            //                        }
            //                        .tag(0)
            //
            //                    }
            
            .onAppear {
                Task{
                    await favoriteVM.fetchHistory()
                }
                favoriteVM.observeHistoryUpdates()
                
            }
            
            
            
            .navigationTitle("Favorites")
            .sheet(item: $selectedItem) { selected in
                //   FavoriteDetailView(favoriteItem: selected)
                
            }
        }
        
    }
    
@ViewBuilder
private func historyRow(for item: HistoryModel) -> some View {
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
            Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .onTapGesture {
                    Task {
                        try? await favoriteVM.toggleFavorite(item: item)
                    }
                }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
    .listRowBackground(Color.clear)
}
}


#Preview {
    HomeView()
}
