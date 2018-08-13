//
//  WebDriverAgentScreenSize.swift
//  iOSium
//
//  Created by VI_Business on 13/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

struct WebDriverAgentScreenSize {
    let logicSize: NSSize
    
    init(responseJSON: Any) {
        var responseDict = responseJSON as! Dictionary<String, Any>
        
        var sizeDict = responseDict["value"] as! Dictionary<String, Int>
        self.logicSize = NSSize(width: sizeDict["width"]!, height: sizeDict["height"]!)
    }
}
