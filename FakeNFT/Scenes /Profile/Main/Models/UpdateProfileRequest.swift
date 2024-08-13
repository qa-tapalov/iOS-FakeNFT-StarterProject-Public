//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 13/08/2024.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    
    static let method = "/api/v1/profile/1"

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(UpdateProfileRequest.method)")
    }

    var httpMethod: HttpMethod = .put
    var body: Data?

    init(profile: UpdateProfileRequestModel) {
        var components = URLComponents()

        components.queryItems = [
            URLQueryItem(name: "name", value: profile.name),
            URLQueryItem(name: "description", value: profile.description),
            URLQueryItem(name: "website", value: profile.website)
        ]
        
        components.queryItems?.append(
            contentsOf: profile.likes.isEmpty
                ? [URLQueryItem(name: "likes", value: "null")]
                : profile.likes.map { URLQueryItem(name: "likes", value: $0) }
        )

        if let queryString = components.percentEncodedQuery {
            self.body = queryString.data(using: .utf8)
        }
    }
}
