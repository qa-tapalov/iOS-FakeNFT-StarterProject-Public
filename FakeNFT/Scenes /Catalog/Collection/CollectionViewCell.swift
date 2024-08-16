//
//  CollectionViewCell.swift
//  FakeNFT
//
//  Created by Gleb on 15.08.2024.
//

import UIKit
import Kingfisher

final class CollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    static let identifier = "CollectionCell"
    
    var nftModel: NFTs?
    
    private lazy var ratingView = RatingView()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(
            top: 11,
            left: 9,
            bottom: 11,
            right: 10)
        // TODO: - добавить таргет
        return button
    }()
    
    private lazy var nftName: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var nftPrice: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "Cart"), for: .normal)
        button.tintColor = .textPrimary
        // TODO: - добавить таргет
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionViewCell()
        setupTrackerCollectionViewConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCollectionCell() {
        guard let nftModel = nftModel else { return }
        if let imageURL = nftModel.images.first {
            nftImageView.kf.setImage(with: imageURL)
        }
        nftName.text = nftModel.name
        nftPrice.text = "\(nftModel.price) ETH"
        ratingView.createRating(with: nftModel.rating)
    }
    
    private func setupCollectionViewCell() {
        [
            ratingView,
            nftImageView,
            likeButton,
            nftName,
            nftPrice,
            cardButton
        ].forEach {
            contentView.addSubview(
                $0
            )
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupTrackerCollectionViewConstrains() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 2),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            
            ratingView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.widthAnchor.constraint(equalToConstant: 70),
            
            nftName.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4),
            nftName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftName.widthAnchor.constraint(equalToConstant: 68),
            nftName.heightAnchor.constraint(equalToConstant: 22),
            
            nftPrice.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: 4),
            nftPrice.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            cardButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cardButton.heightAnchor.constraint(equalToConstant: 40),
            cardButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
