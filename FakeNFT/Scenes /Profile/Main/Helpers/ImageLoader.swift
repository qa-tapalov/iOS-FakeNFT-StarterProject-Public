//
//  ImageLoader.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 15/08/2024.
//

import UIKit
import Kingfisher

protocol ImageLoaderProtocol {
    func loadImage(from urlString: String, completion: @escaping (Result<ImageWrapper, Error>) -> Void)
}

final class ImageLoader: ImageLoaderProtocol {
    func loadImage(from urlString: String, completion: @escaping (Result<ImageWrapper, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case let .success(value):
                let imageWrapper = ImageWrapper(image: value.image)
                completion(.success(imageWrapper))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
