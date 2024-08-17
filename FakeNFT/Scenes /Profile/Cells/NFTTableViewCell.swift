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
    
    private lazy var NFTView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var NFTImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageViewCornerRadius
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.ratingStackViewSpacing
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = .caption2
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var NFTStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
        
    }()
    
    private lazy var NFTStackLeft: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = Constants.leftStackViewSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var NFTStackRight: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Private methods
    
    private func setup() {
        
    }
    
    private func setupView() {
        
    }
    
    
    
    
    
    
    
    @objc private func likeButtonTapped() {
        // TODO: - Add like logic
    }
}

// MARK: - Constants

private struct Constants {
    static let ratingStackViewSpacing: CGFloat = 2
    static let leftStackViewSpacing: CGFloat = 4
    static let imageViewCornerRadius: CGFloat = 12
}

// MARK: - Images

private struct Images {
    // MARK: - Likes
    static let liked = UIImage(systemName: "heart.fill")?.withTintColor(UIColor(hexString: "#F56B6C"))
    static let unliked = UIImage(systemName: "heart.fill")?.withTintColor(.white)
    
    // MARK: - Stars
    static let activeStar = UIImage(systemName: "star.fill")?.withTintColor(UIColor(hexString: "#FEEF0D"))
    static let inactiveStar = UIImage(systemName: "star.fill")?.withTintColor(UIColor(hexString: "#F7F7F8"))
}
