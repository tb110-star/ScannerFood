//
//  SettingView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//
import SwiftUI

struct SettingView: View {
    @EnvironmentObject var settingVM: SettingVM
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
       NavigationStack {
        ZStack {
          Color.timberwolf.ignoresSafeArea()
        ScrollView {
        VStack(alignment:.leading) {
            Section(
                header: Label("Personal Settings", systemImage: "person.fill").scaleEffect(0.9)
                    .foregroundColor(colorScheme == .dark ? .white : .gray))
                 {
                            VStack{
                                Toggle(isOn: $settingVM.isDarkMode) {
                                    Text(settingVM.isDarkMode ? "Dark Mode" : "Light Mode")
                                }
                                Divider()
                                VStack(alignment:.leading ){
                                    Text("Select Font size")
                                    Spacer()
                                    Picker("Font Size", selection: $settingVM.selectedFontSize) {
                                        ForEach(FontSizeOption.allCases, id: \.self) { size in
                                            Text(size.rawValue).tag(size)
                                        }
                                    }
                                }
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .padding()
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                            
                        }
            Divider()
                        
            Section(
                header: Label("Help", systemImage: "questionmark.circle.fill").scaleEffect(0.9)
                    .foregroundColor(colorScheme == .dark ? .white : .gray))
            {
                VStack(alignment:.leading){
                                Link(destination: URL(string: "https://www.google.com")!) {
                                    HStack{
                                        Image(systemName: "globe")
                                        Text("Help Forum")
                                    }
                                }
                                Divider()
                                Link(destination: URL(string: "tel://+4912345")!) {
                                    HStack{
                                        Image(systemName: "phone")
                                        Text("Hotline")
                                    }
                               }
                            }
                .foregroundColor(colorScheme == .dark ? .white : .darkGreen)
                            .padding()
                            .frame(maxWidth: .infinity,maxHeight:.infinity)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(12)
                            
                        }
                    }
        .padding()
                    
                }

                .padding()
                
                .pickerStyle(SegmentedPickerStyle())
                
                .navigationTitle("Setting")
                .preferredColorScheme(settingVM.isDarkMode ? .dark : .light)
            }
             .foregroundColor(colorScheme == .dark ? .timberwolf : .fontDarkGreen)

            .font(.system(size: settingVM.selectedFontSize.size))
        }
    }
}

#Preview {
    let settingVM = SettingVM()
    SettingView()
        .environmentObject(settingVM)
}

