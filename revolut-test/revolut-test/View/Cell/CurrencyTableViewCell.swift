//
//  CurrencyTableViewCell.swift
//  revolut-test
//
//  Created by Frederico Bechara De Paola on 06/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var abreviationLabel: UILabel!
    @IBOutlet weak var completeTitleLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        logoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(model: Rates) {
        abreviationLabel.text = model.currency
        priceTextField.text = String(format: "%.2f", model.value)
    }
}
