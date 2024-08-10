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
}
