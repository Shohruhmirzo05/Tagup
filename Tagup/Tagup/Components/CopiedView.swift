//
//  Copied.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 04/03/25.
//

import SwiftUI

struct CopiedView: View {
    var body: some View {
        Text("Copied")
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.bar)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray.opacity(0.5))
            }
    }
}

struct SavedView: View {
    var body: some View {
        Text("Saved")
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.bar)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray.opacity(0.5))
            }
    }
}
