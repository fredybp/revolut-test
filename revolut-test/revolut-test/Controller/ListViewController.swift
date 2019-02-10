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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: kReuseIdentifier)
//        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: kReuseIdentifier)
        setupNextRun()
//        loadData {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
    private func setupNextRun() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self?.loadData {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    private func loadData(completion: @escaping () -> Void) {
        let rqtr = Requester()
        rqtr.request { (model, error) in
            if let err = error {
                print(err)
            } else {
                self.currencyList = model as? CurrencyModel
            }
            completion()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: kReuseIdentifier) as? CurrencyTableViewCell, let ratesModel = currencyList?.orderedRates() else {
            return UITableViewCell()
        }
        
        listCell.setup(model: ratesModel[indexPath.row])
        
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
        return 94
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.moveRow(at: indexPath, to: IndexPath(item: 0, section: indexPath.section))
    }
}
