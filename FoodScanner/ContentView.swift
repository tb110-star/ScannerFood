//
//  ContentView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingVM: SettingVM
    @EnvironmentObject var tabVM: TabVM

    var body: some View {
      
    TabView()
        .font(.system(size: settingVM.selectedFontSize.size))
    }
}

#Preview {
    let settingVM = SettingVM()
    let tabVM = TabVM()
    
    ContentView()
        .environmentObject(settingVM)
        .environmentObject(tabVM)
    
}
