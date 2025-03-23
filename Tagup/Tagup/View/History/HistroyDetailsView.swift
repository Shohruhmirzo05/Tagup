//
//  HistroyDetailsView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 23/03/25.
//

import SwiftUI

struct HistroyDetailsView: View {
    
    @StateObject var viewModel: HistoryViewModel
    let group: SavedKeywordGroupForKeychain?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                MainTopView()
                Tags()
                CopyTagButton()
            }
            .padding()
            .padding(.horizontal, 8)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            TopSafeArea(title: "History", color: .safeareaBlue, isBackEnabled: true)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $viewModel.showEditView) {
            SelectedTagEditView(viewModel: viewModel, group: group)
        }
    }
    
    @ViewBuilder func Tags() -> some View {
        VStack(spacing: 24) {
            Text(group?.keywords.first ?? "Tags")
                .font(.system(size: 20, weight: .semibold))
            WrappingHStack(group?.keywords ?? [], alignment: .center, spacing: .constant(8), lineSpacing: 8) { tag in
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
    
    @ViewBuilder func CopyTagButton() -> some View {
        HStack {
            Button {
                if let tags = group?.keywords {
                    let copiedText = tags.joined(separator: " ")
                    UIPasteboard.general.string = copiedText
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
            
            Button {
                viewModel.showEditView.toggle()
            } label: {
                HStack(spacing: 5) {
                    Image(.editIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Edit")
                        .font(.system(size: 18, weight: .semibold))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(.tabBackground)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .tint(.accent)
        }
    }
}
