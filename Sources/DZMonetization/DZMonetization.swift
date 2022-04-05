import Foundation

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
    
    public func restore(completion: (() -> Void)? = nil) {
        InAppPuchase.shared.restorePurchases {completion?()}
    }
    
    public func retrieveInfo(completion: @escaping ((Bool) -> ())) {
		InAppPuchase.shared.retrieveInfo(completion: completion)
    }
	
	public func getPrice(for productId: String, completion: ((String) -> Void)? ) {
		InAppPuchase.shared.getPrice(for: productId, completion: completion)
	}
	
	func purchaseProduct(withId productId: String, completion: ((Bool) -> Void)?) {
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
