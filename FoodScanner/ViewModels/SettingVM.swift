//
//  SettingVM.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 05.02.25.
//

import Foundation
import SwiftUI
import SwiftData
@MainActor
@Observable
class SettingVM {
 var isDarkMode = false
 var isDataSendingEnabled = false
 var selectedFontSizeRaw: String = FontSizeOption.medium.rawValue

    var selectedFontSize: FontSizeOption {
        get { FontSizeOption(rawValue: selectedFontSizeRaw) ?? .medium }
        set { selectedFontSizeRaw = newValue.rawValue }
    }
}
