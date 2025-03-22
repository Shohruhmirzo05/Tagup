//
//  OneButtonAlert.swift
//  Hashly-IOS
//
//  Created byBekzod Rakhmatov on 05/03/25.
//

import SwiftUI
import UIKit

class OneButtonAlert {
    
    static let shared = OneButtonAlert()
    
    var isPresented = false
    
    func present(
        title: String,
        message: String? = nil,
        button: String? = nil,
        _ action: (() -> Void)? = nil) {
            if isPresented {
                return
            }
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: button ?? "Ok", style: .default) { _ in
                self.isPresented = false
                action?()
            }
            action.setValue(UIColor.tintColor, forKey: "titleTextColor")
            alertController.addAction(action)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIApplication.shared.rootViewController?.present(alertController, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if !alertController.isViewLoaded {
                        UIApplication.findNavigationController()?.present(alertController, animated: true)
                    }
                }
            }
            isPresented = true
        }
}
