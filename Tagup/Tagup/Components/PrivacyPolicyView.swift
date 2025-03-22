//
//  WebView.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 07/03/25.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    PolicySection(title: "Information Collection and Use At Hashly", content: "We prioritize user privacy while continuously improving the app's features and functionality. We collect non-personally identifiable data to assess user engagement, streamline performance, and optimize the experience. This data is analyzed in a way that respects privacy and enhances the overall usability of our services. User-provided details, such as display names or profile identifiers, may be securely stored along with anonymized interaction data. This aggregated information helps refine our app, introduce new enhancements, and ensure a seamless experience. If you wish, you can request the deletion of your stored data at any time.")
                    PolicySection(title: "Data Processing and Consent", content: " Users can revoke their consent to data collection at any time, though this may limit access to certain app features. Hashlydoes not store or process financial transactions or payment data. For details on our security practices, please review our compliance section.")
                    PolicySection(title: "Cookies and Analytics", content: "To enhance user interaction, Hashly utilizes cookies and similar technologies to remember preferences and improve navigation. We may also analyze anonymized data to identify patterns, evaluate performance, and understand which features are most valuable to our users. To expand our reach, we may partner with advertising and marketing services. Any promotional content displayed within the app is based on aggregated, non-personalized data collected from trusted sources.")
                    PolicySection(title: "External Services and Third-Party Links", content: "Some features within Hashly may incorporate external services governed by their own privacy policies. We encourage users to review those policies, as our privacy standards apply only within the Hashly platform. We are not responsible for how external sites handle your information.")
                    PolicySection(title: "Security Measures", content: "Keeping user data secure is a top priority for Hashly. We employ encryption and other industry-standard security protocols to safeguard information from unauthorized access. To further enhance security, we recommend keeping your app and device software updated.")
                    PolicySection(title: "Policy Revisions", content: " This privacy policy may be updated periodically. Any major revisions will be communicated to users in advance, allowing them to review the changes and adjust their preferences accordingly. We recommend checking this policy from time to time for the latest updates.")
                    PolicySection(title: "Contact Information", content: "For any questions or concerns regarding this privacy policy, please reach out to us: Email: contact@hashlyapp.org")
                }
                .padding(.horizontal)
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
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder func PolicySection(title: String, content: String) -> some View {
        VStack(spacing: 14) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            Text(content)
                .font(.system(size: 14))
        }
    }
}
