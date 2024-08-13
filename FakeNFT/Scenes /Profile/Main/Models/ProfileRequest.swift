//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 13/08/2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    
    static let method = "/api/v1/profile/"
    
    let id: String
    let dto: Encodable?
    let httpMethod: HttpMethod
    
    var token: String? {
        RequestConstants.token
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(ProfileRequest.method)\(id)")
    }
}
