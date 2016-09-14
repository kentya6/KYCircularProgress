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

    fileprivate var halfCircularProgress: KYCircularProgress!
    fileprivate var fourColorCircularProgress: KYCircularProgress!
    fileprivate var starProgress: KYCircularProgress!
    fileprivate var progress: UInt8 = 0
    @IBOutlet fileprivate weak var storyboardCircularProgress: KYCircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHalfCircularProgress()
        configureFourColorCircularProgress()
        configureStarProgress()
        
        Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
    }

    fileprivate func configureHalfCircularProgress() {
        let halfCircularProgressFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        halfCircularProgress = KYCircularProgress(frame: halfCircularProgressFrame, showProgressGuide: true)
        
        let center = CGPoint(x: 160.0, y: 200.0)
        halfCircularProgress.path = UIBezierPath(arcCenter: center, radius: CGFloat((halfCircularProgress.frame).width/3), startAngle: CGFloat(M_PI), endAngle: CGFloat(0.0), clockwise: true)
        halfCircularProgress.colors = [UIColor(rgba: 0xA6E39DAA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABAA)]
        halfCircularProgress.lineWidth = 8.0
        halfCircularProgress.progressGuideColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
        
        let textLabel = UILabel(frame: CGRect(x: halfCircularProgress.frame.origin.x + 120.0, y: 170.0, width: 80.0, height: 32.0))
        textLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 32)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.green
        textLabel.alpha = 0.3
        halfCircularProgress.addSubview(textLabel)

        halfCircularProgress.progressChangedClosure() {
            (progress: Double, circularView: KYCircularProgress) in
            print("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))%"
        }
        
        view.addSubview(halfCircularProgress)
    }
    
    fileprivate func configureFourColorCircularProgress() {
        let fourColorCircularProgressFrame = CGRect(x: 0, y: (halfCircularProgress.frame).height, width: (view.frame).width/2, height: (view.frame).height/3)
        fourColorCircularProgress = KYCircularProgress(frame: fourColorCircularProgressFrame)
        
        fourColorCircularProgress.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        
        view.addSubview(fourColorCircularProgress)
    }
    
    fileprivate func configureStarProgress() {
        let starProgressFrame = CGRect(x: (fourColorCircularProgress.frame).width*1.25, y: (halfCircularProgress.frame).height*1.15, width: (view.frame).width/2, height: (view.frame).height/2)
        starProgress = KYCircularProgress(frame: starProgressFrame)
        
        starProgress.colors = [UIColor.purple, UIColor(rgba: 0xFFF77A55), UIColor.orange]
        starProgress.lineWidth = 3.0
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50.0, y: 2.0))
        path.addLine(to: CGPoint(x: 84.0, y: 86.0))
        path.addLine(to: CGPoint(x: 6.0, y: 33.0))
        path.addLine(to: CGPoint(x: 96.0, y: 33.0))
        path.addLine(to: CGPoint(x: 17.0, y: 86.0))
        path.close()
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
