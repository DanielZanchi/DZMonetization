import Foundation

public class DZMonetization {
    
    public static let shared = DZMonetization()
    
    private var sharedKey: String?
    private var subscriptionIdentifiers: Set<String>?
	private var purchaseIdentifiers: Set<String>?
    private var appName: String?
    private var priceForTerms: String?

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
    
    public func startInAppPurchase() {
        InAppPuchase.shared.completeTransactions()
        InAppPuchase.shared.restorePurchases {}
    }
    
    public func restore(completion: (() -> Void)? = nil) {
        InAppPuchase.shared.restorePurchases {completion?()}
    }
    
    public func retrieveInfo(completion: @escaping (() -> ())) {
        InAppPuchase.shared.retrieveInfo { _ in
            completion()
        }
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
