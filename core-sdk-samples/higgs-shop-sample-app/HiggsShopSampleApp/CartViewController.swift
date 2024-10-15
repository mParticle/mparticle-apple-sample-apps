import UIKit
import SnapKit
import mParticle_Apple_SDK

final class CartViewController: UITableViewController {
    let subtotalLabel = UILabel()
    let subtotalValueLabel = UILabel()
    let subtotalDivider = UIView()

    let checkoutButton = UIButton()
    let checkoutDisclaimerLabel = UILabel()

    override func viewDidLoad() {
        navigationItem.title = "My Cart"
        edgesForExtendedLayout = []
        let numberOfProducts = AppDelegate.cart.items.count
        var subTotal = 0.0
        for item in AppDelegate.cart.items {
            subTotal += Double(item.quantity) * item.product.price
        }

        // Renders an initial cart view when the screen loads
        MParticle.sharedInstance().logScreen("View My Cart", eventInfo: ["number_of_products": numberOfProducts, "total_product_amounts": subTotal])

        tableView.accessibilityIdentifier = "CartTableView"
        tableView.register(CartTableCell.self, forCellReuseIdentifier: CartTableCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        calculateCosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTable()
        calculateCosts()
    }

    private func reloadTable() {
        tableView.reloadData()

        let count = AppDelegate.cart.items.count
        tabBarController?.tabBar.items?.last?.badgeValue = (count == 0 ? nil : "\(AppDelegate.cart.items.count)")

        if count == 0 {
            let noItemsLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 50)))
            noItemsLabel.accessibilityLabel = "CartNoItemsLabel"
            noItemsLabel.textAlignment = .center
            noItemsLabel.textColor = .label
            noItemsLabel.font = Utils.font(ofSize: 15)
            noItemsLabel.text = NSLocalizedString("CartNoItemsLabel", comment: "")
            tableView.tableHeaderView = noItemsLabel
            tableView.tableFooterView = nil
            tableView.isScrollEnabled = false
        } else {
            tableView.tableHeaderView = nil
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 164))
            footerView.backgroundColor = UIColor.clear

            footerView.addSubview(subtotalLabel)
            subtotalLabel.snp.makeConstraints { make in
                make.top.equalTo(footerView.snp.top).offset(14)
                make.height.equalTo(24)
                make.leading.equalTo(footerView.snp.leading).offset(32)
                make.trailing.equalTo(footerView.snp.centerX)
            }
            subtotalLabel.text = NSLocalizedString("CheckoutSubtotalLabel", comment: "")
            subtotalLabel.font = Utils.boldFont(ofSize: 16)
            subtotalLabel.textAlignment = .left

            footerView.addSubview(subtotalValueLabel)
            subtotalValueLabel.snp.makeConstraints { make in
                make.top.equalTo(footerView.snp.top).offset(14)
                make.height.equalTo(24)
                make.leading.equalTo(footerView.snp.centerX)
                make.trailing.equalTo(footerView.snp.trailing).offset(-32)
            }
            subtotalValueLabel.font = Utils.font(ofSize: 16)
            subtotalValueLabel.textAlignment = .right

            footerView.addSubview(subtotalDivider)
            subtotalDivider.snp.makeConstraints { make in
                make.top.equalTo(subtotalLabel.snp.bottom).offset(9)
                make.height.equalTo(1)
                make.leading.equalTo(footerView.snp.leading).offset(16)
                make.trailing.equalTo(footerView.snp.trailing).offset(-16)
            }
            subtotalDivider.backgroundColor = .separator

            footerView.addSubview(checkoutButton)
            checkoutButton.snp.makeConstraints { make in
                make.top.equalTo(subtotalDivider.snp.bottom).offset(38)
                make.leading.equalTo(footerView.snp.leading).offset(16)
                make.trailing.equalTo(footerView.snp.trailing).offset(-16)
                make.height.equalTo(50)
            }
            checkoutButton.setTitle(NSLocalizedString("CartCheckout", comment: ""), for: .normal)
            checkoutButton.addTarget(self, action: #selector(checkout), for: .touchUpInside)
            checkoutButton.backgroundColor = UIColor(red: 64/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0)
            checkoutButton.layer.cornerRadius = 8
            checkoutButton.titleLabel?.font = Utils.font(ofSize: 16)

            footerView.addSubview(checkoutDisclaimerLabel)
            checkoutDisclaimerLabel.snp.makeConstraints { make in
                make.top.equalTo(checkoutButton.snp.bottom).offset(19)
                make.leading.equalTo(footerView.snp.leading).offset(16)
                make.trailing.equalTo(footerView.snp.trailing).offset(-16)
                make.height.equalTo(16)
            }
            checkoutDisclaimerLabel.text = NSLocalizedString("CheckoutDemoOnly", comment: "")
            checkoutDisclaimerLabel.font = Utils.font(ofSize: 12)
            checkoutDisclaimerLabel.textAlignment = .center
            checkoutDisclaimerLabel.textColor = .secondaryLabel

            footerView.frame.size.height = 164
            tableView.tableFooterView = footerView
            tableView.isScrollEnabled = true
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.cart.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartTableCell: CartTableCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.reuseId) as? CartTableCell {
            cartTableCell = cell
        } else {
            cartTableCell = CartTableCell(style: .default, reuseIdentifier: CartTableCell.reuseId)
        }
        cartTableCell.cartItem = AppDelegate.cart.items[indexPath.row]
        return cartTableCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let removedItem = AppDelegate.cart.items.remove(at: indexPath.row)
        let detailView = ProductDetailViewController(product: removedItem.product)
        detailView.hidesBottomBarWhenPushed = true
        calculateCosts()
        reloadTable()
        let product = MPProduct(name: removedItem.product.label, sku: removedItem.product.imageName, quantity: NSNumber(value: removedItem.quantity), price: NSNumber(value: removedItem.product.price))
        let event = MPCommerceEvent(action: .removeFromCart, product: product)
        event.shouldBeginSession = AppDelegate.eventsBeginSessions
        MParticle.sharedInstance().logEvent(event)
    }

    private func calculateCosts() {
        var subtotal = 0.00
        for cartItem in AppDelegate.cart.items {
            subtotal += cartItem.totalAmount
        }

        subtotalValueLabel.text = "$" + String(format: "%.2f", subtotal)
        checkoutButton.isEnabled = subtotal != 0
    }

    @objc private func checkout() {
        if let event = MPCommerceEvent(action: .checkout) {
            var products = [MPProduct]()
            var subtotal = 0.0
            for cartItem in AppDelegate.cart.items {
                let product = cartItem.product
                let mpProduct = MPProduct(name: product.label, sku: product.imageName, quantity: NSNumber(value: cartItem.quantity), price: NSNumber(value: product.price))
                let attributes = NSMutableDictionary()
                if cartItem.color != "N/A" {
                    attributes.setObject(cartItem.color, forKey: NSString("color"))
                }
                if cartItem.size != "N/A" {
                    attributes.setObject(cartItem.size, forKey: NSString("size"))
                }
                mpProduct.setUserDefinedAttributes(attributes)
                products.append(mpProduct)
                subtotal += cartItem.totalAmount
            }
            event.addProducts(products)
            let transactionAttributes = MPTransactionAttributes()
            AppDelegate.transactionId = UUID().uuidString
            transactionAttributes.transactionId = AppDelegate.transactionId
            let tax = subtotal * 0.08875
            let shipping = subtotal * 0.15
            transactionAttributes.tax = NSNumber(value: Double(String(format: "%.2f", tax)) ?? 0)
            transactionAttributes.shipping = NSNumber(value: Double(String(format: "%.2f", shipping)) ?? 0)
            transactionAttributes.revenue = NSNumber(value: Double(String(format: "%.2f", subtotal + tax + shipping)) ?? 0)
            event.transactionAttributes = transactionAttributes // transaction attributes are required
            event.shouldBeginSession = AppDelegate.eventsBeginSessions
            MParticle.sharedInstance().logEvent(event)

            let checkoutVC = CheckoutViewController()
            checkoutVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(checkoutVC, animated: true)
        }
    }
}
