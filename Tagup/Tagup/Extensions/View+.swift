//
//  View+.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 23/03/25.
//

import SwiftUI

extension View {
    func shimmerEffect(isLoading: @autoclosure () -> Bool) -> some View {
        redacted(reason: isLoading() ? .placeholder : []).shimmering(active: isLoading()).disabled(isLoading())
    }
}
