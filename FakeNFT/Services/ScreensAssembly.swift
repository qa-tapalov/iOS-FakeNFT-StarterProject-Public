//
//  ScreensAssembly.swift
//  FakeNFT
//
//  Created by Юрий Клеймёнов on 10/08/2024.
//

import UIKit

protocol ScreensAssemblyProtocol: AnyObject {
    static func buildMainScreen() -> UIViewController
}

final class ScreensAssembly: ScreensAssemblyProtocol {

    static func buildMainScreen() -> UIViewController {
        let tabBarController = UITabBarController()
        let profileController = Self.buildProfileScreen()

        profileController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Профиль", comment: ""),
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 0)

        tabBarController.viewControllers = [profileController]

        return tabBarController
    }

    static func buildProfileScreen() -> UIViewController {
        let profileController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileController)
        let profileRouter = ProfileRouter(view: profileController)
        let profilePresenter = ProfilePresenter(view: profileController, router: profileRouter)
        profileController.presenter = profilePresenter

        return navigationController
    }
}
