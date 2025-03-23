//
//  SearchByImageView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 22/03/25.
//

import SwiftUI

struct SearchByImageView: View {
    
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        VStack(spacing: 22) {
            MainTopView()
            Spacer()
            Text("Upload an image to search trending tags")
                .padding(.horizontal, 40)
            Button {
                viewModel.showImageSourceActionSheet = true
            } label: {
                Image(.imageSelection)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 325, height: 369)
                    .overlay {
                        if viewModel.imageLoading {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.safeareaGreen.opacity(0.2))
                            ProgressView()
                                .scaleEffect(2)
                                .tint(.accent)
                        }
                    }
            }
            .disabled(viewModel.imageLoading)
            CoinSection()
            Spacer(minLength: 0)
        }
        .padding()
        .padding(.horizontal, 8)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            TopSafeArea(title: "Tags by Word", color: .safeareaGreen, isBackEnabled: true)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $viewModel.isImagePickerPresented) {
            ImagePicker(selectedImage: $viewModel.image, sourceType: .photoLibrary) {
                viewModel.lookImageTags()
            }
        }
        .sheet(isPresented: $viewModel.isCameraPresented) {
            ImagePicker(selectedImage: $viewModel.image, sourceType: .camera) {
                viewModel.lookImageTags()
            }
        }
        .actionSheet(isPresented: $viewModel.showImageSourceActionSheet) {
            ActionSheet(title: Text("Select Image Source"), buttons: [
                .default(Text("Photo Library")) { viewModel.isImagePickerPresented = true },
                .default(Text("Camera")) { viewModel.isCameraPresented = true },
                .cancel()
            ])
        }
        .navigationDestination(isPresented: $viewModel.showResult) {
            SearchResultView(viewModel: viewModel)
        }
    }
    
    @ViewBuilder func CoinSection() -> some View {
        Group {
            if viewModel.showInsufficientCoinImage {
                Text("Oops! You’re out of coins")
                    .font(.system(size: 14))
            } else {
                HStack(spacing: 0) {
                    Text("1 word = ")
                    +
                    Text("50 ")
                        .foregroundStyle(.pinkLight)
                    Image(.mainCoin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
            }
        }
    }
}

#Preview {
    SearchByImageView()
}
