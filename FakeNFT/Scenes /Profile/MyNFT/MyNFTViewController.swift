//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 14/08/2024.
//

import UIKit

final class MyNFTViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "У Вас еще нет NFT"
        label.font = .bodyBold
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var nftModels: [NFTTableViewCellModel] = [
        NFTTableViewCellModel(
            image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Pink/Lilo/1.png",
            name: "Lilo",
            authorName: "John Doe",
            price: "1,78",
            rating: 3,
            isLiked: true,
            onLikeAction: { isLiked in print("CryptoPunk #3100 liked: \(isLiked)") }
        )]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(emptyStateLabel)
        isNFTsEmpty()
        configureNavigationBar()
    }

    private func isNFTsEmpty() {
        if nftModels.isEmpty {
            configureEmptyStateLabel()
        } else {
            view.addSubview(tableView)
            configureTableView()
        }
        configureNavigationBar()
    }

    private func configureEmptyStateLabel() {
        NSLayoutConstraint.activate([
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -Constants.tableViewTopOffset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
    }

    private func configureNavigationBar() {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)

        let backButton = UIButton(type: .custom)
        let sortButton = UIButton(type: .custom)

        let backImage = UIImage(systemName: "chevron.left", withConfiguration: boldConfig)
        let sortImage = UIImage(systemName: "text.justify.left", withConfiguration: boldConfig)

        backButton.setImage(backImage, for: .normal)
        backButton.tintColor = .black
        sortButton.setImage(sortImage, for: .normal)
        sortButton.tintColor = .black

        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)

        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let rightBarButtonItem = UIBarButtonItem(customView: sortButton)

        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sortButtonTapped() {
        // TODO: - Add sorting logic
        print("Sort NFTs")
    }
}

// MARK: - UITableViewDelegate

extension MyNFTViewController: UITableViewDelegate {

}

// MARK: - UITableViewDataSource

extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }

        let model = nftModels[indexPath.row]
        cell.model = model

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
}

// MARK: - Constants

private struct Constants {
    static let tableViewTopOffset: CGFloat = 20
    static let cellHeight: CGFloat = 140
}
