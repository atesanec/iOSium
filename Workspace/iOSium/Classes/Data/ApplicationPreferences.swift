//
//  ApplicationPreferences.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import AppKit

fileprivate enum ApplicationPreferencesKeys: String {
    case webDriverAgentURL
}

/**
 *  Stored application preferences
 */
class ApplicationPreferences {
    static var serviceURL: URL? {
        get {
            return UserDefaults.standard.url(forKey: ApplicationPreferencesKeys.webDriverAgentURL.rawValue)
        }
        
        set(url) {
            UserDefaults.standard.set(url, forKey: ApplicationPreferencesKeys.webDriverAgentURL.rawValue)
        }
    }
}
