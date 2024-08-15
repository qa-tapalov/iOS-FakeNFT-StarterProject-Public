//
//  ProfileScreenModel.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import UIKit

struct ProfileScreenModel {
    struct TableData {
        enum Section {
            case simple(cells: [Cell])
        }

        enum Cell {
            case detail(ProfileDetailCellModel)
        }

        let sections: [Section]
    }

    let userName: String
    let userImage: ImageWrapper
    let userAbout: String
    let websiteUrlString: String
    let tableData: TableData

    static let empty = ProfileScreenModel(
        userName: "",
        userImage: ImageWrapper(data: Data()),
        userAbout: "",
        websiteUrlString: "",
        tableData: TableData(sections: [])
    )
}
