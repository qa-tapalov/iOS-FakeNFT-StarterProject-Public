//
//  CartProductTableViewCell.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 05.08.2024.
//

import UIKit

protocol DeleteItemFromCartDelegate: AnyObject {
    func deleteItem(indexPath: IndexPath)
}

final class CartProductTableViewCell: UITableViewCell {
    static let cellIdentifier = "cartProductCellIdentifier"
    weak var delegate: DeleteItemFromCartDelegate?
    private var indexPath: IndexPath?
    
    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starRatingView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = UIColor.init(hexString: "F7F7F8")
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            stackView.addArrangedSubview(starImageView)
        }
        stackView.arrangedSubviews.first?.tintColor = UIColor.init(hexString: "FEEF0D")
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(resource: .delete), for: .normal)
        view.tintColor = .black
        view.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starRatingView)
        contentView.addSubview(priceTextLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 108),
            itemImageView.heightAnchor.constraint(equalToConstant: 108),
            
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            starRatingView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starRatingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            priceTextLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceTextLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: priceTextLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceTextLabel.bottomAnchor, constant: 4),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func buttonDeleteAction(){
        guard let indexPath else {return}
        delegate?.deleteItem(indexPath: indexPath)
    }
    
    func configure(with image: UIImage?, title: String, rating: Int, price: Double, indexPath: IndexPath) {
        itemImageView.image = image
        titleLabel.text = title
        self.indexPath = indexPath
        for (index, view) in starRatingView.arrangedSubviews.enumerated() {
            if let starImageView = view as? UIImageView {
                starImageView.tintColor = index < rating ? UIColor.init(hexString: "FEEF0D") : UIColor.init(hexString: "F7F7F8")
            }
        }
        priceLabel.text = String(price) + " ETH"
    }
}

