//
//  UserResult.swift
//  FakeNFT
//
//  Created by Gleb on 16.08.2024.
//

import Foundation

struct UserResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
