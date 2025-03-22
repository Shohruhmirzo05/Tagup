//
//  SplashView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(.splash)
                .resizable()
                .scaledToFit()
                .frame(width: 216, height: 170)
            Text("Powerful utility for generating ")
            +
            Text("#tags")
                .foregroundStyle(.pinkBold)
        }
        .multilineTextAlignment(.center)
        .font(.system(size: 28, weight: .semibold))
        .padding(.horizontal, 54)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.splashBackground)
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
