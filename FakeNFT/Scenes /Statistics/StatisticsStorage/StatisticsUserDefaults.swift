//
//  StatisticsUserDefaults.swift
//  FakeNFT
//
//  Created by Артур Гайфуллин on 19.08.2024.
//

import Foundation

final class StatisticsUserDefaults {
    
    private let userDefaults = UserDefaults.standard
    
    var sortingWay: String? {
        get {
            userDefaults.string(forKey: "sortingWay")
        }
        set {
            userDefaults.set(newValue, forKey: "sortingWay")
        }
    }
}
