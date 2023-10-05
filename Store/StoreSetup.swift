import StoreKit

protocol Storable {
    func requestProducts() async
    var nonconsumableProducts: [Productable] { get }
    /// You could add other products here, consumables, subscriptions, etc.
    @MainActor func purchase(_ product: Productable?) async throws -> Bool
    func isPurchased(_ productIdentifier: String) async throws -> Bool
}

extension Store: Storable {
    var nonconsumableProducts: [Productable] {
        nonConsumables
    }
    
    @MainActor
    func purchase(_ product: Productable?) async throws -> Bool {
        if let product = product as? Product {
            return try await purchase(product) != nil
        }
        
        return false
    }
}

import StoreKit

class PreviewStore: Storable {
    var madePurchase = false
    var nonconsumableProducts: [Productable] =
    [
        PreviewProduct(id: "com.BagCheck.PurchasePro.GoPro", 
                       displayName: "Go Pro for", 
                       displayPrice: "$9.99")
    ]
    
    private var transactions: [Transactionable] = [
        PreviewTransaction(productID: "com.BagCheck.PurchasePro.GoPro"),
    ]
    
    @MainActor
    func purchase(_ product: Productable?) async throws -> Bool {
        guard let product = product else {
            return false
        }
        
        let transaction = transactions.first { 
            $0.productID == product.id
        }
        
        madePurchase = true
        
        return transaction != nil
    }
    
    func requestProducts() async { }
    
    func getProduct(forId id: String) async -> Transactionable? {
        let transaction = transactions.first { 
            $0.productID == id
        }
        
        return transaction
    }
    
    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        return madePurchase
    }
}

struct PreviewProduct: Productable {
    var id: String
    var displayName: String
    var displayPrice: String
}

struct PreviewTransaction: Transactionable {
    var productID: String
}

public protocol Productable {
    var id: String { get }
    var displayName: String { get }
    var displayPrice: String { get }
}

protocol Transactionable {
    var productID: String { get }
}

extension Product: Productable { }
extension Transaction: Transactionable { }
