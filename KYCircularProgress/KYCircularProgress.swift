//  KYCircularProgress.swift
//
//  Copyright (c) 2014-2015 Kengo Yokoyama.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit

// MARK: - KYCircularProgress
public class KYCircularProgress: UIView {
    public typealias progressChangedHandler = (progress: Double, circularView: KYCircularProgress) -> ()
    private var progressChangedClosure: progressChangedHandler?
    private var progressView: KYCircularShapeView!
    private var gradientLayer: CAGradientLayer!
    private var progressGuideView: KYCircularShapeView?
    private var guideLayer: CALayer?
    
    
    public var progress: Double = 0.0 {
        didSet {
            let clipProgress = max( min(oldValue, Double(1.0)), Double(0.0))
            progressView.updateProgress(clipProgress)
            
            progressChangedClosure?(progress: clipProgress, circularView: self)
        }
    }
    
    public var startAngle: Double = 0.0 {
        didSet {
            progressView.startAngle = oldValue
            progressGuideView?.startAngle = oldValue
        }
    }
    
    public var endAngle: Double = 0.0 {
        didSet {
            progressView.endAngle = oldValue
            progressGuideView?.endAngle = oldValue
        }
    }
    
    public var lineWidth: Double = 8.0 {
        willSet {
            progressView.shapeLayer().lineWidth = CGFloat(newValue)
        }
    }
    
    public var guideLineWidth: Double = 8.0 {
        willSet {
            progressGuideView?.shapeLayer().lineWidth = CGFloat(newValue)
        }
    }
    
    public var path: UIBezierPath? {
        willSet {
            progressView.shapeLayer().path = newValue?.CGPath
            progressGuideView?.shapeLayer().path = newValue?.CGPath
        }
    }
    
    public var colors: [UIColor]? {
        willSet {
            updateColors(newValue)
        }
    }
    
    public var progressGuideColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2) {
        willSet {
            guideLayer?.backgroundColor = newValue.CGColor
        }
    }

    public var showProgressGuide: Bool = false {
        willSet {
            configureProgressGuideLayer(newValue)
        }
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureProgressLayer()
        configureProgressGuideLayer(showProgressGuide)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureProgressLayer()
        configureProgressGuideLayer(showProgressGuide)
    }
    
    public init(frame: CGRect, showProgressGuide: Bool) {
        super.init(frame: frame)
        configureProgressLayer()
        self.showProgressGuide = showProgressGuide
        configureProgressGuideLayer(self.showProgressGuide)
    }

    private func configureProgressLayer() {
        progressView = KYCircularShapeView(frame: bounds)
        progressView.shapeLayer().fillColor = UIColor.clearColor().CGColor
        progressView.shapeLayer().path = path?.CGPath
        progressView.shapeLayer().strokeColor = tintColor.CGColor

        gradientLayer = CAGradientLayer(layer: layer)
        gradientLayer.frame = progressView.frame
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.mask = progressView.shapeLayer();
        gradientLayer.colors = colors ?? [UIColor(rgba: 0x9ACDE755).CGColor, UIColor(rgba: 0xE7A5C955).CGColor]
        
        layer.addSublayer(gradientLayer)
    }
    
    private func configureProgressGuideLayer(showProgressGuide: Bool) {
        if showProgressGuide && progressGuideView == nil {
            progressGuideView = KYCircularShapeView(frame: bounds)
            progressGuideView!.shapeLayer().fillColor = UIColor.clearColor().CGColor
            progressGuideView!.shapeLayer().path = path?.CGPath
            progressGuideView!.shapeLayer().lineWidth = CGFloat(lineWidth)
            progressGuideView!.shapeLayer().strokeColor = tintColor.CGColor

            guideLayer = CAGradientLayer(layer: layer)
            guideLayer!.frame = progressGuideView!.frame
            guideLayer!.mask = progressGuideView!.shapeLayer()
            guideLayer!.backgroundColor = progressGuideColor.CGColor
            guideLayer!.zPosition = -1

            progressGuideView!.updateProgress(1.0)
            
            layer.addSublayer(guideLayer)
        }
    }
    
    public func progressChangedClosure(completion: progressChangedHandler) {
        progressChangedClosure = completion
    }
    
    private func updateColors(colors: [UIColor]?) -> () {
        var convertedColors: [CGColorRef] = []
        if let inputColors = colors {
            for color in inputColors {
                convertedColors.append(color.CGColor)
            }
        } else {
            convertedColors = [UIColor(rgba: 0x9ACDE7FF).CGColor, UIColor(rgba: 0xE7A5C9FF).CGColor]
        }
        gradientLayer.colors = convertedColors
    }
}

// MARK: - KYCircularShapeView
class KYCircularShapeView: UIView {
    var startAngle = 0.0
    var endAngle = 0.0
    
    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    private func shapeLayer() -> CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateProgress(0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if startAngle == endAngle {
            endAngle = startAngle + (M_PI * 2)
        }
        shapeLayer().path = shapeLayer().path ?? layoutPath().CGPath
    }
    
    private func layoutPath() -> UIBezierPath {
        let halfWidth = CGFloat(CGRectGetWidth(frame) / 2.0)
        return UIBezierPath(arcCenter: CGPointMake(halfWidth, halfWidth), radius: halfWidth - shapeLayer().lineWidth, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
    }
    
    private func updateProgress(progress: Double) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        shapeLayer().strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience public init(rgba: Int64) {
        let red   = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue  = CGFloat((rgba & 0x0000FF00) >> 8)  / 255.0
        let alpha = CGFloat( rgba & 0x000000FF)        / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
