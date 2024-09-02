//
//  CatalogSceneConfiguration.swift
//  FakeNFT
//
//  Created by Gleb on 18.08.2024.
//

import UIKit

class CatalogSceneConfiguration {
    // MARK: - Public Properties
    let catalogViewController: UIViewController
    
    // MARK: - Initializers
    init() {
        let networkClient = DefaultNetworkClient()
        let catalogStorage = CatalogStorage()
        let catalogService = CatalogService(
            networkClient: networkClient,
            catalogStorage: catalogStorage)
        let sortStorage = SortStorage()
        let catalogPresenter = CatalogPresenter(
            catalogService: catalogService,
            sortStorage: sortStorage)
        catalogViewController = CatalogViewController(presenter: catalogPresenter)
        catalogPresenter.catalogView = catalogViewController as? any CatalogViewControllerProtocol
    }
    
    // MARK: - Public Methods
    func assemblyCollection(_ collection: NFTCollection) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let catalogStorage = CatalogStorage()
        let catalogService = CatalogService(
            networkClient: networkClient,
            catalogStorage: catalogStorage)
        let presenter = CollectionPresenter(
                collectionNft: collection,
                catalogService: catalogService
            )
        let viewController = CollectionViewController(presenter: presenter)
        presenter.collectionView = viewController
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
