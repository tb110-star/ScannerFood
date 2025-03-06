//
//  FoodScannerApp.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//


  import SwiftUI
  import FirebaseCore
import TipKit
  @main
  struct FoodScannerApp: App {
       private var tabVM = TabVM()
      private var favoriteVM = FavoriteVM()

       private var scanViewModel = ScanViewModel()
       private var settingVM = SettingVM()
      private var authViewModel : AuthViewModel
      private var fireStoreManager = FireStoreManeger()
  init() {
      FirebaseConfiguration.shared.setLoggerLevel(.min)
      FirebaseApp.configure()
      authViewModel = AuthViewModel()
  }
  

      var body: some Scene {
          WindowGroup {
              if authViewModel.isUserSignedIn {
                  TabsView()
                      .task {
                          try? Tips.resetDatastore()
                          try? Tips.configure()
                      }
                      .font(.system(size: settingVM.selectedFontSize.size))
                      .environment(favoriteVM)

                      .environment(tabVM)
                     .environment(scanViewModel)
                     .environment(settingVM)
                     .preferredColorScheme(settingVM.isDarkMode ? .dark : .light)

                     .environment(authViewModel)
  } else {
                  LoginView(authViewModel: authViewModel)
                   .environment(settingVM)
                    .environment(tabVM)
                 .environment(scanViewModel)
                  .environment(authViewModel)
                  .environment(favoriteVM)

              }
          }
          
        //  .environment(fireStoreManager)
      }
  }
 
