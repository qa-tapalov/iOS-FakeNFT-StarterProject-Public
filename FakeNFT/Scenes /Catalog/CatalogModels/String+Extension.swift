//
//  String+Extension.swift
//  FakeNFT
//
//  Created by Gleb on 18.08.2024.
//

import Foundation

extension String {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
