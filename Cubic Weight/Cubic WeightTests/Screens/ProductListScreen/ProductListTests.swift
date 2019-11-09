//
//  ProductListTests.swift
//  Cubic WeightTests
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import XCTest
import RxSwift
@testable import Cubic_Weight

class CountryTest: XCTestCase {
    
    var viewModel: ProductListViewModeling?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testSuccessfulGetProducts(){
        let disposeBag = DisposeBag()
        let networkService = MockNetworkService()
        let mockProductArray = [Product(),Product()]
        let result: ([Product]?, NetworkError) = (mockProductArray, NetworkError.success)
        networkService.getProductsResult = result
        viewModel = ProductListViewModel.init(networkService: networkService)
        
        let expectProductsFetched = expectation(description:"Fetched result contains products data")
        viewModel?.getProductFromAPI()
            .subscribe(onNext: { (products) in
                let productDataFetched: Bool
                if products.isEmpty{
                    productDataFetched = false
                } else {
                    productDataFetched = true
                }
                
                XCTAssertTrue(productDataFetched)
                expectProductsFetched.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectProductsFetched], timeout:0.1)
    }
    
    func testFailToGetEmployees(){
        let disposeBag = DisposeBag()
        let networkService = MockNetworkService()
        let mockProductArray = [Product]()
        let result: ([Product]?, NetworkError) = (mockProductArray, NetworkError.failure)
        networkService.getProductsResult = result
        viewModel = ProductListViewModel.init(networkService: networkService)
        
        let expectProductsFailToFetch = expectation(description:"Fetched result does not contains products data")
        viewModel?.getProductFromAPI()
            .subscribe(onNext: { (products) in
                
            }, onError: { (error) in
                expectProductsFailToFetch.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectProductsFailToFetch], timeout:0.1)
    }
    
    func testSuccessFilterProductsByAirConditioners(){
        let networkService = MockNetworkService()
        viewModel = ProductListViewModel.init(networkService: networkService)

        let mockProductOne = Product()
        mockProductOne.category = "Shoes"

        let mockProductTwo = Product()
        mockProductTwo.category = "Air Conditioners"

        let products = [mockProductOne, mockProductTwo]
        
        let filteredProducts = viewModel?.filterProductsByAirConditioners(products: products) ?? [Product]()
        
        XCTAssertEqual(filteredProducts.count, 1, "The filtered product should only have 1 element")
        XCTAssertEqual(filteredProducts[0].category, "Air Conditioners", "The filtered product category should be Air Conditioners")
        
    }
    
    func testSuccessGetAverageCubicWeightOfProducts(){
        let networkService = MockNetworkService()
        viewModel = ProductListViewModel.init(networkService: networkService)
        
        let mockProductOne = Product()
        let mockProductSizeOne = ProductSize()
        mockProductSizeOne.width = 10
        mockProductSizeOne.length = 10
        mockProductSizeOne.height = 10
        mockProductOne.size = mockProductSizeOne
        
        let mockProductTwo = Product()
        let mockProductSizeTwo = ProductSize()
        mockProductSizeTwo.width = 20
        mockProductSizeTwo.length = 20
        mockProductSizeTwo.height = 20
        mockProductTwo.size = mockProductSizeTwo
        
        let products = [mockProductOne, mockProductTwo]
        
        let averageCubicWeight = viewModel?.getAverageCubicWeightOfProducts(products: products) ?? ""
        
        XCTAssertEqual(averageCubicWeight, "1.13", "The average cubic weight should be 1.13 kg")
    }
    
}
