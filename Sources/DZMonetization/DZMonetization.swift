import SwiftUI
import SwiftKeychainWrapper

public class DZMonetization {
    
    public static let shared = DZMonetization()
    
    private var sharedKey: String?
    private var identifiers: Set<String>?
    private var appName: String?
    private var priceForTerms: String?

    public init() {
        
    }
    
    public func configure(sharedKey: String,
                          identifiers: Set<String>,
                          appName: String,
                          priceForTerms: String) {
        self.sharedKey = sharedKey
        self.identifiers = identifiers
        self.appName = appName
        self.priceForTerms = priceForTerms
    }
    
    func getIdentifiers() -> Set<String>? {
        return self.identifiers
    }
    
    func getSharedKey() -> String? {
        return self.sharedKey
    }
    
    func getPriceForTersm() -> String? {
        return self.priceForTerms
    }
    
    func getAppName() -> String? {
        return self.appName
    }
}

public extension DZMonetization {
    
    class AppData {
        
        private enum Keys: String {
            case isPremium
        }
        
        public static let shared = AppData()
        private var keychain: KeychainWrapper!
        
        
        private init() {
            self.keychain = KeychainWrapper(serviceName: "\(Bundle.main.bundleIdentifier ?? "").DZMonetization")
        }
        
        func setPremium(_ isPremium: Bool) {
            keychain.set(isPremium, forKey: Keys.isPremium.rawValue)
        }
        
        public func isPremium() -> Bool {
            if let isPremium = keychain.bool(forKey: Keys.isPremium.rawValue) {
                return isPremium
            }
            return false
        }
        
    }
    
}

public extension DZMonetization {
    
    class UI {
        
        static var accent: Color = .clear
        static var paywallBackground: Color = .clear
        static var textColor: Color = .clear
        static var accentGradient: LinearGradient = LinearGradient(colors: [], startPoint: .top, endPoint: .bottom)
        static var enableTrialBoxBackground: Color = .clear

        public static func configure(paywallBackground: Color,
                                     textColor: Color,
                                     accent: Color,
                                     accentTop: Color,
                                     accentBottom: Color) {
            self.paywallBackground = paywallBackground
            self.textColor = textColor
            self.accent = accent
            self.accentGradient = LinearGradient(colors: [
                accentTop, accentBottom
            ], startPoint: .top, endPoint: .bottom)
            
            self.enableTrialBoxBackground = paywallBackground.modified(withAdditionalHue: 0, additionalSaturation: 10, additionalBrightness: -10, additionalAlpha: 0)
        }
        
    }
    
}
