//
//  UserModelResult.swift
//  FakeNFT
//
//  Created by Артур Гайфуллин on 14.08.2024.
//

import Foundation

struct StatisticsUserModelResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
