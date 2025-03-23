//
//  PacksView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct CoinPrice: Identifiable {
    var id: Int { coin }
    var coin: Int
    var price: Double
    var productID: String
    
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
}

struct PacksView: View {
    
    @State var path = NavigationPath()
    @StateObject var storeKitViewModel = StoreKitViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                MainTopView()
                    .padding(.bottom, 32)
                ForEach(CoinPrice.prices) { coin in
                    Button {
                        if let matchingProduct = storeKitViewModel.products.first(where: { $0.id == coin.productID }) {
                            storeKitViewModel.buyCoins(matchingProduct)
                        } else {
                            storeKitViewModel.requestProducts()
                        }
                    } label: {
                        CoinCard(coin: coin)
                    }
                    .tint(.primary)
                }
            }
            .padding(.horizontal, 8)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top, content: TopArea)
        .allowsHitTesting(!storeKitViewModel.isPurchasing)
        .overlay { LoaderView() }
        .onAppear {
            storeKitViewModel.requestProducts()
        }
        .toolbar(storeKitViewModel.isPurchasing ? .hidden : .automatic, for: .tabBar)
    }
    
    @ViewBuilder func TopArea() -> some View {
        Text("Packs")
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.safeareaYellow)
            .font(.system(size: 24, weight: .semibold))
    }
    
    @ViewBuilder func CoinCard(coin: CoinPrice) -> some View {
        HStack(spacing: 4) {
            Text("\(coin.coin)")
            Image(.mainCoin)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
            Spacer()
            Image(.cardIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 17)
                .padding(.trailing, 8)
            Text("\(coin.price.formatted(.number.precision(.fractionLength(2))))$")
        }
        .frame(maxWidth: .infinity)
        .font(.system(size: 18))
        .padding()
        .padding(.horizontal, 32)
        .background {
            Color.tabBackground
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }
    
    @ViewBuilder func LoaderView() -> some View {
        if storeKitViewModel.isPurchasing {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(2)
        }
    }
}

#Preview {
    PacksView()
}
