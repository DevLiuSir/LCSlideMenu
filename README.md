![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/LCSlideMenu.png)

![](https://camo.githubusercontent.com/f3bc68f8badf9ec1143275e35cba2114910b0522/687474703a2f2f696d672e736869656c64732e696f2f62616467652f6c616e67756167652d73776966742d627269676874677265656e2e7376673f7374796c653d666c6174)
[![Swift &4.0+](https://img.shields.io/badge/Swift-4.0+-orange.svg?style=flat)](https://developer.apple.com/swift/)
![](https://camo.githubusercontent.com/c33e2972a445f3e8ecf5859b339577fcbe9e2b65/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f58636f64652d392532422d627269676874677265656e2e737667)
[![Swift compatible](https://img.shields.io/badge/swift-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift/)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/LCSlideMenu.svg)](#cocoapods) 
![](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)
![](https://img.shields.io/badge/platform-iOS-blue.svg)
![https://github.com/ChinaHackers/LCSlideMenu/blob/master/LICENSE](https://img.shields.io/github/license/ChinaHackers/LCSlideMenu.svg)
![](https://img.shields.io/github/stars/ChinaHackers/LCSlideMenu.svg?style=social&label=Star)
[![Twitter Follow](https://img.shields.io/twitter/follow/LiuChuan_.svg?style=social)](https://twitter.com/LiuChuan_)


## What is LCSlideMenu?

<p align="center"> <b> LCSlideMenu It's a powerful and easy to use slider menu. </b></p> 


## Screencast from our Demo

![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast01.gif)
![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast02.gif)
![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast03.gif)

## Requirements
---
- iOS 11.2
- Xcode 9.2
- Swift 4.0.3+

## Installation

[CocoaPods](http://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```swift
$ gem install cocoapods
```


Just add the `LCSlideMenu` folder to your project.

or use `CocoaPods` with Podfile:

```swift
pod 'LCSlideMenu'
```

Swift 4.0.3：

```swift
platform :ios, '11.2'
target '<Your Target Name>' do
use_frameworks!
pod 'LCSlideMenu'
end
```


Then, run the following command:

```swift
$ pod install
```
## Example:


```swift
import UIKit
import LCSlideMenu

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        example()
    }
    fileprivate func example() {
        
       let titles = ["头条", "精选", "轻松一刻", "娱乐", "新时代", "手机","体育", "视频", "财经", "汽车","军事", "房产", "健康", "彩票", "搞笑"]
        var controllers: [UIViewController] = []
        
        for _ in 0 ..< titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1)

            addChildViewController(vc)
            controllers.append(vc)
        }
        /* -- LCSlideMenu -- */
        let slideMenu = LCSlideMenu(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: 40), titles: titles, childControllers: controllers)
        slideMenu.indicatorType = .stretch
        slideMenu.titleStyle = .gradient
        view.addSubview(slideMenu)
    }
}
```
