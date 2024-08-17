//
//  NFTService.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 17/08/2024.
//

import Foundation

protocol NFTServiceProtocol: AnyObject {
    func getNFT(id: String, completion: @escaping (Result<NFTResultModel, Error>) -> Void)
}

final class NFTService: NFTServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getNFT(id: String, completion: @escaping (Result<NFTResultModel, any Error>) -> Void) {
        let request = NFTsRequest(id: id, httpMethod: .get)
        networkClient.send(request: request, type: NFTResultModel.self) { result in
            switch result {
            case let .success(nft):
                completion(.success(nft))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
