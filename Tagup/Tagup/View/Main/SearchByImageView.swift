//
//  SearchByImageView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

class SearchByImageViewModel: ObservableObject {
    
}

struct SearchByImageView: View {
    var body: some View {
        VStack {
            
        }
        .padding()
        .toolbar(.hidden, for: .tabBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            TopSafeArea(title: "Tags by Word", color: .safeareaGreen, isBackEnabled: true)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SearchByImageView()
}
