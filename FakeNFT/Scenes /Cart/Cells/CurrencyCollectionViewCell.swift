//
//  CurrencyCollectionViewCell.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 14.08.2024.
//

import UIKit
import Kingfisher

final class CurrencyCollectionViewCell: UICollectionViewCell {
    static var identifier = "currencyCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.font = .caption2
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UILabel = {
        let view = UILabel()
        view.font = .caption2
        view.textColor = .black
        view.textColor = UIColor.init(hexString: "1C9F00")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.alignment = .leading
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .init(hexString: "F7F7F8")
        contentView.addSubview(containerView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(name)
        containerView.addSubview(icon)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.widthAnchor.constraint(equalToConstant: 36),
            containerView.heightAnchor.constraint(equalToConstant: 36),
            
            icon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 32),
            icon.heightAnchor.constraint(equalToConstant: 32),
            
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 4)
        ])
    }
    
    func configure(cell: CurrencyModel) {
        let url = URL(string: cell.image)
        icon.kf.indicatorType = .activity
        icon.kf.setImage(with: url)
        title.text = cell.title
        name.text = cell.name
    }
}
