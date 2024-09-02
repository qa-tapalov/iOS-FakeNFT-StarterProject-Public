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
    // MARK: - Private Properties
    private let sortingStorageKey = "SortingType"
    private let userDefaults = UserDefaults.standard
    private var sorting: Sorting?
    
    // MARK: - Public Methods
    func saveSort(_ sorting: Sorting) {
        userDefaults.set(sorting.rawValue, forKey: sortingStorageKey)
    }
    
    func getSort() -> Sorting? {
        guard let saveSort = userDefaults.string(forKey: sortingStorageKey) else {
            return Sorting.byNftCount
        }
        return Sorting(rawValue: saveSort)
    }
}
