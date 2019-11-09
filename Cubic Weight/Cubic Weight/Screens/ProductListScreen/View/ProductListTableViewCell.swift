//
//  ProductListTableViewCell.swift
//  Cubic Weight
//
//  Created by Kaipeng Wu on 9/11/19.
//  Copyright © 2019 Kaipeng Wu. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product){
        categoryLabel.text = "Category: " + (product.category ?? "")
        titleLabel.text = "Title: " + (product.title ?? "")
        weightLabel.text = "Weight: " + (String(product.weight ?? 0)) + "grams"
        widthLabel.text = "Width: " + (String(product.size?.width ?? 0)) + "cm"
        heightLabel.text = "Width: " + (String(product.size?.height ?? 0)) + "cm"
        lengthLabel.text = "Length: " + (String(product.size?.length ?? 0)) + "cm"
    }
    
}
