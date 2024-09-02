//
//  NFTModelResult.swift
//  FakeNFT
//
//  Created by Артур Гайфуллин on 22.08.2024.
//

import Foundation

struct StatisticsNFTModelResult: Codable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String?
    let price: Float
    let author: String
    let id: String
}
