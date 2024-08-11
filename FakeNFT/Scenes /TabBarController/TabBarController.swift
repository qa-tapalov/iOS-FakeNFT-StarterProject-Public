import UIKit

final class TabBarController: UITabBarController {

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: "Профиль"),
        image: UIImage(resource: .tabProfile),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: "Каталог"),
        image: UIImage(resource: .tabCatalog),
        tag: 1
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: "Корзина"),
        image: UIImage(resource: .tabCart),
        tag: 2
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: "Статистика"),
        image: UIImage(resource: .tabStatistic),
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        view.backgroundColor = UIColor.systemBackground

// MARK: - ProfileViewController
        let profileViewController = ProfileViewController()
        let profileRouter = ProfileRouter(view: profileViewController)
        let profilePresenter = ProfilePresenter(view: profileViewController, router: profileRouter)
        profileViewController.presenter = profilePresenter
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.tabBarItem = profileTabBarItem
        //
        //        let catalogViewController = UINavigationController(rootViewController: )
        //        catalogViewController.tabBarItem = catalogTabBarItem
        //
        //        let cartViewController = UINavigationController(rootViewController: )
        //        cartViewController.tabBarItem = cartTabBarItem
        //
        //        let statisticViewController = UINavigationController(rootViewController: )
        //        statsViewController.tabBarItem = statisticsTabBarItem
        //
        viewControllers = [profileNavController]
    }
}
