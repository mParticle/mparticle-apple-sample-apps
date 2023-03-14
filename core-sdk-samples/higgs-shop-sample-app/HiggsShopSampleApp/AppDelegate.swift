import UIKit
import mParticle_Apple_SDK
import mp_sideloaded_kit_example

@main
final class AppDelegate: UIResponder, UIApplicationDelegate, MPListenerProtocol {
    static var eventsBeginSessions = false
    static var shouldShowCredsAlert = false
    static var transactionId = ""
    static var cart = Cart()

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: Main implementation

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let listener = parseBool(getConfigInfo("MPARTICLE_LISTENER")) {
            if listener == true {
                MPListenerController.sharedInstance().addSdkListener(self)
            }
        }
        if let options = makeOptions() {
            if let reset = parseBool(getConfigInfo("MPARTICLE_RESET")) {
                if reset == true {
                    MParticle.sharedInstance().reset()
                }
            }
            if let optOut = parseBool(getConfigInfo("MPARTICLE_OPTOUT")) {
                MParticle.sharedInstance().optOut = optOut
            }
            MParticle.sharedInstance().start(with: options)
        } else {
            log("Error: Unable to create mParticle Options object")
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([.font: Utils.font(ofSize: 12)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.font: Utils.font(ofSize: 12)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([.font: Utils.font(ofSize: 12)], for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: Utils.font(ofSize: 12)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: Utils.font(ofSize: 12)], for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: Utils.font(ofSize: 12)], for: .highlighted)
        UINavigationBar.appearance().titleTextAttributes = [.font: Utils.boldFont(ofSize: 24)]

        return true
    }

    func makeOptions() -> MParticleOptions? {
        guard let key = getConfigInfo("MPARTICLE_KEY"),
              let secret = getConfigInfo("MPARTICLE_SECRET") else {
                  AppDelegate.shouldShowCredsAlert = true
                  log("Error: No mParticle key and secret were found")
                  return nil
              }
        if key == "REPLACEME" || secret == "REPLACEME" {
            AppDelegate.shouldShowCredsAlert = true
            if let value = getOverrideConfig("IS_UITEST") {
                if value == "YES" {
                    AppDelegate.shouldShowCredsAlert = false
                }
            }
        }
        let options = MParticleOptions(key: key, secret: secret)
        if let logLevel = parseLogLevel(getConfigInfo("MPARTICLE_LOGLEVEL")) {
            // Log level is set to .none by default--you should use a preprocessor directive to ensure it is only set for your non-App Store build configurations (e.g. Debug, Enterprise distribution, etc)
            #if DEBUG
            options.logLevel = logLevel
            #endif
        }
        options.customLogger = { (message: String) in
            self.log("Custom Higgs Logs - \(message)")
        }
        if let autoTracking = parseBool(getConfigInfo("MPARTICLE_AUTOTRACKING")) {
            if autoTracking == false {
                options.automaticSessionTracking = false
                options.shouldBeginSession = false
                Self.eventsBeginSessions = false
            }
        }
        if let sessionTimeout = parseDouble(getConfigInfo("MPARTICLE_SESSIONTIMEOUT")) {
            options.sessionTimeout = sessionTimeout
        }
        if let proxyDelegate = parseBool(getConfigInfo("MPARTICLE_PROXYDELEGATE")) {
            if proxyDelegate == false {
                // If you are disabling App Delegate proxying, you will need to manually forward certain App Delegate methods.
                // See our docs here: https://docs.mparticle.com/developers/sdk/ios/getting-started/#uiapplication-delegate-proxy
                options.proxyAppDelegate = false
            }
        }
        
        // Sideloaded kits are simply classes that conform to MPKitProtocol and can be used to receive callbacks when various things happen such as events being logged.
        // This example uses a simple implementation that just logs the callbacks to the console, but the data in the callbacks can be used for anything.
        // NOTE: Sideloaded kits are always active regardless of server-side configuration.
        options.sideloadedKits = [ConsoleLoggingKit()]
        
        return options
    }

    func parseLogLevel(_ logLevel: String?) -> MPILogLevel? {
        if let logLevel = logLevel {
            if logLevel == "NONE" {
                return MPILogLevel.none
            } else if logLevel == "ERROR" {
                return  .error
            } else if logLevel == "WARNING" {
                return .warning
            } else if logLevel == "DEBUG" {
                return  .debug
            } else if logLevel == "VERBOSE" {
                return .verbose
            }
        }
        log("Warning: No logLevel was found, defaulting to NONE")
        return nil
    }

    func parseBool(_ value: String?) -> Bool? {
        if value == "YES" {
            return true
        } else if value == "NO" {
            return false
        }
        return nil
    }

    func parseDouble(_ value: String?) -> Double? {
        if let value = value {
            return Double(value)
        }
        return nil
    }

    // These are the default settings for MParticleOptions. Update these with your settings if you're not using a Scheme to define these keys.
    func getDefaultConfig(_ key: String) -> String? {
        if key == "MPARTICLE_LOGLEVEL" {
            return "VERBOSE"
        }
        if key == "MPARTICLE_KEY" {
            return "REPLACEME"
        }
        if key == "MPARTICLE_SECRET" {
            return "REPLACEME"
        }
        if key == "CONFIG_DISABLEOVERRIDE" {
            return "NO" // You can change this to 'YES' to prevent values from the scheme from overriding these values
        }
        return nil
    }
    
    // This code allows us to create predefined Schemes with with different settings and accounts for MParticleOptions. If you would like to use schemes in this way for simulator testing, add these keys as 'Environment Variables' under the 'Arguments' section of the 'Run' tab of the scheme.
    func getOverrideConfig(_ key: String) -> String? {
#if targetEnvironment(simulator)
        return ProcessInfo.processInfo.environment[key]
#else
        return nil
#endif
    }

    func getConfigInfo(_ key: String) -> String? {
        var defaultValue = getDefaultConfig(key)
        var overrideValue = getOverrideConfig(key)
        if defaultValue == "REPLACEME" {
            defaultValue = nil
        }
        if overrideValue == "REPLACEME" {
            overrideValue = nil
        }
        
        var shouldOverride = true
        if let disableOverride = parseBool(getDefaultConfig("CONFIG_DISABLEOVERRIDE")), disableOverride {
            shouldOverride = false
        }
        if !shouldOverride {
            if let defaultValue = defaultValue {
                return defaultValue
            }
            return getDefaultConfig(key)
        }
        if let overrideValue = overrideValue {
            return overrideValue
        }
        if let defaultValue = defaultValue {
            return defaultValue
        }
        return getDefaultConfig(key)
    }

    func loudLog(_ msg: String) {
        log("!!!!!!!!\n\n\(msg)\n\n!!!!!!!!")
    }

    func log(_ msg: String) {
        logRaw(msg)
        if let remoteLogURL = getConfigInfo("CONFIG_REMOTELOGURL") {
            if remoteLogURL == "https://example.com/" {
                return
            }
            sendRemoteLogRequest(msg, remoteLogURL)
        }
    }

    func logRaw(_ msg: String) {
        NSLog(msg)
    }

    func sendRemoteLogRequest(_ msg: String, _ remoteLogURL: String) {
        let json: [String: Any] = ["msg": msg]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: remoteLogURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, error == nil {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    self.logRaw("Info: Messages from remote log server: \(responseJSON)")
                }
            } else {
                self.logRaw("Error: Remote Log request failed: \(error?.localizedDescription ?? "No data")")
                return
            }
        }
        task.resume()
    }

    func listenerLog(_ msg: String) {
        loudLog("[Listener] \(msg)")
    }

    // MARK: MPListenerProtocol

    func onAPICalled(_ apiName: String, stackTrace: [Any], isExternal: Bool, objects: [Any]?) {
        listenerLog("API was called: \(apiName)")
    }

    func onKitConfigReceived(_ kitId: Int32, configuration: [AnyHashable: Any]) {
        listenerLog("Received config for kit=\(kitId): \(configuration)")
    }

    func onSessionUpdated(_ session: MParticleSession?) {
        listenerLog("Session changed to UUID=\(session?.uuid ?? "(none)")")
    }

    func onKitStarted(_ kitId: Int32) {
        listenerLog("Kit started with module id: \(kitId)")
    }

    func onNetworkRequestStarted(_ type: MPEndpoint, url: String, body: NSObject) {
        listenerLog("Network request started with url: \(url)")
    }

    func onEntityStored(_ tableName: MPDatabaseTable, primaryKey: NSNumber, message: String) {
        listenerLog("Storing data to tableName=\(tableName) message: \(message)")
    }

}
