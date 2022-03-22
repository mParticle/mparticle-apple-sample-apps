import UIKit
import SnapKit
import mParticle_Apple_SDK

final class LandingViewController: UIViewController {
    let backgroundImageView = UIImageView()
    let higgsImageView = UIImageView()
    let welcomeLabel = UILabel()
    let storeButton = UIButton(type: .custom)
    let disclaimerLabel = UILabel()
    
    override func viewDidLoad() {
        backgroundImageView.accessibilityIdentifier = "LandingBackgroundImageView"
        backgroundImageView.image = UIImage(named: "BackgroundGradient")
        backgroundImageView.contentMode = .scaleToFill
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        higgsImageView.accessibilityIdentifier = "HiggsWelcomeLogo"
        higgsImageView.image = UIImage(named: "HiggsWelcomeLogo")
        higgsImageView.contentMode = .scaleAspectFit
        view.addSubview(higgsImageView)
        higgsImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.width.height.equalTo(250)
        }
        
        welcomeLabel.accessibilityIdentifier = "WelcomeLabel"
        welcomeLabel.textColor = .label
        welcomeLabel.text = NSLocalizedString("LandingWelcome", comment: "")
        welcomeLabel.numberOfLines = 0
        welcomeLabel.textAlignment = .center
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(higgsImageView.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        storeButton.accessibilityIdentifier = "LandingCTA"
        storeButton.setTitle(NSLocalizedString("LandingCTA", comment: ""), for: .normal)
        storeButton.setTitleColor(.label, for: .normal)
        storeButton.backgroundColor = UIColor(red: 64/255.0, green: 121/255.0, blue: 254/255.0, alpha: 1.0)
        storeButton.layer.cornerRadius = 8
        storeButton.addTarget(self, action: #selector(storeButtonAction), for: .touchUpInside)
        view.addSubview(storeButton)
        storeButton.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(50)
            make.width.equalTo(190)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        disclaimerLabel.accessibilityIdentifier = "DisclaimerLabel"
        disclaimerLabel.textColor = .lightGray
        disclaimerLabel.text = NSLocalizedString("LandingDisclaimer", comment: "")
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.textAlignment = .center
        view.addSubview(disclaimerLabel)
        disclaimerLabel.snp.makeConstraints { make in
            make.top.equalTo(storeButton.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
        }
        MParticle.sharedInstance().logScreen("Landing", eventInfo: nil)
    }
    
    override func viewDidAppear(_ _: Bool) {
        if AppDelegate.shouldShowCredsAlert {
            showCredsAlert()
        }
    }
    
    @objc private func storeButtonAction() {
        if AppDelegate.shouldShowCredsAlert {
            showCredsAlert()
            return
        }
        // Logs an event to signify that the user clicked on a button
        if let event = MPEvent(name: "Landing Button Click", type: .other) {
            event.shouldBeginSession = AppDelegate.eventsBeginSessions
            MParticle.sharedInstance().logEvent(event)
        }
        if let window = view.window {
            window.rootViewController = TabBarController()
        }
    }
    
    private func showCredsAlert() {
        let keysAlertMessage = UIAlertController(title: NSLocalizedString("AlertKeysMissingTitle", comment: ""), message: NSLocalizedString("AlertKeysMissingMessage", comment: ""), preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: NSLocalizedString("AlertKeysMissingDismissLabel", comment: ""), style: .default, handler: { (_) -> Void in
            self.navigationController?.popViewController(animated: true)
            exit(1)
         })
        dismissAction.accessibilityIdentifier = "AlertKeysMissingDismissLabel"
        let docsAction = UIAlertAction(title: NSLocalizedString("AlertKeysMissingDocsLabel", comment: ""), style: .default, handler: { (_) -> Void in
            self.navigationController?.popViewController(animated: true)
            let url = URL(string: NSLocalizedString("AlertKeysMissingDocsURL", comment: ""))
            if let url = url {
                UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey: Any]()) { _ in
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(1)
            }
         })
        keysAlertMessage.addAction(dismissAction)
        keysAlertMessage.addAction(docsAction)
        self.view.addSubview(keysAlertMessage.view)
        self.present(keysAlertMessage, animated: true, completion: nil)
    }
}
