//
//  Station.swift
//  werkstuk_2
//
//  Created by DE MAEYER Kenny (s) on 24/05/2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

struct Position {
    var latitude:Double?
    var longitude:Double?
}

class Station: NSObject {
    
    var number:Int
    var name:String
    var address:String
    var position:Position
    var banking:Bool
    var bonus:Bool
    var status:String
    var bike_stands:Int
    var available_stands:Int
    var available_bikes:Int
    
    override init() {
        self.number = 0
        self.name = "//"
        self.address = "//"
        self.position = Position(latitude: 0.0, longitude: 0.0)
        self.banking = false
        self.bonus = false
        self.status = "UNKNOWN"
        self.bike_stands = 0
        self.available_stands = 0
        self.available_bikes = 0
    }
}
