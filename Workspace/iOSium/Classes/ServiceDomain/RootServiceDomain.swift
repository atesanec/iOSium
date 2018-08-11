//
//  RootServiceDomain.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

/**
 *  Root service domain
 */
class RootServiceDomain {
    static let sharedDomain = RootServiceDomain()
    
    let webDriverAgentService = WebDriverAgentService()
}
