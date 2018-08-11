//
//  DeviceInteractionWindowModel.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import RxSwift

class DeviceInteractionWindowModel {
    static var maxWindowSize: CGFloat {
        return NSScreen.main!.visibleFrame.height * 0.5
    }
    
    let screenshotImage = BehaviorSubject<NSImage?>(value: nil)
    
    var targetWindowSize: NSSize {
        let image = try! self.screenshotImage.value()!
        let imageSize = image.size
        let maxSize = DeviceInteractionWindowModel.maxWindowSize
        let scaleRatio = min(maxSize / imageSize.width, maxSize / imageSize.height)
        
        return NSSize(width: imageSize.width * scaleRatio, height: imageSize.height * scaleRatio)
    }
}
