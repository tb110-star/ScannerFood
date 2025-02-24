//
//  Enums.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 05.02.25.
//
import SwiftUI

import Foundation
enum FontSizeOption: String, CaseIterable {
    case small = "small"
    case medium = "medium"
    case large = "lange"
    
    var size: CGFloat {
        switch self {
        case .small:
            return 12
        case .medium:
            return 16
        case .large:
            return 20
        }
    }
}


enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case home, scann, favorite //, setting
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .scann:
            return "barcode.viewfinder"
        case .favorite:
            return "heart.fill"
//        case .setting:
//            return "gearshape.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .scann:
            return "Scann"
        case .favorite:
            return "Favorite"
//        case .setting:
//            return "Setting"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return .indigo
        case .scann:
            return .pink
        case .favorite:
            return .orange
//        case .setting:
//            return .teal
        }
    }
}

