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
        let catalogService = CatalogService(networkClient: networkClient)
        let sortStorage = SortStorage()
        let catalogPresenter = CatalogPresenter(
            catalogService: catalogService,
            sortStorage: sortStorage)
        catalogViewController = CatalogViewController(presenter: catalogPresenter)
    }
    
    // MARK: - Public Methods
    func assemblyCollection(_ collection: NFTCollection) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let catalogService = CatalogService(networkClient: networkClient)
        let presenter = CollectionPresenter(
            collectionNft: collection,
            catalogService: catalogService)
        let viewCintroller = CollectionViewController(presenter: presenter)
        viewCintroller.hidesBottomBarWhenPushed = true
        return viewCintroller
    }
}
