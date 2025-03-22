//
//  ContentView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 21/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var isActive = true
    
    var body: some View {
        Group {
            if isActive {
                SplashView()
                    .transition(.opacity.combined(with: .scale(2)))
                    .ignoresSafeArea()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                isActive = false
                            }
                        }
                    }
            } else {
                TabbarView()
            }
        }
    }
}

#Preview {
    ContentView()
}
