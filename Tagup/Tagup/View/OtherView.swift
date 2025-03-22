//
//  OtherView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct OtherView: View {
    var body: some View {
        VStack(spacing: 26) {
            MainTopView()
                .padding(.bottom) 
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top, content: TopArea)
    }
    
    @ViewBuilder func TopArea() -> some View {
        Text("Other")
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.safeareaBlue)
            .font(.system(size: 24, weight: .semibold))
    }
}

#Preview {
    OtherView()
}
