//
//  TestView.swift
//  Tagup
//
//  Created by Alijonov Shohruhmirzo on 25/03/25.
//

import SwiftUI
import UIKit
import AVFoundation

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = CustomUITextField()
        textField.text = text
        textField.borderStyle = .roundedRect
        textField.delegate = context.coordinator
        DispatchQueue.main.async {
            textField.becomeFirstResponder() // Forces the text field to gain focus
        }
        return textField
    }


    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        init(_ parent: CustomTextField) { self.parent = parent }
    }
}


import UIKit

class CustomUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(listenText) ||
           action == #selector(shareText) ||
           action == #selector(searchWeb) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }



    override func buildMenu(with builder: UIMenuBuilder) {
        // Do not call super.buildMenu to override the default menu
        builder.remove(menu: .standardEdit)

        let listen = UIAction(title: "Listen", image: UIImage(systemName: "ear")) { _ in
            self.listenText()
        }
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            self.shareText()
        }
        let search = UIAction(title: "Search Web", image: UIImage(systemName: "magnifyingglass")) { _ in
            self.searchWeb()
        }

        let customMenu = UIMenu(title: "Actions", options: .displayInline, children: [listen, share, search])
        
        builder.insertChild(customMenu, atStartOfMenu: .text)
    }

    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        UIMenuSystem.main.setNeedsRebuild()
    }
    
    @objc func listenText() {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: self.text ?? "")
        synthesizer.speak(utterance)
    }

    @objc func shareText() {
        let activityVC = UIActivityViewController(activityItems: [self.text ?? ""], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
    }

    @objc func searchWeb() {
        if let text = self.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: "https://www.google.com/search?q=\(text)") {
            UIApplication.shared.open(url)
        }
    }
}



import SwiftUI
import AVFoundation

struct CustomTextView: View {
    let text: String

    var body: some View {
        CustomTextField(text: .constant("Hellloooo"))
    }
}



#Preview {
    CustomTextView(text: "textjwferjwbf")
}
