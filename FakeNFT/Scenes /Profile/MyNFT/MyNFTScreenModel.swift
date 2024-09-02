//
//  MyNFTScreenModel.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 16/08/2024.
//

import Foundation

struct MyNFTScreenModel {
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
        }

        enum Cell {
            case NFTCell(NFTTableViewCellModel)
        }

        let sections: [Section]
    }

    let title: String
    let tableData: TableData

    static let empty: MyNFTScreenModel = MyNFTScreenModel(
        title: "",
        tableData: TableData(sections: []))
}
