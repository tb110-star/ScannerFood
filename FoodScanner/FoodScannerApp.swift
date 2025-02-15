//
//  FoodScannerApp.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//

import SwiftUI

@main
struct FoodScannerApp: App {
    @StateObject var  tabVM = TabVM()
    private var scanViewModel = ScanViewModel()
   @StateObject var  settingVM = SettingVM()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingVM)
                .environmentObject(tabVM)
                .environment(scanViewModel)
        }
    }
}
