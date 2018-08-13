//
//  DeviceConnectionWindow.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import AppKit
import RxCocoa
import RxSwift

/**
 *  Window that contains device connection settings
 */
class DeviceConnectionWindowController: NSWindowController {
    @IBOutlet weak var hintLabel: NSTextField!
    @IBOutlet weak var ipAddressField: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var refreshButton: NSButton!
    
    private let interactionWindowController = DeviceInteractionWindowController()
    
    private let disposeBag = DisposeBag()
    private let windowModel = DeviceConnectionWindowModel()
    private let requestAdapter = WebDriverAgentServiceAdapter()
    
    convenience init() {
        self.init(windowNibName: NSNib.Name("DeviceConnectionWindowController"))
    }
    
    override func windowDidLoad() {
        self.window!.title = self.window!.title.localized
        
        hintLabel.stringValue = hintLabel.stringValue.localized
        hintLabel.placeholderString = hintLabel.placeholderString?.localized
        
        let savedURL = RootServiceDomain.sharedDomain.webDriverAgentService.url?.absoluteString
        if let url = savedURL {
            ipAddressField.stringValue = url
        }
        
        self.setupUIObservations()
        self.setupModelObservations()
    }
    
    private func setupUIObservations() {
        ipAddressField.rx.text.orEmpty.asObservable().map {URL(string: $0)}
            .bind(to: self.windowModel.webDriverAgentURL).disposed(by: self.disposeBag)
        
        startButton.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            let webDriverAgent = RootServiceDomain.sharedDomain.webDriverAgentService
            let isStopped =  try! webDriverAgent.connectionStatus.value() == .disconnected
            if isStopped {
                let url = try! self!.windowModel.webDriverAgentURL.value()
                webDriverAgent.start(url: url!)
            } else {
                webDriverAgent.stop()
            }
        }).disposed(by: self.disposeBag)
        
        refreshButton.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            let strongSelf = self!
            
           // if !strongSelf.interactionWindowController.window!.isVisible {
                strongSelf.interactionWindowController.showWindow(self)
           // }
            
            strongSelf.interactionWindowController.refreshScreenshot()
        }).disposed(by: self.disposeBag)
    }
    
    private func setupModelObservations() {
        self.windowModel.webDriverAgentURL.subscribe(onNext: { [weak self] url in
            RootServiceDomain.sharedDomain.webDriverAgentService.stop()
            
            let isValidURL = url != nil && url!.host != nil
            self!.startButton.isEnabled = isValidURL
        }).disposed(by: self.disposeBag)
        
        let webDriverAgent = RootServiceDomain.sharedDomain.webDriverAgentService
        webDriverAgent.connectionStatus.subscribe(onNext: { [weak self] status in
            let strongSelf = self!
            
            strongSelf.statusLabel.stringValue = status.displayText()
            var isActive = false
            var isConnected = false
            switch(status) {
            case .connected:
                isConnected = true
                isActive = true
                
            case .connecting:
                isConnected = false
                isActive = true
                
            case .disconnected:
                isConnected = false
                isActive = false
            }
            
            strongSelf.refreshButton.isEnabled = isConnected
            strongSelf.startButton.title = isActive ? "StopService".localized : "StartService".localized
        }).disposed(by: self.disposeBag)
    }
}
