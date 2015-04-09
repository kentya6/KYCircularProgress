//
//  ViewController.swift
//  KYCircularProgress
//
//  Created by Kengo Yokoyama on 2014/10/02.
//  Copyright (c) 2014 Kengo Yokoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var circularProgress1: KYCircularProgress!
    var circularProgress2: KYCircularProgress!
    var circularProgress3: KYCircularProgress!
    var progress: UInt8 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureKYCircularProgress1()
        configureKYCircularProgress2()
        configureKYCircularProgress3()
        
        NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
    }

    func configureKYCircularProgress1() {
        circularProgress1 = KYCircularProgress(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2))
        let center = (CGFloat(160.0), CGFloat(200.0))
        circularProgress1.path = UIBezierPath(arcCenter: CGPointMake(center.0, center.1), radius: CGFloat(circularProgress1.frame.size.width/3.0), startAngle: CGFloat(M_PI), endAngle: CGFloat(0.0), clockwise: true)
        circularProgress1.colors = [UIColor(rgba: 0xA6E39DAA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABAA)]
        circularProgress1.lineWidth = 8.0
        circularProgress1.showProgressGuide = true
        circularProgress1.progressGuideColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
        
        let textLabel = UILabel(frame: CGRectMake(circularProgress1.frame.origin.x + 120.0, 170.0, 80.0, 32.0))
        textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.greenColor()
        textLabel.alpha = 0.3
        self.view.addSubview(textLabel)
        
        circularProgress1.progressChangedClosure({ (progress: Double, circularView: KYCircularProgress) in
            println("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))%"
        })
        
        self.view.addSubview(circularProgress1)
    }
    
    func configureKYCircularProgress2() {
        circularProgress2 = KYCircularProgress(frame: CGRectMake(0, circularProgress1.frame.size.height, self.view.frame.size.width/2, self.view.frame.size.height/3))
        circularProgress2.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        
        self.view.addSubview(circularProgress2)
    }
    
    func configureKYCircularProgress3() {
        circularProgress3 = KYCircularProgress(frame: CGRectMake(circularProgress2.frame.size.width*1.25, circularProgress1.frame.size.height*1.15, self.view.frame.size.width/2, self.view.frame.size.height/2))
        circularProgress3.colors = [UIColor.purpleColor(), UIColor(rgba: 0xFFF77A55), UIColor.orangeColor()]
        circularProgress3.lineWidth = 3.0
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(50.0, 2.0))
        path.addLineToPoint(CGPointMake(84.0, 86.0))
        path.addLineToPoint(CGPointMake(6.0, 33.0))
        path.addLineToPoint(CGPointMake(96.0, 33.0))
        path.addLineToPoint(CGPointMake(17.0, 86.0))
        path.closePath()
        circularProgress3.path = path
        
        self.view.addSubview(circularProgress3)
    }
    
    func updateProgress() {
        progress = progress &+ 1
        let normalizedProgress = Double(progress) / 255.0
        
        circularProgress1.progress = normalizedProgress
        circularProgress2.progress = normalizedProgress
        circularProgress3.progress = normalizedProgress
    }
}
