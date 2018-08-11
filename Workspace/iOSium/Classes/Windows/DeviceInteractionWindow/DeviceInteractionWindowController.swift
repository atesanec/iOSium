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
    @IBOutlet weak var imageView: NSImageView?
    
    private let disposeBag = DisposeBag()
    private let windowModel = DeviceInteractionWindowModel()
    private var actionManager: DeviceInteractionActionManager!
    
    convenience init() {
        self.init(windowNibName: NSNib.Name("DeviceInteractionWindowController"))
    }
    
    func refreshScreenshot() {
        self.actionManager.refreshScreenshot()
    }
    
    override func windowDidLoad() {
        self.actionManager = DeviceInteractionActionManager(windowModel: self.windowModel)
        self.setupObservations()
    }
    
    private func setupObservations() {
        self.windowModel.screenshotImage.subscribe(onNext: { [weak self] image in
            let strongSelf = self!
            strongSelf.updateWindowVisibility()
            strongSelf.imageView!.image = image
            strongSelf.window!.setContentSize(strongSelf.windowModel.targetWindowSize)
        }).disposed(by: disposeBag);
        
        let agent = RootServiceDomain.sharedDomain.webDriverAgentService
        agent.connectionStatus.subscribe(onNext: { [weak self] status in
            self!.updateWindowVisibility()
        }).disposed(by: disposeBag)
    }
    
    private func updateWindowVisibility() {
        let webDriverAgentStatus = try! RootServiceDomain.sharedDomain.webDriverAgentService.connectionStatus.value()
        let image = try! self.windowModel.screenshotImage.value()
        
        self.hideWindow(hide: webDriverAgentStatus != .connected || image == nil)
    }
    
    private func hideWindow(hide: Bool) {
        if hide {
            self.close()
        } else {
            self.showWindow(self)
        }
    }
}
