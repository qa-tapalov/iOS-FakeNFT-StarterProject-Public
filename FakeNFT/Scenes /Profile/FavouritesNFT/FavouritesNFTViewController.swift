//
//  FavouritesNFTViewController.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 14/08/2024.
//

import UIKit

protocol FavouritesNFTViewProtocol: AnyObject {
    func display(data: FavoritesNFTScreenModel, reloadData: Bool)
}

final class FavouritesNFTViewController: UIViewController {

    // MARK: - Properties

    typealias Cell = FavoritesNFTScreenModel.CollectionData.Cell
    typealias Section = FavoritesNFTScreenModel.CollectionData.Cell
    var presenter: FavouritesNFTPresenterProtocol?

    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: 20, left: Constants.horizontalOffset, bottom: 0, right: Constants.horizontalOffset)
        return layout
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет избранных NFT"
        label.font = .bodyBold
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var model: FavoritesNFTScreenModel = .empty {
        didSet {
            setup()
        }
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private methods

    private func setup() {
        title = model.title
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white

        configureNavigationBar()
        configureCollectionView()
        configureEmptyLabel()
        showEmptyLabel()
    }

    private func showEmptyLabel() {
        guard let presenter = presenter else {
            emptyStateLabel.isHidden = false
            collectionView.isHidden = true
            navigationItem.title = nil
            return
        }

        let isEmpty = presenter.favouriteNFTIds.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        collectionView.isHidden = isEmpty

        navigationItem.title = isEmpty ? nil : model.title
        configureCollectionView()
    }

    private func configureNavigationBar() {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        let backButton = createBarButtonItem(
            imageName: "chevron.left",
            config: boldConfig,
            action: #selector(backButtonTapped)
        )

        navigationItem.leftBarButtonItem = backButton
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.collectionViewTopOffset),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
    }

    private func configureEmptyLabel() {
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func createBarButtonItem(imageName: String, config: UIImage.SymbolConfiguration, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    private func collectionDataCell(indexPath: IndexPath) -> Cell {
        let section = model.collectionData.sections[indexPath.section]

        switch section {
        case let .simple(cells):
            return cells[indexPath.item]
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - FavouritesNFTViewProtocol

extension FavouritesNFTViewController: FavouritesNFTViewProtocol {
    func display(data: FavoritesNFTScreenModel, reloadData: Bool) {
        model = data
        showEmptyLabel()
        if reloadData {
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FavouritesNFTViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension FavouritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = collectionDataCell(indexPath: indexPath)
        let cell: UICollectionViewCell

        switch cellType {
        case let .NFTCell(model):
            guard let nftCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NFTCollectionViewCell.identifier,
                for: indexPath) as? NFTCollectionViewCell else { return UICollectionViewCell() }
            nftCell.model = model
            cell = nftCell
        }

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        model.collectionData.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch model.collectionData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }
}

// MARK: - Constants

private struct Constants {
    static let horizontalOffset: CGFloat = 16.0
    static let minimumLineSpacing: CGFloat = 20.0
    static let minimumInteritemSpacing: CGFloat = 7.0
    static let itemWidth: CGFloat = (UIScreen.main.bounds.width - (2 * horizontalOffset) - minimumInteritemSpacing) / 2
    static let itemHeight: CGFloat = 80.0
    static let collectionViewTopOffset: CGFloat = 20
}
