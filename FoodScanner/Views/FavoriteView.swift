//////
//////  FavoriteView.swift
//////  FoodScanner
//////
//////  Created by tarlan bakhtiari on 04.02.25.


import SwiftUI
import TipKit

struct FavoriteView: View {
    @Bindable var favoriteVM : FavoriteVM
    @State private var selectedItem: HistoryModel? = nil
    @State private var selectedItemtoDelet: HistoryModel? = nil
    @State private var showSheet = false
    @State  var nutritionData : HistoryModel? = nil
    @Environment(SettingVM.self) private var settingVM
    @State private var showingDeleteAlert = false
    @Environment(AuthViewModel.self) private var authViewModel

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
                        TipView(favoriteVM.onDeleteItem)
                            .tipBackground(.ultraThinMaterial.opacity(0.4))
                            .tipViewStyle(MyTipStyle()).padding(.horizontal,12)
                        List(favoriteVM.historyItems, id: \..id) { item in
                            historyRow(for: item)
                        }
                        .scrollContentBackground(.hidden)
                        .alert("Are you sure you want to delete this item?", isPresented: $showingDeleteAlert) {
                            Button("Delete", role: .destructive) {
                                guard let history = selectedItemtoDelet else {
                                            print("❌ Error: No item selected for deletion")
                                            return
                                        }
                            print("🟢 Deleting item with ID: \(history.id ?? "No ID")")
                            favoriteVM.deleteHistory(history)
                            }
                            Button("Cancel", role: .cancel) { }
                        }
                        .listStyle(.plain)
                    } else {
                        List(favoriteVM.favoriteItems, id: \..id) { item in
                            historyRow(for: item)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
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
                                         Text("\(user.userName) 👋")
                                             .font(.custom("AvenirNext", size: 18))
                                             .foregroundColor(Color(.darkGray))

                                     } else{
                                         Text("Hi,Dear Guest 😊").font(.custom("AvenirNext", size: 18))
                                             .foregroundColor(Color(.darkGray))

                 
                                     }
                                }
            }

            .onAppear {
                Task {
                    await favoriteVM.fetchHistory()
                }
                favoriteVM.observeHistoryUpdates()
            }
            .toolbarBackground(.ultraThinMaterial.opacity(0.5), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
           // .navigationTitle("")

            .sheet(item: $selectedItem) { selected in
                 DetailView(favoriteItem: selected)
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.ultraThinMaterial)
            
            }
        }
    }
    
    
    @ViewBuilder
    private func historyRow(for item: HistoryModel) -> some View {
        VStack{
        Button {
            selectedItem = item
            showSheet = true
        } label: {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: item.imageUrl)) { image in
                    image.resizable()
                        .scaledToFill()
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
            Divider()
              .listRowBackground(Color.clear)
        }
    }
        .swipeActions{
            Button(role:.destructive) {
                selectedItemtoDelet = item

                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
       // .listRowInsets(EdgeInsets())
      //  .padding(.horizontal)
//        Divider()
//            .listRowBackground(Color.clear)

    }
    
}
