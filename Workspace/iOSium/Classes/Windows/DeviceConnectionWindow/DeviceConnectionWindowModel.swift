//
//  DeviceConnectionWindowModel.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import RxSwift

/**
 *  Model for device connection window
 */
class DeviceConnectionWindowModel {
    let webDriverAgentURL = BehaviorSubject<URL?>(value: nil)
}
