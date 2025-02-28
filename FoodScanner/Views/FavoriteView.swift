//////
//////  FavoriteView.swift
//////  FoodScanner
//////
//////  Created by tarlan bakhtiari on 04.02.25.


import SwiftUI

struct FavoriteView: View {
    @Bindable var favoriteVM : FavoriteVM
    @State private var selectedItem: HistoryModel? = nil
    @State private var showSheet = false
    @State  var nutritionData : HistoryModel? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.timberwolf.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("All History")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(favoriteVM.selectedTab == 1 ? Color.gray.opacity(0.2) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture { favoriteVM.selectedTab = 1 }
                        
                        Text("Favorites")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(favoriteVM.selectedTab == 0 ? Color.gray.opacity(0.2) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture { favoriteVM.selectedTab = 0 }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    if favoriteVM.selectedTab == 1 {
                        List(favoriteVM.historyItems, id: \..id) { item in
                            historyRow(for: item)
                        }
                        .listStyle(.plain)
                    } else {
                        List(favoriteVM.favoriteItems, id: \..id) { item in
                            historyRow(for: item)
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .onAppear {
                Task {
                    await favoriteVM.fetchHistory()
                }
                favoriteVM.observeHistoryUpdates()
            }
            .navigationTitle("Favorites")
            .sheet(item: $selectedItem) { selected in
                 DetailView(favoriteItem: selected)
            }
        }
    }
    
    
    @ViewBuilder
    private func historyRow(for item: HistoryModel) -> some View {
        Button {
            selectedItem = item
            showSheet = true
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
            .listRowBackground(Color.clear)
        }
        .listRowBackground(Color.clear)

    }
    
}
