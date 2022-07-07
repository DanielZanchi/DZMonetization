//
//  InAppPurchase.swift
//
//  Created by Daniel Zanchi on 10/10/21.
//

import Foundation
import StoreKit
import SwiftyStoreKit
import DZDataAnalytics

typealias completionBool = ((Bool) -> Void)?
typealias completionString = ((String) -> Void)?
typealias completionData = ((Data?) -> Void)?
typealias completionVoid = (() -> Void)?

struct InAppPuchase {
    
    static let shared = InAppPuchase()
    static private var productsInfo: [SKProduct]?
    
    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                default: break
                }
            }
        }
    }
    
    func retrieveInfo(completion: completionBool) {
		guard let identifiers = DZMonetization.shared.getSubscriptionIdentifiers() else { return }
        SwiftyStoreKit.retrieveProductsInfo(identifiers) { result in
            let retrievedProducts = result.retrievedProducts
            InAppPuchase.productsInfo = [SKProduct]()
            for product in retrievedProducts {
                InAppPuchase.productsInfo?.append(product)
            }
            
            if retrievedProducts.isEmpty == false {
                completion?(true)
            } else {
                print("There was en error retriving the products: - \(result.error?.localizedDescription ?? "")")
                completion?(false)
            }
        }
    }
    
    func getProduct(fromProductId productId: String, completion: @escaping ((SKProduct) -> Void), errorHandler: @escaping (() -> Void)) {
        if let products = InAppPuchase.productsInfo, !products.isEmpty {
            if let product = products.filter({$0.productIdentifier == productId}).first {
                completion(product)
            }
        } else {
            retrieveInfo { _ in
                if let products = InAppPuchase.productsInfo {
                    if let product = products.filter({$0.productIdentifier == productId}).first {
                        completion(product)
                    }
                } else {
                    errorHandler()
                }
            }
        }
    }
    
    func getPrice(for productId: String, completion: completionString ) {
        func price(fromProducts products: [SKProduct]) {
            if let product = products.filter({$0.productIdentifier == productId}).first,
               let priceString = product.localizedPrice {
                print("Product: \(product.localizedDescription), price: \(priceString)")
                completion?(priceString)
            }
        }
        
        if let products = InAppPuchase.productsInfo, !products.isEmpty {
            price(fromProducts: products)
        } else {
            retrieveInfo { (result) in
                if let products = InAppPuchase.productsInfo {
                    price(fromProducts: products)
                } else {
                    print("error getting price")
                }
            }
        }
    }
    
    func purchaseProduct(withId productId: String, completion: @escaping ((Bool, AdjustSubscriptionObj?) -> Void)) {
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                var originalTransaction = "should initialize"
                
                originalTransaction = purchase.transaction.transactionIdentifier ?? purchase.originalTransaction?.transactionIdentifier ?? ""
                DZAnalytics.setOriginalTransId(originalTransaction)
                
                DZAnalytics.setPremium(true)
                DZAnalytics.didPurchase(product: purchase.product)
                DZMonetization.AppData.shared.setPremium(true)
                
                
                let adjustObj =  AdjustSubscriptionObj(transactionId: purchase.transaction.transactionIdentifier,
                                                       transactionDate: purchase.transaction.transactionDate,
                                                       appStoreReceiptURL: Bundle.main.appStoreReceiptURL,
                                                       price: purchase.product.price,
                                                       countryCode: purchase.product.priceLocale.regionCode,
                                                       currencyCode: purchase.product.priceLocale.currencyCode)
                
                completion(true, adjustObj)
                
            case .deferred(purchase: _):
                DZAnalytics.sendEvent(withName: "ce_purchase_deferred", parameters: [:])
                completion(false, nil)
                
            case .error(let error):
                DZAnalytics.purchaseFlowEvent(.ce_purchase_error, addedParameters: [
                    "errorCode": error.code.rawValue, "errorMessage": error.localizedDescription
                ])
                completion(false, nil)
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    /// This can be used to restore purchases or to check if the previous purchase is expired.
    func restorePurchases(completion: @escaping (() -> Void), errorHandler: @escaping ((DZMonetization.RestoreError) -> Void)) {
        guard let sharedKey = DZMonetization.shared.getSharedKey() else { return }
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true) { result in
            switch result {
            case .success(let receipt):
                
                DZMonetization.AppData.shared.didRefreshReceipt()
                
                DZAnalytics.sendReceiptInfos(receipt)
                
                var isPremium = false
				
				if let purchaseIdentifiers = DZMonetization.shared.getPurchaseIdentifiers() {
					for identifier in purchaseIdentifiers {
						let didRestore = verifyPurchase(receipt: receipt, productId: identifier)
						if didRestore {
                            isPremium = true
							break
						}
					}
				}
				
				if isPremium {
					completion()
					return
				}
                
				if let subsIdentifiers = DZMonetization.shared.getSubscriptionIdentifiers() {
					for identifier in subsIdentifiers {
						let didRestore = verifySubscription(receipt: receipt, productId: identifier)
						if didRestore == true {
							break
						}
					}
				}
                
                completion()
                
            case .error(let error):
                print("Verify receipt failed: \(error)")
                if DZMonetization.AppData.shared.shouldBlockUserWithoutConnection() {
                    errorHandler(.block)
                } else {
                    if DZMonetization.AppData.shared.isPremium() {
                        errorHandler(.pass)
                    } else {
                        errorHandler(.passNotPremium)
                    }
                }
            }
        }
    }
    
    private func verifySubscription(receipt: ReceiptInfo, productId: String) -> Bool {
        let purchaseResult = SwiftyStoreKit.verifySubscription(
            ofType: .autoRenewable,
            productId: productId,
            inReceipt: receipt)
        
        switch purchaseResult {
        case .purchased(let expiryDate, let items):
            if let originalTransactionId = items.first?.originalTransactionId {
                DZAnalytics.setOriginalTransId(originalTransactionId)
            }
            
            print("\(productId) is valid until \(expiryDate)\n\(items)\n")
            if expiryDate > Date() {
                DZMonetization.AppData.shared.setPremium(true)
                DZAnalytics.setPremium(true)
                return true
            }
            DZMonetization.AppData.shared.setPremium(false)
            DZAnalytics.setPremium(false)
            return false
            
        case .expired(let expiryDate, let items):
            if let originalTransactionId = items.first?.originalTransactionId {
                DZAnalytics.setOriginalTransId(originalTransactionId)
            }
            print("\(productId) is expired since \(expiryDate)\n\(items)\n")
            DZMonetization.AppData.shared.setPremium(false)
            DZAnalytics.setPremium(false)
            DZAnalytics.didExpire(productId: productId, expireDate: expiryDate)
            return false
            
        case .notPurchased:
            print("The user has never purchased \(productId)")
            DZMonetization.AppData.shared.setPremium(false)
            DZAnalytics.setPremium(false)
            return false
        }
    }
    
    // TO USE IN APP WHERE WE HAVE ONE TIME LIFETIME PURCHASE
    private func verifyPurchase(receipt: ReceiptInfo, productId: String) -> Bool {
        // Verify the purchase of Consumable or NonConsumable
        let purchaseResult = SwiftyStoreKit.verifyPurchase(
            productId: productId,
            inReceipt: receipt)
        
        switch purchaseResult {
        case .purchased(let receiptItem):
            print("\(productId) is purchased: \(receiptItem)")
            DZMonetization.AppData.shared.setPremium(true)
            DZAnalytics.setPremium(true)
            return true
        case .notPurchased:
            print("The user has never purchased \(productId)")
            DZMonetization.AppData.shared.setPremium(false)
            DZAnalytics.setPremium(false)
            return false
        }
    }
}

public struct AdjustSubscriptionObj {
    public let transactionId: String?
    public let transactionDate: Date?
    public let appStoreReceiptURL: URL?
    public let price: NSDecimalNumber
    public let countryCode: String?
    public let currencyCode: String?
}
