import UIKit
import SnapKit

final class LabeledTextField: UIView {
    static let reuseId = "CartTableCell"
    
    let textBoxField = UITextField()
    let textBoxLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedLayout()
    }

    private func sharedLayout() {
        self.addSubview(textBoxField)
        textBoxField.snp.makeConstraints { make in
            make.top.equalTo(self).offset(9)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(54)
        }
        textBoxField.isUserInteractionEnabled = true
        textBoxField.textAlignment = .left
        textBoxField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 54))
        textBoxField.leftViewMode = .always
        textBoxField.textColor = .label
        textBoxField.backgroundColor = .systemBackground
        textBoxField.layer.borderColor = UIColor.gray.cgColor
        textBoxField.layer.borderWidth = 1.0
        textBoxField.layer.cornerRadius = 3.5
        textBoxField.returnKeyType = .done
        
        self.addSubview(textBoxLabel)
        textBoxLabel.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(textBoxField.snp.leading).offset(16)
            make.height.equalTo(16)
        }
        textBoxLabel.font = Utils.font(ofSize: 12)
        textBoxLabel.textColor = .secondaryLabel
        textBoxLabel.textAlignment = .center
        textBoxLabel.backgroundColor = .systemBackground
    }
}
