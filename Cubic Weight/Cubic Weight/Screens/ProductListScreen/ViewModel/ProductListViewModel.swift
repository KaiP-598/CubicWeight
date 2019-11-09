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
    var airConditionersArray: PublishSubject<[Product]> {get}
    var averageCubicWeight: PublishSubject<String> {get}
    
    func getProductFromAPI() -> Observable<[Product]>
    
}

class ProductListViewModel: ProductListViewModeling{
    
    let networkService: NetworkServicing
    var getProducts: PublishSubject<Void> = PublishSubject<Void>()
    var allProducts: [Product] = [Product]()
    var airConditionersArray: PublishSubject<[Product]> = PublishSubject<[Product]>()
    var averageCubicWeight: PublishSubject<String> = PublishSubject<String>()
    
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
                
                strongSelf.allProducts = products
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func getProductFromAPI() -> Observable<[Product]>{
        //Create an observable of employee array here
        return Observable.create { [weak self] observer in
            self?.networkService.getProducts(completionHandler: { (productArray, result) in
                switch result{
                case .failure:
                    debugPrint("There is an error when getting product data")
                    observer.onNext([Product]())
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
    
    
    
    
}


