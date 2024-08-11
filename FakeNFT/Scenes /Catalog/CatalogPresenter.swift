//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Gleb on 10.08.2024.
//

import Foundation

protocol CatalogPresenterProtocol: AnyObject {
    var collectionsNft: [NFTCollection] { get }
    var catalogView: CatalogViewControllerProtocol? { get set }
    func getNftCollections()
}

final class CatalogPresenter: CatalogPresenterProtocol {
    var collectionsNft: [NFTCollection] = []
    weak var catalogView: CatalogViewControllerProtocol?
    
    private var catalogService: CatalogServiceProtocol
    
    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
    }
    
    func getNftCollections() {
        catalogService.getNftCollections() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.collectionsNft = collections
                self.catalogView?.reloadCatalogTableView()
            case .failure(let error):
                // TODO: алерт ошибки
                ///
                print("[DEBUG]: [ERROR]: CatalogPresenter: getNftCollections")
                ///
            }
            
        }
    }
}
