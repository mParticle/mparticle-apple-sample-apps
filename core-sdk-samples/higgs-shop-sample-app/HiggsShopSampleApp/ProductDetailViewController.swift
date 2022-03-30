import UIKit
import SnapKit
import mParticle_Apple_SDK

final class ProductDetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let product: Product
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let productImageView = UIImageView()
    let addToCartButton = UIButton(type: .custom)
    let colorPicker = UIPickerView()
    let sizePicker = UIPickerView()
    let quantityPicker = UIPickerView()
    let quantities = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var selectedColor: String
    var selectedSize: String
    var selectedQuantity: Int
    
    init(product: Product) {
        self.product = product
        self.selectedColor = product.variants.colors[0]
        self.selectedSize = product.variants.sizes[0]
        self.selectedQuantity = quantities[0]
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        titleLabel.font = Utils.font(ofSize: 24)
        view.addSubview(titleLabel)
        titleLabel.text = product.label
        titleLabel.snp.makeConstraints { make in
            make.topMargin.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        priceLabel.font = Utils.font(ofSize: 16)
        priceLabel.text = "$" + String(format: "%.2f", product.price)
        view.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        productImageView.image = UIImage(named: product.imageName)
        productImageView.contentMode = .scaleAspectFill
        view.addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(productImageView.snp.width).multipliedBy(0.77)
        }
        
        let pickerStackView = UIStackView()
        pickerStackView.axis = .horizontal
        pickerStackView.distribution = .fillProportionally
        view.addSubview(pickerStackView)
        pickerStackView.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        colorPicker.dataSource = self
        colorPicker.delegate = self
        pickerStackView.addArrangedSubview(colorPicker)
        
        sizePicker.dataSource = self
        sizePicker.delegate = self
        pickerStackView.addArrangedSubview(sizePicker)
        
        quantityPicker.dataSource = self
        quantityPicker.delegate = self
        pickerStackView.addArrangedSubview(quantityPicker)
        
        addToCartButton.accessibilityIdentifier = "DetailCTA"
        addToCartButton.setTitle(NSLocalizedString("DetailCTA", comment: ""), for: .normal)
        addToCartButton.setTitleColor(.label, for: .normal)
        addToCartButton.titleLabel?.font = Utils.font(ofSize: 16)
        addToCartButton.backgroundColor = UIColor(red: 64/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0)
        addToCartButton.layer.cornerRadius = 8
        addToCartButton.addTarget(self, action: #selector(productDetailButtonAction), for: .touchUpInside)
        view.addSubview(addToCartButton)
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(pickerStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        let mpProduct = MPProduct(name: product.label, sku: product.imageName, quantity: NSNumber(value: 1), price: NSNumber(value: product.price))
        let event = MPCommerceEvent(action: .viewDetail, product: mpProduct)
        event.shouldBeginSession = AppDelegate.eventsBeginSessions
        MParticle.sharedInstance().logEvent(event)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel: UILabel
        if let label = view as? UILabel {
            titleLabel = label
        } else {
            titleLabel = UILabel()
            titleLabel.font = Utils.font(ofSize: 15)
            titleLabel.textAlignment = .center
        }
        
        let titleString: String
        switch pickerView {
        case colorPicker:
            titleString = product.variants.colors[row]
        case sizePicker:
            titleString = product.variants.sizes[row]
        case quantityPicker:
            titleString = String(quantities[row])
        default:
            titleString = ""
        }
        titleLabel.text = titleString
        
        return titleLabel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == colorPicker {
            if product.variants.colors.last == "N/A" {
                pickerView.isHidden = true
            }
            return product.variants.colors.count
        } else if pickerView == sizePicker {
            if product.variants.sizes.last == "N/A" {
                pickerView.isHidden = true
            }
            return product.variants.sizes.count
        } else if pickerView == quantityPicker {
            return quantities.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == colorPicker {
            print("selected color: \(product.variants.colors[row])")
            selectedColor = product.variants.colors[row]
        } else if pickerView == sizePicker {
            print("selected size: \(product.variants.sizes[row])")
            selectedSize = product.variants.sizes[row]
        } else if pickerView == quantityPicker {
            print("selected quantity: \(quantities[row])")
            selectedQuantity = quantities[row]
        }
    }
    
    @objc private func productDetailButtonAction() {
        print("Add to cart tapped - color: \(selectedColor) size: \(selectedSize) quantity: \(selectedQuantity)")
        
        let cartItem = CartItem(product: product, quantity: selectedQuantity, totalAmount: Double(selectedQuantity) * product.price, color: selectedColor, size: selectedSize)
        
        let cart = AppDelegate.cart
        cart.items.append(cartItem)
        if let tabBarItem = self.tabBarController?.tabBar.items?.last {
            tabBarItem.badgeValue = "\(cart.items.count)"
        }
        
        let mpProduct = MPProduct(name: product.label, sku: product.imageName, quantity: NSNumber(value: selectedQuantity), price: NSNumber(value: product.price))
        let attributes = NSMutableDictionary()
        if selectedColor != "N/A" {
            attributes.setObject(selectedColor, forKey: NSString("color"))
        }
        if selectedSize != "N/A" {
            attributes.setObject(selectedSize, forKey: NSString("size"))
        }
        mpProduct.setUserDefinedAttributes(attributes)
        let event = MPCommerceEvent(action: .addToCart, product: mpProduct)
        event.shouldBeginSession = AppDelegate.eventsBeginSessions
        MParticle.sharedInstance().logEvent(event)
        
        navigationController?.popViewController(animated: true)
    }
}
