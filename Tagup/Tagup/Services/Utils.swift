//
//  Utils.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 03/03/25.
//

import SwiftUI

class Utils {
    
    static let shared = Utils()
    
    func openAppStore() {
        let appStoreURL = URL(string: "https://apps.apple.com/app/\(AppEnvironment.current.appId)")!
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    static func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notificationFeedback(_ feedback: UINotificationFeedbackGenerator.FeedbackType = .error) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(feedback)
    }
    
    func dismissKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func openEmail() {
        let email = "contact@hashlyapp.org"
        let subject = "Support Request"
        let body = "Hello,\n\nI need help with..."
        
        let emailString = "mailto:\(email)?subject=\(subject)&body=\(body)"
        
        if let encodedString = emailString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let emailURL = URL(string: encodedString) {
            if UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL)
            } else {
                Utils.hapticFeedback(style: .light)
                OneButtonAlert.shared.present(title: "Support", message: "If you need help, reach us by email at contact@hashlyapp.org", button: "Ok")
            }
        } else {
            Utils.hapticFeedback(style: .light)
            OneButtonAlert.shared.present(title: "Support", message: "If you need help, reach us by email at contact@hashlyapp.org", button: "Ok")
        }
    }
}
