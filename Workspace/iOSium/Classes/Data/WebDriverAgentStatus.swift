//
//  WebDriverAgentStatus.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

/**
 *  Status of Web Driver Agent
 */
struct WebDriverAgentStatus {
    let defaultSessionId: String
    
    init(responseJSON: Any) {
        var responseDict = responseJSON as! Dictionary<String, Any>
        self.defaultSessionId = responseDict["sessionId"] as! String
    }
}
