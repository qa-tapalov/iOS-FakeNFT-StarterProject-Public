//
//  NFTsRequest.swift
//  FakeNFT
//
//  Created by Gleb on 16.08.2024.
//

import Foundation

struct NFTsRequestCatalog: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
