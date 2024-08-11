//
//  ProfileDetailCell.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import UIKit

struct ProfileDetailCellModel {
    let title: String
    let subtitle: String
    var action: () -> Void
}

final class ProfileDetailCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "ProfileDetailCell"

    // MARK: - UI Elements

    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var navButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var model: ProfileDetailCellModel? {
        didSet {
            setup()
        }
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addGesture()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setup() {
        configureLabelText()
    }

    private func setupView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(navButtonImageView)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            subtitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .subtitleGap),

            navButtonImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            navButtonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    private func configureLabelText() {
        guard let model else { return }
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }

    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc private func tapAction() {
        guard let model else { return }
        model.action()
    }
}

// MARK: - Constants

private extension CGFloat {
    static let subtitleGap: CGFloat = 8
}
