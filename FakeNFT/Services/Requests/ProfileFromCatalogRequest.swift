//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Gleb on 22.08.2024.
//

import Foundation

struct ProfileFromCatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
