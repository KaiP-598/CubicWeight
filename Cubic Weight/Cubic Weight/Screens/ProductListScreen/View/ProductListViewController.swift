//
//  ViewController.swift
//  Cubic Weight
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var averageCubicWeightLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: ProductListViewModeling?
    var shouldFetchMore = true
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBinding()
    }
    
    func setupView(){
        
        tableView.register(UINib(nibName: "ProductListTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProductListTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func setupBinding(){
        viewModel = ProductListViewModel.init(networkService: NetworkService())
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        //subscribe to getAirConditionersSuccess
        viewModel.getAirConditionersSuccess
            .subscribe(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
                self?.shouldFetchMore = true
            })
            .disposed(by: disposeBag)
        
        //Subscribe to average cubic weight and update label
        viewModel.averageCubicWeight
            .subscribe(onNext: { [weak self] (avgWeight) in
                self?.averageCubicWeightLabel.text = "Current Average Cubic Weight: " + avgWeight + "kg"
            })
            .disposed(by: disposeBag)
        
        viewModel.getProducts.onNext(())
    }

}

extension ProductListViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = viewModel?.airConditionersArray{
            return products.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let products = viewModel?.airConditionersArray{
            let product = products[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell") as? ProductListTableViewCell {
                cell.configureCell(product: product)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //load more data when reach to the last displayed cell
        if let array = viewModel?.airConditionersArray{
            let lastElement = array.count - 1
            if indexPath.row == lastElement && shouldFetchMore {
                shouldFetchMore = false
                viewModel?.getProducts.onNext(())
                debugPrint("Start to fetch more products")
            }
        }
    }
    
}

