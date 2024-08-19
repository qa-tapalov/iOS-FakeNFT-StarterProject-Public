//
//  StatisticsUserViewController.swift
//  FakeNFT
//
//  Created by Артур Гайфуллин on 19.08.2024.
//

import Kingfisher
import UIKit

final class StatisticsUserViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var avatarImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private lazy var usernameLabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .ypBlackUniversal
        return label
    }()
    
    private lazy var userDescriptionTextView = {
        let textView = UITextView()
        textView.font = UIFont.caption2
        textView.textColor = .ypBlackUniversal
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
        return textView
    }()
    
    private lazy var userWebsiteButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.ypBlackUniversal, for: .normal)
        button.titleLabel?.font = UIFont.caption1
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(goToUserWebsite), for: .touchUpInside)
        button.isEnabled = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypBlackUniversal.cgColor
        return button
    }()
    
    private lazy var nftCollectionButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goToNFTCollection), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    private lazy var nftCollectionLabel = {
        let label = UILabel()
        label.font = UIFont.caption1
        label.textColor = .ypBlackUniversal
        label.font = UIFont.bodyBold
        return label
    }()
    
    private lazy var nftCollectionImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.tintColor = .ypBlackUniversal
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .viewBackgroundColor
        setupUI()
    }
    
    // MARK: - Methods
    
    func configure(for user: UsersModel) {
        avatarImageView.kf.setImage(with: URL(string: user.avatar), placeholder: UIImage(named: "person"))
        usernameLabel.text = user.name
        userDescriptionTextView.text = user.description
        nftCollectionLabel.text = "Коллекция NFT (\(user.nfts.count))"
    }
    
    private func setupUI() {
        setupNavBar()
        setupConstraints()
    }
    
    // MARK: - View Configuration
    
    private func setupNavBar() {
        let backButton = UIBarButtonItem(
            image: UIImage.backwardImage,
            style: .plain,
            target: self,
            action: #selector(backToStaticsVC)
        )
        backButton.tintColor = .ypBlackUniversal
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        [avatarImageView, usernameLabel, userDescriptionTextView, userWebsiteButton, nftCollectionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [nftCollectionLabel, nftCollectionImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            nftCollectionButton.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            userDescriptionTextView.heightAnchor.constraint(equalToConstant: 72),
            userDescriptionTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            userDescriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userDescriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            userWebsiteButton.heightAnchor.constraint(equalToConstant: 40),
            userWebsiteButton.topAnchor.constraint(equalTo: userDescriptionTextView.bottomAnchor, constant: 28),
            userWebsiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userWebsiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            nftCollectionButton.heightAnchor.constraint(equalToConstant: 54),
            nftCollectionButton.topAnchor.constraint(equalTo: userWebsiteButton.bottomAnchor, constant: 40),
            nftCollectionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            nftCollectionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            nftCollectionImageView.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),
            nftCollectionImageView.trailingAnchor.constraint(equalTo: nftCollectionButton.trailingAnchor, constant: -16),
            
            nftCollectionLabel.centerYAnchor.constraint(equalTo: nftCollectionButton.centerYAnchor),
            nftCollectionLabel.leadingAnchor.constraint(equalTo: nftCollectionButton.leadingAnchor, constant: 16)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func backToStaticsVC() {
        dismiss(animated: true)
    }
    
    @objc
    private func goToNFTCollection() {
        // TODO: - Переход на экран с коллекцией NFT пользователя
    }
    
    @objc
    private func goToUserWebsite() {
        // TODO: - Переход на вебвью сайта пользователя
    }
}
