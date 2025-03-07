//
//  DeleteItemTip.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 06.03.25.
//

import Foundation
import TipKit

struct DeleteTip: Tip {
    
   static var onDeleteEvent = Event(id: "onDeleteEvent")

    var title: Text {
        Text("Swipe to delete")
//            .font(.headline)
//            .foregroundColor(.darkGreen)
    }
    
    var message: Text? {
        Text("swipe to the left to delete an item")
//            .font(.subheadline)
//            .foregroundColor(.darkGreen.opacity(0.8))
    }
    
    var image: Image? {
        Image(systemName: "hand.draw")
    }
    
    var rules: [Rule] {
        #Rule(Self.onDeleteEvent) { event in
            event.donations.count > 0
        }
        

  }
   
}

struct MyTipStyle: TipViewStyle {
    func makeBody (configuration: Configuration) -> some View {
      
        VStack() {
            HStack{
                configuration.image?
                    .resizable()
                    .frame (width: 20, height: 20)
                    .foregroundColor(.darkGreen)
                    .modifier(HandAnimationModifier())
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
        .background(.ultraThinMaterial)
        .cornerRadius (16)
        .frame(width: 300, height: 100)
    }
    struct HandAnimationModifier: ViewModifier {
        @State private var handOffset: CGFloat = 50
        @State private var isAnimating = false

        func body(content: Content) -> some View {
            content
                .offset(x: isAnimating ? 0 : handOffset)
                .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }

}
