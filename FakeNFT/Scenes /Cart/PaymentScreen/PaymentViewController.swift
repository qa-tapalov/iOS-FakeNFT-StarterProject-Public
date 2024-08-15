//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 14.08.2024.
//

import UIKit

protocol PaymentViewControllerProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func reloadCollection()
}

final class PaymentViewController: UIViewController, PaymentViewControllerProtocol {
    
    private var presenter: PaymentViewPresenterProtocol!
    private var id: String = "" {
        didSet {
            updatePaymentButtonState()
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var paymentButton: UIButton = {
        let view = UIButton()
        view.setTitle("Оплатить", for: .normal)
        view.titleLabel?.font = .bodyBold
        view.titleLabel?.textColor = .white
        view.backgroundColor = .gray
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hexString: "F7F7F8")
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelAgreement: UILabel = {
        let view = UILabel()
        view.text = "Совершая покупку, вы соглашаетесь с условиями"
        view.font = .caption2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let linkAgreement: UILabel = {
        let view = UILabel()
        view.text = "Пользовательского соглашения"
        view.textColor = .init(hexString: "0A84FF")
        view.font = .caption2
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = PaymentViewPresenter(view: self)
        setupView()
        setupCollection()
    }
    
    
    private func setupView(){
        title = "Выберите способ оплаты"
        view.backgroundColor = .systemBackground
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        self.navigationController?.navigationBar.tintColor = UIColor.black
        view.addSubview(collectionView)
        view.addSubview(paymentView)
        view.addSubview(activityIndicator)
        paymentView.addSubview(labelAgreement)
        paymentView.addSubview(linkAgreement)
        paymentView.addSubview(paymentButton)
        NSLayoutConstraint.activate([
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: 186),
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            paymentButton.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 20),
            paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -20),
            paymentButton.heightAnchor.constraint(equalToConstant: 60),
            paymentButton.bottomAnchor.constraint(equalTo: paymentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            labelAgreement.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            labelAgreement.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            labelAgreement.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            
            linkAgreement.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            linkAgreement.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            linkAgreement.topAnchor.constraint(equalTo: labelAgreement.bottomAnchor, constant: 4),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCollection(){
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: CurrencyCollectionViewCell.identifier)
    }
    
    func reloadCollection(){
        collectionView.reloadData()
    }
    
    func showLoader(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideLoader(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
    }
    
    @objc private func buttonAction(){
        
    }
    
    private func updatePaymentButtonState(){
        paymentButton.isEnabled = !id.isEmpty
        paymentButton.backgroundColor = .black
    }
    
}

extension PaymentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCollectionViewCell.identifier, for: indexPath) as? CurrencyCollectionViewCell else {
            return UICollectionViewCell()}
        let currency = presenter.getItem(index: indexPath.row)
        cell.configure(cell: currency)
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRow = 2
        let leftInset = 16
        let rightInset = 16
        let cellSpacing = 7
        let paddingWidth: CGFloat = CGFloat(leftInset + rightInset + (cellsPerRow - 1) * cellSpacing)
        let availableWidth = collectionView.frame.width - paddingWidth
        let cellWidth =  availableWidth / CGFloat(cellsPerRow)
        return CGSize(width: cellWidth, height: 46)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.black.cgColor
        cell?.layer.borderWidth = 1
        cell?.layer.cornerRadius = 12
        id = presenter.getItem(index: indexPath.row).id
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
    
}
