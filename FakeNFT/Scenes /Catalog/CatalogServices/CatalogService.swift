//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Gleb on 10.08.2024.
//

import Foundation

protocol CatalogServiceProtocol: AnyObject {
    func getNftCollections(completion: @escaping (Result<[NFTCollection], Error>) -> Void)
}

final class CatalogService: CatalogServiceProtocol {
    // MARK: - Private Properties
    private let networkClient: DefaultNetworkClient
    
    // MARK: - Initializers
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    func getNftCollections(completion: @escaping (Result<[NFTCollection], any Error>) -> Void) {
        let request = NFTCollectionsRequest()
        networkClient.send(
            request: request,
            type: [NFTCollection].self) { result in
                switch result {
                case .success(let collections):
                    completion(.success(collections))
                case .failure(let error):
                    if let networkError = error as? NetworkClientError {
                        completion(.failure(networkError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}
