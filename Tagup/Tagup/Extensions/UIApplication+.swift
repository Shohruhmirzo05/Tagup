//
//  UIApplication+.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 07/03/25.
//

import SwiftUI
import SafariServices
import StoreKit

extension UIApplication {
    
    func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow
    }
    
    var rootViewController: UIViewController? {
        return firstKeyWindow?.rootViewController
    }
    
    var topViewController: UIViewController? {
        var rootViewController: UIViewController? = rootViewController
        while rootViewController?.presentedViewController != nil {
            rootViewController = rootViewController?.presentedViewController
        }
        return rootViewController
    }
    
    class func findNavigationController(controller: UIViewController? = UIApplication.shared.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return findNavigationController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController, let selected = tabController.selectedViewController {
            return findNavigationController(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return findNavigationController(controller: presented)
        }
        return controller
    }
    
    func openUrl(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = false
            let vc = SFSafariViewController(url: url, configuration: config)
            UIApplication.shared.topViewController?.present(vc, animated: true)
        }
    }
}

