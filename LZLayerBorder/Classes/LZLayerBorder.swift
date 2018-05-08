//
//  LZLayerBorder.swift
//  LZLayerBorder
//
//  Created by 9fbank-lizhao on 2018/5/7.
//

import Foundation
import UIKit

private var leftLayerKey: Void?
private var topLayerKey: Void?
private var rightLayerKey: Void?
private var bottomLayerKey: Void?

public struct LZBorderDirection: OptionSet {
    public var rawValue: UInt
    public init(rawValue: UInt){self.rawValue = rawValue}
    public static let left = LZBorderDirection(rawValue: 1 << 1)
    public static let top = LZBorderDirection(rawValue: 1 << 2)
    public static let right = LZBorderDirection(rawValue: 1 << 3)
    public static let bottom = LZBorderDirection(rawValue: 1 << 4)
}

class LZBorderLayer: CALayer {
    
    var lz_borderWidth: CGFloat
    var lz_borderInsets: UIEdgeInsets
    
    override init() {
        self.lz_borderWidth = 0.0
        self.lz_borderInsets = .zero
        super.init()
        self.anchorPoint = CGPoint.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol LZViewBorderDirection {
    var leftLayer: LZBorderLayer { get set }
    var topLayer: LZBorderLayer {get set}
    var rightLayer: LZBorderLayer {get set}
    var bottomLayer: LZBorderLayer {get set}
}

extension UIView: LZViewBorderDirection {
    
    public class func initializeMethod() {
        let originalSelector = #selector(UIView.layoutSubviews)
        let swizzledSelector = #selector(UIView.lz_layoutSubviews)
        
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    @objc func lz_layoutSubviews() {
        self.lz_layoutSubviews()
        var generalBounds = self.leftLayer.bounds
        var generalPoint = CGPoint.zero
        var generalInsets = self.leftLayer.lz_borderInsets
        
        //left
        generalBounds.size.height = self.layer.bounds.size.height - generalInsets.top - generalInsets.bottom
        generalBounds.size.width = self.leftLayer.lz_borderWidth
        self.leftLayer.bounds = generalBounds
        
        generalPoint.x = generalInsets.left
        generalPoint.y = generalInsets.top
        self.leftLayer.position = generalPoint
        
        generalBounds = self.topLayer.bounds
        generalPoint = self.topLayer.position
        generalInsets = self.topLayer.lz_borderInsets
        
        //top
        generalBounds.size.height = self.topLayer.lz_borderWidth
        generalBounds.size.width = self.layer.bounds.size.width - generalInsets.left - generalInsets.right
        self.topLayer.bounds = generalBounds
        
        generalPoint.x = generalInsets.left
        generalPoint.y = generalInsets.top
        self.topLayer.position = generalPoint
        
        generalBounds = self.rightLayer.bounds
        generalPoint = self.rightLayer.position
        generalInsets = self.rightLayer.lz_borderInsets
        
        //right
        generalBounds.size.height = self.layer.bounds.height - generalInsets.top - generalInsets.bottom
        generalBounds.size.width = self.rightLayer.lz_borderWidth
        self.rightLayer.bounds = generalBounds
        
        generalPoint.x = self.layer.bounds.size.width - generalInsets.right - generalBounds.size.width
        generalPoint.y = generalInsets.top
        self.rightLayer.position = generalPoint
        
        generalBounds = self.bottomLayer.bounds
        generalPoint = self.bottomLayer.position
        generalInsets = self.bottomLayer.lz_borderInsets
        
        //bottom
        generalBounds.size.height = self.bottomLayer.lz_borderWidth
        generalBounds.size.width = self.layer.bounds.size.width - generalInsets.left - generalInsets.right
        self.bottomLayer.bounds = generalBounds
        
        generalPoint.x = generalInsets.left
        generalPoint.y = self.layer.bounds.size.height - generalInsets.bottom - generalBounds.size.height
        self.bottomLayer.position = generalPoint
    }
    
    var leftLayer: LZBorderLayer {
        get {
            if objc_getAssociatedObject(self, &leftLayerKey) == nil {
                self.leftLayer = LZBorderLayer()
            }
            
            return objc_getAssociatedObject(self, &leftLayerKey) as! LZBorderLayer
        }
        set {
            objc_setAssociatedObject(self, &leftLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var topLayer: LZBorderLayer {
        get {
            if objc_getAssociatedObject(self, &topLayerKey) == nil {
                self.topLayer = LZBorderLayer()
            }
            return objc_getAssociatedObject(self, &topLayerKey) as! LZBorderLayer
        }
        set {
            objc_setAssociatedObject(self, &topLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var rightLayer: LZBorderLayer {
        get {
            if objc_getAssociatedObject(self, &rightLayerKey) == nil {
                self.rightLayer = LZBorderLayer()
            }
            return objc_getAssociatedObject(self, &rightLayerKey) as! LZBorderLayer
        }
        set {
            objc_setAssociatedObject(self, &rightLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bottomLayer: LZBorderLayer {
        get {
            if objc_getAssociatedObject(self, &bottomLayerKey) == nil {
                self.bottomLayer = LZBorderLayer()
            }
            return objc_getAssociatedObject(self, &bottomLayerKey) as! LZBorderLayer
        }
        set {
            objc_setAssociatedObject(self, &bottomLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func lz_addBorderWith(insets: UIEdgeInsets, borderColor: UIColor, directions: LZBorderDirection) {
        self.lz_addBorderWith(insets: insets, borderColor: borderColor, borderWidth: Float(self.layer.borderWidth), directions: directions)
    }
    
    func lz_addBorderWith(insets: UIEdgeInsets, borderWidth: Float, directions: LZBorderDirection) {
        self.lz_addBorderWith(insets: insets, borderColor:UIColor(cgColor: self.layer.borderColor!), borderWidth: borderWidth, directions: directions)
    }
    
    func lz_addBorderWith(borderColor: UIColor, borderWidth: Float, directions: LZBorderDirection) {
        self.lz_addBorderWith(insets: .zero, borderColor: borderColor, borderWidth: borderWidth, directions: directions)
    }
    
    public func lz_addBorderWith(insets: UIEdgeInsets, borderColor: UIColor, borderWidth: Float, directions: LZBorderDirection) {
        if directions.contains(.left) {
            self.leftLayer.backgroundColor = borderColor.cgColor
            self.leftLayer.lz_borderWidth = CGFloat(borderWidth)
            self.leftLayer.lz_borderInsets = insets
            if (self.leftLayer.superlayer != nil) {
                self.leftLayer.removeFromSuperlayer()
            }
            self.layer.addSublayer(self.leftLayer)
        }
        if directions.contains(.top) {
            self.topLayer.backgroundColor = borderColor.cgColor
            self.topLayer.lz_borderWidth = CGFloat(borderWidth)
            self.topLayer.lz_borderInsets = insets
            if (self.topLayer.superlayer != nil) {
                self.topLayer.removeFromSuperlayer()
            }
            self.layer.addSublayer(self.topLayer)
        }
        if directions.contains(.right) {
            self.rightLayer.backgroundColor = borderColor.cgColor
            self.rightLayer.lz_borderWidth = CGFloat(borderWidth)
            self.rightLayer.lz_borderInsets = insets
            if (self.rightLayer.superlayer != nil) {
                self.rightLayer.removeFromSuperlayer()
            }
            self.layer.addSublayer(self.rightLayer)
        }
        
        if directions.contains(.bottom) {
            self.bottomLayer.backgroundColor = borderColor.cgColor
            self.bottomLayer.lz_borderWidth = CGFloat(borderWidth)
            self.bottomLayer.lz_borderInsets = insets
            if (self.bottomLayer.superlayer != nil) {
                self.bottomLayer.removeFromSuperlayer()
            }
            self.layer.addSublayer(self.bottomLayer)
        }
        self.setNeedsLayout()
    }
    
    public func lz_removeBorder(directions: LZBorderDirection) {
        if directions.contains(.left) {
            self.lz_removeBorderLayer(layer: self.leftLayer)
        }
        if directions.contains(.top) {
            self.lz_removeBorderLayer(layer: self.topLayer)
        }
        if directions.contains(.right) {
            self.lz_removeBorderLayer(layer: self.rightLayer)
        }
        if directions.contains(.bottom) {
            self.lz_removeBorderLayer(layer: self.bottomLayer)
        }
    }
    
    public func lz_removeAllBorders() {
        self.lz_removeBorderLayer(layer: self.leftLayer)
        self.lz_removeBorderLayer(layer: self.topLayer)
        self.lz_removeBorderLayer(layer: self.rightLayer)
        self.lz_removeBorderLayer(layer: self.bottomLayer)
    }
    
    func lz_removeBorderLayer(layer:CALayer?) {
        if let layer = layer {
            layer.removeFromSuperlayer()
        }
    }
}


