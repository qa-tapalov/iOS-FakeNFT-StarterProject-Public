//
//  SortStorage.swift
//  FakeNFT
//
//  Created by Gleb on 12.08.2024.
//

import Foundation

protocol SortStorageProtocol: AnyObject {
    func saveSort(_ sorting: Sorting)
    func getSort() -> Sorting?
}

final class SortStorage: SortStorageProtocol {
    private let SortingStorageKey = ""
    private let userDefaults = UserDefaults.standard
    private var sorting: Sorting?
    
    func saveSort(_ sorting: Sorting) {
        userDefaults.set(sorting.rawValue, forKey: SortingStorageKey)
    }
    
    func getSort() -> Sorting? {
        guard let saveSort = userDefaults.string(forKey: SortingStorageKey) else {
            return Sorting.byNftCount
        }
        return Sorting(rawValue: saveSort)
    }
}
