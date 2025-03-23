//
//  OtherView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct OtherView: View {
    
    @StateObject var storeKitViewModel = StoreKitViewModel()
    @State var showPrivacyView: Bool = false
    @Binding var selection: Tab
    
    var body: some View {
        VStack(spacing: 26) {
            MainTopView()
                .padding(.bottom)
            OtherCard(icon: .mailIcon, title: "Contact us") {
                Utils.shared.openEmail()
            }
            OtherCard(icon: .rateIcon, title: "Rate us") {
                Utils.shared.openAppStore()
            }
            OtherCard(icon: .solarBagBold, title: "More coins") {
                selection = .packs
            }
            OtherCard(icon: .privacyIcon, title: "Privacy & Policy") {
                showPrivacyView = true
            }
            Spacer(minLength: 0)
        }
        .padding()
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top, content: TopArea)
        .onAppear {
            storeKitViewModel.requestProducts()
        }
        .sheet(isPresented: $showPrivacyView) {
            PrivacyView()
        }
    }
    
    @ViewBuilder func TopArea() -> some View {
        Text("Other")
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.safeareaBlue)
            .font(.system(size: 24, weight: .semibold))
    }
    
    @ViewBuilder func OtherCard(icon: ImageResource, title: String, action: @escaping () -> ()) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
            }
            .font(.system(size: 14, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.tabBackground, lineWidth: 2)
            }
        }
        .tint(.primary)
    }
}

#Preview {
    OtherView(selection: .constant(.other))
}
