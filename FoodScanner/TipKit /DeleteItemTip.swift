//
//  DeleteItemTip.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 06.03.25.
//

import Foundation
import TipKit

struct DeleteTip: Tip {
    
 //   static var onDeleteEvent = Event(id: "onDeleteEvent")
//
    var title: Text {
        Text("Swipe to delete")
    }
    
    var message: Text? {
        Text("swipe to the left to delete an item")
    }
    
    var image: Image? {
        Image(systemName: "hand.point.up.left.fill")
    }
    
//    var rules: [Rule] {
//        #Rule(Self.onDeleteEvent) { event in
//            event.donations.count == 0
//        }
//        

//  }
}

