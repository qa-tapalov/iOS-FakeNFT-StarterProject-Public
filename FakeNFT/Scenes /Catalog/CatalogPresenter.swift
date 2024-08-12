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
    func sortByName()
    func sortByNftCount()
}

final class CatalogPresenter: CatalogPresenterProtocol {
    var collectionsNft: [NFTCollection] = []
    weak var catalogView: CatalogViewControllerProtocol?
    
    private let catalogService: CatalogServiceProtocol
    private let sortStorage: SortStorageProtocol
    
    init(catalogService: CatalogServiceProtocol, sortStorage: SortStorageProtocol) {
        self.catalogService = catalogService
        self.sortStorage = sortStorage
    }
    
    func getNftCollections() {
        catalogService.getNftCollections { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.collectionsNft = collections
                self.getSotrCollections()
                self.catalogView?.reloadCatalogTableView()
            case .failure(let error):
                // TODO: алерт ошибки
                ///
                print("[DEBUG]: [ERROR]: CatalogPresenter: getNftCollections")
                ///
            }
            
        }
    }
    
    func sortByName() {
        sortStorage.saveSort(.byName)
        collectionsNft = collectionsNft.sorted {
            $0.name < $1.name
        }
        catalogView?.reloadCatalogTableView()
    }
    
    func sortByNftCount() {
        sortStorage.saveSort(.byNftCount)
        collectionsNft = collectionsNft.sorted {
            $0.nfts.count < $1.nfts.count
        }
        catalogView?.reloadCatalogTableView()
    }
    
    private func getSotrCollections() {
        let sortStorage = sortStorage.getSort()
        switch sortStorage {
        case .byName:
            sortByName()
        case .byNftCount:
                sortByNftCount()
        default: break
        }
    }
}
