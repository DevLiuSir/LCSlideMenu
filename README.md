![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/LCSlideMenu.png)

![language](https://img.shields.io/badge/language-swift-orange.svg)
[![Swift  4.0](https://img.shields.io/badge/swift-4.0+-blue.svg?style=flat)](https://developer.apple.com/swift/)
![xcode version](https://img.shields.io/badge/xcode-9+-brightgreen.svg)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/LCSlideMenu.svg)](#cocoapods) 
![download](https://img.shields.io/cocoapods/dt/LCSlideMenu.svg)
![build ](https://img.shields.io/appveyor/ci/gruntjs/grunt/master.svg)
![platform](https://img.shields.io/cocoapods/p/LCSlideMenu.svg?style=flat)
![https://github.com/ChinaHackers/LCSlideMenu/blob/master/LICENSE](https://img.shields.io/github/license/ChinaHackers/LCSlideMenu.svg)
![GitHub starts](https://img.shields.io/github/stars/ChinaHackers/LCSlideMenu.svg?style=social&label=Stars)
![GitHub fork](https://img.shields.io/github/forks/ChinaHackers/LCSlideMenu.svg?style=social&label=Fork)
[![Twitter Follow](https://img.shields.io/twitter/follow/LiuChuan_.svg?style=social)](https://twitter.com/LiuChuan_)

---

## What is LCSlideMenu?

<p align="center"> <b> LCSlideMenu It's a powerful and easy to use slider menu. </b></p> 


> [中文](https://github.com/ChinaHackers/LCSlideMenu/blob/master/README_CN.md) | [English](https://github.com/ChinaHackers/LCSlideMenu/blob/master/README.md)



## Screencast from our Demo

| ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast01.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast02.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast03.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast04.gif) |
| :------------: | :------------: | :------------: | :------------: |
| `indicatorType = .stretch` `titleStyle = .gradient` |  `indicatorType = .circle` `titleStyle = .gradient` |  `indicatorType = .stretch` `titleStyle = .transfrom` |  `indicatorType = .normal` `titleStyle = .transfrom` |

| ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast05.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast06.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast08.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast07.gif) |
| :------------: | :------------: | :------------: | :------------: |
| `indicatorType = .cover` `titleStyle = .gradient` | `isShowIndicatorView = false`  `titleStyle = .transfrom` | `indicatorType = .cover` `titleStyle = .transfrom` | `isShowIndicatorView = false`  `titleStyle = .gradient` |

---
## Menu indicator and title style

- **Using enumerations to define `LCSlideMenuTitleStyle` and `LCSlideMenuTitleStyle` types**

```swift

/// Select the menu header style
///
/// - normal: normal
/// - gradient: The gradient color
/// - transfrom: zoom
public enum LCSlideMenuTitleStyle {
    case normal
    case gradient
    case transfrom
}

/// Select the menu indicator style
///
/// - normal: normal
/// - stretch: stretch
/// - followText: Following text length
/// - cover: mask
/// - circle: circle
public enum LCSlideMenuIndicatorStyle {
    case normal
    case stretch
    case followText
    case cover
    case circle
}

```


## Public Attribute

|  Attribute name	|  Specific introduction of attributes	|
| :------------: | :------------: | 
| `coverView` 		|  Mask the view |
|  `indicatorType `  	|  LCSlideMenu  of  indicator type  |
| `circleIndicatorColor` |  circle Style Indicator Color  |
|  `titleStyle`			|  Heading styles  |
| `itemFont`			|  The font size of the heading  |
|  `isShowIndicatorView` |  Whether to display the indicator view  |
|  `isNeedMask`  		|  Do you need a mask?  |
| `coverHeight`		| The height of the mask view  |
|  `coverColor` 		|  The background color of the mask view  |
|  `selectedColor` 		| The color in the currently selected state   |
|  `unSelectedColor` 	| The color of the unchecked state  |
| `bottomPadding`		| The indicator is at the bottom  |
| `indicatorHeight`		| Height of indicator |


---

## Requirements

- iOS 11.2
- Xcode 9.2
- Swift 4.0.3+

## Installation

[CocoaPods](http://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:


```swift
$ gem install cocoapods
```


- Just add the `LCSlideMenu` folder to your project.

- or add them to your ` Podfile ` file to  use `CocoaPods`  install  **LCSlideMenu**


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
        
        let titles = ["Apple", "Banana", "Watermelon", "Orange", "Lemon", "Pear","Strawberry", "Sapodilla", "Haw", "Grape","Mango", "Plum", "Persimmon", "Fig", "Betelnut"]
        var controllers: [UIViewController] = []
        
        for _ in 0 ..< titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 255, green: CGFloat(arc4random() % 256) / 255, blue: CGFloat(arc4random() % 256) / 255, alpha: 1)
            addChildViewController(vc)
            controllers.append(vc)
        }
      	/* -- LCSlideMenu -- */
        let slideMenu = LCSlideMenu(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: 40), titles: titles, childControllers: controllers)
        slideMenu.indicatorType = .cover
        slideMenu.titleStyle = .gradient
        slideMenu.isShowIndicatorView = false
        slideMenu.isNeedMask = true
        slideMenu.coverView.layer.cornerRadius = slideMenu.coverHeight * 0.2
        slideMenu.circleIndicatorColor = UIColor.red.cgColor
        slideMenu.coverColor = .black
        slideMenu.selectedColor = .white
        slideMenu.unSelectedColor = .black
        slideMenu.indicatorView.backgroundColor = .red
        view.addSubview(slideMenu)
    }
}
```
