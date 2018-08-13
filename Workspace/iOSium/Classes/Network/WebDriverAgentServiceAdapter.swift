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
    case screenClick = "/wda/tap/0"
    case screenLogicSize = "window/size"
}

/**
 *  Service params
 */
fileprivate enum WebDriverAgentServiceParams: String {
    case x
    case y
}

class WebDriverAgentServiceAdapterError: Error {
    
}

/**
 *  Service adapter to perform specific service requests
 */
class WebDriverAgentServiceAdapter {
    let mappingQueue = DispatchQueue(label: "com.WebDriverAgentServiceAdapterMappingQueue")
    
    func checkConnectionStatus() -> Observable<WebDriverAgentStatus> {
        return Observable.create { observer -> Disposable in
            let path = self.buildRequestURL(path: WebDriverAgentServicePaths.status.rawValue).absoluteString
            let task = Alamofire.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON(queue: self.mappingQueue) { response in
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
        return Observable.create { observer -> Disposable in
            let path = self.buildSessionRequestURL(path: WebDriverAgentServicePaths.screenshot.rawValue)
            let task = Alamofire.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON(queue: self.mappingQueue) { response in
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
    
    func sendScreenClick(point: NSPoint) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            let path = self.buildSessionRequestURL(path: WebDriverAgentServicePaths.screenClick.rawValue)
            let params = [
                WebDriverAgentServiceParams.x.rawValue: point.x,
                WebDriverAgentServiceParams.y.rawValue: point.y,
            ]
            
            let task = Alamofire.request(path, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .responseJSON(queue: self.mappingQueue) { response in
                    switch(response.result) {
                    case .success(_):
                        observer.onNext(())
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
    
    func loadScreenLogicSize() -> Observable<WebDriverAgentScreenSize> {
        return Observable.create { observer -> Disposable in
            let path = self.buildSessionRequestURL(path: WebDriverAgentServicePaths.screenLogicSize.rawValue)
            
            let task = Alamofire.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON(queue: self.mappingQueue) { response in
                    switch(response.result) {
                    case .success(_):
                        observer.onNext(WebDriverAgentScreenSize(responseJSON: response.result.value!))
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
        
    private func buildSessionRequestURL(path: String) -> URL {
        let sessionId = RootServiceDomain.sharedDomain.webDriverAgentService.sessionId!
        let path = NSURL(string: WebDriverAgentServicePaths.session.rawValue)!.appendingPathComponent(sessionId)!.appendingPathComponent(path)
        return buildRequestURL(path: path.absoluteString)
    }
}
