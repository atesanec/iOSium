//
//  DeviceInteractionWindowModel.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import RxSwift

/**
 *  View model for device interaction screen
 */
class DeviceInteractionWindowModel {
    let deviceScreenInfo = BehaviorSubject<DeviceInteractionScreenInfo?>(value: nil)
    
    let refreshScreenshotSignal = PublishSubject<Void>()
    
    /// Emits click coordinates that are normalized in [0,1] interval
    let screenClickSignal = PublishSubject<NSPoint>()
}
