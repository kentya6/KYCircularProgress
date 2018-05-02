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
    private var animationProgress: UInt8 = 0
    @IBOutlet private weak var storyboardCircularProgress1: KYCircularProgress!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var storyboardCircularProgress2: KYCircularProgress!
    @IBOutlet private weak var progressLabel2: UILabel!
    @IBOutlet private weak var storyboardCircularProgress3: KYCircularProgress!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHalfCircularProgress()
        configureFourColorCircularProgress()
        configureStarProgress()
        configureStoryboardProgress1()
        configureStoryboardProgress2()
        configureStoryboardProgress3()
        
        Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateAnimationProgress), userInfo: nil, repeats: true)
    }

    private func configureHalfCircularProgress() {
        halfCircularProgress = KYCircularProgress(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2), showGuide: true)
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 4)
        halfCircularProgress.path = UIBezierPath(arcCenter: center, radius: CGFloat((halfCircularProgress.frame).width/3), startAngle: CGFloat(Double.pi), endAngle: CGFloat(0.0), clockwise: true)
        halfCircularProgress.colors = [UIColor(rgba: 0xA6E39DAA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABAA)]
        halfCircularProgress.guideColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.4)
      
        let labelWidth = CGFloat(80.0)
        let textLabel = UILabel(frame: CGRect(x: (view.frame.width - labelWidth) / 2, y: (view.frame.height - labelWidth) / 4, width: labelWidth, height: 32.0))
        textLabel.font = UIFont(name: "HelveticaNeue", size: 24)
        textLabel.textAlignment = .center
        textLabel.textColor = .green
        textLabel.alpha = 0.3
        halfCircularProgress.addSubview(textLabel)

        halfCircularProgress.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
            print("progress: \(progress)")
            textLabel.text = "\(Int(progress * 100.0))%"
        }
        
        view.addSubview(halfCircularProgress)
    }
    
    private func configureFourColorCircularProgress() {
        fourColorCircularProgress = KYCircularProgress(frame: CGRect(x: 20.0, y: halfCircularProgress.frame.height/1.75, width: view.frame.width/3, height: view.frame.height/3))
        fourColorCircularProgress.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]
        fourColorCircularProgress.lineCap = kCALineCapRound
      
        view.addSubview(fourColorCircularProgress)
    }
    
    private func configureStarProgress() {
        starProgress = KYCircularProgress(frame: CGRect(x: view.frame.width - 150.0, y: halfCircularProgress.frame.height/1.5, width: view.frame.width/3, height: view.frame.height/3))
        
        starProgress.colors = [.purple, UIColor(rgba: 0xFFF77A55), .orange]
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
    
    private func configureStoryboardProgress1() {
        storyboardCircularProgress1.progressChanged {
            (progress: Double, circularProgress: KYCircularProgress) in
            self.progressLabel.text = String.init(format: "%.2f", progress * 100.0) + "%"
        }
    }
    
    private func configureStoryboardProgress2() {
        storyboardCircularProgress2.delegate = self
    }
    
    private func configureStoryboardProgress3() {
        storyboardCircularProgress3.delegate = self
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50.0, y: 2.0))
        path.addLine(to: CGPoint(x: 84.0, y: 86.0))
        path.addLine(to: CGPoint(x: 6.0, y: 33.0))
        path.addLine(to: CGPoint(x: 96.0, y: 33.0))
        path.addLine(to: CGPoint(x: 17.0, y: 86.0))
        path.close()
        storyboardCircularProgress3.path = path
        
        storyboardCircularProgress3.colors = [.white, .groupTableViewBackground, .gray, .darkGray]
    }
    
    @objc private func updateProgress() {
        progress = progress &+ 1
        let normalizedProgress = Double(progress) / Double(UInt8.max)
        
        halfCircularProgress.progress = normalizedProgress
        fourColorCircularProgress.progress = normalizedProgress
        starProgress.progress = normalizedProgress
        storyboardCircularProgress1.progress = normalizedProgress
    }
    
    @objc private func updateAnimationProgress() {
        animationProgress = animationProgress &+ 50
        let normalizedProgress = Double(animationProgress) / Double(UInt8.max)
        
        storyboardCircularProgress2.set(progress: normalizedProgress, duration: 0.75)
        storyboardCircularProgress3.set(progress: normalizedProgress, duration: 0.25)
    }
}

extension ViewController: KYCircularProgressDelegate {
    func progressChanged(progress: Double, circularProgress: KYCircularProgress) {
        if circularProgress == storyboardCircularProgress2 {
            progressLabel2.text = "\(Int(progress * 100.0))%"
        }
    }
}
