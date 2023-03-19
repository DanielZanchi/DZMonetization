//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 15/03/22.
//

import Foundation
import SwiftKeychainWrapper
import DZUtilities

public extension DZMonetization {
    
    class AppData {
        
        private enum Keys: String {
            case isPremium, didSeeFirstPaywall, lastRefreshDate
        }
        
        public static let shared = AppData()
        private var keychain: KeychainWrapper!
        private let defaults: UserDefaults!
        
        private init() {
            self.keychain = KeychainWrapper(serviceName: "\(Bundle.main.bundleIdentifier ?? "").DZMonetization")
            self.defaults = UserDefaults(suiteName: "\(Bundle.main.bundleIdentifier ?? "").DZMonetization")
        }
        
        public func didSeeFirstSessionPaywall() {
            defaults.set(true, forKey: Keys.didSeeFirstPaywall.rawValue)
        }
        
        public func shouldShowFirstSessionPaywall() -> Bool {
            if isPremium() == true { return false }
            if let didSee = defaults.object(forKey: Keys.didSeeFirstPaywall.rawValue) as? Bool {
                return !didSee
            }
            return true
        }
        
        func setPremium(_ isPremium: Bool) {
            keychain.set(isPremium, forKey: Keys.isPremium.rawValue)
        }
        
        func didRefreshReceipt() {
            let date = Date().timeIntervalSince1970
            keychain.set(date, forKey: Keys.lastRefreshDate.rawValue)
        }
        
        func shouldBlockUserWithoutConnection() -> Bool {
            if Reachability.isConnectedToNetwork() {
                return false
            } else {
                if let lastRefreshDateDouble = keychain.double(forKey: Keys.lastRefreshDate.rawValue) {
                    let lastRefreshDate = Date(timeIntervalSince1970: lastRefreshDateDouble)
                    if Calendar.current.numberOfDaysBetween(Date(), and: lastRefreshDate) > 6 {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return true
                }
            }
        }
        
        public func isPremium() -> Bool {
            if let isPremium = keychain.bool(forKey: Keys.isPremium.rawValue) {
                return isPremium
            }
            return false
        }
        
        public func resetForTest() {
            #if DEBUG
            keychain.removeAllKeys()
            #endif
        }
        
    }
    
}
