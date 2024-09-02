//
//  SuccessOrderViewController.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 15.08.2024.
//

import UIKit

final class SuccessOrderViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(resource: .imageSuccess)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelSuccess: UILabel = {
        let view = UILabel()
        view.text = "Успех! Оплата прошла,\n поздравляем с покупкой!"
        view.font = .headline3
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        let view = UIButton()
        view.setTitle("Вернуться в корзину", for: .normal)
        view.titleLabel?.font = .bodyBold
        view.titleLabel?.textColor = .white
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    private func setupView() {
        view.addSubview(imageView)
        view.addSubview(labelSuccess)
        view.addSubview(paymentButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            labelSuccess.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelSuccess.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            paymentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            paymentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    @objc
    private func buttonAction(){
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = TabBarController()
        tabBarController.selectedIndex = 2
        window.rootViewController = tabBarController
    }
}
