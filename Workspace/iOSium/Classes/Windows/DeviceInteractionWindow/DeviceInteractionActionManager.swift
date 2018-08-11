//
//  DeviceInteractionActionManager.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import RxSwift

/**
 *  Complex action manager for device interaction screen
 */
class DeviceInteractionActionManager {
    private let requestAdapter = WebDriverAgentServiceAdapter()
    private let windowModel: DeviceInteractionWindowModel
    private let disposeBag = DisposeBag()
    
    init(windowModel: DeviceInteractionWindowModel) {
        self.windowModel = windowModel
    }
    
    func refreshScreenshot() {
        self.requestAdapter.takeScreenshot().map {$0.image}.bind(to: self.windowModel.screenshotImage).disposed(by: self.disposeBag)
    }
}
