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
    let deviceScreenInfo = BehaviorSubject<DeviceInteractionScreenInfo?>(value: nil)
    
    let refreshScreenshotSignal = PublishSubject<Void>()
    let screenClickSignal = PublishSubject<NSPoint>()
}
