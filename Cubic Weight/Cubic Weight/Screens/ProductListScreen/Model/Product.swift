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
    var cubicWeight: Double {
        get{
            if let width = size?.width, let length = size?.length, let height = size?.height{
                let widthInMeters = width * 0.01
                let lengthInMeters = length * 0.01
                let heightInMeters = height * 0.01
                //250 is the industry standard cubic weight conversion factor
                return widthInMeters * lengthInMeters * heightInMeters * 250
            }
            return 0
        }
    }
    
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

