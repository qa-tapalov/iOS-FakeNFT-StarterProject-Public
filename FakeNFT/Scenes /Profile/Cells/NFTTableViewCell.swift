//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 16/08/2024.
//

import UIKit

// MARK: - NFTTableViewCellModel

struct NFTTableViewCellModel {
    let image: String
    let name: String
    let authorName: String
    let price: String
    let rating: Int
    var isLiked: Bool
    
    var onLikeAction: (Bool) -> Void
    
    static let empty: NFTTableViewCellModel = NFTTableViewCellModel(
        image: "",
        name: "",
        authorName: "",
        price: "",
        rating: 0,
        isLiked: false,
        onLikeAction: { _ in }
    )
}

// MARK: - NFTTableViewCell

final class NFTTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "NFTTableViewCell"
    
    var model: NFTTableViewCellModel = .empty {
        didSet {
            setup()
        }
    }
    
    // MARK: - UI Elements
    
    private lazy var NFTImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Private methods
    
    private func setup() {
        
    }
    
    
    
    
    
    
    
    
    @objc private func likeButtonTapped() {
        // TODO: - Add like logic
    }
}

// MARK: - Images

private struct Images {
    static let liked = UIImage(systemName: "heart.fill")?.withTintColor(UIColor(hexString: "#F56B6C"))
    static let unliked = UIImage(systemName: "heart.fill")?.withTintColor(.white)
}
