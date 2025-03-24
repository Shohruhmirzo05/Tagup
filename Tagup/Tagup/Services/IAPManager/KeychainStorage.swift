//
//  KeychainStorage.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 05/03/25.
//

import SwiftUI
import KeychainAccess

struct SavedKeywordGroupForKeychain: Codable, Identifiable, Equatable {
    var id = UUID()
    var title: String
    var keywords: [String]
    var date: Date = Date()
    
    static let mock = SavedKeywordGroupForKeychain(
        id: UUID(),
        title: "Mock Group",
        keywords: ["Mock Keyword 1", "Mock Keyword 2"],
        date: Date()
    )
}

class KeychainManager {
    static let shared = KeychainManager()
    
    private let keychain = Keychain(service: "com.hashly.app")
    private let coinsKey = "user_coins"
    private let historyKey = "saved_keyword_groups"
    
    private init() {}
    
    // MARK: - Coins
    
    func saveCoins(_ coins: Int) {
        try? keychain.set(String(coins), key: coinsKey)
    }
    
    func getCoins() -> Int {
        if let coinsString = try? keychain.get(coinsKey), let coins = Int(coinsString) {
            return coins
        } else {
            saveCoins(100)
            return 100
        }
    }
    
    func addCoins(_ amount: Int) {
        let currentCoins = getCoins()
        saveCoins(currentCoins + amount)
    }
    
    func useCoins(_ amount: Int) -> Bool {
        let currentCoins = getCoins()
        guard currentCoins >= amount else {
            return false
        }
        saveCoins(currentCoins - amount)
        NotificationCenter.default.post(name: .coinsUpdated, object: nil)
        return true
    }
    
    // MARK: - Keyword History Management
    
    func saveKeywords(title: String, keywords: [String]) {
        var groups = fetchAllKeywordGroups()
        let newGroup = SavedKeywordGroupForKeychain(title: title, keywords: keywords)
        groups.append(newGroup)
        saveKeywordGroups(groups)
    }
    
    func fetchAllKeywordGroups() -> [SavedKeywordGroupForKeychain] {
        guard let data = try? keychain.getData(historyKey),
              let groups = try? JSONDecoder().decode([SavedKeywordGroupForKeychain].self, from: data) else {
            return []
        }
        return groups
    }
    
    func deleteKeywordGroup(_ group: SavedKeywordGroupForKeychain) {
        var groups = fetchAllKeywordGroups()
        groups.removeAll { $0.id.uuidString == group.id.uuidString }
        saveKeywordGroups(groups)
    }
    
    func deleteKeywordsFromGroup(groupID: UUID, keywordsToDelete: [String]) {
        var groups = fetchAllKeywordGroups()
        
        if let index = groups.firstIndex(where: { $0.id == groupID }) {
            groups[index].keywords.removeAll { keywordsToDelete.contains($0) }
            
            if groups[index].keywords.isEmpty {
                groups.remove(at: index)
            }
            
            saveKeywordGroups(groups)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .historyUpdated, object: nil)
            }
        }
    }
    
    func saveKeywordGroups(_ groups: [SavedKeywordGroupForKeychain]) {
        guard let data = try? JSONEncoder().encode(groups) else { return }
        try? keychain.set(data, key: historyKey)
    }
}
