//
//  HomeView.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 04.02.25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
                   Text("Home View")
               }
               .onAppear {
                   VisionAPIManager.testJSONPath() // ✅ اینجا اجرا می‌شود
               }
           }    }


#Preview {
    HomeView()
}
