//
//  TableHeaderView.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 11/08/2024.
//

import UIKit

final class TableHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    static let identifier = "HeaderView"
    
    // MARK: - UI Elements
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = .headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHeaderLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setup(with text: String) {
        headerLabel.text = text
    }
    
    // MARK: - Private methods
    
    private func configureHeaderLabel() {
        contentView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .vertical),
            headerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.vertical)
        ])
    }
}

// MARK: - Constants

private extension CGFloat {
    static let vertical: CGFloat = 8
}
