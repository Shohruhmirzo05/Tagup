//
//  StoreKitManager.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 06/03/25.
//

import StoreKit
import SwiftUI

class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    
    @Published var products: [Product] = []
    @Published var purchasedIdentifiers: Set<String> = []
    @Published var isLoading = false
    
    static let prices: [CoinPrice] = [
        .init(coin: 50, price: 0.99, productID: "tagup.coins.50"),
        .init(coin: 100, price: 1.99, productID: "tagup.coins.100"),
        .init(coin: 200, price: 3.99, productID: "tagup.coins.200"),
        .init(coin: 500, price: 7.99, productID: "tagup.coins.500"),
        .init(coin: 1000, price: 13.99, productID: "tagup.coins.1000"),
        .init(coin: 3000, price: 19.99, productID: "tagup.coins.3000"),
        .init(coin: 9000, price: 29.99, productID: "tagup.coins.9000"),
        .init(coin: 15000, price: 49.99, productID: "tagup.coins.15000"),
        .init(coin: 30000, price: 79.99, productID: "tagup.coins.30000"),
    ]
    
    let coinProductIDs = [
        "tagup.coins.50",
        "tagup.coins.100",
        "tagup.coins.200",
        "tagup.coins.500",
        "tagup.coins.1000",
        "tagup.coins.3000",
        "tagup.coins.9000",
        "tagup.coins.15000",
        "tagup.coins.30000"
    ]
    
    let coinAmounts: [String: Int] = [
        "tagup.coins.50": 50,
        "tagup.coins.100": 100,
        "tagup.coins.200": 200,
        "tagup.coins.500": 500,
        "tagup.coins.1000": 1000,
        "tagup.coins.3000": 3000,
        "tagup.coins.9000": 9000,
        "tagup.coins.15000": 15000,
        "tagup.coins.30000": 30000
    ]
    
    var updateListenerTask: Task<Void, Error>?
    
    init() {
        updateListenerTask = listenForTransactions()
        Task { await updatePurchasedProducts() }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch {
                    Log.error("Transaction failed verification: \(error)")
                }
            }
        }
    }
    
    @MainActor func requestProducts() async {
        isLoading = true
        do {
            products = try await Product.products(for: coinProductIDs)
            Log.info("Products loaded: \(products.map { $0.displayName })")
        } catch {
            Log.error("Failed to load products: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    @MainActor func purchase(_ product: Product) async -> Bool {
        isLoading = true
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                
                if let coinsToAdd = coinAmounts[product.id] {
                    await addCoins(coinsToAdd)
                    Log.info("added coins supposed to be \(coinsToAdd)")
                }
                
                await transaction.finish()
                await updatePurchasedProducts()
                Log.info("Purchase successful for \(product.displayName)")
                isLoading = false
                return true
                
            case .userCancelled:
                Log.warning("Purchase cancelled")
                isLoading = false
                return false
                
            case .pending:
                Log.info("Purchase pending")
                isLoading = false
                return false
                
            default:
                Log.error("Unexpected purchase result")
                isLoading = false
                return false
            }
        } catch {
            Log.error("Purchase failed: \(error.localizedDescription)")
            isLoading = false
            return false
        }
    }
    
    @MainActor
    func addCoins(_ amount: Int) async {
        Log.info("Adding \(amount) coins...")
        KeychainManager.shared.addCoins(amount)
        let updatedCoins = KeychainManager.shared.getCoins()
        Log.info("Updated coin balance: \(updatedCoins)")
        NotificationCenter.default.post(name: .coinsUpdated, object: nil)
    }
    
    @MainActor
    func useCoins(cost: Int) -> Bool {
        let success = KeychainManager.shared.useCoins(cost)
        if success {
            NotificationCenter.default.post(name: .coinsUpdated, object: nil)
        }
        return success
    }
    
    func getCurrentCoins() -> Int {
        return KeychainManager.shared.getCoins()
    }
    
    @MainActor
    func restorePurchases() async {
        isLoading = true
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            Log.error("Failed to restore purchases: \(error)")
        }
        isLoading = false
    }
    
    @MainActor
    func updatePurchasedProducts() async {
        purchasedIdentifiers.removeAll()
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.revocationDate == nil {
                    purchasedIdentifiers.insert(transaction.productID)
                }
            } catch {
                Log.error("Transaction failed verification: \(error)")
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    enum StoreError: Error {
        case failedVerification
    }
}
