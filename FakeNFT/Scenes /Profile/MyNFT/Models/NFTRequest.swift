//
//  NFTRequest.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 17/08/2024.
//

import Foundation

struct NFTsRequest: NetworkRequest {

    static let method = "/api/v1/nft/"

    let id: String
    let httpMethod: HttpMethod

    var token: String? {
        RequestConstants.token
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(NFTsRequest.method)\(id)")
    }
}
