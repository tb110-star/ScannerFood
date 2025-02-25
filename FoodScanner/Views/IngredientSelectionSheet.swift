//
//  IngredientSelectionSheet.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 21.02.25.
//


import SwiftUI

struct IngredientSelectionSheet: View {
    @Bindable var viewModel: ScanViewModel
    @Binding var isPresented: Bool
    
    @State private var newIngredientName = ""
    @State private var newIngredientAmount = ""
    @State private var newIngredientUnit: MeasurementUnit = .gram
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.timberwolf.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    // ScrollView(.vertical, showsIndicators: false)
                    let columns = [
                        GridItem(.flexible(), spacing: 6),
                        GridItem(.flexible(), spacing: 6),
                        GridItem(.flexible(), spacing: 6)
                        
                    ]
                    LazyVGrid(columns: columns, spacing: 6)    {
                        //   HStack {
                        ForEach(viewModel.recognizedIngredients) { ingredient in
                            Button(action: {
                                viewModel.toggleIngredientSelection(ingredient: ingredient)
                            }) {
                                Text(ingredient.name)
                                    .padding(.vertical, 5)                          .frame(minWidth: 80, maxWidth: .infinity)
                                    .lineLimit(1)      .background(viewModel.selectedIngredients.contains { $0.name == ingredient.name } ? Color.pinkLavender.opacity(0.5) : Color.white.opacity(0.5))
                                    .foregroundColor(.primary)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .stroke(viewModel.selectedIngredients.contains { $0.name == ingredient.name } ? Color.pinkLavender : Color.white, lineWidth: 0.5)
                                    )
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        // }
                    }
                    
                  //  ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            List{
                            ForEach($viewModel.selectedIngredients) { $item in
                                VStack{
                                    HStack {
                                        Text(item.name)
                                            .bold()
                                        Spacer()
                                        TextField("quantity", text: $item.amount)
                                            .keyboardType(.decimalPad)
                                            .frame(width: 50)
                                            .multilineTextAlignment(.center)
                                            .background(Color.white.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 7))
                                        
                                    }
                                    Picker("", selection: $item.unit) {
                                        ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                                            Text(unit.rawValue).tag(unit)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    
                                }
                                .padding(.vertical)
                                .listRowBackground(Color.clear)

                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth:.infinity)
                                
                                .background(Color.manatee.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.selectedIngredients.removeAll { $0.id == item.id }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                                .listRowInsets(EdgeInsets())
                            }
                            .padding(.vertical)

                        }
                            .scrollContentBackground(.hidden)

                    }
                    
                    VStack{
                        HStack {
                            TextField("Add new Ingrediant", text: $newIngredientName)
                                .textFieldStyle(.roundedBorder)
                            
                            TextField("Quantity", text: $newIngredientAmount)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 70)
                            
                        }
                        Picker("", selection: $newIngredientUnit) {
                            ForEach(MeasurementUnit.allCases, id: \.self) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        Button("+") {
                            viewModel.addCustomIngredient(name: newIngredientName, amount: newIngredientAmount, unit: newIngredientUnit)
                            newIngredientName = ""
                            newIngredientAmount = ""
                        }
                        .font(.title2)
                        .frame(width: 35, height: 35)       .background(Color.pink.opacity(0.4))   .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        //                        .buttonStyle(.borderedProminent)
                        //                        .tint(Color.pinkLavender)
                        //                        .foregroundColor(Color.black)
                    }
                    .frame(maxWidth:.infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    Spacer()
                    Button("Save") {
                        isPresented = false
                    }
                    .font(.title2)
                    .frame(width: 300, height: 40)       .background(Color.pink.opacity(0.4))   .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(radius: 4)
                }
            }
            .navigationTitle("Ingrediant")
            
        }
    }
}

#Preview {
    IngredientSelectionSheet(viewModel: ScanViewModel(isMock: true), isPresented: .constant(true))}
