//
//  TextFieldCell.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 11/08/2024.
//

import UIKit

struct TextFieldCellModel {
    var text: String
    var textDidChanged: (String) -> Void

    static let empty = TextFieldCellModel(
        text: "",
        textDidChanged: {_ in }
    )
}

final class TextFieldCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "TextFieldCell"

    // MARK: - UI Elements

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = .black
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = .clear
        textField.font = .bodyRegular
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    var model: TextFieldCellModel = .empty {
        didSet {
            setup()
        }
    }

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTextField()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setup() {
        textField.text = model.text
    }

    private func configureTextField() {
        contentView.addSubview(textField)
        contentView.backgroundColor = .segmentInactive

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .horizont),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: .height)
        ])

        textField.addTarget(self, action: #selector(editingChanged), for: .editingDidEnd)
    }

    @objc private func editingChanged() {
        model.textDidChanged(textField.text ?? "")
    }
}

// MARK: - UITextFieldDelegate

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Constants

private extension CGFloat {
    static let horizont: CGFloat = 16
    static let height: CGFloat = 44
}
