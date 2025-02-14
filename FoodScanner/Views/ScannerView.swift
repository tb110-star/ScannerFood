//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//

import SwiftUI
import PhotosUI

struct ScanView: View {
    //@Environment(ScanViewModel.self) var viewModel
    @State  var viewModel = ScanViewModel()
   // @State var viewModel: ScanViewModel // preview fromoutside
    var body: some View {
        VStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                    )
            }

            PhotosPicker(
                selection: $viewModel.selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Upload from Gallery")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: viewModel.selectedItem, initial: false) { oldItem, newItem in
                viewModel.loadSelectedImage()
            }
        }
        .padding()
    }
}



#Preview {
    ScanView()
    //    ScanView(viewModel: ScanViewModel.previewModel)
}
