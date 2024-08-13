//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 08.08.2024.
//

import UIKit
import ProgressHUD

final class CartViewController: UIViewController {
    
    let refreshControl = UIRefreshControl()
    var presenter: CartViewPresenterProtocol!
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var sortButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(resource: .sort), style: .plain, target: self, action: #selector(sortItems))
        view.tintColor = .black
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
    
    private lazy var totalCountLabel: UILabel = {
        let view = UILabel()
        view.font = .caption1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let view = UILabel()
        view.font = .bodyBold
        view.textColor = UIColor.init(hexString: "1C9F00")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var paymentButton: UIButton = {
        let view = UIButton()
        view.setTitle("К оплате", for: .normal)
        view.titleLabel?.font = .bodyBold
        view.titleLabel?.textColor = .white
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.separatorColor = .clear
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.register(CartProductTableViewCell.self, forCellReuseIdentifier: CartProductTableViewCell.cellIdentifier)
        return view
    }()
    
    private lazy var emptyLabel: UILabel = {
        let view = UILabel()
        view.text = "Корзина пустая"
        view.font = .bodyBold
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        view.backgroundColor = .systemBackground
        presenter = CartViewPresenter(view: self)
        setupView()
        updateUI()
    }
    
    private func setupView(){
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(paymentView)
        view.addSubview(activityIndicator)
        paymentView.addSubview(paymentButton)
        paymentView.addSubview(totalCountLabel)
        paymentView.addSubview(totalPriceLabel)
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: paymentView.topAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: 76),
            
            paymentButton.widthAnchor.constraint(equalToConstant: 240),
            paymentButton.trailingAnchor.constraint(equalTo: paymentView.trailingAnchor, constant: -16),
            paymentButton.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            paymentButton.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: -16),
            
            totalCountLabel.topAnchor.constraint(equalTo: paymentButton.topAnchor),
            totalCountLabel.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            
            totalPriceLabel.topAnchor.constraint(equalTo: totalCountLabel.bottomAnchor, constant: 2),
            totalPriceLabel.leadingAnchor.constraint(equalTo: totalCountLabel.leadingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func refreshData(){
        presenter.loadNfts()
        refreshControl.endRefreshing()
    }
    
    @objc
    private func sortItems(){
        let price = UIAlertAction(title: "По цене", style: .default) { _ in
            self.presenter?.sortItems(options: .price)
            self.tableView.reloadData()
        }
        
        let rating = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.presenter?.sortItems(options: .rating)
            self.tableView.reloadData()
        }
        
        let name = UIAlertAction(title: "По названию", style: .default) { _ in
            self.presenter?.sortItems(options: .names)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        let alert = UIAlertController(title: .none, message: "Сортировка", preferredStyle: .actionSheet)
        alert.addAction(price)
        alert.addAction(rating)
        alert.addAction(name)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func updateUI(){
        let items = presenter.items
        totalCountLabel.text = String(items.count) + " NFT"
        let totalPrice = items.map {$0.price}.reduce(0, +)
        totalPriceLabel.text = totalPrice.formatDecimal() + " ETH"
        tableView.isHidden = items.isEmpty
        emptyLabel.isHidden = !items.isEmpty
        navigationItem.rightBarButtonItem = items.isEmpty ? nil : sortButton
        paymentView.isHidden = items.isEmpty
        tableView.reloadData()
    }
    
    func showLoader(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    func hideLoader(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
    }
    
    
    private func showConfirmDeleteView(item: ProductModel, indexPath: IndexPath){
        let vc = ConfirmDeletionViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.itemImage = item.imageUrl.first
        vc.confirmDelete = { [weak self] in
            guard let self else {return}
            self.presenter.deleteItem(index: indexPath.row)
            self.updateUI()
        }
        self.present(vc, animated: true)
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartProductTableViewCell.cellIdentifier, for: indexPath) as? CartProductTableViewCell else { return UITableViewCell() }
        let item = presenter.getItem(index: indexPath.row)
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configure(with: item, indexPath: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] action, tableView, complition in
            guard let self else {return}
            let item = presenter.items[indexPath.row]
            self.showConfirmDeleteView(item: item, indexPath: indexPath)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = true
        return swipeAction
    }
}

extension CartViewController: DeleteItemFromCartDelegate{
    func deleteItem(indexPath: IndexPath) {
        let item = presenter.items[indexPath.row]
        showConfirmDeleteView(item: item, indexPath: indexPath)
    }
}

extension Double {
    func formatDecimal() -> String{
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
