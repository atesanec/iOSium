//
//  AppDelegate.swift
//  iOSium
//
//  Created by VI_Business on 10/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    weak var window: NSWindow!
    let mainWindowController = DeviceConnectionWindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window = mainWindowController.window
    }

}

