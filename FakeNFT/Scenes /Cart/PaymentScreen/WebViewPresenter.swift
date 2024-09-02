//
//  WebViewPresenter.swift
//  FakeNFT
//
//  Created by Андрей Тапалов on 15.08.2024.
//

import Foundation

protocol WebViewPresenterProtocol {
    func didLoad(request: URLRequest)
    func didUpdateProgressValue(_ newValue: Double)
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewControllerProtocol?
    
    init(view: WebViewControllerProtocol) {
        self.view = view
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        view?.setProgressHidden(shouldHideProgress(for: newProgressValue))
    }
    
    func didLoad(request: URLRequest) {
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    private func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
