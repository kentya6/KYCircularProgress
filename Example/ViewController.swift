//
//  ViewController.swift
//  KYCircularProgress
//
//  Created by Kengo Yokoyama on 2014/10/02.
//  Copyright (c) 2014 Kengo Yokoyama. All rights reserved.
//

import UIKit
import KYCircularProgress

class ViewController: UIViewController {

    private var halfCircularProgress: KYCircularProgress!
    private var fourColorCircularProgress: KYCircularProgress!
    private var starProgress: KYCircularProgress!
    private var progress: UInt8 = 0
    @IBOutlet private weak var storyboardCircularProgress: KYCircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHalfCircularProgress()
        configureFourColorCircularProgress()
        configureStarProgress()
        
        NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
    }

    private func configureHalfCircularProgress() {
        let halfCircularProgressFrame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)/2)
        halfCircularProgress = KYCircularProgress(frame: halfCircularProgressFrame)
        
        let center = CGPoint(x: 160.0, y: 200.0)
        halfCircularProgress.path = UIBezierPath(arcCenter: center, radius: CGFloat(CGRectGetWidth(halfCircularProgress.frame)/3), startAngle: CGFloat(M_PI), endAngle: CGFloat(0.0), clockwise: true)
        halfCircularProgress.colors = [UIColor(rgba: 0xA6E39DAA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABAA)]
        halfCircularProgress.lineWidth = 8.0
        halfCircularProgress.showProgressGuide = true
        halfCircularProgress.progressGuideColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
        
        let textLabel = UILabel(frame: CGRectMake(halfCircularProgress.frame.origin.x + 120.0, 170.0, 80.0, 32.0))
        textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.greenColor()
        textLabel.alpha = 0.3
        halfCircularProgress.addSubview(textLabel)

        halfCircularProgress.progressChangedClosure() {
            (progress: Double, circularView: KYCircularProgress) in
            println("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))%"
        }
        
        view.addSubview(halfCircularProgress)
    }
    
    private func configureFourColorCircularProgress() {
        let fourColorCircularProgressFrame = CGRectMake(0, CGRectGetHeight(halfCircularProgress.frame), CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/3)
        fourColorCircularProgress = KYCircularProgress(frame: fourColorCircularProgressFrame)
        
        fourColorCircularProgress.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        
        view.addSubview(fourColorCircularProgress)
    }
    
    private func configureStarProgress() {
        let starProgressFrame = CGRectMake(CGRectGetWidth(fourColorCircularProgress.frame)*1.25, CGRectGetHeight(halfCircularProgress.frame)*1.15, CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2)
        starProgress = KYCircularProgress(frame: starProgressFrame)
        
        starProgress.colors = [UIColor.purpleColor(), UIColor(rgba: 0xFFF77A55), UIColor.orangeColor()]
        starProgress.lineWidth = 3.0
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(50.0, 2.0))
        path.addLineToPoint(CGPointMake(84.0, 86.0))
        path.addLineToPoint(CGPointMake(6.0, 33.0))
        path.addLineToPoint(CGPointMake(96.0, 33.0))
        path.addLineToPoint(CGPointMake(17.0, 86.0))
        path.closePath()
        starProgress.path = path
        
        view.addSubview(starProgress)
    }
    
    func updateProgress() {
        progress = progress &+ 1
        let normalizedProgress = Double(progress) / 255.0
        
        halfCircularProgress.progress = normalizedProgress
        fourColorCircularProgress.progress = normalizedProgress
        starProgress.progress = normalizedProgress
        storyboardCircularProgress.progress = normalizedProgress
    }
}
