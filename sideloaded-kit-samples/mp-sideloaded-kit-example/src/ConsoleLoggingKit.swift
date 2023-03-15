//
//  ConsoleLoggingKit.swift
//  iOSTestApp_Cocoapods_Swift
//
//  Created by Ben Baron on 3/1/23.
//

import Foundation
import mParticle_Apple_SDK

@objc public class ConsoleLoggingKit: NSObject, MPKitProtocol {
    // Not used in sideloaded kits
    public static func kitCode() -> NSNumber { -1 }
    
    // Must be true to receive callbacks, can set to true later after any needed initialization is performed
    public var started: Bool = true
    
    public var sideloadedKitCode: NSNumber = 0
    
    public var kitApi: MPKitAPI?
    
    public func didFinishLaunching(withConfiguration configuration: [AnyHashable : Any]) -> MPKitExecStatus {
        print("[ConsoleLoggingKit] didFinishLaunching, configuration: \(configuration), kitApi: \(String(describing: kitApi))")
        return MPKitExecStatus(sdkCode: sideloadedKitCode, returnCode: .success)
    }
    
    public func didBecomeActive() -> MPKitExecStatus {
        print("[ConsoleLoggingKit] didBecomeActive")
        return MPKitExecStatus(sdkCode: sideloadedKitCode, returnCode: .success)
    }
    
    public func beginSession() -> MPKitExecStatus {
        print("[ConsoleLoggingKit] beginSession")
        return MPKitExecStatus(sdkCode: sideloadedKitCode, returnCode: .success)
    }
    
    public func endSession() -> MPKitExecStatus {
        print("[ConsoleLoggingKit] endSession")
        return MPKitExecStatus(sdkCode: sideloadedKitCode, returnCode: .success)
    }
    
    public func logBaseEvent(_ event: MPBaseEvent) -> MPKitExecStatus {
        print("[ConsoleLoggingKit] logBaseEvent")
        return MPKitExecStatus(sdkCode: sideloadedKitCode, returnCode: .success)
    }
}
