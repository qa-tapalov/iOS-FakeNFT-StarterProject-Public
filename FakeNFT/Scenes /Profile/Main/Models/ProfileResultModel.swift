//
//  ProfileResultModel.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 13/08/2024.
//

import Foundation

struct ProfileResultModel: Codable {
    var name: String
    var avatar: String
    var description: String
    var website: String
    var nfts: [String]
    var likes: [String]
    var id: String
}
