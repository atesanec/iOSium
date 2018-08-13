//
//  DeviceInteractionImageViewContainer.swift
//  iOSium
//
//  Created by VI_Business on 13/08/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import AppKit
import RxSwift

/**
 *  Positions imageView at the center of container
 */
class DeviceInteractionImageViewContainer: NSView {
    private let imageView = NSImageView()
    private let imageViewClickRecognizer = NSClickGestureRecognizer()
    
    var image: NSImage? {
        get {
            return self.imageView.image
        }
        
        set {
            self.imageView.image = newValue
            self.needsLayout = true
        }
    }
    
    let imageViewClick = PublishSubject<NSPoint>()
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commonInit()
    }
    
    override func layout() {
        super.layout()
        
        if let image = self.imageView.image {
            let imageSize = image.size
            let maxSize = self.bounds.size
            let scaleRatio = min(maxSize.width / imageSize.width, maxSize.height / imageSize.height)
            let imageViewSize = NSSize(width: imageSize.width * scaleRatio, height: imageSize.height * scaleRatio)
            
            let imageViewFrame = CGRect(origin: CGPoint(x: self.bounds.midX - imageViewSize.width / 2,
                                                        y: self.bounds.midY - imageViewSize.height / 2),
                                        size: imageViewSize)
            self.imageView.frame = imageViewFrame
        }
    }
    
    private func commonInit() {
        self.addSubview(imageView)
        self.imageView.acceptsTouchEvents = true
        self.imageView.addGestureRecognizer(self.imageViewClickRecognizer)
        
        self.imageViewClickRecognizer.target = self
        self.imageViewClickRecognizer.action = #selector(onImageViewClick(sender:))
    }
    
    @objc private func onImageViewClick(sender: NSClickGestureRecognizer) {
        var point = sender.location(in: sender.view)
        point.x /= self.imageView.bounds.width
        point.y /= self.imageView.bounds.height
        
        imageViewClick.onNext(point)
    }
}
