import UIKit
import SnapKit
import mParticle_Apple_SDK

final class ShopViewController: UITableViewController {
    
    var products = [Product]()
    
    override func viewDidLoad() {
        products = readProducts()
        tableView.accessibilityIdentifier = "ShopTableView"
        tableView.register(ShopTableCell.self, forCellReuseIdentifier: ShopTableCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        navigationItem.title = "Shop Higgs"
        
        edgesForExtendedLayout = []
        MParticle.sharedInstance().logScreen("Shop", eventInfo: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shopTableCell: ShopTableCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableCell.reuseId) as? ShopTableCell {
            shopTableCell = cell
        } else {
            shopTableCell = ShopTableCell(style: .default, reuseIdentifier: ShopTableCell.reuseId)
        }
        shopTableCell.product = products[indexPath.row]
        return shopTableCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = ProductDetailViewController(product: products[indexPath.row])
        detailView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailView, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // We're logging product impressions here to ensure we only include items that the user has actually viewed.
        let product = products[indexPath.row]
        let event = MPCommerceEvent(impressionName: "Product List Impression", product: MPProduct(name: product.label, sku: product.imageName, quantity: NSNumber(value: 1), price: NSNumber(value: product.price)))
        event.shouldBeginSession = AppDelegate.eventsBeginSessions
        MParticle.sharedInstance().logEvent(event)
    }

    private func readProducts() -> [Product] {
        if let localData = Utils.readLocalFile(forName: "ConfigurationData") {
            return Utils.parse(jsonData: localData).products
        }
        
        return [Product]()
    }
}
