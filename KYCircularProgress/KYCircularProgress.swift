//
//  KYCircularProgress.swift
//  KYCircularProgress
//
//  Created by Kengo Yokoyama on 2014/10/02.
//  Copyright (c) 2014 Kengo Yokoyama. All rights reserved.
//

import Foundation
import UIKit

// MARK: - KYCircularProgress
class KYCircularProgress: UIView {
    typealias progressChangedHandler = (progress: Double, circularView: KYCircularProgress) -> ()
    private var progressChangedClosure: progressChangedHandler?
    private var progressView: KYCircularShapeView!
    private var gradientLayer: CAGradientLayer!
    private var progressGuideView: KYCircularShapeView?
    private var guideLayer: CALayer?
    
    
    var progress: Double = 0.0 {
        didSet {
            // MARK: - This code can **not** compile on Swift1.1 compiler with -O optimization option. Wait Swift1.2 compiler.
            // see (http://stackoverflow.com/questions/28516677/swift-issue-using-max-and-min-sequentially-while-archiving-on-xcode)
//            let clipProgress = max( min(oldValue, Double(1.0)), Double(0.0))            
            
            // MARK: - This code can compile on Swift1.1 compiler with -O optimization option.
            if self.progress < 0.0 {
                self.progress = 0.0
            } else if self.progress > 1.0 {
                self.progress = 1.0
            }
            
            self.progressView.updateProgress(self.progress)
            
            if let progressChanged = progressChangedClosure {
                progressChanged(progress: self.progress, circularView: self)
            }
        }
    }
    var startAngle: Double = 0.0 {
        didSet {
            self.progressView.startAngle = oldValue
            self.progressGuideView?.startAngle = oldValue
        }
    }
    var endAngle: Double = 0.0 {
        didSet {
            self.progressView.endAngle = oldValue
            self.progressGuideView?.endAngle = oldValue
        }
    }
    var lineWidth: Double = 8.0 {
        willSet {
            self.progressView.shapeLayer().lineWidth = CGFloat(newValue)
        }
    }
    var guideLineWidth: Double = 8.0 {
        willSet {
            self.progressGuideView?.shapeLayer().lineWidth = CGFloat(newValue)
        }
    }
    var path: UIBezierPath? {
        willSet {
            self.progressView.shapeLayer().path = newValue?.CGPath
            self.progressGuideView?.shapeLayer().path = newValue?.CGPath
        }
    }
    var colors: [Int]? {
        didSet {
            updateColors(oldValue)
        }
    }
    
    var progressGuideColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2) {
        willSet {
            self.guideLayer?.backgroundColor = newValue.CGColor
        }
    }
    
    var progressAlpha: CGFloat = 0.55 {
        didSet {
            updateColors(self.colors)
        }
    }

    var showProgressGuide: Bool = false {
        willSet {
            self.configureProgressGuideLayer(newValue)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureProgressLayer()
        self.configureProgressGuideLayer(self.showProgressGuide)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureProgressLayer()
        self.configureProgressGuideLayer(self.showProgressGuide)
    }
    
    init(frame: CGRect, showProgressGuide: Bool) {
        super.init(frame: frame)
        self.configureProgressLayer()
        self.showProgressGuide = showProgressGuide
        self.configureProgressGuideLayer(self.showProgressGuide)
    }

    private func configureProgressLayer() {
        self.progressView = KYCircularShapeView(frame: self.bounds)
        self.progressView.shapeLayer().fillColor = UIColor.clearColor().CGColor
        self.progressView.shapeLayer().path = self.path?.CGPath
        self.progressView.shapeLayer().strokeColor = self.tintColor.CGColor

        gradientLayer = CAGradientLayer(layer: layer)
        gradientLayer.frame = self.progressView.frame
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.mask = self.progressView.shapeLayer();
        gradientLayer.colors = self.colors ?? [colorHex(0x9ACDE7).CGColor!, colorHex(0xE7A5C9).CGColor!]
        
        self.layer.addSublayer(gradientLayer)
    }
    
    private func configureProgressGuideLayer(showProgressGuide: Bool) {
        if showProgressGuide && self.progressGuideView == nil {
            self.progressGuideView = KYCircularShapeView(frame: self.bounds)
            self.progressGuideView!.shapeLayer().fillColor = UIColor.clearColor().CGColor
            self.progressGuideView!.shapeLayer().path = self.path?.CGPath
            self.progressGuideView!.shapeLayer().lineWidth = CGFloat(self.lineWidth)
            self.progressGuideView!.shapeLayer().strokeColor = self.tintColor.CGColor

            guideLayer = CAGradientLayer(layer: layer)
            guideLayer!.frame = self.progressGuideView!.frame
            guideLayer!.mask = self.progressGuideView!.shapeLayer()
            guideLayer!.backgroundColor = self.progressGuideColor.CGColor
            guideLayer!.zPosition = -1
            
            self.progressGuideView!.updateProgress(1.0)
            
            self.layer.addSublayer(guideLayer)
        }
    }
    
    func progressChangedClosure(completion: progressChangedHandler) {
        progressChangedClosure = completion
    }
    
    private func colorHex(rgb: Int) -> UIColor {
        return UIColor(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat(rgb & 0xFF) / 255.0,
                       alpha: progressAlpha)
    }
    
    private func updateColors(colors: [Int]?) -> () {
        var convertedColors: [AnyObject] = []
        if let inputColors = self.colors {
            for hexColor in inputColors {
                convertedColors.append(self.colorHex(hexColor).CGColor!)
            }
        } else {
            convertedColors = [self.colorHex(0x9ACDE7).CGColor!, self.colorHex(0xE7A5C9).CGColor!]
        }
        self.gradientLayer.colors = convertedColors
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
        return self.layer as CAShapeLayer
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateProgress(0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.startAngle == self.endAngle {
            self.endAngle = self.startAngle + (M_PI * 2)
        }
        self.shapeLayer().path = self.shapeLayer().path ?? self.layoutPath().CGPath
    }
    
    private func layoutPath() -> UIBezierPath {
        var halfWidth = CGFloat(self.frame.size.width / 2.0)
        return UIBezierPath(arcCenter: CGPointMake(halfWidth, halfWidth), radius: halfWidth - self.shapeLayer().lineWidth, startAngle: CGFloat(self.startAngle), endAngle: CGFloat(self.endAngle), clockwise: true)
    }
    
    private func updateProgress(progress: Double) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.shapeLayer().strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
}
