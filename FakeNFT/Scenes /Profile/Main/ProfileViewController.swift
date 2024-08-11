//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {

}

final class ProfileViewController: UIViewController {
    // MARK: - Properties

    typealias Cell = ProfileScreenModel.TableData.Cell

    var presenter: ProfilePresenterProtocol!

    // MARK: - UI Elements

    private lazy var profileContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = .profileStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var avatarNameContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = .avatarNameStackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .avatarCornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.numberOfLines = 1
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var linkTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.textColor = .linkBlue
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var model: ProfileScreenModel = .empty {
        didSet {
            setup()
        }
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        presenter.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        loadMockData()
    }

    // MARK: - Private methods

    private func loadMockData() {
        // Set mock data for UI elements
        avatarImageView.image = UIImage(systemName: "person.circle")
        userNameLabel.text = "John Doe"
        descriptionLabel.text = "This is a short bio or description about the user. It can span multiple lines and should be tested for wrapping."
        linkTextView.text = "https://www.google.com/"

        // Set mock data for table view cells
        let cellModels = [
            ProfileDetailCellModel(title: "Мои NFT", subtitle: "(12)", action: { print("Tapped My NFTs") }),
            ProfileDetailCellModel(title: "Избранные NFT", subtitle: "(8)", action: { print("Tapped Favorites") }),
            ProfileDetailCellModel(title: "О разработчике", subtitle: "", action: { print("Tapped Settings") })
        ]

        model = ProfileScreenModel(
            userName: "John Doe",
            userImage: UIImage(systemName: "person.circle")!,
            userAbout: "This is a short bio or description about the user. It can span multiple lines and should be tested for wrapping.",
            websiteUrlString: "https://www.google.com/",
            tableData: ProfileScreenModel.TableData(sections: [
                .simple(cells: cellModels.map { .detail($0) })
            ])
        )
    }

    private func setup() {
        updateLinkTextView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(profileContainerView)
        view.addSubview(tableView)
        configureNavigationBar()
        configureProfileContainer()
        configureAvatarNameStack()
        configureTableView()
    }

    private func updateLinkTextView() {
        guard !model.websiteUrlString.isEmpty else {
            linkTextView.attributedText = nil
            return
        }

        let attributedString = NSMutableAttributedString(string: "")
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .link: model.websiteUrlString,
            .foregroundColor: UIColor.linkBlue,
            .font: UIFont.caption1
        ]
        let linkText = NSAttributedString(string: model.websiteUrlString, attributes: linkAttributes)

        attributedString.append(linkText)
        linkTextView.attributedText = attributedString

        linkTextView.linkTextAttributes = [
            .foregroundColor: UIColor.linkBlue,
            .font: UIFont.caption1
        ]
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        linkTextView.delegate = self
        tableView.register(ProfileDetailCell.self, forCellReuseIdentifier: ProfileDetailCell.identifier)
    }

    private func configureNavigationBar() {
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "pencil"), // TODO: - Change to design asset
            style: .plain,
            target: self,
            action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = editButton
    }

    private func configureProfileContainer() {
        profileContainerView.addArrangedSubview(avatarNameContainer)
        profileContainerView.addArrangedSubview(descriptionLabel)
        profileContainerView.addArrangedSubview(linkTextView)

        NSLayoutConstraint.activate([
            profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .topOffset),
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .horizontalOffset),
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.horizontalOffset)
        ])
    }

    private func configureAvatarNameStack() {
        avatarNameContainer.addArrangedSubview(avatarImageView)
        avatarNameContainer.addArrangedSubview(userNameLabel)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: .avatarWidthHeight),
            avatarImageView.heightAnchor.constraint(equalToConstant: .avatarWidthHeight)
        ])
    }

    private func configureTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: .tableViewTopInsets),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.horizontalOffset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .horizontalOffset),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func tableDataCell(indexPath: IndexPath) -> Cell {
        let section = model.tableData.sections[indexPath.section]
        switch section {
        case let .simple(cells):
            return cells[indexPath.row]
        }
    }

    @objc private func editButtonTapped() {
        // TODO: - Add presenter logic for editButton
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {

}

// MARK: - UITextViewDelegate

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        presenter.showWebsite(URL: URL)
        return false
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell

        switch cellType {
        case let .detail(model):
            guard let detailCell = tableView.dequeueReusableCell(
                withIdentifier: ProfileDetailCell.identifier,
                for: indexPath) as? ProfileDetailCell
            else { return UITableViewCell() }

            detailCell.model = model
            detailCell.selectionStyle = .none
            cell = detailCell
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        model.tableData.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.tableData.sections[section] {
        case let .simple(cells):
            return cells.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        .cellHeight
    }
}

private extension CGFloat {
    static let profileStackSpacing: CGFloat = 20
    static let avatarCornerRadius: CGFloat = 35
    static let cellHeight: CGFloat = 54
    static let avatarNameStackSpacing: CGFloat = 16
    static let horizontalOffset: CGFloat = 16
    static let topOffset: CGFloat = 20
    static let avatarWidthHeight: CGFloat = 70
    static let tableViewTopInsets: CGFloat = 20
}
