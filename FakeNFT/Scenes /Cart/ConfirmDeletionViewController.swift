//
//  DeleteItemViewController.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 08.08.2024.
//

import UIKit

class ConfirmDeletionViewController: UIViewController {
    
    var itemImage: UIImage?
    var confirmDelete: (() -> Void)?
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var confirmationLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Вы уверены, что хотите удалить объект из корзины?"
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var deleteButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Удалить", for: .normal)
           button.setTitleColor(.red, for: .normal)
           button.backgroundColor = .black
           button.layer.cornerRadius = 12
           button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()

       private lazy var returnButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Вернуться", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.backgroundColor = .black
           button.layer.cornerRadius = 12
           button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        imageView.image = itemImage
    }
    
    private func setupView(){
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(confirmationLabel)
        containerView.addSubview(deleteButton)
        containerView.addSubview(returnButton)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: blurEffectView.contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor, constant: -20),
            
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            confirmationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            confirmationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            confirmationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            deleteButton.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            returnButton.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 20),
            returnButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            returnButton.heightAnchor.constraint(equalToConstant: 50),
            returnButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 20),
            deleteButton.widthAnchor.constraint(equalTo: returnButton.widthAnchor),
            
            returnButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func deleteButtonTapped() {
        confirmDelete?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func returnButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
