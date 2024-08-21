//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 20/08/2024.
//

import UIKit
import Kingfisher

struct NFTCollectionViewCellModel {
    let image: String
    let name: String
    let authorName: String
    let price: String
    let rating: Int
    var isLiked: Bool

    var onLikeAction: (Bool) -> Void

    static let empty: NFTCollectionViewCellModel = NFTCollectionViewCellModel(
        image: "",
        name: "",
        authorName: "",
        price: "",
        rating: 0,
        isLiked: false,
        onLikeAction: { _ in }
    )
}

final class NFTCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier  = "NFTCollectionViewCell"

    var model: NFTCollectionViewCellModel = .empty {
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

    private lazy var priceValueLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var NFTStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Private methods

    private func setup() {
        setNFTImage()
        setupView()
        setupConstraints()

        nameLabel.text = model.name.components(separatedBy: " ").first
        priceValueLabel.text = "\(model.price) ETH"
        likeButton.setImage(model.isLiked ? Images.liked : Images.unliked, for: .normal)
    }

    private func setupView() {
        backgroundColor = .white

        contentView.addSubview(NFTView)

        NFTView.addSubview(NFTImageView)
        NFTView.addSubview(NFTStackView)
        NFTView.addSubview(likeButton)

        NFTStackView.addArrangedSubview(nameLabel)
        NFTStackView.addArrangedSubview(ratingStackView)
        NFTStackView.addArrangedSubview(priceValueLabel)
    }

    private func setupConstraints() {
        configureNFTView()
        configureNFTImageView()
        configureNFTStackView()
        configureRatingStackView()
        configureLikeButton()
    }

    private func configureNFTView() {
        NSLayoutConstraint.activate([
            NFTView.topAnchor.constraint(equalTo: contentView.topAnchor),
            NFTView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            NFTView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            NFTView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func configureLikeButton() {
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.topAnchor.constraint(equalTo: NFTImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: NFTImageView.trailingAnchor)
        ])
    }

    private func configureNFTImageView() {
        NSLayoutConstraint.activate([
            NFTImageView.topAnchor.constraint(equalTo: NFTView.topAnchor),
            NFTImageView.leadingAnchor.constraint(equalTo: NFTView.leadingAnchor),
            NFTImageView.widthAnchor.constraint(equalToConstant: Constants.NFTImageSize),
            NFTImageView.heightAnchor.constraint(equalToConstant: Constants.NFTImageSize)
        ])
    }

    private func configureNFTStackView() {
        NSLayoutConstraint.activate([
            NFTStackView.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: Constants.stackViewLeading),
            NFTStackView.trailingAnchor.constraint(equalTo: NFTView.trailingAnchor),
            NFTStackView.centerYAnchor.constraint(equalTo: NFTView.centerYAnchor),
            NFTStackView.heightAnchor.constraint(equalToConstant: Constants.stackViewHeight)
        ])
    }

    private func configureRatingStackView() {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 1...5 {
            let starImageView = UIImageView(image: index <= model.rating ? Images.activeStar : Images.inactiveStar)
            starImageView.contentMode = .scaleAspectFit
            ratingStackView.addArrangedSubview(starImageView)
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: Constants.starSize),
                starImageView.heightAnchor.constraint(equalToConstant: Constants.starSize),
                ratingStackView.heightAnchor.constraint(equalToConstant: Constants.ratingStackViewHeight),
                ratingStackView.widthAnchor.constraint(equalToConstant: Constants.ratingStackViewWidth)
            ])
        }
    }

    private func setNFTImage() {
        if let url = URL(string: model.image) {
            NFTImageView.kf.setImage(with: url)
        }
    }

    @objc private func likeButtonTapped() {
        model.isLiked.toggle()
        model.onLikeAction(model.isLiked)
        likeButton.setImage(model.isLiked ? Images.liked : Images.unliked, for: .normal)
    }
}

// MARK: - Constants

private struct Constants {
    static let imageViewCornerRadius: CGFloat = 12
    static let starSize: CGFloat = 12
    static let likeButtonSize: CGFloat = 30
    static let likeButtonLeading: CGFloat = 50
    static let ratingStackViewHeight: CGFloat = 12
    static let ratingStackViewWidth: CGFloat = 68
    static let NFTImageSize: CGFloat = 80
    static let stackViewHeight: CGFloat = 66
    static let stackViewLeading: CGFloat = 8
}

// MARK: - Images

private extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

private struct Images {
    static let liked = UIImage(
        systemName: "heart.fill")?.withTintColor(UIColor(hexString: "#F56B6C"), renderingMode: .alwaysOriginal)
    static let unliked = UIImage(
        systemName: "heart.fill")?.withTintColor(UIColor(hexString: "#FFFFFF"), renderingMode: .alwaysOriginal)

    static let activeStar = UIImage(
        systemName: "star.fill")?.withTintColor(UIColor(hexString: "#FEEF0D"), renderingMode: .alwaysOriginal).resized(to: CGSize(width: Constants.starSize, height: Constants.starSize))
    static let inactiveStar = UIImage(
        systemName: "star.fill")?.withTintColor(.segmentInactive, renderingMode: .alwaysOriginal).resized(to: CGSize(width: Constants.starSize, height: Constants.starSize))
}
