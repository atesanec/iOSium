//
//  WebDriverAgentServiceAdapter.swift
//  iOSium
//
//  Created by VI_Business on 11/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

/**
 *  Service paths
 */
fileprivate enum WebDriverAgentServicePaths: String {
    case status
    case screenshot
    case session
}

class WebDriverAgentServiceAdapterError: Error {
    
}

/**
 *  Service adapter to perform specific service requests
 */
class WebDriverAgentServiceAdapter {
    
    func checkConnectionStatus() -> Observable<WebDriverAgentStatus> {
        return Observable.create {(observer) -> Disposable in
            let path = self.buildRequestURL(path: WebDriverAgentServicePaths.status.rawValue).absoluteString
            let task = Alamofire.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        observer.onNext(WebDriverAgentStatus(responseJSON: response.result.value!))
                        observer.onCompleted()
                        break
                        
                    case .failure(_):
                        observer.onError(response.result.error!)
                        break
                        
                    }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func takeScreenshot() -> Observable<WebDriverAgentScreenshot> {
        return Observable.create {(observer) -> Disposable in
            let sessionId = RootServiceDomain.sharedDomain.webDriverAgentService.sessionId!
            var path = NSURL(string: WebDriverAgentServicePaths.session.rawValue)!.appendingPathComponent(sessionId)!
                .appendingPathComponent(WebDriverAgentServicePaths.screenshot.rawValue)
            path = self.buildRequestURL(path: path.absoluteString)
            let task = Alamofire.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    switch(response.result) {
                    case .success(_):
                        observer.onNext(WebDriverAgentScreenshot(responseJSON: response.result.value!))
                        observer.onCompleted()
                        break
                        
                    case .failure(_):
                        observer.onError(response.result.error!)
                        break
                        
                    }
            }
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func buildRequestURL(path: String) -> URL {
        return RootServiceDomain.sharedDomain.webDriverAgentService.url!.appendingPathComponent(path)
    }
}
