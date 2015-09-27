KYCircularProgress
==================

[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/KYCircularProgress.svg)](https://img.shields.io/cocoapods/v/KYCircularProgress.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Percentage of issues still open](http://isitmaintained.com/badge/open/kentya6/KYCircularProgress.svg)](http://isitmaintained.com/project/kentya6/KYCircularProgress "Percentage of issues still open")
[![Average time to resolve an issue](http://isitmaintained.com/badge/resolution/kentya6/KYCircularProgress.svg)](http://isitmaintained.com/project/kentya6/KYCircularProgress "Average time to resolve an issue")

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
- Swift2

## Usage
#### Create KYCircularProgress
```swift
// create KYCircularProgress
var circularProgress = KYCircularProgress(frame: self.view.bounds)

// create KYCircularProgress with gauge guide
var circularProgress = KYCircularProgress(frame: self.view.bounds, showProgressGuide: true)
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
    print("progress: \(progress)")
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

####Carthage (iOS 8+)
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate KYCircularProgress into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "kentya6/KYCircularProgress" >= 0.5.0
```

#### Manually
Add `KYCircularProgress.swift` into your Xcode project.

## Licence

The MIT License (MIT)

Copyright (c) 2014-2015 Kengo YOKOYAMA

## Author

[kentya6](https://github.com/kentya6)
