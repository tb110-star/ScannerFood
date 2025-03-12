//
//  HomeView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//

import SwiftUI

struct HomeView: View {
    @Bindable var favoriteVM : FavoriteVM
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(SettingVM.self) private var settingVM

    var user:User? = nil
    @State private var userTarget: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.timberwolf.ignoresSafeArea()
                VStack() {
//                HStack(){
//                    if let user = authViewModel.user {
//                        Text("Hi, Dear \(user.userName) 👋")
//                            .font(.custom("AvenirNext-Bold", size: 24))
//                    } else{
//                        Text("Hi, Dear guest 😊").font(.custom("AvenirNext-Bold", size: 24))
//                        
//                    }
//                    Spacer()
//                }
//                .padding()
//                Divider()
//                    
                Text("Daily Calories")
                    .font(.system(.title))
                    .padding()
                //
                HStack {
                    TextField("Change your target calories", text: $userTarget)
                        .padding(12)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.plain)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)

                    //
                    Button(action: {
                        Task {
                            if let target = Double(userTarget) {
                                favoriteVM.targetCalories = target
                            }
                        }
                    })
                    {
                        Text("Set")
                            .font(.headline)
                            .frame(width: 80, height: 40)
                            .background(Color.grad1)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 1)
                    }
                }
                .padding()
               
                    Gauge(value: favoriteVM.todayCalories, in: 0...favoriteVM.targetCalories) {
                        Text("Calories")
                    } currentValueLabel: {
                        Text("\(Int(favoriteVM.todayCalories))")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color.grad2)
                    } minimumValueLabel: {
                        Text("0")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.grad0)
                    } maximumValueLabel: {
                        Text("\(Int(favoriteVM.targetCalories))")
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.grad3)
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(Gradient(colors: [.grad0, .grad1, .grad2, .grad3]))
                    .scaleEffect(4)
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .background(Color.clear)
                    Spacer()
            }
            .onAppear{
                Task{
                    await favoriteVM.fetchHistory()
                    print("🟢 todayCalories: \(favoriteVM.todayCalories)")
                    print("🔵 targetCalories: \(favoriteVM.targetCalories)")
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
        }
    }
}
    #Preview {
        //    HomeView()
        //        .environment(SettingVM())
        
    }

