//
//  DeviceInteractionScreenInfo.swift
//  iOSium
//
//  Created by VI_Business on 13/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import AppKit

/**
 * Information that is used for rendering and processing clicks on device interaction screen
 */
struct DeviceInteractionScreenInfo {
    /// Screenshot
    let image: NSImage
    /// Screen size in device points
    let logicSize: NSSize
}
