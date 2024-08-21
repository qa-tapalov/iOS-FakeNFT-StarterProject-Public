//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 14/08/2024.
//

import UIKit

protocol MyNFTViewProtocol: AnyObject {
    func display(data: MyNFTScreenModel, reloadData: Bool)
}

final class MyNFTViewController: UIViewController {

    // MARK: - Properties

    typealias Cell = MyNFTScreenModel.TableData.Cell
    var presenter: MyNFTPresenterProtocol?

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
        tableView.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        return tableView
    }()

    private var model: MyNFTScreenModel = .empty {
        didSet {
            title = model.title
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

    private func setupView() {
        view.backgroundColor = .white
        configureNavigationBar()
        updateView()
    }

    private func updateView() {
        guard let presenter = presenter else {
            showEmptyState()
            return
        }
        if presenter.nftIds.isEmpty {
            showEmptyState()
        } else {
            showTableView()
        }
    }

    private func showEmptyState() {
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func showTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -Constants.tableViewTopOffset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureNavigationBar() {
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)

        let backButton = createBarButtonItem(imageName: "chevron.left", config: boldConfig, action: #selector(backButtonTapped))
        let sortButton = createBarButtonItem(assetImageName: "sort", action: #selector(sortButtonTapped))

        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = sortButton
    }

    private func createBarButtonItem(imageName: String, config: UIImage.SymbolConfiguration, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    private func createBarButtonItem(assetImageName: String, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let image = UIImage(named: assetImageName)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }

    private func tableDataCell(indexPath: IndexPath) -> Cell {
        let section = model.tableData.sections[indexPath.section]
        switch section {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }

    private func showSortAlert() {
        let sortOrder = presenter?.loadSortOrder()

        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )

        let priceAction = UIAlertAction(
            title: "По цене",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortByPrice()
        }
        priceAction.setValue(sortOrder == "price", forKey: "checked")

        let ratingAction = UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortByRating()
        }
        ratingAction.setValue(sortOrder == "rating", forKey: "checked")

        let nameAction = UIAlertAction(
            title: "По названию",
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortByName()
        }
        nameAction.setValue(sortOrder == "name", forKey: "checked")

        alert.addAction(priceAction)
        alert.addAction(ratingAction)
        alert.addAction(nameAction)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func sortButtonTapped() {
        showSortAlert()
    }
}

// MARK: - MyNFTViewProtocol

extension MyNFTViewController: MyNFTViewProtocol {
    func display(data: MyNFTScreenModel, reloadData: Bool) {
        model = data
        if reloadData {
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyNFTViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return model.tableData.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.tableData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        switch cellType {
        case let .NFTCell(model):
            guard let nftCell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else {
                return UITableViewCell()
            }
            nftCell.model = model
            return nftCell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

// MARK: - Constants

private struct Constants {
    static let tableViewTopOffset: CGFloat = 20
    static let cellHeight: CGFloat = 140
}
