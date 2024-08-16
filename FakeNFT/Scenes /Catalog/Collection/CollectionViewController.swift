//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Gleb on 15.08.2024.
//

import UIKit

final class CollectionViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        button.tintColor = .black
        return button
    }()
    
    private lazy var collectionCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CoverCollection")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var collectionName: UILabel = {
        let label = UILabel()
        label.text = "Классная коллекция"
        label.font = .headline3
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionAuthor: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionAuthorLink: UILabel = {
        let label = UILabel()
        label.text = "Иван Петров"
        label.font = .caption1
        label.textColor = .yaBlueUniversal
        label.numberOfLines = 0
        // TODO: - Ссылка на страницу автора
        return label
    }()
    
    private lazy var collectionDescription: UILabel = {
        let label = UILabel()
        label.text = "Просто текст имитирующий описание коллекции которую открыли выбором на предыдущем экране. Никакой смысловой нагрузки."
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewController()
    }
    
    @objc
    private func backButtonTapped() {
        // TODO: переход на экран каталога NFT
    }
    
    private func setupCollectionViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = backButton
        addSubviews()
        setupCollectionView()
        setupCollectionViewControllerConstrains()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        [
            collectionCoverImage,
            descriptionStackView,
            nftCollectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        [
            collectionName,
            collectionAuthor,
            collectionAuthorLink,
            collectionDescription
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            descriptionStackView.addSubview($0)
        }
    }
    
    private func setupCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.register(CollectionViewCell.self)
    }
    
    private func setupCollectionViewControllerConstrains() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collectionCoverImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            collectionCoverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionCoverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionCoverImage.heightAnchor.constraint(equalToConstant: 310),
            
            descriptionStackView.topAnchor.constraint(equalTo: collectionCoverImage.bottomAnchor, constant: 16),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionName.topAnchor.constraint(equalTo: descriptionStackView.topAnchor),
            collectionName.leadingAnchor.constraint(equalTo: descriptionStackView.leadingAnchor, constant: 16),
            collectionName.trailingAnchor.constraint(equalTo: descriptionStackView.trailingAnchor, constant: -16),
            
            collectionAuthor.topAnchor.constraint(equalTo: collectionName.bottomAnchor, constant: 8),
            collectionAuthor.leadingAnchor.constraint(equalTo: collectionName.leadingAnchor),
            
            collectionAuthorLink.leadingAnchor.constraint(equalTo: collectionAuthor.trailingAnchor, constant: 4),
            collectionAuthorLink.centerYAnchor.constraint(equalTo: collectionAuthor.centerYAnchor),
            
            collectionDescription.topAnchor.constraint(equalTo: collectionAuthor.bottomAnchor, constant: 5),
            collectionDescription.leadingAnchor.constraint(equalTo: collectionName.leadingAnchor),
            collectionDescription.trailingAnchor.constraint(equalTo: collectionName.trailingAnchor),
            collectionDescription.bottomAnchor.constraint(equalTo: descriptionStackView.bottomAnchor),
            
            nftCollectionView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 24),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configCollectionCell()
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 18) / 3, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
