//
//  TopSafeArea.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct TopSafeArea: View {
    
    let title: String
    let color: Color
    var isBackEnabled: Bool?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(color)
            .font(.system(size: 24, weight: .semibold))
            .overlay {
                if isBackEnabled ?? false {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .tint(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
            }
    }
}
