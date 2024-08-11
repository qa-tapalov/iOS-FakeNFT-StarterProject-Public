//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 11/08/2024.
//

import UIKit

final class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    typealias Cell = EditProfileScreenModel.TableData.Cell
    
    // MARK: - UI Elements
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.radius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var avatarLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Cменить /nфото"
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var avatarOverlay: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.layer.opacity = 0.6
        view.layer.cornerRadius = Constants.radius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(avatarImageView)
        view.addSubview(backButton)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextViewCell.self, forCellReuseIdentifier: TextViewCell.identifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.tableViewTopInsets),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizont),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizont),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.horizont)
        ])
    }
    
    private func configureAvatarImageView() {
        avatarImageView.addSubview(avatarOverlay)
        avatarOverlay.addSubview(avatarLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.avatarTopOffset),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarSize),
            
            avatarOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            avatarOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            avatarOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            avatarLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureBackButton() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.backButtonTop),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizont)
        ])
    }
}


// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    }
}
// MARK: - Constants

private struct Constants {
    static let radius: CGFloat = 35
    static let horizont: CGFloat = 16
    static let avatarTopOffset: CGFloat = 80
    static let avatarSize: CGFloat = 70
    static let tableViewTop: CGFloat = 24
    static let backButtonTop: CGFloat = 16
    static let tableViewTopInsets: CGFloat = 24
}
