//
//  ViewController.swift
//  revolut-test
//
//  Created by Frederico Bechara De Paola on 06/02/19.
//  Copyright © 2019 Frederico Bechara De Paola. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    private let kReuseIdentifier = "currencyTableViewCell"
    private var currencyList: CurrencyModel?
    private var base: Rates = Rates(currency: "EUR", value: 1)
    private var amountInputByUser: Double = 1
    var rqtr = Business(requester: Provider())
    var timer: Timer?
    var inputingData = false
    let initialIndex = IndexPath(item: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil),
                           forCellReuseIdentifier: kReuseIdentifier)
        setupRun()
    }
    
    private func setupRun() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.loadData {
                DispatchQueue.main.async {
                    if let inputingData = self?.inputingData, !inputingData {
                        self?.tableView.reloadData()
                    }
                }
            }
        })
        
        timer?.fire()

    }
    
    private func loadData(completion: @escaping () -> Void) {
        rqtr.getRates(base: base.currency, completion: { (model, error) in
            if error != nil {
                let alert = UIAlertController(title: "Sorry",
                                              message: "Something went wrong, please try again later",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                self.currencyList = model
            }
            completion()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: kReuseIdentifier) as? CurrencyTableViewCell,
            let ratesModel = currencyList?.orderedRates() else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            listCell.setup(model: base, multiplier: amountInputByUser)
        } else {
            listCell.setup(model: ratesModel[indexPath.row], multiplier: amountInputByUser)
        }
        
        listCell.delegate = self

        return listCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let validCurrencyList = currencyList?.orderedRates() {
            return validCurrencyList.count
        } else {
         return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        timer?.invalidate()
        updateBase(at: indexPath)
        view.endEditing(true)
        tableView.performBatchUpdates({
            tableView.moveRow(at: indexPath, to: initialIndex)
            tableView.scrollToRow(at: initialIndex, at: .top, animated: true)
            if let cell = tableView.cellForRow(at: indexPath) as? CurrencyTableViewCell {
                cell.priceTextField.becomeFirstResponder()
            }
        }, completion: nil)
        setupRun()
    }
    
    func updateBase(at index: IndexPath) {
        guard let cell = tableView.cellForRow(at: index) as? CurrencyTableViewCell else {
            return
        }
        amountInputByUser = 1
        base.currency = cell.abreviationLabel.text ?? ""
        base.value = (cell.priceTextField?.text as NSString?)?.doubleValue ?? 0
    }
}

extension ListViewController: CurrencyCellTextDelegate {
    
    func amountChanged(to amount: Double) {
        self.amountInputByUser = amount
    }
    
    func becameFirstResponder(cell: CurrencyTableViewCell) {
        inputingData = true
    }
    
    func stoppedBeingFirstResponder(cell: CurrencyTableViewCell) {
        inputingData = false
        checkForCellOnTop(cell)
    }
    
    func checkForCellOnTop(_ cell: CurrencyTableViewCell) {
        if let indexOfCell = tableView.indexPath(for: cell), indexOfCell != initialIndex {
            tableView(tableView, didSelectRowAt: indexOfCell)
        }
    }
    
    func newInput(value: Double) {
        amountInputByUser = value
        
        for cell in tableView.visibleCells {
            guard let currencyCell = cell as? CurrencyTableViewCell,
                let index = tableView.indexPath(for: currencyCell) else { return }
            if index != IndexPath(row: 0, section: 0) {
                currencyCell.updateValue(to: amountInputByUser)
                tableView.reloadRows(at: [index], with: .none)
            }
        }
        
    }
}
