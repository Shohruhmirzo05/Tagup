//
//  TodaysTagsView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct TodaysTagsView: View {
    
    @StateObject private var viewModel = TodaysTagViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                MainTopView()
                    .padding(.bottom)
                VStack(spacing: 24) {
                    Text("\(viewModel.loadedTags.first ?? "Tags")")
                        .font(.system(size: 20, weight: .semibold))
                    WrappingHStack(viewModel.loadedTags, alignment: .center, spacing: .constant(8), lineSpacing: 8) { tag in
                        Text(tag)
                            .font(.system(size: 18))
                            .id(tag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(.tabBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shimmerEffect(isLoading: viewModel.dailyWordsLoading)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            TopSafeArea(title: "Tags by Word", color: .safeareaGreen, isBackEnabled: true)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

