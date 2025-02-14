//
//  ScanViewModel.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 13.02.25.
//
import SwiftUI
import PhotosUI

@Observable
class ScanViewModel {
    var selectedItem: PhotosPickerItem? = nil
    var selectedImage: UIImage? = nil

    func loadSelectedImage() {
        Task {
            if let item = selectedItem {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    selectedImage = UIImage(data: data)
                }
            }
        }
    }
}
