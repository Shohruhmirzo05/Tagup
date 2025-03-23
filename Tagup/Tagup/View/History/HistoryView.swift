//
//  HistoryView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var storeKitViewModel = StoreKitViewModel()
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    MainTopView()
                    Spacer()
                    ForEach(viewModel.keywordGroups) { group in
                        HistoryCard(group: group) {
                            viewModel.selectedGroup = group
                            viewModel.showDetails = true
                            print("group selected: \(group.title)")
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .top) {
                TopSafeArea(title: "History", color: .safeareaIndigo)
            }
            .onAppear {
                storeKitViewModel.requestProducts()
            }
            .navigationDestination(isPresented: $viewModel.showDetails) {
                if let group = viewModel.selectedGroup {
                    HistroyDetailsView(viewModel: viewModel, group: group)
                }
            }
        }
    }
    
    @ViewBuilder func HistoryCard(group: SavedKeywordGroupForKeychain, action: @escaping () -> ()) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Text(group.title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .font(.system(size: 14, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(13)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.tabBackground, lineWidth: 2)
            }
        }
        .tint(.primary)
    }
}

#Preview {
    HistoryView()
}
