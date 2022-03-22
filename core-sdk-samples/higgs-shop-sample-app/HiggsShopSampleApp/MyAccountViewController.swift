import UIKit
import SnapKit
import mParticle_Apple_SDK

final class MyAccountViewController: UIViewController, UITextFieldDelegate {
    let myAccountLabel = UILabel()
    
    let myAccountValueTextbox = LabeledTextField()
    let signInButton = UIButton()
    
    let signedInLabel = UILabel()
    let signedInUserLabel = UILabel()
    let signOutButton = UIButton()
    
    let disclaimerLabel = UILabel()
    
    override func viewDidLoad() {
        MParticle.sharedInstance().logScreen("My Account", eventInfo: nil)
        
        view.accessibilityLabel = "MyAccountView"
        
        view.addSubview(myAccountLabel)
        view.addSubview(myAccountValueTextbox)
        view.addSubview(signInButton)
        view.addSubview(signedInLabel)
        view.addSubview(signedInUserLabel)
        view.addSubview(signOutButton)
        view.addSubview(disclaimerLabel)
        toggleVisibility(isSignedIn: false)
        
        myAccountLabel.accessibilityLabel = "MyAccountTitle"
        myAccountLabel.text = NSLocalizedString("MyAccountTitle", comment: "")
        myAccountLabel.font = Utils.boldFont(ofSize: 24)
        myAccountLabel.textColor = .label
        myAccountLabel.textAlignment = .center
        myAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(43)
            make.leading.equalTo(self.view).offset(32)
            make.trailing.equalTo(self.view).offset(-32)
            make.height.equalTo(24)
        }
        
        myAccountValueTextbox.accessibilityLabel = "MyAccountUserIdDefault"
        myAccountValueTextbox.isUserInteractionEnabled = true
        myAccountValueTextbox.textBoxField.text = NSLocalizedString("MyAccountUserIdDefault", comment: "")
        myAccountValueTextbox.textBoxField.delegate = self
        myAccountValueTextbox.textBoxLabel.text = NSLocalizedString("MyAccountUserIdLabel", comment: "")
        myAccountValueTextbox.isUserInteractionEnabled = true
        myAccountValueTextbox.snp.makeConstraints { make in
            make.top.equalTo(myAccountLabel.snp.bottom).offset(55)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(63)
        }
        
        signInButton.accessibilityLabel = "MyAccountCTAUnselected"
        signInButton.setTitle(NSLocalizedString("MyAccountCTAUnselected", comment: ""), for: .normal)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.backgroundColor = UIColor(red: 64/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0)
        signInButton.layer.cornerRadius = 8
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(myAccountValueTextbox.snp.bottom).offset(40)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(52)
        }
        
        signedInLabel.accessibilityLabel = "MyAccountYouAreSignedInAs"
        signedInLabel.font = Utils.boldFont(ofSize: 18)
        signedInLabel.textAlignment = .center
        signedInLabel.textColor = .label
        signedInLabel.text = NSLocalizedString("MyAccountYouAreSignedInAs", comment: "")
        signedInLabel.snp.makeConstraints { make in
            make.top.equalTo(myAccountValueTextbox.snp.top)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
        
        signedInUserLabel.accessibilityLabel = "MyAccountSignedInUserLabel"
        signedInUserLabel.font = Utils.boldFont(ofSize: 18)
        signedInUserLabel.textAlignment = .center
        signedInUserLabel.textColor = .secondaryLabel
        signedInUserLabel.snp.makeConstraints { make in
            make.top.equalTo(signedInLabel.snp.bottom).offset(6)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        signOutButton.accessibilityLabel = "MyAccountCTASelected"
        signOutButton.setTitle(NSLocalizedString("MyAccountCTASelected", comment: ""), for: .normal)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        signOutButton.backgroundColor = UIColor(red: 64/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0)
        signOutButton.layer.cornerRadius = 8
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(myAccountValueTextbox.snp.bottom).offset(40)
            make.leading.equalTo(self.view).offset(16)
            make.trailing.equalTo(self.view).offset(-16)
            make.height.equalTo(52)
        }
        
        disclaimerLabel.accessibilityLabel = "DetailDemoOnly"
        disclaimerLabel.text = NSLocalizedString("DetailDemoOnly", comment: "")
        disclaimerLabel.textColor = .secondaryLabel
        disclaimerLabel.font = Utils.font(ofSize: 12)
        disclaimerLabel.snp.makeConstraints { make in
            make.top.equalTo(signOutButton.snp.bottom).offset(29)
            make.centerX.equalToSuperview()
        }
    }
    
    private func toggleVisibility(isSignedIn: Bool) {
        if isSignedIn {
            myAccountValueTextbox.isHidden = true
            signInButton.isHidden = true
            signedInLabel.isHidden = false
            signedInUserLabel.isHidden = false
            signOutButton.isHidden = false
            signedInUserLabel.text = myAccountValueTextbox.textBoxField.text
            signedInUserLabel.accessibilityValue = signedInUserLabel.text
        } else {
            myAccountValueTextbox.isHidden = false
            signInButton.isHidden = false
            signedInLabel.isHidden = true
            signedInUserLabel.isHidden = true
            signOutButton.isHidden = true
        }
    }
    
    @objc private func signIn() {
        myAccountValueTextbox.textBoxField.resignFirstResponder()
        toggleVisibility(isSignedIn: true)
        let loginRequest = MPIdentityApiRequest.withEmptyUser()
        loginRequest.email = myAccountValueTextbox.textBoxField.text
        
        MParticle.sharedInstance().identity.login(loginRequest) { result, error in
            print("Login request complete - result=\(String(describing: result)) error=\(String(describing: error))")
        }
    }
    
    @objc private func signOut() {
        toggleVisibility(isSignedIn: false)
        MParticle.sharedInstance().identity.logout { result, error in
            print("Logout request complete - result=\(String(describing: result)) error=\(String(describing: error))")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         myAccountValueTextbox.textBoxField.resignFirstResponder()
        return true
    }
}
