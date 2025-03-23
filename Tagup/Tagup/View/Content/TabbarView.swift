//
//  TabbarView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct TabbarView: View {
    
    @State var selection: Tab = .main
    @StateObject var storeKitViewModel = StoreKitViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.tabBackground
    }
    
    var body: some View {
        TabView(selection: $selection) {
            MainView()
                .tag(Tab.main)
                .tabItem {
                    Label(Tab.main.tabName, image: Tab.main.icon)
                }
            HistoryView()
                .tag(Tab.history)
                .tabItem {
                    Label(Tab.history.tabName, image: Tab.history.icon)
                }
            PacksView()
                .tag(Tab.packs)
                .tabItem {
                    Label(Tab.packs.tabName, image: Tab.packs.icon)
                }
            OtherView()
                .tag(Tab.other)
                .tabItem {
                    Label(Tab.other.tabName, image: Tab.other.icon)
                }
        }
        .tint(.accentColor)
        .onChange(of: selection) { _, _ in
            Utils.hapticFeedback(style: .soft)
        }
    }
}

enum Tab: String, CaseIterable {
    case main, history, packs, other
    
    var icon: ImageResource {
        switch self {
        case .main: return .mainTabIcon
        case .history: return .historyTabIcon
        case .packs: return .packsTabIcon
        case .other: return .otherTabIcon
        }
    }
    
    var tabName: LocalizedStringKey {
        switch self {
        case .main:
            return "Main"
        case .history:
            return "History"
        case .packs:
            return "Packs"
        case .other:
            return "Other"
        }
    }
}

#Preview {
    TabbarView()
}

