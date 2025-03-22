//
//  PaywalViewModel.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 05/03/25.
//

import SwiftUI
import StoreKit

@MainActor
class StoreKitViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var purchaseSuccess = false
    @Published var coins: Int = 0
    @Published var isPurchasing: Bool = false
    
    private let storeKitManager = StoreKitManager.shared
    
    init() {
        loadCoins()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCoins),
            name: .coinsUpdated,
            object: nil
        )
    }
    
    func requestProducts() {
        isLoading = true
        Task {
            await storeKitManager.requestProducts()
            DispatchQueue.main.async {
                self.products = self.storeKitManager.products
                self.isLoading = false
            }
        }
    }
    
    func buyCoins(_ product: Product) {
        isPurchasing = true
        Log.info("Attempting to purchase: \(product.id)")
        Task {
            self.isLoading = true
            let success = await storeKitManager.purchase(product)
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.purchaseSuccess = success
                
                if success {
                    self.updateCoins()
                } else {
                    self.errorMessage = "Purchase could not be completed. Please try again."
                    self.showError = true
                }
            }
            DispatchQueue.main.async {
                self.isPurchasing = false
            }
        }
    }
    
    func restorePurchases() {
        Task {
            self.isLoading = true
            await storeKitManager.restorePurchases()
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.updateCoins()
            }
        }
    }
    
    func getCurrentCoins() -> Int {
        return storeKitManager.getCurrentCoins()
    }
    
    func loadCoins() {
        coins = storeKitManager.getCurrentCoins()
    }
    
    @objc func updateCoins() {
        coins = storeKitManager.getCurrentCoins()
    }
}
