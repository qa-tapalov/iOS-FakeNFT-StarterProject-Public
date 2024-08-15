//
//  WebViewAgreemantViewController.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 15.08.2024.
//

import Foundation
import WebKit

protocol WebViewControllerProtocol: AnyObject {
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewAgreemantViewController: UIViewController, WebViewControllerProtocol {
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    var presenter: WebViewPresenterProtocol?
    var request: URLRequest?
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(resource: .close), for: .normal)
        view.tintColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.progressTintColor = .systemBackground
        view.progress = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
        if let request {
            presenter?.didLoad(request: request)
        }
    }
    
    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.setProgress(newValue, animated: true)
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    private func setupConstraitsWebView(){
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    private func setupConstraitsBackButton(){
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupConstraitsProgressView(){
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupButtonAction(){
        self.closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
    }
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(closeButton)
        view.addSubview(progressView)
        setupConstraitsWebView()
        setupConstraitsBackButton()
        setupConstraitsProgressView()
        setupButtonAction()
    }
    
    @objc func tapCloseButton() {
        dismiss(animated: true)
    }
}

