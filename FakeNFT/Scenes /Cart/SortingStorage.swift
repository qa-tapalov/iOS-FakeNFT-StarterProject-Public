//
//  SortingUserDefault.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 14.08.2024.
//

import Foundation

final class SortingStorage {
    
    static let shared = SortingStorage()
    private let userDefaults = UserDefaults.standard
    private let selectedSortKey = "selectedSort"
    var selectedSort: String? {
        get {
            userDefaults.string(forKey: selectedSortKey)
        }
        set {
            userDefaults.set(newValue, forKey: selectedSortKey)
        }
    }
    
    func getSort() -> SortingCart {
           guard let saveSort = selectedSort else { return SortingCart.names }
        return SortingCart(rawValue: saveSort) ?? .names
        }
    
    private init(){}
}
