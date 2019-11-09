//
//  ProductSize.swift
//  Cubic Weight
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductSize: Mappable {
    var width: Double?
    var length: Double?
    var height: Double?
    
    init (){
        
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        width <- map["width"]
        length <- map["length"]
        height <- map["height"]
    }
}

