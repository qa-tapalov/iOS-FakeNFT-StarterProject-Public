//
//  PresenterCartView.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 12.08.2024.
//

import Foundation

protocol CartViewPresenterProtocol: AnyObject {
    var items: [ProductModel] {get set}
    func getItem(index: Int) -> ProductModel
    func numberOfRows() -> Int
    func sortItems(options: Sorting)
    func loadNfts()
    func deleteItem(index: Int)
}

final class CartViewPresenter: CartViewPresenterProtocol {
    
    var items: [ProductModel] = []
    weak var view: CartViewController?
    let cartNetwork = CartNetworkService.shared
    init(view: CartViewController) {
        self.view = view
        loadNfts()
    }
    
    func getItem(index: Int) -> ProductModel {
        return items[index]
    }
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func sortItems(options: Sorting) {
        switch options {
        case .price:
            self.items.sort {$0.price < $1.price}
        case .rating:
            self.items.sort {$0.rating < $1.rating}
        case .names:
            self.items.sort {$0.title < $1.title}
        }
    }
    
    func loadNfts() {
        var count = 0
        var itemsNetwork: [ProductModel] = []
        view?.showLoader()
        cartNetwork.fetchOrder { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let order):
                if order.nfts.isEmpty {
                    self.view?.hideLoader()
                }
                else {
                    order.nfts.forEach { id in
                        self.cartNetwork.getNftById(id: id) { result in
                            switch result {
                            case .success(let nft):
                                let productModel = ProductModel(
                                    imageUrl: [nft.images[0]],
                                    title: nft.name,
                                    rating: nft.rating,
                                    price: nft.price,
                                    id: nft.id
                                )
                                itemsNetwork.append(productModel)
                                count += 1
                                if count == order.nfts.count {
                                    DispatchQueue.main.async {
                                        self.items = itemsNetwork
                                        self.view?.hideLoader()
                                        self.view?.updateUI()
                                    }
                                }
                            case .failure(let failure):
                                self.view?.hideLoader()
                                print(failure.localizedDescription)
                            }
                        }
                    }
                }
                
            case .failure(let failure):
                self.view?.hideLoader()
                print(failure.localizedDescription)
            }
        }
    }
    
    func deleteItem(index: Int) {
        items.remove(at: index)
        let newItems = items.map {$0.id}
        view?.showLoader()
        cartNetwork.deleteNftById(id: newItems) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let order):
                DispatchQueue.main.async {
                    if order.nfts.isEmpty {
                        self.items = []
                    }
                    self.view?.hideLoader()
                    self.view?.updateUI()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

enum Sorting: String {
    case price = "цена"
    case rating = "рейтинг"
    case names = "название"
}
