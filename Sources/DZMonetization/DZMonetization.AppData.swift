//
//  File.swift
//  
//
//  Created by Daniel Zanchi on 15/03/22.
//

import Foundation
import SwiftKeychainWrapper

public extension DZMonetization {
    
    class AppData {
        
        private enum Keys: String {
            case DZMonetization_isPremium, DZMonetization_didSeeFirstPaywall
        }
        
        public static let shared = AppData()
        private var keychain: KeychainWrapper!
        
        private init() {
            self.keychain = KeychainWrapper(serviceName: "\(Bundle.main.bundleIdentifier ?? "").DZMonetization")
        }
        
        public func didSeeFirstSessionPaywall() {
            keychain.set(true, forKey: Keys.DZMonetization_didSeeFirstPaywall.rawValue)
        }
        
        public func shouldShowFirstSessionPaywall() -> Bool {
            if isPremium() == true { return false }
            if let didSee = keychain.bool(forKey: Keys.DZMonetization_didSeeFirstPaywall.rawValue) {
                return !didSee
            }
            return true
        }
        
        func setPremium(_ isPremium: Bool) {
            keychain.set(isPremium, forKey: Keys.DZMonetization_isPremium.rawValue)
        }
        
        public func isPremium() -> Bool {
            if let isPremium = keychain.bool(forKey: Keys.DZMonetization_isPremium.rawValue) {
                return isPremium
            }
            return false
        }
        
    }
    
}
