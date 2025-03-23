//
//  Untitled.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 23/03/25.
//

import SwiftUI

@MainActor
class TodaysTagViewModel: ObservableObject {
    @Published var loadedTags: [String] = []
    @Published var dailyWordsLoading: Bool = false

    let userDefaultsKey = "SavedDailyTags"
    let lastFetchedDateKey = "LastFetchedDate"

    init() {
        lookDailyTag()
    }

    func lookDailyTag() {
        let today = formattedDate(Date())

        let lastFetchedDate = UserDefaults.standard.string(forKey: lastFetchedDateKey)
        if lastFetchedDate == today, let savedTags = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            self.loadedTags = savedTags
            return
        }

        dailyWordsLoading = true
        let word = DailyWordManager.shared.fetchDailyWord()

        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.lookKey(requiredType: "tags", word: word), decodeTo: KeyModel.self)
                DispatchQueue.main.async {
                    if let newKeys = response.data.data {
                        self.loadedTags = newKeys
                        UserDefaults.standard.set(newKeys, forKey: self.userDefaultsKey)
                        UserDefaults.standard.set(today, forKey: self.lastFetchedDateKey)
                    } else {
                        Utils.notificationFeedback(.error)
                    }
                    self.dailyWordsLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.dailyWordsLoading = false
                    Utils.notificationFeedback(.error)
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
