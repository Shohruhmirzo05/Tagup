//
//  AppEnvironment.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 06/03/25.
//

import SwiftUI

enum AppEnvironment: String {
    case development
    case production
}

extension AppEnvironment {
    static var current: AppEnvironment {
#if RELEASE
        return .production
#elseif DEBUG
        return .development
#else
        return .development
#endif
    }
}
 
extension AppEnvironment {
    private var keyPairs: [String: String] {
        guard
            let infoDictionary = Bundle.main.infoDictionary,
            let envDictionary = infoDictionary["Environments"] as? [String: [String: String]],
            let keyPairs = envDictionary[self.rawValue]
        else {
            fatalError("Missing or invalid configuration for \(self.rawValue) environment in Info.plist.")
        }
        return keyPairs
    }

    var baseUrl: String {
        keyPairs["baseUrl"] ?? ""
    }
    
    var appId: String {
        keyPairs["AppID"] ?? ""
    }
    
    var email: String {
        keyPairs["Email"] ?? ""
    }
}
