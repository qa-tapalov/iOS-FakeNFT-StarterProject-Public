import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly: ServicesAssembly!
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: "Каталог"),
        image: UIImage(resource: .tabCatalog),
        tag: 1
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: "Корзина",
        image: UIImage(resource: .cart),
        tag: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        let cartController = UINavigationController(rootViewController: CartViewController(
            servicesAssembly: servicesAssembly))
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartTabBarItem
        viewControllers = [catalogController,cartController]
        
        view.backgroundColor = .systemBackground
    }
}
