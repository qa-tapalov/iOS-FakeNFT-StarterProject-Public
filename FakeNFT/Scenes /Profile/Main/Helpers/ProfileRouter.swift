//
//  ProfileRouter.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import UIKit
import SafariServices

protocol ProfileRouterProtocol: AnyObject {
    func showWebView(URL: URL)
    func showEditProfile(profile: ProfileModel)
    func showMyNFTScreen()
    func showFavouritesNFTScreen()
}

final class ProfileRouter: ProfileRouterProtocol {

    // MARK: - Properties

    private weak var view: ProfileViewProtocol?

    init(view: ProfileViewProtocol) {
        self.view = view
    }

    // MARK: - Public methods

    func showWebView(URL: URL) {
        guard let view = view as? UIViewController else { return }

        let safariViewController = SFSafariViewController(url: URL)
        safariViewController.hidesBottomBarWhenPushed = true

        view.present(safariViewController, animated: true)
    }

    func showEditProfile(profile: ProfileModel) {
        guard let view = view as? UIViewController else { return }

        let editProfileController = EditProfileViewController()
        let networkClient = DefaultNetworkClient()
        let profileService = ProfileService(networkClient: networkClient)
        let presenter = EditProfilePresenter(view: editProfileController, profileService: profileService, profile: profile)

        editProfileController.presenter = presenter
        editProfileController.hidesBottomBarWhenPushed = true
        editProfileController.modalPresentationStyle = .pageSheet

        view.present(editProfileController, animated: true)
    }

    func showMyNFTScreen() {
        guard let view = view as? UIViewController else { return }

        let myNFTController = MyNFTViewController()
        myNFTController.hidesBottomBarWhenPushed = true

        view.navigationController?.pushViewController(myNFTController, animated: true)
    }

    func showFavouritesNFTScreen() {
        guard let view = view as? UIViewController else { return }

        let favouritesNFTsController = FavouritesNFTViewController()
        favouritesNFTsController.hidesBottomBarWhenPushed = true

        view.navigationController?.pushViewController(favouritesNFTsController, animated: true)
    }
}
