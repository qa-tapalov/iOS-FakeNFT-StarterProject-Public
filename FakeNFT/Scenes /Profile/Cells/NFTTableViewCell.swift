//
//  NFTTableViewCell.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 16/08/2024.
//

import UIKit
import Kingfisher

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
        label.numberOfLines = 2
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

    private lazy var authorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .segmentActive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.text = "от"
        label.font = .caption2
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
        stack.distribution = .fillProportionally
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
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
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

        nameLabel.text = model.name
        authorLabel.text = model.authorName
        priceValueLabel.text = "\(model.price) ETH"
        likeButton.setImage(model.isLiked ? Images.liked : Images.unliked, for: .normal)
    }

    private func setupView() {
        contentView.addSubview(NFTView)
        backgroundColor = .white
        selectionStyle = .none

        NFTView.addSubview(NFTImageView)
        NFTView.addSubview(likeButton)
        NFTView.addSubview(NFTStackView)

        NFTStackView.addArrangedSubview(NFTStackLeft)
        NFTStackView.addArrangedSubview(NFTStackRight)

        NFTStackLeft.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NFTStackLeft.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NFTStackLeft.addArrangedSubview(nameLabel)
        NFTStackLeft.addArrangedSubview(ratingStackView)
        NFTStackLeft.addArrangedSubview(authorView)

        NFTStackRight.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NFTStackRight.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        NFTStackRight.addArrangedSubview(priceLabel)
        NFTStackRight.addArrangedSubview(priceValueLabel)

        authorView.addSubview(fromLabel)
        authorView.addSubview(authorLabel)
    }

    private func setupConstraints() {
        configureNFTView()
        configureNFTImageView()
        configureLikeButton()
        configureNFTStackView()
        configureAuthorView()
        configureRatingStackView()
    }

    private func configureNFTView() {
        NSLayoutConstraint.activate([
            NFTView.heightAnchor.constraint(equalToConstant: Constants.nftViewHeight),
            NFTView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            NFTView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            NFTView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func configureNFTImageView() {
        NSLayoutConstraint.activate([
            NFTImageView.heightAnchor.constraint(equalToConstant: Constants.nftImageSize),
            NFTImageView.widthAnchor.constraint(equalToConstant: Constants.nftImageSize),
            NFTImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            NFTImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func configureLikeButton() {
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.widthAnchor.constraint(equalToConstant: Constants.likeButtonSize),
            likeButton.topAnchor.constraint(equalTo: NFTImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: NFTImageView.trailingAnchor)
        ])
    }

    private func configureNFTStackView() {
        NSLayoutConstraint.activate([
            NFTStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.nftStackTopOffset),
            NFTStackView.leadingAnchor.constraint(equalTo: NFTImageView.trailingAnchor, constant: Constants.nftStackLeadingOffset),
            NFTStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            NFTStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Constants.nftStackBottomOffset)
        ])
    }

    private func configureAuthorView() {
        NSLayoutConstraint.activate([
            authorView.heightAnchor.constraint(equalToConstant: Constants.authorViewHeight),
            authorView.widthAnchor.constraint(equalToConstant: Constants.authorViewWidth),

            fromLabel.leadingAnchor.constraint(equalTo: authorView.leadingAnchor),
            fromLabel.centerYAnchor.constraint(equalTo: authorView.centerYAnchor),

            authorLabel.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor, constant: Constants.authorLabelLeadingOffset),
            authorLabel.centerYAnchor.constraint(equalTo: authorView.centerYAnchor),

            nameLabel.widthAnchor.constraint(equalToConstant: Constants.nameLabelWidth)
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
                ratingStackView.heightAnchor.constraint(equalToConstant: Constants.ratingStackViewHeight)
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
    static let ratingStackViewSpacing: CGFloat = 2
    static let leftStackViewSpacing: CGFloat = 4
    static let imageViewCornerRadius: CGFloat = 12
    static let nftViewHeight: CGFloat = 108
    static let nftImageSize: CGFloat = 108
    static let likeButtonSize: CGFloat = 40
    static let nftStackTopOffset: CGFloat = 23
    static let nftStackBottomOffset: CGFloat = -23
    static let nftStackLeadingOffset: CGFloat = 20
    static let ratingStackViewHeight: CGFloat = 12
    static let authorViewHeight: CGFloat = 20
    static let authorViewWidth: CGFloat = 78
    static let authorLabelLeadingOffset: CGFloat = 5
    static let nameLabelWidth: CGFloat = 100
    static let starSize: CGFloat = 12
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
