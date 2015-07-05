KYCircularProgress
==================

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/KYCircularProgress.svg)](https://img.shields.io/cocoapods/v/KYCircularProgress.svg)
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/kentya6/KYCircularProgress.svg?style=flat
)](https://github.com/kentya6/KYCircularProgress/issues?state=open)

Flexible progress bar written in Swift.

## Features
- [x] Gradation Color
- [x] Progress Closure
- [x] UIBezierPath Progress Bar
- [x] Progress Gauge Guide
- [x] Customizable on Storyboard

## ToDo
1. Progress Change Animation

## Demo
<p align="center" >
<img src="https://raw.githubusercontent.com/kentya6/KYCircularProgress/gh-pages/demo.gif" width="232" height="418"/>
</p>

## Requirement
- Swift1.2

## Usage
#### Create KYCircularProgress
```swift
// create KYCircularProgress
var circularProgress: KYCircularProgress! = KYCircularProgress(frame: self.view.bounds)

// create KYCircularProgress with gauge guide
var circularProgress: KYCircularProgress! = KYCircularProgress(frame: self.view.bounds, showProgressGuide: true)
```

#### Gradation Color
```swift
// support Hex color to RGBA color
circularProgress.colors = [UIColor(rgba: 0xA6E39D11), UIColor(rgba: 0xAEC1E355), UIColor(rgba: 0xAEC1E3AA), UIColor(rgba: 0xF3C0ABFF)]

// combine Hex color and UIColor
circularProgress.colors = [UIColor.purpleColor(), UIColor(rgba: 0xFFF77A55), UIColor.orangeColor()]
```

#### Progress Closure
```swift
circularProgress.progressChangedClosure() {
    (progress: Double, circularView: KYCircularProgress) in
    println("progress: \(progress)")
}
```

#### UIBezierPath Progress Bar
```swift
// create "Star progress bar"
let path = UIBezierPath()
path.moveToPoint(CGPointMake(50.0, 2.0))
path.addLineToPoint(CGPointMake(84.0, 86.0))
path.addLineToPoint(CGPointMake(6.0, 33.0))
path.addLineToPoint(CGPointMake(96.0, 33.0))
path.addLineToPoint(CGPointMake(17.0, 86.0))
path.closePath()
circularProgress.path = path
```

## Installation
#### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects.

To integrate KYCircularProgress into your Xcode project using CocoaPods, specify it in your `podfile`:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'KYCircularProgress'
```

Then, run the following command:

```
$ pod install
```

#### Manually
Add `KYCircularProgress.swift` into your Xcode project.

## Licence

The MIT License (MIT)

Copyright (c) 2014-2015 Kengo YOKOYAMA

## Author

[kentya6](https://github.com/kentya6)
