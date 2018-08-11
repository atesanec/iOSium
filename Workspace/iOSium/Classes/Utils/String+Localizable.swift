//
//  String+Localizable
//  iOSium
//
//  Created by VI_Business on 15/07/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import AppKit

extension String {
    
    /// Localize string
    ///
    /// - Returns: localized string
    var localized: String {
        let notFound = "__NOT_FOUND__"
        let localizedString = NSLocalizedString(self, value: notFound, comment: "")
        if localizedString == notFound {
            NSLog("LOCALIZATION ERROR: Key \(self) is not found in Localized.strings")
            return self
        }
        return localizedString
    }
}
