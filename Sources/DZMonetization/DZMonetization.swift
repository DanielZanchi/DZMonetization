import Foundation

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
    
    public func startInAppPurchase() {
        InAppPuchase.shared.completeTransactions()
        InAppPuchase.shared.restorePurchases {}
    }
    
    public func restore() {
        InAppPuchase.shared.restorePurchases {}
    }
    
    public func retrieveInfo(completion: @escaping (() -> ())) {
        InAppPuchase.shared.retrieveInfo { _ in
            completion()
        }
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
