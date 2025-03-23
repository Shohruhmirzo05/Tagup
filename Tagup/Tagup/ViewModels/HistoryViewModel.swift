//
//  HistoryViewModel.swift
//  Hashly-IOS
//
//  Created by Alijonov Shohruhmirzo on 08/03/25.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var keywordGroups: [SavedKeywordGroupForKeychain] = []
    @Published var selectedGroup: SavedKeywordGroupForKeychain?
    @Published var showDetails = false
    @Published var showEditView = false
    @Published var selectedTags: [String] = []
    
    init() {
        loadKeywordGroups()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHistory), name: .historyUpdated, object: nil)
    }
    
    func loadKeywordGroups() {
        DispatchQueue.main.async {
            withAnimation {
                self.keywordGroups = KeychainManager.shared.fetchAllKeywordGroups()
                    .sorted(by: { $0.date > $1.date })
            }
        }
    }
    
    @objc func reloadHistory() {
        loadKeywordGroups()
    }
    
    func deleteKeywordsFromHistory(groupID: UUID, keywords: [String]) {
        KeychainManager.shared.deleteKeywordsFromGroup(groupID: groupID, keywordsToDelete: keywords)
        
        DispatchQueue.main.async {
            let newGroups = KeychainManager.shared.fetchAllKeywordGroups()
            
            if newGroups != self.keywordGroups {
                self.keywordGroups = newGroups
                NotificationCenter.default.post(name: .historyUpdated, object: nil)
            }
        }
    }
}
