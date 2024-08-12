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
    
    var items: [ProductModel] = [
        ProductModel(imageUrl: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png"],
                     title: "April",
                     rating: 3,
                     price: 3.32),
        ProductModel(imageUrl: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Lark/1.png"],
                     title: "Greena",
                     rating: 2,
                     price: 3),
        ProductModel(imageUrl: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/1.png"],
                     title: "Spring",
                     rating: 3,
                     price: 1.3),
        ProductModel(imageUrl: ["https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Penny/1.png"],
                     title: "Torro",
                     rating: 4,
                     price: 64.3)]
    
    weak var view: CartViewController?
    
    init(view: CartViewController) {
        self.view = view
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
        //TODO: network
    }
    
    func deleteItem(index: Int) {
        items.remove(at: index)
    }
}

enum Sorting {
    case price
    case rating
    case names
}
