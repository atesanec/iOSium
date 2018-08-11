//
//  WebDriverAgentService.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import RxSwift

enum WebDriverAgentServiceConnectionStatus {
    case connected
    case disconnected
}

/**
 *  Service that handles connection with WebDriverAgent on device
 */
class WebDriverAgentService {
    private(set) var connectionStatus = BehaviorSubject<WebDriverAgentServiceConnectionStatus>(value: .disconnected)
    private(set) var url: URL?
    private(set) var sessionId: String?
    
    private let requestAdapter = WebDriverAgentServiceAdapter()
    private var disposeBag = DisposeBag()
    
    func start(url: URL) {
        self.stop()
        
        self.url = url
        Observable<Int>.timer(0, period: 5, scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ in
                self!.requestAdapter.checkConnectionStatus().retry()
        }.subscribe(onNext: { [weak self] status in
            self!.connectionStatus.onNext(.connected)
            self!.sessionId = status.defaultSessionId
        }, onError: { [weak self] _ in
            self!.connectionStatus.onNext(.disconnected)
        }).disposed(by: self.disposeBag)
    }
    
    func stop() {
        self.sessionId = nil
        self.disposeBag = DisposeBag()
    }
}
