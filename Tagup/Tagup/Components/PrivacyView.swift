//
//  WebView.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 07/03/25.
//

import SwiftUI
import WebKit

struct PrivacyView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    PolicySection(title: "Data Collection and Usage", content: "At Tags, we collect specific non-identifying data, referred to as 'Anonymous Data,' as you interact with our app. This data includes user interaction patterns and habits, which we analyze meticulously to assess performance, identify trends, and measure various metrics. Our goal is to derive valuable insights to enhance user experience and continually refine our services. ")
                    
                    PolicySection(title: "", content: "Your account username is securely stored in our database alongside comprehensive analytics linked to it. These analytics consist of daily snapshots capturing diverse statistics reflecting the evolution of your account over time. We prioritize safeguarding data privacy and can promptly delete this information upon your request.")
                    PolicySection(title: "Data Handling", content: "You have the right to withdraw consent for the collection and use of personally identifiable information at any time, reliable third-party sources.")
                }
                .padding()
                .multilineTextAlignment(.center)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Privacy Policy")
                        .font(.system(size: 24, weight: .semibold))
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder func PolicySection(title: String? = nil, content: String) -> some View {
        VStack(spacing: 14) {
            if let title = title, !title.isEmpty {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            Text(content)
                .font(.system(size: 14))
        }
    }
}
