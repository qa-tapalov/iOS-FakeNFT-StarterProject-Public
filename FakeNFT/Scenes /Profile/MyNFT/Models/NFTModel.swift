//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 17/08/2024.
//

import Foundation

struct NFTModel {
    let createdAt: Date?
    let name: String
    let rating: Int
    let authorName: String
    let price: CGFloat
    let image: String
    let id: String

    var isLiked: Bool
}
