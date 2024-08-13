//
//  OrderModel.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 12.08.2024.
//

import Foundation

struct OrderModel: Codable {
    let nfts: [String]
    let id: String
}

struct NftNetworkModel: Codable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let id: String
}
