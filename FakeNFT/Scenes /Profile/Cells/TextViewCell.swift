//
//  TextViewCell.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 11/08/2024.
//

import UIKit

struct TextViewCellModel {
    var text: String
    var textDidChanged: (String) -> Void

    static let empty: TextViewCellModel = TextViewCellModel(
        text: "",
        textDidChanged: { _ in }
    )
}

final class TextViewCell: UITableViewCell {

    // MARK: - Properties

    static let identifier = "TextViewCell"

    // MARK: - UI Elements

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .bodyRegular
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    var model: TextViewCellModel = .empty {
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
        configureTextView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setup() {
        textView.text = model.text
    }

    private func configureTextView() {
        contentView.backgroundColor = .segmentInactive
        contentView.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .horizont),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: - UITextViewDelegate

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        model.textDidChanged(textView.text)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let horizont: CGFloat = 16
}
