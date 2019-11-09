//
//  ProductListViewModel.swift
//  Cubic Weight
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductListViewModeling {
    
    var getProducts: PublishSubject<Void> {get}
    var allProducts: [Product] {get}
    var airConditionersArray: [Product] {get}
    var averageCubicWeight: PublishSubject<String> {get}
    var sortAirConditioners: PublishSubject<Void> {get}
    var getAirConditionersSuccess: PublishSubject<Void> {get}
    
    func getProductFromAPI() -> Observable<[Product]>
    
}

class ProductListViewModel: ProductListViewModeling{
    
    let networkService: NetworkServicing
    var getProducts: PublishSubject<Void> = PublishSubject<Void>()
    var allProducts: [Product] = [Product]()
    var airConditionersArray: [Product] = [Product]()
    var averageCubicWeight: PublishSubject<String> = PublishSubject<String>()
    var sortAirConditioners: PublishSubject<Void> = PublishSubject<Void>()
    var getAirConditionersSuccess: PublishSubject<Void> = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    
    init(networkService: NetworkServicing){
        
        self.networkService = networkService
        
        getProducts
            .flatMapLatest { [weak self] (_) -> Observable<[Product]> in
                guard let strongSelf = self else {
                    return Observable.just([Product]())
                }
                
                return strongSelf.getProductFromAPI()
            }
            .subscribe(onNext: { [weak self] (products) in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.allProducts = strongSelf.allProducts + products
                strongSelf.sortAirConditioners.onNext(())
            }, onError: { (error) in
                debugPrint(error)
            })
            .disposed(by: disposeBag)
        
        sortAirConditioners
            .subscribe(onNext: { [weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                
                let filteredArray = strongSelf.filterProductsByAirConditioners(products: strongSelf.allProducts)
                
                strongSelf.averageCubicWeight.onNext(strongSelf.getAverageCubicWeightOfProducts(products: filteredArray))
                strongSelf.airConditionersArray = filteredArray
                strongSelf.getAirConditionersSuccess.onNext(())
                
                
                
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func getProductFromAPI() -> Observable<[Product]>{
        //Create an observable of product array here
        return Observable.create { [weak self] observer in
            self?.networkService.getProducts(completionHandler: { (productArray, result) in
                switch result{
                case .failure:
                    debugPrint("There is an error when getting product data")
                    observer.onError(result)
                case .success:
                    if let products = productArray {
                        observer.onNext(products)
                    } else {
                        observer.onNext([Product]())
                    }
                }
            })
            
            return Disposables.create {
            }
        }
    }
    
    func filterProductsByAirConditioners(products: [Product]) -> [Product]{
        return products.filter({ (product) -> Bool in
            if let category = product.category{
                if category.contains("Air Conditioners"){
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        })
    }
    
    func getAverageCubicWeightOfProducts(products: [Product]) -> String{
        let totalSum = products.map({$0.cubicWeight}).reduce(0, +)
        let averageCubicWeight = totalSum / Double(products.count)
        return String(format: "%.2f", averageCubicWeight)
    }
    
    
}


