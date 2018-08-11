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

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        RootServiceDomain.sharedDomain.webDriverAgentService.start(url: URL(string: "http://192.168.1.72:8100")!)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

