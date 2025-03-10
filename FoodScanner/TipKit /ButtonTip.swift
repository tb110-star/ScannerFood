//
//  ButtonTip.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 06.03.25.
//
import Foundation
import TipKit
struct ScannButtonTip: Tip {
    static var scanButtonTapped = Event(id: "scanButtonTapped")

    var title: Text {
        Text("Scann an Image")
    }
    
    var message: Text? {
        Text("Press the button to select an image")
    }
    var image: Image? {
        Image(systemName: "hand.draw")
    }
    var rules: [Rule] {
        #Rule(ScannButtonTip.scanButtonTapped) { event in
            event.donations.count == 0
        }
        }
}
struct DetectButtonTip: Tip {
    static var detectButtonTapped = Event(id: "detectButtonTapped")

    var title: Text {
        Text("Detect an Image")
    }
    
    var message: Text? {
        Text("Press the button to detect ingredients")
    }
    var image: Image? {
        Image(systemName: "hand.tap")
    }
    var rules: [Rule] {
        #Rule(DetectButtonTip.detectButtonTapped) { event in
            event.donations.count > 0

        }
        }

}

struct NutritionButtonTip: Tip {
    static var nutritionButtonTapped = Event(id: "nutritionButtonTapped")

    var title: Text {
        Text("Nutrition facts")
    }
    
    var message: Text? {
        Text("Press the button to recieve nutrition facts")
    }
    var image: Image? {
        Image(systemName: "hand.draw")
    }
    var rules: [Rule] {
        #Rule(NutritionButtonTip.nutritionButtonTapped) { event in
            event.donations.count > 0
        }
        }

}

struct MyButtonTipStyle: TipViewStyle {
    func makeBody (configuration: Configuration) -> some View {
      
        VStack() {
            HStack{
                configuration.image?
                    .resizable()
                    .frame (width: 20, height: 20)
                    .foregroundColor(.darkGreen)
                    .modifier(AnimationModifier())
                Spacer()
                Button(action: {
                    configuration.tip.invalidate (reason: .tipClosed)
                }) {
                    Image (systemName: "xmark.circle")
                        .foregroundColor(.darkGreen)
                        .font(.title2)
                }
            }
            HStack {
                configuration.title
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.darkGreen)
                
                
                
                configuration.message?
                    .font(.caption)
                    .foregroundColor(.darkGreen)
                    .padding(. top,4)
                    .multilineTextAlignment (.leading)
              
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.1))
        .cornerRadius (16)
    }
    struct AnimationModifier: ViewModifier {
        @State private var isTapping = false

        func body(content: Content) -> some View {
            content
                .scaleEffect(isTapping ? 0.9 : 1.2)
                .offset(y: isTapping ? -5 : 0)
                .animation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true), value: isTapping)
                .onAppear {
                   isTapping = true
                }
        }
    }

}
