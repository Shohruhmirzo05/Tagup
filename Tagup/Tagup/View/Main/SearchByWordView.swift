//
//  SearchByWordView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct KeyModel: Codable {
    let data: [String]?
}

@MainActor
class SearchByWordViewModel: ObservableObject {
    @Published var key: String = ""
    @Published var image: UIImage? = nil
    
    @Published var selectedKeys: [String] = []
    @Published var loadedKeys: [String] = []
    
    @Published var lookKeysLoading: Bool = false
    @Published var imageLoading: Bool = false
    @Published var showResult: Bool = false
    @Published var showInsufficientCoin: Bool = false
    @Published var showInsufficientCoinImage: Bool = false
    @Published var showImageSourceActionSheet: Bool = false
    @Published var isImagePickerPresented: Bool = false
    @Published var isCameraPresented: Bool = false
    
    let keywordCost = 15
    let imageCost: Int = 40
    
    func lookKeys() {
        if StoreKitManager.shared.getCurrentCoins() < keywordCost {
            withAnimation {
                showInsufficientCoin = true
                Log.info("coin not enough \(StoreKitManager.shared.getCurrentCoins())")
            }
            return
        }
        
        lookKeysLoading = true
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.lookKey(requiredType: "tags", word: key), decodeTo: KeyModel.self)
                DispatchQueue.main.async {
                    if let newKeys = response.data.data {
                        let existingKeys = Set(self.loadedKeys)
                        let uniqueKeys = Set(newKeys).subtracting(existingKeys)
                        self.loadedKeys.append(contentsOf: uniqueKeys)
                        if !self.loadedKeys.isEmpty {
                            self.showResult = true
                            _ = StoreKitManager.shared.useCoins(cost: 15)
                        }
                    } else {
                        Utils.notificationFeedback(.error)
                    }
                    self.lookKeysLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.lookKeysLoading = false
                    Utils.notificationFeedback(.error)
                }
            }
        }
    }
    
    func lookImageKeys() {
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
                        let existingKeys = Set(self.loadedKeys)
                        let uniqueKeys = Set(newKeys).subtracting(existingKeys)
                        self.loadedKeys.append(contentsOf: uniqueKeys)
                        if !self.loadedKeys.isEmpty {
                            self.showResult = true
                            _ = StoreKitManager.shared.useCoins(cost: 40)
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
    
    func saveSelectedKeysToHistory() {
        let title = loadedKeys.first ?? "Untitled"
        KeychainManager.shared.saveKeywords(title: title, keywords: loadedKeys)
        NotificationCenter.default.post(name: .historyUpdated, object: nil)
    }
    
    func copySelectedKeys() {
        let copiedText = selectedKeys.joined(separator: " ")
        UIPasteboard.general.string = copiedText
    }
    
    func toggleSelectedKeys() {
        Utils.hapticFeedback(style: .light)
        if selectedKeys.isEmpty {
            selectedKeys = loadedKeys
        } else {
            selectedKeys.removeAll()
        }
    }
}

struct SearchByWordView: View {
    
    @StateObject var viewModel = SearchByWordViewModel()
    
    var body: some View {
        VStack(spacing: 22) {
            MainTopView()
                .padding(.bottom, 60)
            Text("Put any keyword to search trending tags")
                .frame(maxWidth: 240)
                .multilineTextAlignment(.center)
            SearchTextField()
            CoinSection()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            TopSafeArea(title: "Tags by Word", color: .safeareaGreen, isBackEnabled: true)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    @ViewBuilder func SearchTextField() -> some View {
        HStack {
            TextField("Enter keyword", text: $viewModel.key)
                .frame(width: 220, height: 38)
                .padding(.horizontal)
                .background {
                    Color.clear
                    HStack(spacing: 23) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1)
                    }
                }
            Button {
                if viewModel.key != "" {
                    viewModel.lookKeys()
                }
            } label: {
                if viewModel.lookKeysLoading {
                    ProgressView()
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: "chevron.forward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.greenLight)
                }
            }
        }
        .padding(.leading, 44)
    }
    
    @ViewBuilder func CoinSection() -> some View {
        Group {
            if viewModel.showInsufficientCoin {
                Text("Oops! You’re out of coins")
                    .font(.system(size: 14))
            } else {
                HStack(spacing: 0) {
                    Text("1 word = ")
                    +
                    Text("30 ")
                        .foregroundStyle(.pinkLight)
                    Image(.mainCoin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
}

#Preview {
    SearchByWordView()
    //    TabbarView()
}

