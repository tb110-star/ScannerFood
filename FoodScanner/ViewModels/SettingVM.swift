//
//  SettingVM.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 05.02.25.
//

import Foundation
import SwiftUI
import SwiftData

class SettingVM: ObservableObject {
    @Published  var isDarkMode = false
    @Published  var isDataSendingEnabled = false
    @Published var selectedFontSize: FontSizeOption {
        didSet {
            UserDefaults.standard.set(selectedFontSize.rawValue, forKey: "fontSizePreference")
        }
    }
    
    init() {
        let fontSizeRawValue = UserDefaults.standard.string(forKey: "fontSizePreference") ?? FontSizeOption.medium.rawValue
        self.selectedFontSize = FontSizeOption(rawValue: fontSizeRawValue) ?? .medium
    }
}
