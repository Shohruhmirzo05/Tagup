//
//  SearchViewModel.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 23/03/25.
//

import SwiftUI

struct KeyModel: Codable {
    let data: [String]?
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var tag: String = ""
    @Published var image: UIImage? = nil
    @Published var loadedTags: [String] = []
    
    @Published var lookTagsLoading: Bool = false
    @Published var imageLoading: Bool = false
    @Published var showResult: Bool = false
    @Published var showInsufficientCoin: Bool = false
    @Published var showInsufficientCoinImage: Bool = false
    @Published var showImageSourceActionSheet: Bool = false
    @Published var isImagePickerPresented: Bool = false
    @Published var isCameraPresented: Bool = false
    
    let keywordCost = 30
    let imageCost: Int = 50
    
    func lookTags() {
        if StoreKitManager.shared.getCurrentCoins() < keywordCost {
            withAnimation {
                showInsufficientCoin = true
                Log.info("coin not enough \(StoreKitManager.shared.getCurrentCoins())")
            }
            return
        }
        
        lookTagsLoading = true
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.lookKey(requiredType: "tags", word: tag), decodeTo: KeyModel.self)
                DispatchQueue.main.async {
                    if let newKeys = response.data.data {
                        let existingKeys = Set(self.loadedTags)
                        let uniqueKeys = Set(newKeys).subtracting(existingKeys)
                        self.loadedTags.append(contentsOf: uniqueKeys)
                        if !self.loadedTags.isEmpty {
                            self.showResult = true
                            _ = StoreKitManager.shared.useCoins(cost: self.keywordCost)
                            self.saveTagsToHistory()
                        }
                    } else {
                        Utils.notificationFeedback(.error)
                    }
                    self.lookTagsLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.lookTagsLoading = false
                    Utils.notificationFeedback(.error)
                }
            }
        }
    }
    
    func lookImageTags() {
        if StoreKitManager.shared.getCurrentCoins() < imageCost {
            withAnimation {
                showInsufficientCoinImage = true
                Log.info("coin not enough \(StoreKitManager.shared.getCurrentCoins())")
            }
            return
        }
        
        imageLoading = true
        let imageData = convertImageToBase64(image ?? UIImage()) ?? ""
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.lookImage(requiredType: "image_tags", imageData: imageData), decodeTo: KeyModel.self)
                DispatchQueue.main.async {
                    if let newKeys = response.data.data {
                        let existingKeys = Set(self.loadedTags)
                        let uniqueKeys = Set(newKeys).subtracting(existingKeys)
                        self.loadedTags.append(contentsOf: uniqueKeys)
                        if !self.loadedTags.isEmpty {
                            self.showResult = true
                            _ = StoreKitManager.shared.useCoins(cost: self.imageCost)
                            self.saveTagsToHistory()
                        }
                    } else {
                        Utils.notificationFeedback(.error)
                    }
                    self.imageLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.imageLoading = false
                    Utils.notificationFeedback(.error)
                }
            }
        }
    }
    
    func convertImageToBase64(_ image: UIImage) -> String? {
        guard let compressedData = image.jpegData(compressionQuality: 0.2) else { return nil }
        return compressedData.base64EncodedString()
    }
    
    func saveTagsToHistory() {
        let title = loadedTags.first ?? "Untitled"
        KeychainManager.shared.saveKeywords(title: title, keywords: loadedTags)
        NotificationCenter.default.post(name: .historyUpdated, object: nil)
    }
    
    func copyLoadedTags() {
        let copiedText = loadedTags.joined(separator: " ")
        UIPasteboard.general.string = copiedText
    }
}
