import UIKit
import SnapKit

final class ShopTableCell: UITableViewCell {
    static let reuseId = "ShopTableCell"

    let productImageView = UIImageView()
    let productNameLabel = UILabel()

    var product: Product? {
        didSet {
            productImageView.image = product?.image
            productNameLabel.text = product?.label
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessibilityIdentifier = product?.altText
        productImageView.accessibilityIdentifier = "ShopCellProductImageView"
        productImageView.contentMode = .scaleAspectFill
        addSubview(productImageView)
        productImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(productImageView.snp.width).multipliedBy(0.77)
        }

        let nameContainer = UIView()
        nameContainer.backgroundColor = UIColor(red: 64/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0)
        addSubview(nameContainer)
        nameContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productImageView.snp.bottom)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(56).priority(.medium)
        }

        let arrowImageView = UIImageView(image: UIImage(named: "RightArrow"))
        arrowImageView.accessibilityIdentifier = "ShopCellRightArrowImageView"
        arrowImageView.contentMode = .scaleAspectFill
        nameContainer.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-22)
            make.width.height.equalTo(16)
        }

        productNameLabel.accessibilityIdentifier = "ShopCellProductNameLabel"
        productNameLabel.textColor = .label
        productNameLabel.font = Utils.boldFont(ofSize: 20)
        nameContainer.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
