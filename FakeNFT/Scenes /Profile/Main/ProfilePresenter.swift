//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    func setup()
    func editProfile()
    func showWebsite(URL: URL)
}

final class ProfilePresenter {
    // MARK: - Properties

    private weak var view: ProfileViewProtocol?
    private var router: ProfileRouterProtocol?

    init(view: ProfileViewProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func setup() {
        // TODO: - Add render
    }

    func editProfile() {
        router?.showEditProfile()
    }

    func showWebsite(URL: URL) {
        router?.showWebView(URL: URL)
    }
}
