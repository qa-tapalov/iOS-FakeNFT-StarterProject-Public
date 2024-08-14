//
//  PaymentViewPresenter.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 14.08.2024.
//

import Foundation

protocol PaymentViewPresenterProtocol: AnyObject {
    var currencies: [CurrencyModel] {get set}
    func getItem(index: Int) -> CurrencyModel
    func numberOfRows() -> Int
    func fetchCurrencies()
    func payOrder(id: String)
}

final class PaymentViewPresenter: PaymentViewPresenterProtocol {
    
    var currencies: [CurrencyModel] = []
    
    weak var view: PaymentViewController?
    let cartNetwork = CartNetworkService.shared
    init(view: PaymentViewController) {
        self.view = view
        fetchCurrencies()
    }
    
    func getItem(index: Int) -> CurrencyModel {
        return currencies[index]
    }
    
    func numberOfRows() -> Int {
        currencies.count
    }
    
    func fetchCurrencies() {
        //TODO: load currencies
    }
    
    func payOrder(id: String) {
        //TODO: pay order
    }
    
    
}
