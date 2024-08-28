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
    func makeSortTypeModel() -> SortTypeModel
    func makeSortModel() -> AlertModel
}

final class CatalogPresenter: CatalogPresenterProtocol {
    // MARK: - Public Properties
    var collectionsNft: [NFTCollection] = []
    weak var catalogView: CatalogViewControllerProtocol?
    
    // MARK: - Private Properties
    private let catalogService: CatalogServiceProtocol
    private let sortStorage: SortStorageProtocol
    
    // MARK: - Initializers
    init(catalogService: CatalogServiceProtocol, sortStorage: SortStorageProtocol) {
        self.catalogService = catalogService
        self.sortStorage = sortStorage
    }
    
    // MARK: - Public Methods
    func getNftCollections() {
        catalogView?.showLoadIndicator()
        catalogService.getNftCollections { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let collections):
                self.collectionsNft = collections
                self.sotrCollections()
                self.catalogView?.reloadCatalogTableView()
                self.catalogView?.hideLoadIndicator()
            case .failure(let error):
                let errorModel = makeErrorModel(error)
                self.catalogView?.hideLoadIndicator()
                catalogView?.openAlert(
                    title: errorModel.title,
                    message: errorModel.message,
                    alertStyle: .alert,
                    actionTitles: errorModel.actionTitles,
                    actionStyles: [.default, .default],
                    actions: [{ _ in }, { _ in
                        self.getNftCollections()}]
                )
            }
            self.catalogView?.hideLoadIndicator()
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
    
    func makeSortTypeModel() -> SortTypeModel {
        let sortTypeModel = SortTypeModel(
            title: "Сортировка",
            byName: "По названию",
            byNftCount: "По количеству NFT",
            close: "Закрыть"
        )
        return sortTypeModel
    }
    
    func makeSortModel() -> AlertModel {
        let title: String = NSLocalizedString("Catalog.sorting", comment: "")
        let message: String? = nil
        let actionSortByName: String =  NSLocalizedString("Catalog.sortingByName", comment: "")
        let actionSortByCount: String =  NSLocalizedString("Catalog.sortingByCount", comment: "")
        let actionClose: String =  NSLocalizedString("Catalog.sortingClose", comment: "")
        return AlertModel(
            title: title,
            message: message,
            actionTitles: [actionSortByName,
                           actionSortByCount,
                           actionClose]
        )
    }
    
    // MARK: - Private Methods
    private func sotrCollections() {
        let sortStorage = sortStorage.getSort()
        switch sortStorage {
        case .byName:
            sortByName()
        case .byNftCount:
            sortByNftCount()
        default: break
        }
    }
    
    private func makeErrorModel(_ error: Error) -> AlertModel {
        let title: String = NSLocalizedString("Error.title", comment: "")
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText: String =  NSLocalizedString("Error.repeat", comment: "")
        let cancelText: String = NSLocalizedString("Error.cancel", comment: "")
        return AlertModel(
            title: title,
            message: message,
            actionTitles: [cancelText,
                           actionText]
        )
    }
}
