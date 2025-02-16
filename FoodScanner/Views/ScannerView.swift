//
//  ScannerView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//

import SwiftUI
import PhotosUI

struct ScanView: View {
    //  @Environment(ScanViewModel.self) private var viewModel
   // @State  var viewModel = ScanViewModel()
   // @State var viewModel: ScanViewModel // preview fromoutside
    @Bindable var viewModel: ScanViewModel
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
                Task {
                        await viewModel.loadAndConvertImage()
                    }
            }
            if let response = viewModel.visionResponse {
                        List(response.labelAnnotations ?? [], id: \.mid) { label in
                            Text("\(label.description) - Score: \(label.score)")
                        }
                    }
        }
        .padding()
    }
}



#Preview {
    ScanView(viewModel: ScanViewModel())
    //    ScanView(viewModel: ScanViewModel.previewModel)
}
