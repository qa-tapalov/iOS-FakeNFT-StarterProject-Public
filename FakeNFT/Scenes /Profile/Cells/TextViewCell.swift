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

    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "multiply.circle.fill"), for: .normal)
        button.tintColor = UIColor(hexString: "#8E8E93")
        button.isHidden = true
        button.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        configureClearButton()
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
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40)
        ])
    }

    private func configureClearButton() {
        contentView.addSubview(clearButton)

        NSLayoutConstraint.activate([
            clearButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            clearButton.widthAnchor.constraint(equalToConstant: .clearBottonSize),
            clearButton.heightAnchor.constraint(equalToConstant: .clearBottonSize)
        ])
    }

    @objc private func clearText() {
        textView.text = ""
        model.textDidChanged("")
        clearButton.isHidden = true
    }
}

// MARK: - UITextViewDelegate

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        model.textDidChanged(textView.text)
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))

        clearButton.isHidden = textView.text.isEmpty

        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)

            if let thisIndexPath = tableView?.indexPath(for: self) {
                tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        clearButton.isHidden = textView.text.isEmpty
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        clearButton.isHidden = true
    }

    var tableView: UITableView? {
        var view = superview
        while let newView = view, !(newView is UITableView) {
            view = newView.superview
        }
        return view as? UITableView
    }
}

// MARK: - Constants

private extension CGFloat {
    static let horizont: CGFloat = 16
    static let clearBottonSize: CGFloat = 17
}
