//
//  MockNetworkService.swift
//  Cubic WeightTests
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import XCTest
@testable import Cubic_Weight

class MockNetworkService: NetworkServicing{
    
    var getProductsResult: ([Product]?, NetworkError)?
    
    func getProducts(completionHandler: @escaping ([Product]?, NetworkError) -> ()) {
        guard let result = getProductsResult else {
            completionHandler(nil, .failure)
            return
        }
        
        completionHandler(result.0, result.1)
    }
    
}

