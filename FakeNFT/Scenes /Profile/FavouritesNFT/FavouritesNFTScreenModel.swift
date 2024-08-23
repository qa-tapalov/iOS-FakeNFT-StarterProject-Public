//
//  FavouritesNFTScreenModel.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 20/08/2024.
//

import Foundation

struct FavoritesNFTScreenModel {
    struct CollectionData {
        enum Section {
            case simple(cells: [Cell])
        }

        enum Cell {
            case NFTCell(NFTCollectionViewCellModel)
        }

        let sections: [Section]
    }

    let title: String
    let collectionData: CollectionData

    static let empty: FavoritesNFTScreenModel = FavoritesNFTScreenModel(
        title: "",
        collectionData: CollectionData(sections: []))
}
