//
//  DeviceInteractionWindowController.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import AppKit
import RxCocoa
import RxSwift

class DeviceInteractionWindowController: NSWindowController {
    @IBOutlet weak var imageViewContainer: DeviceInteractionImageViewContainer!
    
    private let disposeBag = DisposeBag()
    private let windowModel = DeviceInteractionWindowModel()
    private var actionManager: DeviceInteractionActionManager!
    
    convenience init() {
        self.init(windowNibName: NSNib.Name("DeviceInteractionWindowController"))
        self.actionManager = DeviceInteractionActionManager(windowModel: self.windowModel)
    }
    
    func refreshScreenshot() {
        self.windowModel.refreshScreenshotSignal.onNext(())
    }
    
    override func windowDidLoad() {
        self.actionManager = DeviceInteractionActionManager(windowModel: self.windowModel)
        self.setupModelObservations()
        self.setupUIObservations()
    }
    
    private func setupModelObservations() {
        self.windowModel.deviceScreenInfo.subscribe(onNext: { [weak self] info in
            let strongSelf = self!
            if let screenInfo = info {
                strongSelf.imageViewContainer!.image = screenInfo.image
            }
        }).disposed(by: disposeBag);
        
        let agent = RootServiceDomain.sharedDomain.webDriverAgentService
        agent.connectionStatus.subscribe(onNext: { [weak self] status in
            self!.imageViewContainer.isHidden = status != .connected
        }).disposed(by: disposeBag)
    }
    
    private func setupUIObservations() {
        self.imageViewContainer.imageViewClick.bind(to: self.windowModel.screenClickSignal).disposed(by: disposeBag)
    }
}
