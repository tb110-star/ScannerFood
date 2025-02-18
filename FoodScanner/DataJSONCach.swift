//
//  DataJasonCach.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//

import Foundation
import SwiftData
@Model

class DataJSONCach : Identifiable {
    var id :UUID
    var data: Data
    init(id: UUID, data:Data){
        self.id = id
        self.data = data
    }
}
