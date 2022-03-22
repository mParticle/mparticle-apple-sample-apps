import UIKit

final class TabBarController: UITabBarController {
    
    enum TabType: Int, CaseIterable {
        case shop = 0, myAccount, cart
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "TabBarController"
        createTabs()
    }

    private func createTabs() {
        var controllers = [UIViewController]()
        for type in TabType.allCases {
            var controller: UINavigationController?
            switch type {
            case .shop:
                controller = UINavigationController(rootViewController: ShopViewController())
                controller?.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(named: "TabBarIconShop"), tag: type.rawValue)
                controller?.tabBarItem.accessibilityIdentifier = "TabBarItemShop"
            case .myAccount:
                controller = UINavigationController(rootViewController: MyAccountViewController())
                controller?.tabBarItem = UITabBarItem(title: "My Account", image: UIImage(named: "TabBarIconMyAccount"), tag: type.rawValue)
                controller?.tabBarItem.accessibilityIdentifier = "TabBarItemMyAccount"
            case .cart:
                controller = UINavigationController(rootViewController: CartViewController())
                controller?.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(named: "TabBarIconCart"), tag: type.rawValue)
                controller?.tabBarItem.accessibilityIdentifier = "TabBarItemCart"
            }
            if let controller = controller {
                controllers.append(controller)
            }
        }
        self.viewControllers = controllers
    }
    
}
