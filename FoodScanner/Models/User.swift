//
//  User.swift
//  FoodScanner
//
//  Created by tarlan bakhtiari on 17.02.25.
//

import Foundation

struct  User :Codable,Identifiable{
    var id :String
    var signedUpOn :Date
     var userName : String
     var birthDate : Date
     var gender : String
     //var occupation : String
}
