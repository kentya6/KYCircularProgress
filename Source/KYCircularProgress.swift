//  KYCircularProgress.swift
//
//  Copyright (c) 2014-2016 Kengo Yokoyama.
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
@IBDesignable
open class KYCircularProgress: UIView {
    
    /**
    Typealias of progressChangedClosure.
    */
    public typealias progressChangedHandler = (_ progress: Double, _ circularProgress: KYCircularProgress) -> Void
    
    /**
    This closure is called when set value to `progress` property.
    */
    fileprivate var progressChanged: progressChangedHandler?
    
    /**
    Main progress view.
    */
    fileprivate lazy var progressView: KYCircularShapeView = {
        let progressView = KYCircularShapeView(frame: self.bounds)
        progressView.shapeLayer.fillColor = UIColor.clear.cgColor
        progressView.shapeLayer.path = self.path?.cgPath
        progressView.shapeLayer.lineWidth = CGFloat(self.lineWidth)
        progressView.shapeLayer.strokeColor = self.tintColor.cgColor
        return progressView
    }()
    
    /**
    Gradient mask layer of `progressView`.
    */
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer(layer: self.layer)
        gradientLayer.frame = self.progressView.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = self.progressView.shapeLayer
        gradientLayer.colors = self.colors
        self.layer.addSublayer(gradientLayer)
        return gradientLayer
    }()
    
    /**
    Guide view of `progressView`.
    */
    fileprivate lazy var progressGuideView: KYCircularShapeView = {
        let progressGuideView = KYCircularShapeView(frame: self.bounds)
        progressGuideView.shapeLayer.fillColor = UIColor.clear.cgColor
        progressGuideView.shapeLayer.path = self.progressView.shapeLayer.path
        progressGuideView.shapeLayer.lineWidth = CGFloat(self.guideLineWidth)
        progressGuideView.shapeLayer.strokeColor = self.tintColor.cgColor
        progressGuideView.update(progress: 1.0)
        return progressGuideView
    }()
    
    /**
    Mask layer of `progressGuideView`.
    */
    fileprivate lazy var guideLayer: CALayer = {
        let guideLayer = CAGradientLayer(layer: self.layer)
        guideLayer.frame = self.progressGuideView.frame
        guideLayer.mask = self.progressGuideView.shapeLayer
        guideLayer.backgroundColor = self.progressGuideColor.cgColor
        guideLayer.zPosition = -1
        self.layer.addSublayer(guideLayer)
        return guideLayer
    }()
    
    /**
    Current progress value. (0.0 - 1.0)
    */
    @IBInspectable open var progress: Double = 0.0 {
        didSet {
            let clipProgress = max( min(progress, Double(1.0)), Double(0.0) )
            progressView.update(progress: clipProgress)
            
            progressChanged?(clipProgress, self)
        }
    }
    
    /**
    Progress start angle.
    */
    open var startAngle: Double = 0.0 {
        didSet {
            progressView.startAngle = startAngle
            progressGuideView.startAngle = startAngle
        }
    }
    
    /**
    Progress end angle.
    */
    open var endAngle: Double = 0.0 {
        didSet {
            progressView.endAngle = endAngle
            progressGuideView.endAngle = endAngle
        }
    }
    
    /**
    Main progress line width.
    */
    @IBInspectable open var lineWidth: Double = 8.0 {
        didSet {
            progressView.shapeLayer.lineWidth = CGFloat(lineWidth)
        }
    }
    
    /**
    Guide progress line width.
    */
    @IBInspectable open var guideLineWidth: Double = 8.0 {
        didSet {
            progressGuideView.shapeLayer.lineWidth = CGFloat(guideLineWidth)
        }
    }
    
    /**
    Progress bar path. You can create various type of progress bar.
    */
    open var path: UIBezierPath? {
        didSet {
            progressView.shapeLayer.path = path?.cgPath
            progressGuideView.shapeLayer.path = path?.cgPath
        }
    }
    
    /**
    Progress bar colors. You can set many colors in `colors` property, and it makes gradation color in `colors`.
    */
    open var colors: [UIColor] = [UIColor(rgba: 0x9ACDE7FF), UIColor(rgba: 0xE7A5C9FF)] {
        didSet {
            update(colors: colors)
        }
    }
    
    /**
    Progress guide bar color.
    */
    @IBInspectable open var progressGuideColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2) {
        didSet {
            guideLayer.backgroundColor = progressGuideColor.cgColor
        }
    }

    /**
    Switch of progress guide view. If you set to `true`, progress guide view is enabled.
    */
    @IBInspectable open var showProgressGuide: Bool = false {
        didSet {
            progressGuideView.isHidden = !showProgressGuide
            guideLayer.backgroundColor = showProgressGuide ? progressGuideColor.cgColor : UIColor.clear.cgColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setNeedsLayout()
        layoutIfNeeded()
        
        update(colors: colors)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        progressGuideView.shapeLayer.path = progressView.shapeLayer.path
    }
    
    /**
    Create `KYCircularProgress` with progress guide.
    
    - parameter frame: `KYCircularProgress` frame.
    - parameter showProgressGuide: If you set to `true`, progress guide view is enabled.
    */
    public init(frame: CGRect, showProgressGuide: Bool) {
        super.init(frame: frame)
        self.showProgressGuide = showProgressGuide
        guideLayer.backgroundColor = showProgressGuide ? progressGuideColor.cgColor : UIColor.clear.cgColor
    }
    
    /**
    This closure is called when set value to `progress` property.
    
    - parameter completion: progress changed closure.
    */
    open func progressChanged(completion: @escaping progressChangedHandler) {
        progressChanged = completion
    }

    fileprivate func update(colors: [UIColor]) {
        gradientLayer.colors = colors.map {$0.cgColor}
        if colors.count == 1 {
            gradientLayer.colors?.append(colors.first!.cgColor)
        }
    }
}

// MARK: - KYCircularShapeView
class KYCircularShapeView: UIView {
    var startAngle = 0.0
    var endAngle = 0.0
    
    override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
    
    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        update(progress: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if startAngle == endAngle {
            endAngle = startAngle + (M_PI * 2)
        }

        shapeLayer.path = shapeLayer.path ?? layoutPath().cgPath
    }
    
    private func layoutPath() -> UIBezierPath {
        let halfWidth = CGFloat(frame.width / 2.0)
        return UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: halfWidth - shapeLayer.lineWidth, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
    }
    
    fileprivate func update(progress: Double) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        shapeLayer.strokeEnd = CGFloat(progress)
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
