//
//  FoodScannerApp.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//

import SwiftUI
import SwiftData
import FirebaseCore

//@main
//struct FoodScannerApp: App {
//    @StateObject var  tabVM = TabVM()
//    private var scanViewModel = ScanViewModel()
//    @StateObject var  settingVM = SettingVM()
//    @State private var authViewModel : AuthViewModel
//  
//    init() {
//        FirebaseConfiguration.shared.setLoggerLevel(.min)
//        FirebaseApp.configure()
//        authViewModel = AuthViewModel()
//    }
//    var body: some Scene {
//        WindowGroup {
//            if authViewModel.isUserSignedIn {
//                ContentView()
//                    
//                    .environmentObject(settingVM)
//                    .environmentObject(tabVM)
//                    .environment(scanViewModel)
//                    .environment(authViewModel)
//            } else {
//                LoginView(authViewModel: AuthViewModel())
//                  
//                    .environmentObject(settingVM)
//                    .environmentObject(tabVM)
//                    .environment(scanViewModel)
//                    .environment(authViewModel)
//            }
//        }
//        .modelContainer(for:DataJSONCach.self)
//    }
//}

  import SwiftUI
  import FirebaseCore

  @main
  struct FoodScannerApp: App {
      @StateObject var tabVM = TabVM()
      private var scanViewModel = ScanViewModel()
      @StateObject var settingVM = SettingVM()
      @State var authViewModel : AuthViewModel
      @State var fireStoreManager = FireStoreManeger()
  init() {
      FirebaseConfiguration.shared.setLoggerLevel(.min)
      FirebaseApp.configure()
      authViewModel = AuthViewModel()
  }
  

      var body: some Scene {
          WindowGroup {
              if authViewModel.isUserSignedIn {
                  ContentView()
                      
  } else {
                  LoginView(authViewModel: authViewModel)
                     
              }
          }
          .environmentObject(settingVM)
          .environmentObject(tabVM)
          .environment(scanViewModel)
          .environment(authViewModel)
        //  .environment(fireStoreManager)
      }
  }
 
