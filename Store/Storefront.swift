import StoreKit
import SwiftUI

public class Storefront: ObservableObject {
    enum StoreType {
        case preview
        case production
    }
    
    var store: Storable
    let goProId = "com.BagCheck.PurchasePro.GoPro"
    @Published var isPro = false
    @Published var product: Productable? = nil
    
    
    init(type: StoreType) {
        switch type {
        case .preview:
            store = PreviewStore()
        case .production:
            store = Store(productIds: [goProId])
        }
        
        Task {
            await store.requestProducts()
            if try await store.isPurchased(goProId) {
                isPro = true
            }
            product = store.nonconsumableProducts.first
        }
    }
    
    @MainActor
    func purchasePro() {
        Task {
            isPro = try await store.purchase(product)
        }
    }
    
    func purchasedIdentifiersUpdated(_ ids: Set<String>) {
        isPro = ids.contains(goProId)
    }
    
}
