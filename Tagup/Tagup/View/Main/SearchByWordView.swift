//
//  SearchByWordView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct SearchByWordView: View {
    
    @StateObject var viewModel = SearchViewModel()
    
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
        .navigationDestination(isPresented: $viewModel.showResult) {
            SearchResultView(viewModel: viewModel)
        }
        .onTapGesture {
            Utils.shared.dismissKeyBoard()
        }
    }
    
    @ViewBuilder func SearchTextField() -> some View {
        HStack {
            TextField("Enter keyword", text: $viewModel.tag)
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
                if viewModel.tag != "" {
                    viewModel.lookTags()
                }
            } label: {
                if viewModel.lookTagsLoading {
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
}

