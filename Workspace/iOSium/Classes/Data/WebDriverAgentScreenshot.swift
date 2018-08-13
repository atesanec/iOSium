//
//  WebDriverAgentScreenshot.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import AppKit

/**
 *  Response for Web Driver Agent screenshot resuest
 */
struct WebDriverAgentScreenshot {
    let image: NSImage
    
    init(responseJSON: Any) {
        var responseDict = responseJSON as! Dictionary<String, Any>
        
        var imageBase64 = responseDict["value"] as! String
        imageBase64 = imageBase64.replacingOccurrences(of: "\r\n", with: "")
        
        self.image = NSImage(data: Data(base64Encoded: imageBase64)!)!
    }
}
