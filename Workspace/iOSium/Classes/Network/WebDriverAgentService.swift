//
//  WebDriverAgentService.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import RxSwift

/**
 *  Connection status
 */
enum WebDriverAgentServiceConnectionStatus {
    case connected
    case connecting
    case disconnected
    
    func displayText() -> String {
        switch self {
        case .connected:
            return "ConnectedState".localized
            
        case .connecting:
            return "ConnectingState".localized
            
        case .disconnected:
            return "DisconnectedState".localized
        }
    }
}

/**
 *  Service that handles connection with WebDriverAgent on device
 */
class WebDriverAgentService {
    private(set) var connectionStatus = BehaviorSubject<WebDriverAgentServiceConnectionStatus>(value: .disconnected)
    private(set) var url = ApplicationPreferences.serviceURL
    private(set) var sessionId: String?
    
    private let requestAdapter = WebDriverAgentServiceAdapter()
    private var disposeBag = DisposeBag()
    
    func start(url: URL) {
        self.stop()
        self.connectionStatus.onNext(.connecting)
        
        self.url = url
        ApplicationPreferences.serviceURL = url
        
        let interval: Double? = 5.0
        // Setup polling for connection status check
        Observable<Int>.timer(0.0, period: interval, scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ in
                self!.requestAdapter.checkConnectionStatus().retryWhen { [weak self] (o : Observable<Error>) -> Observable<Int> in
                    return Observable<Int>.timer(1, period: nil, scheduler: MainScheduler.instance).flatMap({ elem -> Observable<Int> in
                        self!.connectionStatus.onNext(.connecting)
                        return Observable<Int>.just(elem)
                    })
                }
        }.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] status in
            self!.connectionStatus.onNext(.connected)
            self!.sessionId = status.defaultSessionId
        }).disposed(by: self.disposeBag)
    }
    
    func stop() {
        self.connectionStatus.onNext(.disconnected)
        self.sessionId = nil
        self.disposeBag = DisposeBag()
    }
}
