import UIKit
import SnapKit

final class CartTableCell: UITableViewCell {
    static let reuseId = "CartTableCell"

    let productImageView = UIImageView()
    let productNameLabel = UILabel()
    let productDetailLabel = UILabel()
    let productPriceLabel = UILabel()
    let removeProductButton = UIButton()

    var cartItem: CartItem? {
        didSet {
            if let cartItem = cartItem {
                productImageView.image = cartItem.product.image
                productNameLabel.text = cartItem.product.label
                productDetailLabel.text = "Qty: \(cartItem.quantity)"
                if cartItem.color != "N/A" {
                    productDetailLabel.text! += " Color: \(cartItem.color)"
                }
                if cartItem.size != "N/A" {
                    productDetailLabel.text! += " Size: \(cartItem.size)"
                }
                productPriceLabel.text = "$" + String(format: "%.2f", cartItem.product.price)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        productImageView.accessibilityIdentifier = "CartCellProductImageView"
        productImageView.contentMode = .scaleAspectFill
        addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
            make.width.equalTo(100)
        }

        productNameLabel.accessibilityIdentifier = "CartCellProductNameLabel"
        productNameLabel.textColor = .label
        productNameLabel.font = Utils.font(ofSize: 16)
        productNameLabel.textAlignment = .left
        addSubview(productNameLabel)
        addSubview(productPriceLabel)
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.height.equalTo(24).priority(.high)
            make.trailing.equalTo(productPriceLabel.snp.leading).offset(-5)
        }

        productPriceLabel.accessibilityIdentifier = "CartCellProductPriceLabel"
        productPriceLabel.textColor = .label
        productPriceLabel.font = Utils.font(ofSize: 15)
        productPriceLabel.textAlignment = .right
        productPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.height.equalTo(16)
        }

        productDetailLabel.accessibilityIdentifier = "CartCellProductDetailLabel"
        productDetailLabel.textColor = .secondaryLabel
        productDetailLabel.font = Utils.font(ofSize: 14)
        productDetailLabel.textAlignment = .left
        addSubview(productDetailLabel)
        productDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(productNameLabel.snp.bottom).offset(-1)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.height.equalTo(20)
        }

        addSubview(removeProductButton)
        removeProductButton.snp.makeConstraints { make in
            make.top.equalTo(productDetailLabel.snp.bottom)
            make.leading.equalTo(productImageView.snp.trailing).offset(20)
            make.height.equalTo(20)
            make.bottom.equalTo(self.snp.bottom).offset(-15)
        }
        removeProductButton.setTitle(NSLocalizedString("CartRemoveCTA", comment: ""), for: .normal)
        removeProductButton.setTitleColor(.systemBlue, for: .normal)
        removeProductButton.titleLabel?.font = Utils.font(ofSize: 14)
        removeProductButton.titleLabel?.textAlignment = .left
        removeProductButton.layer.borderWidth = 0
        removeProductButton.contentHorizontalAlignment = .left
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
