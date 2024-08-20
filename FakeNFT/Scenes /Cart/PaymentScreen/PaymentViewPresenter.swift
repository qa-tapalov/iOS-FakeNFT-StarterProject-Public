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
    
    weak var view: PaymentViewControllerProtocol?
    let cartNetwork = CartNetworkService.shared
    
    init(view: PaymentViewControllerProtocol) {
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
        view?.showLoader()
        cartNetwork.fetchCurrencies { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let currencies):
                DispatchQueue.main.async {
                    self.currencies = currencies
                    self.view?.hideLoader()
                    self.view?.reloadCollection()
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    print(failure.localizedDescription)
                    self.view?.hideLoader()
                }
            }
        }
    }
    
    func payOrder(id: String) {
        //TODO: pay order
    }
}
