//
//  MainView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack(spacing: 26) {
            MainTopView()
                .padding(.bottom) 
            DiscoverTagCard(title: "Tags by Image", image: .tagsByImageIcon) {
                
            }
            CardDivider()
            DiscoverTagCard(title: "Tags by Word", image: .tagsByWordIcon) {
                
            }
            CardDivider()
            DiscoverTagCard(title: "Today’s tags", image: .todaysTagIcon) {
                
            }
            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top, content: TopArea)
    }
    
    @ViewBuilder func TopArea() -> some View {
        Text("Discover")
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.safeareaPink)
            .font(.system(size: 24, weight: .semibold))
    }
    
    @ViewBuilder func DiscoverTagCard(title: String, image: ImageResource, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 21) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 29)
                    .padding(19)
                    .background {
                        Color.tabBackground
                            .clipShape(Circle())
                    }
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                Image(systemName: "chevron.forward")
                    .font(.system(size: 14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.tabBackground, lineWidth: 5)
                    .frame(maxWidth: .infinity)
            }
     
        }
        .tint(.primary)
    }
    
    @ViewBuilder func CardDivider() -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(.tabBackground)
            .frame(width: 33.5, height: 4)
    }
}

#Preview {
    MainView()
}
