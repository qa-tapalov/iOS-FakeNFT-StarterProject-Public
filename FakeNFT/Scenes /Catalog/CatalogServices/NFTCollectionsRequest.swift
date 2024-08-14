//
//  NFTCollectionsRequest.swift
//  FakeNFT
//
//  Created by Gleb on 10.08.2024.
//

import Foundation

struct NFTCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}
