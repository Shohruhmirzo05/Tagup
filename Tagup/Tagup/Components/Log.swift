//
//  Log.swift
//  Hashly-IOS
//
//  Created by Bekzod Rakhmatov on 05/03/25.
//

import SwiftUI

class Log {
    
    static let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "ZBEKZ GROUP"
    
    static func info(_ log: String) {
            print("\n[\(Log.appName) INFO - 👀👀👀]")
            print(log)
            print("[INFO - END]")
    }
    static func warning(_ log: String) {
            print("\n[\(Log.appName) WARNING - ⚠️⚠️⚠️]")
            print(log)
            print("[INFO - END]")
    }
    static func error(_ log: String) {
            print("\n[\(Log.appName) ERROR - 🚨🚨🚨]")
            print(log)
            print("[INFO - END]")
    }
}
