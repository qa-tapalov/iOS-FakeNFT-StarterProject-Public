//
//  OrderSuccessModel.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 15.08.2024.
//

import Foundation

struct OrderSuccessModel: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
