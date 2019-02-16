//
//  CurrencyTableViewCell.swift
//  revolut-test
//
//  Created by Frederico Bechara De Paola on 06/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import UIKit

protocol CurrencyCellTextDelegate: class {
    func amountChanged(to amount: Double)
    func becameFirstResponder(cell: CurrencyTableViewCell)
    func stoppedBeingFirstResponder(cell: CurrencyTableViewCell)
    func newInput(value: Double)
}

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var abreviationLabel: UILabel!
    @IBOutlet weak var completeTitleLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    
    public weak var delegate: CurrencyCellTextDelegate?
    var originalModel: Rates?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceTextField.delegate = self
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        logoImageView.clipsToBounds = true
    }
    
    func setup(model: Rates, multiplier: Double = 1) {
        abreviationLabel.text = model.currency
        completeTitleLabel.text = model.getSubtitle()
        logoImageView.image = model.getImage()
        priceTextField.text = String(format: "%.2f", model.value * multiplier)
        originalModel = model
    }
    
    @IBAction func textFieldTextChanged(_ sender: Any) {
        guard let text = self.priceTextField.text, let textAsDouble = Double(text) else {
            return
        }
        delegate?.amountChanged(to: textAsDouble)
    }
    
    func updateValue(to newValue: Double) {
        priceTextField.text = String(format: "%.2f", originalModel?.value ?? 0 * newValue)
        layoutIfNeeded()
    }
    
}

extension CurrencyTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.becameFirstResponder(cell: self)
        underlineView.backgroundColor = #colorLiteral(red: 0.5379999876, green: 0.7820000052, blue: 1, alpha: 1)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.stoppedBeingFirstResponder(cell: self)
        underlineView.backgroundColor = #colorLiteral(red: 0.7490000129, green: 0.7490000129, blue: 0.7490000129, alpha: 1)
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
            let textFieldText: NSString = (textField.text ?? "") as NSString
            let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string) as NSString
            delegate?.newInput(value: txtAfterUpdate.doubleValue)
            return true
    }
}
