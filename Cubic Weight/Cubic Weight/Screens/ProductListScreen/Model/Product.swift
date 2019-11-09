//
//  Product.swift
//  Cubic Weight
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import Foundation
import ObjectMapper

class Product: Mappable {
    var category: String?
    var title: String?
    var weight: Double?
    var size: ProductSize?
    
    init (){
        
    }
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        category <- map["category"]
        title <- map["title"]
        weight <- map["weight"]
        size <- map["size"]
    }
}

