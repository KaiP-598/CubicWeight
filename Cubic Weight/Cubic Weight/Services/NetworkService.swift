//
//  NetworkService.swift
//  Cubic Weight
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper

enum NetworkError: Error {
    case failure
    case success
}

protocol NetworkServicing {
    func getProducts(completionHandler: @escaping ([Product]?, NetworkError) -> ())
}

class NetworkService: NetworkServicing{
    
    let BASE_URL_END_POINT = "http://wp8m3he1wt.s3-website-ap-southeast-2.amazonaws.com"
    var PRODUCT_URL: String? = "/api/products/1"

    /// Get all product listings data from the endpoint
    ///
    /// - parameter completionHandler: handler containing product array and network result.
    func getProducts(completionHandler: @escaping ([Product]?, NetworkError) -> ()) {
        guard let productURL = PRODUCT_URL else {
            completionHandler(nil, .failure)
            return
        }
        
        let finalEnpoint = BASE_URL_END_POINT + productURL
        
        Alamofire.request(finalEnpoint).responseJSON { [weak self] response in
            
            if let err = response.error{
                debugPrint(err)
                completionHandler(nil, .failure)
                return
            }
            
            guard let data = response.data else {
                completionHandler(nil, .failure)
                return
            }
            
            let json = try? JSON(data: data)
            if let nextUrl = json?["next"]{
                self?.PRODUCT_URL = nextUrl.stringValue
            }
            if let productsJson = json?["objects"]{
                let productsArray = Mapper<Product>().mapArray(JSONObject: productsJson.arrayObject)
                completionHandler(productsArray, .success)
            } else {
                completionHandler(nil, .failure)
                return
            }
            
        }
    }
    
}


