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
        
        self.setupObservations()
    }
    
    private func setupObservations() {
        self.windowModel.refreshScreenshotSignal.flatMap { [weak self] _ -> Observable<DeviceInteractionScreenInfo> in
            let strongSelf = self!
            let adapter = strongSelf.requestAdapter
            return Observable.combineLatest(adapter.takeScreenshot(), adapter.loadScreenLogicSize()) { imageInfo, sizeInfo in
                return DeviceInteractionScreenInfo(image: imageInfo.image, logicSize: sizeInfo.logicSize)
            }
            }.observeOn(MainScheduler.instance).subscribe(onNext: {[weak self] info in
                self!.windowModel.deviceScreenInfo.onNext(info)
                }, onError: { [weak self] (e) -> Void in
                    self!.showErrorAlert()
            }).disposed(by: self.disposeBag)
        
        self.windowModel.screenClickSignal.flatMap { [weak self] normalizedPoint -> Observable<Void> in
            let strongSelf = self!
            let screenInfo = try! strongSelf.windowModel.deviceScreenInfo.value()!
            let logicSize = screenInfo.logicSize
            let point = NSPoint(x: normalizedPoint.x * logicSize.width, y: (1 - normalizedPoint.y) * logicSize.height)
            
            return strongSelf.requestAdapter.sendScreenClick(point: point)
            }.subscribe(onError: { [weak self] (e) -> Void in
                self!.showErrorAlert()
            }).disposed(by: self.disposeBag)
    }
    
    private func showErrorAlert() {
        let alert = NSAlert()
        alert.messageText = "UnableToCompleteRequest".localized
        alert.addButton(withTitle: "OK".localized)
        alert.runModal()
    }
}
