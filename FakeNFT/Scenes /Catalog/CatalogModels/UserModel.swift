//
//  UserModel.swift
//  FakeNFT
//
//  Created by Gleb on 16.08.2024.
//

import Foundation

struct UserModel {
    let id: String
    let name: String
    let website: String

    init(with user: UserResult) {
        self.id = user.id
        self.name = user.name
        self.website = user.website
    }
}
