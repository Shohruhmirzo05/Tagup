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
    
    let coinProductIDs = [
        "hashly.coins.40",
        "hashly.coins.90",
        "hashly.coins.180",
        "hashly.coins.360",
        "hashly.coins.720",
        "hashly.coins.1500",
        "hashly.coins.3000",
        "hashly.coins.6000",
        "hashly.coins.10000"
    ]
    
    let coinAmounts: [String: Int] = [
        "hashly.coins.40": 40,
        "hashly.coins.90": 90,
        "hashly.coins.180": 180,
        "hashly.coins.360": 360,
        "hashly.coins.720": 720,
        "hashly.coins.1500": 1500,
        "hashly.coins.3000": 3000,
        "hashly.coins.6000": 6000,
        "hashly.coins.10000": 10000
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
    func useCoins(cost: Int = 15) -> Bool {
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
