//
//  ProfileResult.swift
//  FakeNFT
//
//  Created by Gleb on 22.08.2024.
//

import Foundation

struct ProfileResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    var likes: [String]
    let id: String
}
