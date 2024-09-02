//
//  OrdersRequest.swift
//  FakeNFT
//
//  Created by Gleb on 24.08.2024.
//

import Foundation

struct OrdersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
