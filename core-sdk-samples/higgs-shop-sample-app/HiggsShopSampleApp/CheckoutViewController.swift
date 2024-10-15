import UIKit
import SnapKit
import mParticle_Apple_SDK

final class CheckoutViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    let scrollView = UIScrollView()

    let checkoutLabel = UILabel()

    let shippingLabel = UILabel()
    let shippingDisclaimerLabel = UILabel()

    let streetAddressTextbox = LabeledTextField()
    let cityTextbox = LabeledTextField()
    let stateTextbox = LabeledTextField()
    let zipTextbox = LabeledTextField()

    let paymentLabel = UILabel()
    let paymentDisclaimerLabel = UILabel()

    let creditCardTextbox = LabeledTextField()
    let expirationTextbox = LabeledTextField()
    let cardVerificationTextbox = LabeledTextField()

    let reviewOrderLabel = UILabel()

    let cartTableView = UITableView()

    let subtotalLabel = UILabel()
    let subtotalValueLabel = UILabel()
    let subtotalDivider = UIView()

    let salesTaxLabel = UILabel()
    let salesTaxValueLabel = UILabel()
    let salesTaxDivider = UIView()

    let shippingCostLabel = UILabel()
    let shippingCostValueLabel = UILabel()
    let shippingCostDivider = UIView()

    let grandTotalLabel = UILabel()
    let grandTotalValueLabel = UILabel()
    let grandTotalDivider = UIView()
    let grandTotalHighlight = UIView()

    let placeOrderButton = UIButton()
    let placeOrderDisclaimerLabel = UILabel()

    override func viewDidLoad() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.backgroundColor = .systemBackground
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        scrollView.addSubview(checkoutLabel)
        checkoutLabel.text = NSLocalizedString("CheckoutTitle", comment: "")
        checkoutLabel.font = Utils.boldFont(ofSize: 24)
        checkoutLabel.textAlignment = .center
        checkoutLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.height.equalTo(24)
            make.leading.equalTo(self.view).offset(17)
            make.trailing.equalTo(self.view).offset(-17)
        }

        scrollView.addSubview(shippingLabel)
        shippingLabel.text = NSLocalizedString("CheckoutSubtitleShipping", comment: "")
        shippingLabel.font = Utils.font(ofSize: 20)
        shippingLabel.textAlignment = .center
        shippingLabel.snp.makeConstraints { make in
            make.top.equalTo(checkoutLabel.snp.bottom).offset(29)
            make.height.equalTo(20)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }

        scrollView.addSubview(shippingDisclaimerLabel)
        shippingDisclaimerLabel.text = NSLocalizedString("CheckoutDemoOnly", comment: "")
        shippingDisclaimerLabel.font = Utils.font(ofSize: 12)
        shippingDisclaimerLabel.textAlignment = .center
        shippingDisclaimerLabel.textColor = .secondaryLabel
        shippingDisclaimerLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingLabel.snp.bottom).offset(6)
            make.height.equalTo(12)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }

        scrollView.addSubview(streetAddressTextbox)
        streetAddressTextbox.snp.makeConstraints { make in
            make.top.equalTo(shippingDisclaimerLabel.snp.bottom).offset(16)
            make.height.equalTo(63)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        streetAddressTextbox.isUserInteractionEnabled = false
        streetAddressTextbox.textBoxField.delegate = self
        streetAddressTextbox.textBoxLabel.text = NSLocalizedString("CheckoutStreetAddressLabel", comment: "")
        streetAddressTextbox.textBoxField.text = NSLocalizedString("CheckoutStreetAddressDefault", comment: "")

        scrollView.addSubview(cityTextbox)
        cityTextbox.snp.makeConstraints { make in
            make.top.equalTo(streetAddressTextbox.snp.bottom).offset(20)
            make.height.equalTo(63)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        cityTextbox.isUserInteractionEnabled = false
        cityTextbox.textBoxField.delegate = self
        cityTextbox.textBoxLabel.text = NSLocalizedString("CheckoutCityAddressLabel", comment: "")
        cityTextbox.textBoxField.text = NSLocalizedString("CheckoutCityAddressDefault", comment: "")

        scrollView.addSubview(stateTextbox)
        stateTextbox.snp.makeConstraints { make in
            make.top.equalTo(cityTextbox.snp.bottom).offset(20)
            make.height.equalTo(63)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.centerX).offset(-9)
        }
        stateTextbox.isUserInteractionEnabled = false
        stateTextbox.textBoxField.delegate = self
        stateTextbox.textBoxLabel.text = NSLocalizedString("CheckoutStateAddressLabel", comment: "")
        stateTextbox.textBoxField.text = NSLocalizedString("CheckoutStateAddressDefault", comment: "")

        scrollView.addSubview(zipTextbox)
        zipTextbox.snp.makeConstraints { make in
            make.top.equalTo(cityTextbox.snp.bottom).offset(20)
            make.height.equalTo(63)
            make.leading.equalTo(stateTextbox.snp.trailing).offset(18)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        zipTextbox.isUserInteractionEnabled = false
        zipTextbox.textBoxField.delegate = self
        zipTextbox.textBoxLabel.text = NSLocalizedString("CheckoutZipAddressLabel", comment: "")
        zipTextbox.textBoxField.text = NSLocalizedString("CheckoutZipAddressDefault", comment: "")

        scrollView.addSubview(paymentLabel)
        paymentLabel.snp.makeConstraints { make in
            make.top.equalTo(zipTextbox.snp.bottom).offset(45)
            make.height.equalTo(24)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        paymentLabel.text = NSLocalizedString("CheckoutSubtitlePayment", comment: "")
        paymentLabel.font = Utils.font(ofSize: 20)
        paymentLabel.textAlignment = .center

        scrollView.addSubview(paymentDisclaimerLabel)
        paymentDisclaimerLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        paymentDisclaimerLabel.text = NSLocalizedString("CheckoutDemoOnly", comment: "")
        paymentDisclaimerLabel.font = Utils.font(ofSize: 12)
        paymentDisclaimerLabel.textAlignment = .center
        paymentDisclaimerLabel.textColor = .secondaryLabel

        scrollView.addSubview(creditCardTextbox)
        creditCardTextbox.snp.makeConstraints { make in
            make.top.equalTo(paymentDisclaimerLabel.snp.bottom).offset(16)
            make.height.equalTo(63)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        creditCardTextbox.isUserInteractionEnabled = false
        creditCardTextbox.textBoxField.delegate = self
        creditCardTextbox.textBoxLabel.text = NSLocalizedString("CheckoutCreditCardNumberLabel", comment: "")
        creditCardTextbox.textBoxField.text = NSLocalizedString("CheckoutCreditCardNumberDefault", comment: "")

        scrollView.addSubview(expirationTextbox)
        expirationTextbox.snp.makeConstraints { make in
            make.top.equalTo(creditCardTextbox.snp.bottom).offset(20)
            make.height.equalTo(63)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.centerX).offset(-9)
        }
        expirationTextbox.isUserInteractionEnabled = false
        expirationTextbox.textBoxField.delegate = self
        expirationTextbox.textBoxLabel.text = NSLocalizedString("CheckoutCreditCardExpDateLabel", comment: "")
        expirationTextbox.textBoxField.text = NSLocalizedString("CheckoutCreditCardExpDateDefault", comment: "")

        scrollView.addSubview(cardVerificationTextbox)
        cardVerificationTextbox.snp.makeConstraints { make in
            make.top.equalTo(creditCardTextbox.snp.bottom).offset(20)
            make.height.equalTo(63)
            make.leading.equalTo(expirationTextbox.snp.trailing).offset(18)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        cardVerificationTextbox.isUserInteractionEnabled = false
        cardVerificationTextbox.textBoxField.delegate = self
        cardVerificationTextbox.textBoxLabel.text = NSLocalizedString("CheckoutCreditCardCVCLabel", comment: "")
        cardVerificationTextbox.textBoxField.text = NSLocalizedString("CheckoutCreditCardCVCDefault", comment: "")

        scrollView.addSubview(reviewOrderLabel)
        reviewOrderLabel.snp.makeConstraints { make in
            make.top.equalTo(expirationTextbox.snp.bottom).offset(45)
            make.height.equalTo(24)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        reviewOrderLabel.text = NSLocalizedString("CheckoutSubtitleReviewOrder", comment: "")
        reviewOrderLabel.font = Utils.font(ofSize: 20)
        reviewOrderLabel.textAlignment = .center

        scrollView.addSubview(cartTableView)
        cartTableView.snp.makeConstraints { make in
            make.top.equalTo(reviewOrderLabel.snp.bottom).offset(14)
            make.height.equalTo(AppDelegate.cart.items.count * 88)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        cartTableView.accessibilityIdentifier = "CartTableView"
        cartTableView.register(CartTableCell.self, forCellReuseIdentifier: CartTableCell.reuseId)
        cartTableView.rowHeight = UITableView.automaticDimension
        cartTableView.estimatedRowHeight = 88
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartTableView.reloadData()

        scrollView.addSubview(subtotalLabel)
        subtotalLabel.snp.makeConstraints { make in
            make.top.equalTo(cartTableView.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalTo(checkoutLabel.snp.centerX)
        }
        subtotalLabel.text = NSLocalizedString("CheckoutSubtotalLabel", comment: "")
        subtotalLabel.font = Utils.boldFont(ofSize: 16)
        subtotalLabel.textAlignment = .left

        scrollView.addSubview(subtotalValueLabel)
        subtotalValueLabel.snp.makeConstraints { make in
            make.top.equalTo(cartTableView.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalTo(checkoutLabel.snp.centerX)
            make.trailing.equalTo(self.view.snp.trailing).offset(-32)
        }
        subtotalValueLabel.text = "$0.00"
        subtotalValueLabel.font = Utils.font(ofSize: 16)
        subtotalValueLabel.textAlignment = .right

        scrollView.addSubview(subtotalDivider)
        subtotalDivider.snp.makeConstraints { make in
            make.top.equalTo(subtotalLabel.snp.bottom).offset(9)
            make.height.equalTo(1)
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
        }
        subtotalDivider.backgroundColor = .separator

        scrollView.addSubview(salesTaxLabel)
        salesTaxLabel.snp.makeConstraints { make in
            make.top.equalTo(subtotalDivider.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(checkoutLabel.snp.centerX)
        }
        salesTaxLabel.text = NSLocalizedString("CheckoutSalesTaxLabel", comment: "")
        salesTaxLabel.font = Utils.boldFont(ofSize: 16)
        salesTaxLabel.textAlignment = .left

        scrollView.addSubview(salesTaxValueLabel)
        salesTaxValueLabel.snp.makeConstraints { make in
            make.top.equalTo(subtotalDivider.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalTo(checkoutLabel.snp.centerX)
            make.trailing.equalTo(self.view.snp.trailing).offset(-32)
        }
        salesTaxValueLabel.text = "$0.00"
        salesTaxValueLabel.font = Utils.font(ofSize: 16)
        salesTaxValueLabel.textAlignment = .right

        scrollView.addSubview(salesTaxDivider)
        salesTaxDivider.snp.makeConstraints { make in
            make.top.equalTo(salesTaxLabel.snp.bottom).offset(9)
            make.height.equalTo(1)
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
        }
        salesTaxDivider.backgroundColor = .separator

        scrollView.addSubview(shippingCostLabel)
        shippingCostLabel.snp.makeConstraints { make in
            make.top.equalTo(salesTaxDivider.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(checkoutLabel.snp.centerX)
        }
        shippingCostLabel.text = NSLocalizedString("CheckoutShippingLabel", comment: "")
        shippingCostLabel.font = Utils.boldFont(ofSize: 16)
        shippingCostLabel.textAlignment = .left

        scrollView.addSubview(shippingCostValueLabel)
        shippingCostValueLabel.snp.makeConstraints { make in
            make.top.equalTo(salesTaxDivider.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalTo(checkoutLabel.snp.centerX)
            make.trailing.equalTo(self.view.snp.trailing).offset(-32)
        }
        shippingCostValueLabel.text = "$0.00"
        shippingCostValueLabel.font = Utils.font(ofSize: 16)
        shippingCostValueLabel.textAlignment = .right

        scrollView.addSubview(shippingCostDivider)
        shippingCostDivider.snp.makeConstraints { make in
            make.top.equalTo(shippingCostLabel.snp.bottom).offset(9)
            make.height.equalTo(1)
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
        }
        shippingCostDivider.backgroundColor = .separator

        scrollView.addSubview(grandTotalLabel)
        grandTotalLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingCostDivider.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(checkoutLabel.snp.centerX)
        }
        grandTotalLabel.text = NSLocalizedString("CheckoutGrandTotalLabel", comment: "")
        grandTotalLabel.font = Utils.boldFont(ofSize: 16)
        grandTotalLabel.textAlignment = .left

        scrollView.addSubview(grandTotalValueLabel)
        grandTotalValueLabel.snp.makeConstraints { make in
            make.top.equalTo(shippingCostDivider.snp.bottom).offset(14)
            make.height.equalTo(24)
            make.leading.equalTo(checkoutLabel.snp.centerX)
            make.trailing.equalTo(self.view.snp.trailing).offset(-32)
        }
        grandTotalValueLabel.text = "$0.00"
        grandTotalValueLabel.font = Utils.font(ofSize: 16)
        grandTotalValueLabel.textAlignment = .right

        scrollView.addSubview(grandTotalDivider)
        grandTotalDivider.snp.makeConstraints { make in
            make.top.equalTo(grandTotalLabel.snp.bottom).offset(9)
            make.height.equalTo(1)
            make.leading.equalTo(self.view.snp.leading).offset(32)
            make.trailing.equalTo(self.view.snp.trailing).offset(-16)
        }
        grandTotalDivider.backgroundColor = .separator

        scrollView.addSubview(grandTotalHighlight)
        grandTotalHighlight.snp.makeConstraints { make in
            make.top.equalTo(shippingCostDivider.snp.bottom)
            make.bottom.equalTo(grandTotalDivider.snp.top)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
        }
        grandTotalHighlight.backgroundColor = .separator
        scrollView.sendSubviewToBack(grandTotalHighlight)

        scrollView.addSubview(placeOrderButton)
        placeOrderButton.snp.makeConstraints { make in
            make.top.equalTo(grandTotalDivider.snp.bottom).offset(38)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
            make.height.equalTo(50)
        }
        placeOrderButton.setTitle(NSLocalizedString("CheckoutCTA", comment: ""), for: .normal)
        placeOrderButton.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)
        placeOrderButton.backgroundColor = UIColor(red: 64/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0)
        placeOrderButton.layer.cornerRadius = 8
        placeOrderButton.titleLabel?.font = Utils.font(ofSize: 16)

        scrollView.addSubview(placeOrderDisclaimerLabel)
        placeOrderDisclaimerLabel.snp.makeConstraints { make in
            make.top.equalTo(placeOrderButton.snp.bottom)
            make.leading.equalTo(checkoutLabel.snp.leading)
            make.trailing.equalTo(checkoutLabel.snp.trailing)
            make.height.equalTo(50)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        placeOrderDisclaimerLabel.text = NSLocalizedString("CheckoutDemoOnly", comment: "")
        placeOrderDisclaimerLabel.font = Utils.font(ofSize: 12)
        placeOrderDisclaimerLabel.textAlignment = .center
        placeOrderDisclaimerLabel.textColor = .secondaryLabel

        calculateCosts()

        MParticle.sharedInstance().logScreen("Checkout", eventInfo: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.cart.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartTableCell: CartTableCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.reuseId) as? CartTableCell {
            cartTableCell = cell
        } else {
            cartTableCell = CartTableCell(style: .default, reuseIdentifier: CartTableCell.reuseId)
        }
        cartTableCell.cartItem = AppDelegate.cart.items[indexPath.row]
        return cartTableCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let removedItem = AppDelegate.cart.items.remove(at: indexPath.row)
        let detailView = ProductDetailViewController(product: removedItem.product)
        detailView.hidesBottomBarWhenPushed = true
        calculateCosts()
        cartTableView.reloadData()
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
        let taxTotal = subtotal * 0.08875
        let shippingTotal = subtotal * 0.15

        subtotalValueLabel.text = "$" + String(format: "%.2f", subtotal)
        salesTaxValueLabel.text = "$" + String(format: "%.2f", taxTotal)
        shippingCostValueLabel.text = "$" + String(format: "%.2f", shippingTotal)
        grandTotalValueLabel.text = "$" + String(format: "%.2f", subtotal + taxTotal + shippingTotal)
        placeOrderButton.isEnabled = subtotal != 0
    }

    @objc private func placeOrder() {
        print("place order")
        if let event = MPCommerceEvent(action: .purchase) {
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
            transactionAttributes.transactionId = AppDelegate.transactionId
            let tax = subtotal * 0.08875
            let shipping = subtotal * 0.15
            transactionAttributes.tax = NSNumber(value: Double(String(format: "%.2f", tax)) ?? 0)
            transactionAttributes.shipping = NSNumber(value: Double(String(format: "%.2f", shipping)) ?? 0)
            transactionAttributes.revenue = NSNumber(value: Double(String(format: "%.2f", subtotal + tax + shipping)) ?? 0)
            event.transactionAttributes = transactionAttributes // transaction attributes are required
            event.shouldBeginSession = AppDelegate.eventsBeginSessions
            MParticle.sharedInstance().logEvent(event)

            // Clear the cart
            AppDelegate.cart.items.removeAll()

            // Present Purchase Confirmation
            let purchaseMessage = UIAlertController(title: NSLocalizedString("Purchase Complete", comment: ""), message: NSLocalizedString("No actual purchase has been made.", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
             })
            purchaseMessage.addAction(okAction)
            self.present(purchaseMessage, animated: true, completion: nil)
        }
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        streetAddressTextbox.textBoxField.resignFirstResponder()
        cityTextbox.textBoxField.resignFirstResponder()
        stateTextbox.textBoxField.resignFirstResponder()
        zipTextbox.textBoxField.resignFirstResponder()
        creditCardTextbox.textBoxField.resignFirstResponder()
        expirationTextbox.textBoxField.resignFirstResponder()
        cardVerificationTextbox.textBoxField.resignFirstResponder()
        return true
    }
}
