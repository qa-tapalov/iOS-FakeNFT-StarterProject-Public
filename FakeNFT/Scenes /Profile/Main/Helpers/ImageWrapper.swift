//
//  ImageWrapper.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 15/08/2024.
//

import UIKit

struct ImageWrapper {
    let data: Data

    init(data: Data) {
        self.data = data
    }

    init(image: UIImage) {
        self.data = image.pngData() ?? Data()
    }

    func toUIImage() -> UIImage? {
        return UIImage(data: data)
    }
}
