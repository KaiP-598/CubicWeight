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
        
    }
    
    func setupBinding(){
        viewModel = ProductListViewModel.init(networkService: NetworkService())
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        //Bind products array observable to tableview
        viewModel.airConditionersArray.bind(to: tableView.rx.items(cellIdentifier: "ProductListTableViewCell", cellType: ProductListTableViewCell.self)) { row, product, cell in
                cell.configureCell(product: product)
            }.disposed(by: disposeBag)
        
        viewModel.averageCubicWeight
            .subscribe(onNext: { [weak self] (avgWeight) in
                self?.averageCubicWeightLabel.text = "Current Avg Cubic Weight: " + avgWeight + "kg"
            })
            .disposed(by: disposeBag)
        
        viewModel.getProducts.onNext(())
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView{
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > (scrollView.contentSize.height - 200)) && shouldFetchMore){
                shouldFetchMore = false
                viewModel?.getProducts.onNext(())
                print ("Hello")
            }
        }
    }

}

extension ProductListViewController: UITableViewDelegate{

}

