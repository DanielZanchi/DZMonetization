import Foundation
import StoreKit.SKProduct

public class DZMonetization {
	
	public struct ActivePaywallConfiguration {
		let noTrialId: String
		let trialId: String
		let isHardPaywall: Bool
		
		public init(noTrialId: String, trialId: String, isHardPaywall: Bool) {
			self.noTrialId = noTrialId
			self.trialId = trialId
			self.isHardPaywall = isHardPaywall
		}
	}
	
    public static let shared = DZMonetization()
    
    private var sharedKey: String?
    private var subscriptionIdentifiers: Set<String>?
	private var purchaseIdentifiers: Set<String>?
    private var appName: String?
    private var priceForTerms: String?
	var activePaywallConfiguration: ActivePaywallConfiguration!

    public init() {
        
    }
    
    
    /// Configure monetization for retrieve receipt, products, restore products and T&C and Policy views
    /// - Parameters:
    ///   - sharedKey: secred shared key from App Store Connect
    ///   - subscriptionIdentifiers: subscription product identifiers
    ///   - purchaseIdentifiers: in-app purchase product identifiers
    ///   - appName: name of the app
    ///   - priceForTerms: price of the weekl subscription without currency
    public func configure(sharedKey: String,
                          subscriptionIdentifiers: Set<String>,
						  purchaseIdentifiers: Set<String>,
                          appName: String,
                          priceForTerms: String) {
        self.sharedKey = sharedKey
        self.subscriptionIdentifiers = subscriptionIdentifiers
		self.purchaseIdentifiers = purchaseIdentifiers
        self.appName = appName
        self.priceForTerms = priceForTerms
    }
	
	public func configureActivePaywall(_ config: ActivePaywallConfiguration) {
		self.activePaywallConfiguration = config
	}
    
    public func startInAppPurchase() {
        InAppPuchase.shared.completeTransactions()
    }
    
    public enum RestoreError {
        case block, pass, passNotPremium
    }
    
    public func restore(completion: @escaping (() -> Void), errorHandler: @escaping ((RestoreError) -> Void)) {
        InAppPuchase.shared.restorePurchases(completion: completion, errorHandler: errorHandler)
    }
    
    public func restore() {
        InAppPuchase.shared.restorePurchases {
            
        } errorHandler: { _ in
            
        }
    }
    
    public func retrieveInfo(completion: @escaping ((Bool) -> ())) {
		InAppPuchase.shared.retrieveInfo(completion: completion)
    }
	
	public func getPrice(for productId: String, completion: ((String) -> Void)? ) {
		InAppPuchase.shared.getPrice(for: productId, completion: completion)
	}
    
    public func getProduct(for productId: String, completion: @escaping ((SKProduct) -> Void), errorHandler: @escaping (() -> Void)) {
        InAppPuchase.shared.getProduct(fromProductId: productId, completion: completion, errorHandler: errorHandler)
    }
	
	public func purchaseProduct(withId productId: String, completion: @escaping ((Bool, AdjustSubscriptionObj?) -> Void)) {
		InAppPuchase.shared.purchaseProduct(withId: productId, completion: completion)
	}

	func getPurchaseIdentifiers() -> Set<String>? {
		return self.purchaseIdentifiers
	}
    
    func getSubscriptionIdentifiers() -> Set<String>? {
        return self.subscriptionIdentifiers
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
