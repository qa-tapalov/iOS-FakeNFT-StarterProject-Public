//
//  EditProfileScreenModel.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 11/08/2024.
//

import Foundation

struct EditProfileScreenModel {
    struct TableData {
        enum Section {
            case headeredSection(header: String, cells: [Cell])
        }

        enum Cell {
            case textViewCell(TextViewCellModel)
            case textFieldCell(TextFieldCellModel)
        }

        let sections: [Section]
    }

    let image: ImageWrapper
    let tableData: TableData

    static let empty: EditProfileScreenModel = EditProfileScreenModel(
        image: ImageWrapper(data: Data()),
        tableData: TableData(sections: [])
    )
}
