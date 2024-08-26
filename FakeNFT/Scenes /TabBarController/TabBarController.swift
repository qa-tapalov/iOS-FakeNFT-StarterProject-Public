import UIKit

final class TabBarController: UITabBarController {

    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage.profileTabBar,
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: "Каталог",
        image: UIImage.catalogTabBar,
        tag: 1
    )

    private let cartTabBarItem = UITabBarItem(
        title: "Корзина",
        image: UIImage.basketTabBar,
        tag: 2
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: "Статистика",
        image: UIImage.statisticsTabBar,
        tag: 3
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        view.backgroundColor = UIColor.systemBackground
        
        let cartViewController = UINavigationController(rootViewController: CartViewController())
        cartViewController.tabBarItem = cartTabBarItem

        let profileViewController = ProfileViewController()
        let profileRouter = ProfileRouter(view: profileViewController)
        let imageLoader = ImageLoader()
        let networkClient = DefaultNetworkClient()
        let profileService = ProfileService(networkClient: networkClient)
        let profilePresenter = ProfilePresenter(
            view: profileViewController,
            router: profileRouter,
            profileService: profileService,
            imageLoader: imageLoader
        )

        profileViewController.presenter = profilePresenter

        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.tabBarItem = profileTabBarItem

        let statsViewController = UINavigationController(rootViewController: StatisticsViewController())
        statsViewController.tabBarItem = statisticsTabBarItem
        
        viewControllers = [profileNavController, cartViewController, statsViewController]
        
        let tabBarAppearance = tabBar.standardAppearance
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .ypWhite
        
        let normalAppearance = UITabBarItemAppearance()
        normalAppearance.normal.iconColor = .ypBlack
        normalAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.ypBlack ]
        
        tabBarAppearance.stackedLayoutAppearance = normalAppearance
        tabBarAppearance.inlineLayoutAppearance = normalAppearance
        tabBarAppearance.compactInlineLayoutAppearance = normalAppearance
        
        tabBar.standardAppearance = tabBarAppearance
    }
}
