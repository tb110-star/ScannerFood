//
//  FoodScannerApp.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//


  import SwiftUI
  import FirebaseCore

  @main
  struct FoodScannerApp: App {
       private var tabVM = TabVM()
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
                      .font(.system(size: settingVM.selectedFontSize.size))
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
              }
          }
          
        //  .environment(fireStoreManager)
      }
  }
 
