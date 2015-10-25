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

import UIKit

// MARK: - KYCircularProgress
public class KYCircularProgress: UIView {
    
    /**
    Typealias of progressChangedClosure.
    */
    public typealias progressChangedHandler = (progress: Double, circularView: KYCircularProgress) -> Void
    
    /**
    This closure is called when set value to `progress` property.
    */
    private var progressChangedClosure: progressChangedHandler?
    
    /**
    Main progress view.
    */
    private var progressView: KYCircularShapeView!
    
    /**
    Gradient mask layer of `progressView`.
    */
    private var gradientLayer: CAGradientLayer!
    
    /**
    Guide view of `progressView`.
    */
    private var progressGuideView: KYCircularShapeView?
    
    /**
    Mask layer of `progressGuideView`.
    */
    private var guideLayer: CALayer?
    
    /**
    Current progress value. (0.0 - 1.0)
    */
    @IBInspectable public var progress: Double = 0.0 {
        didSet {
            let clipProgress = max( min(progress, Double(1.0)), Double(0.0) )
            progressView.updateProgress(clipProgress)
            
            progressChangedClosure?(progress: clipProgress, circularView: self)
        }
    }
    
    /**
    Progress start angle.
    */
    public var startAngle: Double = 0.0 {
        didSet {
            progressView.startAngle = startAngle
            progressGuideView?.startAngle = startAngle
        }
    }
    
    /**
    Progress end angle.
    */
    public var endAngle: Double = 0.0 {
        didSet {
            progressView.endAngle = endAngle
            progressGuideView?.endAngle = endAngle
        }
    }
    
    /**
    Main progress line width.
    */
    @IBInspectable public var lineWidth: Double = 8.0 {
        didSet {
            progressView.shapeLayer().lineWidth = CGFloat(lineWidth)
        }
    }
    
    /**
    Guide progress line width.
    */
    @IBInspectable public var guideLineWidth: Double = 8.0 {
        didSet {
            progressGuideView?.shapeLayer().lineWidth = CGFloat(guideLineWidth)
        }
    }
    
    /**
    Progress bar path. You can create various type of progress bar.
    */
    public var path: UIBezierPath? {
        didSet {
            progressView.shapeLayer().path = path?.CGPath
            progressGuideView?.shapeLayer().path = path?.CGPath
        }
    }
    
    /**
    Progress bar colors. You can set many colors in `colors` property, and it makes gradation color in `colors`.
    */
    public var colors: [UIColor]? {
        didSet {
            updateColors(colors)
        }
    }
    
    /**
    Progress guide bar color.
    */
    @IBInspectable public var progressGuideColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2) {
        didSet {
            guideLayer?.backgroundColor = progressGuideColor.CGColor
        }
    }

    /**
    Switch of progress guide view. If you set to `true`, progress guide view is enabled.
    */
    @IBInspectable public var showProgressGuide: Bool = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
            configureProgressGuideLayer(showProgressGuide)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureProgressLayer()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureProgressLayer()
    }
    
    /**
    Create `KYCircularProgress` with progress guide.
    
    - parameter frame: `KYCircularProgress` frame.
    - parameter showProgressGuide: If you set to `true`, progress guide view is enabled.
    */
    public init(frame: CGRect, showProgressGuide: Bool) {
        super.init(frame: frame)
        configureProgressLayer()
        configureProgressGuideLayer(showProgressGuide)
    }
    
    /**
    This closure is called when set value to `progress` property.
    
    - parameter completion: progress changed closure.
    */
    public func progressChangedClosure(completion: progressChangedHandler) {
        progressChangedClosure = completion
    }
    
    private func configureProgressLayer() {
        progressView = KYCircularShapeView(frame: bounds)
        progressView.shapeLayer().fillColor = UIColor.clearColor().CGColor
        progressView.shapeLayer().path = path?.CGPath
        progressView.shapeLayer().lineWidth = CGFloat(lineWidth)
        progressView.shapeLayer().strokeColor = tintColor.CGColor

        gradientLayer = CAGradientLayer(layer: layer)
        gradientLayer.frame = progressView.frame
        gradientLayer.startPoint = CGPointMake(0, 0.5)
        gradientLayer.endPoint = CGPointMake(1, 0.5)
        gradientLayer.mask = progressView.shapeLayer()
        gradientLayer.colors = colors ?? [UIColor(rgba: 0x9ACDE755).CGColor, UIColor(rgba: 0xE7A5C955).CGColor]
        
        layer.addSublayer(gradientLayer)
    }
    
    private func configureProgressGuideLayer(showProgressGuide: Bool) {
        if showProgressGuide && progressGuideView == nil {
            progressGuideView = KYCircularShapeView(frame: bounds)
            progressGuideView!.shapeLayer().fillColor = UIColor.clearColor().CGColor
            progressGuideView!.shapeLayer().path = progressView.shapeLayer().path
            progressGuideView!.shapeLayer().lineWidth = CGFloat(guideLineWidth)
            progressGuideView!.shapeLayer().strokeColor = tintColor.CGColor

            guideLayer = CAGradientLayer(layer: layer)
            guideLayer!.frame = progressGuideView!.frame
            guideLayer!.mask = progressGuideView!.shapeLayer()
            guideLayer!.backgroundColor = progressGuideColor.CGColor
            guideLayer!.zPosition = -1

            progressGuideView!.updateProgress(1.0)
            
            layer.addSublayer(guideLayer!)
        }
    }
    
    private func updateColors(colors: [UIColor]?) {
        var convertedColors: [CGColorRef] = []
        if let colors = colors {
            for color in colors {
                convertedColors.append(color.CGColor)
            }
            if convertedColors.count == 1 {
                convertedColors.append(convertedColors.first!)
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
    
    required init?(coder aDecoder: NSCoder) {
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
