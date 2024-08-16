//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Gleb on 15.08.2024.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject {
    var nfts: [NFTs] { get }
    var collectionView: CollectionPresenterProtocol? { get set }
    func getNfts()
}

final class CollectionPresenter: CollectionPresenterProtocol {
    var nfts: [NFTs]
    var collectionNft: NFTCollection?
    weak var collectionView: (any CollectionPresenterProtocol)?
    
    private let catalogService: CatalogServiceProtocol
    
    init(collectionNft: NFTCollection?, catalogService: CatalogServiceProtocol) {
        self.collectionNft = collectionNft
        self.catalogService = catalogService
    }
    
    func getNfts() {
        guard let collectionNft, !collectionNft.nfts.isEmpty else { return }
        collectionNft.nfts.forEach {
            collectionView?.showLoadIndicator()
            catalogService.getNFTs(id: $0, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    self.collectionView?.reloadNftCollectionView()
                case .failure(let error):
                    print(error)
                    // TODO: - обработать ошибку алертом
                }
                self.collectionView?.hideLoadIndicator()
            })
        }
    }
    
    
}
