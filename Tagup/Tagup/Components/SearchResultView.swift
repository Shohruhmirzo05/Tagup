//
//  SearchResultView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 23/03/25.
//

import SwiftUI

struct SearchResultView: View {
    
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                MainTopView()
                ImageView()
                SearchedKeys()
                CopyButton()
            }
            .padding()
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            TopSafeArea(title: viewModel.image == nil ? "Tags by Word" : "Tags by Image", color: .safeareaGreen, isBackEnabled: true)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            if !viewModel.showResult {
                viewModel.image = nil
                viewModel.loadedTags.removeAll()
            }
        }
    }
    
    @ViewBuilder func SearchedKeys() -> some View {
        VStack(spacing: 24) {
            Text(viewModel.loadedTags.first ?? "Tags")
                .font(.system(size: 20, weight: .semibold))
            WrappingHStack(viewModel.loadedTags, alignment: .center, spacing: .constant(8), lineSpacing: 8) { tag in
                Text(tag)
                    .font(.system(size: 18))
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background {
            Color.tabBackground
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    @ViewBuilder func ImageView() -> some View {
        if let image = viewModel.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 176)
                .background(.tabBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    @ViewBuilder func CopyButton() -> some View {
        Button {
            if !viewModel.loadedTags.isEmpty {
                viewModel.copyLoadedTags()
                PopService.shared.show(CopiedView(), fraction: 0.8, time: 1)
                Utils.hapticFeedback(style: .light)
            }
        } label: {
            HStack(spacing: 5) {
                Image(.copyIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("Copy")
                    .font(.system(size: 18, weight: .semibold))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(.tabBackground)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .tint(.greenBold)
    }
}

