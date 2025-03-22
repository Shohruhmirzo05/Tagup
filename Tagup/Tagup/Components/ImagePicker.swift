//
//  ImagePicker.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 06/03/25.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    let oncompletion: (() -> Void)?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.oncompletion?()
            }
            picker.dismiss(animated: true)
        }
    }
}
