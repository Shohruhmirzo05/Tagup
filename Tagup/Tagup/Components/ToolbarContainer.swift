//
//  ToolbarContainer.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 06/03/25.
//

import SwiftUI

struct MainTopView: View {
    var body: some View {
        HStack(spacing: 12) {
            Text("Hello!")
                .font(.system(size: 24, weight: .semibold))
            Image(.helloIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Spacer()
            HStack(spacing: 2) {
                Text("100")
                Image(.mainCoin)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
        }
    }
}
