//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Gleb on 15.08.2024.
//

import Foundation

protocol CollectionPresenterProtocol: AnyObject {
    var nfts: [NFTs] { get }
    var collectionView: CollectionViewControllerProtocol? { get set }
    func getNfts()
    func loadAuthor()
}

final class CollectionPresenter: CollectionPresenterProtocol {
    var nfts: [NFTs] = []
    var collectionNft: NFTCollection?
    weak var collectionView: CollectionViewControllerProtocol?
    
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
                guard let self else { return }
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
    
    func loadAuthor() {
        guard let id = collectionNft?.author else { return }
        collectionView?.showLoadIndicator()
        catalogService.getAuthorNftCollection(id: id) { [weak self] result in
            guard let self else { return }
            self.prepare(authorName: result.name)
            self.collectionView?.hideLoadIndicator()
        }
    }
    
    private func prepare(authorName: String) {
        guard let collection = collectionNft else { return }
        let collectionViewData = CollectionViewData(
            coverImage: collection.cover,
            collectionName: collection.name,
            authorName: authorName,
            description: collection.description
        )
        collectionView?.collectionViewData(data: collectionViewData)
    }
}
