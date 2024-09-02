//
//  NFTResultModel.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 17/08/2024.
//

import Foundation

struct NFTResultModel: Codable {
    var createdAt: String
    var name: String
    var images: [String]
    var rating: Int
    var description: String
    var price: CGFloat
    var author: String
    var id: String
}
