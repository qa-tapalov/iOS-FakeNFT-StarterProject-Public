//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 11/08/2024.
//

import UIKit

protocol EditProfileViewProtocol: AnyObject {
    func display(data: EditProfileScreenModel, reloadTableData: Bool)
    var onDismiss: (() -> Void)? { get set }
}

final class EditProfileViewController: UIViewController {

    // MARK: - Properties

    typealias Cell = EditProfileScreenModel.TableData.Cell

    // MARK: - UI Elements

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .black
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
        label.text = "Cменить \nфото"
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

    private var model: EditProfileScreenModel = .empty {
        didSet {
            setup()
        }
    }

    // MARK: - Public properties

    var presenter: EditProfilePresenter?
    var onDismiss: (() -> Void)?

    // MARK: - Init

    init(onDismiss: (@escaping () -> Void)) {
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        presenter?.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTapGesture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        presenter?.saveChanges()
        onDismiss?()
    }

    // MARK: - Private methods

    private func setup() {
        avatarImageView.image = model.image.toUIImage()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(avatarImageView)
        view.addSubview(backButton)
        setupTableView()
        configureAvatarImageView()
        configureBackButton()
    }

    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(TextViewCell.self, forCellReuseIdentifier: TextViewCell.identifier)
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.tableViewTopInsets),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureAvatarImageView() {
        avatarImageView.addSubview(avatarOverlay)
        avatarImageView.addSubview(avatarLabel)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.avatarTopOffset),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarSize),

            avatarOverlay.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            avatarOverlay.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            avatarOverlay.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            avatarOverlay.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarOverlay.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarOverlay.centerYAnchor)
        ])
    }

    private func configureBackButton() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.backButtonTop),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizont)
        ])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    private func tableDataCell(indexPath: IndexPath) -> Cell {
        let section = model.tableData.sections[indexPath.section]

        switch section {
        case .headeredSection(_, cells: let cells):
            return cells[indexPath.row]
        }
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func backButtonTapped() {
        presenter?.saveChanges()
        onDismiss?()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        model.tableData.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch model.tableData.sections[section] {
        case .headeredSection(_, cells: let cells):
            return cells.count
        }
    }
}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableDataCell(indexPath: indexPath)
        let cell: UITableViewCell

        switch cellType {
        case let .textViewCell(model):
            guard let textViewCell = tableView.dequeueReusableCell(
                withIdentifier: TextViewCell.identifier,
                for: indexPath
            )
                    as? TextViewCell else { return UITableViewCell() }

            textViewCell.model = model
            cell = textViewCell

        case let .textFieldCell(model):
            guard let textFieldCell = tableView.dequeueReusableCell(
                withIdentifier: TextFieldCell.identifier,
                for: indexPath
            )
                    as? TextFieldCell else { return UITableViewCell() }

            textFieldCell.model = model
            cell = textFieldCell
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TableHeaderView.identifier) as? TableHeaderView else {

            return nil
        }

        let headerText: String

        switch model.tableData.sections[section] {
        case .headeredSection(header: let header, _):
            headerText = header
        }

        headerView.setup(with: headerText)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - EditProfileViewProtocol

extension EditProfileViewController: EditProfileViewProtocol {
    func display(data: EditProfileScreenModel, reloadTableData: Bool) {
        model = data
        if reloadTableData {
            tableView.reloadData()
        }
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
