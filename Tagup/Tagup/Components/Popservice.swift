//
//  Popservice.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 04/03/25.
//

import SwiftUI
import UIKit

final class PopService {

    static let shared = PopService()

    private init() {}

    /// Show a SwiftUI popup at a specific fraction of the screen height
    /// - Parameters:
    ///   - view: The SwiftUI view to display
    ///   - fraction: Vertical position (0.0 = top, 1.0 = bottom, 0.5 = center)
    ///   - time: Duration for which the popup remains visible
    func show<Content: View>(_ view: Content, fraction: CGFloat, time: TimeInterval, dismissAction: (() -> Void)? = nil) {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            Log.warning("Could not find active key window.")
            return
        }

        // Create a container view for the popup
        let containerView = UIView(frame: window.bounds)
        containerView.backgroundColor = .clear
        containerView.isUserInteractionEnabled = false // Ensures the popup does not block interactions

        let hostingController = UIHostingController(rootView: AnyView(view.onDisappear {
            dismissAction?()
        }))
        hostingController.view.backgroundColor = .clear

        containerView.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        window.addSubview(containerView)

        // Calculate the popup's vertical position based on the fraction
        let positionY = window.bounds.height * fraction

        // Set up the popup's initial and final transforms
        let initialTransform: CGAffineTransform
        let finalTransform: CGAffineTransform
        if fraction < 0.5 {
            initialTransform = CGAffineTransform(translationX: 0, y: -100) // Slide in from top
            finalTransform = CGAffineTransform(translationX: 0, y: -100) // Slide out to top
        } else if fraction > 0.5 {
            initialTransform = CGAffineTransform(translationX: 0, y: 100) // Slide in from bottom
            finalTransform = CGAffineTransform(translationX: 0, y: 100) // Slide out to bottom
        } else {
            initialTransform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Scale in from center
            finalTransform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Scale out to center
        }

        NSLayoutConstraint.activate([
            hostingController.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: positionY),
            hostingController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9)
        ])

        // Apply the initial transform
        hostingController.view.transform = initialTransform

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            containerView.alpha = 1
            hostingController.view.transform = .identity
        })

        // Schedule dismissal after the specified time
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            UIView.animate(withDuration: 0.2, animations: {
                hostingController.view.transform = finalTransform
                containerView.alpha = 0
            }) { _ in
                containerView.removeFromSuperview()
                dismissAction?()
            }
        }
    }
}
