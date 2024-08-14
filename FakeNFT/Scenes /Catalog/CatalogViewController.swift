//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Gleb on 10.08.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol CatalogViewControllerProtocol: AnyObject {
    func reloadCatalogTableView()
    func showLoadIndicator()
    func hideLoadIndicator()
}

final class CatalogViewController: UIViewController, CatalogViewControllerProtocol {
    // MARK: - Private Properties
    private let presenter: CatalogPresenterProtocol
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage( systemName: "text.justifyleft"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        button.tintColor = .black
        return button
    }()
    
    private lazy var catalogTableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = true
        tableView.allowsMultipleSelection = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getNftCollections()
        setupCatalogViewController()
    }
    
    // MARK: - Initializers
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.catalogView = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc
    private func sortButtonTapped() {
        present(presenter.setSortType(), animated: true)
    }
    
    // MARK: - Public Methods
    func showLoadIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    
    // MARK: - Private Methods
    private func setupCatalogViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = sortButton
        view.addSubview(catalogTableView)
        setupTableView()
        setupCatalogViewControllerConstrains()
    }
    
    private func setupTableView() {
        catalogTableView.dataSource = self
        catalogTableView.delegate = self
        catalogTableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.identifier)
    }
    
    private func setupCatalogViewControllerConstrains() {
        NSLayoutConstraint.activate([
            catalogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            catalogTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            catalogTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}

// MARK: - CatalogViewController
extension CatalogViewController {
    func reloadCatalogTableView() {
        catalogTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.collectionsNft.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = catalogTableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.identifier, for: indexPath) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        configCell(for: cell, with: indexPath)
        
        return cell
    }
}

extension CatalogViewController {
    func configCell(for cell: CatalogTableViewCell, with indexPath: IndexPath) {
        let collection = presenter.collectionsNft[indexPath.row]
        guard let collectionCover = URL(string: collection.cover) else { return }
        
        cell.setCatalogImage(with: collectionCover)
        cell.setCatalogLabel(with: collection.name, quantity: collection.nfts.count)
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Обработать выбор ячейки (переход на CollectionViewController)
    }
}
