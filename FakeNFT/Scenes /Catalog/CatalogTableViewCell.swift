//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Gleb on 10.08.2024.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {
    static let identifier = "CatalogCell"
    
    lazy var catalogImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupCatalogTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCatalogTableViewCell() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubviews()
        setupCatalogTableViewCellConstrains()
    }
    
    private func addSubviews() {
        [catalogImage, catalogLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupCatalogTableViewCellConstrains() {
        NSLayoutConstraint.activate([
            catalogImage.heightAnchor.constraint(equalToConstant: 140),
            catalogImage.topAnchor.constraint(equalTo: topAnchor),
            catalogImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            catalogImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            catalogLabel.topAnchor.constraint(equalTo: catalogImage.bottomAnchor, constant: 4),
            catalogLabel.bottomAnchor.constraint(equalTo: catalogImage.bottomAnchor, constant: 25),
            catalogLabel.leadingAnchor.constraint(equalTo: catalogImage.leadingAnchor),
            catalogLabel.trailingAnchor.constraint(equalTo: catalogImage.trailingAnchor),
            catalogLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
