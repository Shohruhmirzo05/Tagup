//
//  SelectedTagView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 23/03/25.
//

import SwiftUI

struct SelectedTagEditView: View {
    
    @StateObject var viewModel: HistoryViewModel
    @State private var keywords: [String] = []
    var group: SavedKeywordGroupForKeychain?
    var onComplete: (() -> Void)?
    
    init(viewModel: HistoryViewModel, group: SavedKeywordGroupForKeychain?) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.group = group
        self._keywords = State(initialValue: group?.keywords ?? [])
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                MainTopView()
                    .padding(.bottom)
                ForEach(keywords, id: \.self) { tag in
                    TagContainer(title: tag)
                }
                Buttons()
            }
            .padding()
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            TopSafeArea(title: "History", color: .safeareaIndigo, isBackEnabled: true)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            viewModel.selectedTags.removeAll()
        }
    }
    
    @ViewBuilder func TagContainer(title: String) -> some View {
        Button {
            withAnimation {
                if viewModel.selectedTags.contains(title) {
                    viewModel.selectedTags.removeAll { $0 == title }
                } else {
                    viewModel.selectedTags.append(title)
                }
            }
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 18))
                Spacer()
                Rectangle()
                    .fill(.white)
                    .frame(width: 22, height: 22)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .foregroundColor(.primary)
                    .overlay {
                        if viewModel.selectedTags.contains(title) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.pinkLight)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
            }
            .padding(13)
            .background(.tabBackground)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .tint(.primary)
    }
    
    @ViewBuilder func Buttons() -> some View {
        HStack {
            Button {
                withAnimation {
                    if viewModel.selectedTags.contains(group?.keywords ?? []) {
                        viewModel.selectedTags.removeAll()
                    } else {
                        viewModel.selectedTags = group?.keywords ?? []
                    }
                    Utils.hapticFeedback(style: .light)
                }
            } label: {
                HStack(spacing: 5) {
                    Image(.copyIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Select All")
                        .font(.system(size: 18, weight: .semibold))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(.tabBackground)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .tint(.greenBold)
            
            Button {
                keywords.removeAll { viewModel.selectedTags.contains($0) }
                if let groupID = group?.id {
                    viewModel.deleteKeywordsFromHistory(groupID: groupID, keywords: viewModel.selectedTags)
                }
                viewModel.selectedTags.removeAll()
                PopService.shared.show(SavedView(), fraction: 0.8, time: 1)
                Utils.hapticFeedback(style: .light)
                if keywords.isEmpty {
                    viewModel.showDetails = false
                    viewModel.showEditView = false
                }
            } label: {
                HStack(spacing: 5) {
                    Image(.saveIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("Save")
                        .font(.system(size: 18, weight: .semibold))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(.tabBackground)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
            .tint(.accent)
        }
        .padding(.top)
    }
}

#Preview {
    SelectedTagEditView(viewModel: HistoryViewModel(), group: .mock)
}
