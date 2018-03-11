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

##  LCSlideMenu 是什么?

<p align="center"> <b>  LCSlideMenu 是一个功能强大且易于使用的滑块菜单。</b></p> 


> [ English ](https://github.com/ChinaHackers/LCSlideMenu/blob/master/README.md)



### 演示屏幕录像

| ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast01.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast02.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast03.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast04.gif) |
| :------------: | :------------: | :------------: | :------------: |
| `indicatorType = .stretch` `titleStyle = .gradient` |  `indicatorType = .cover` `titleStyle = .gradient` |  `indicatorType = .stretch` `titleStyle = .transfrom` |  `indicatorType = .normal` `titleStyle = .transfrom` |

| ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast05.gif)  | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast06.gif)  |  ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast08.gif) | ![](https://github.com/ChinaHackers/LCSlideMenu/raw/master/Screencast/Screencast07.gif) |
| :------------: | :------------: | :------------: | :------------: |
| `indicatorType = .cover` `titleStyle = .gradient` | `isShowIndicatorView = false`  `titleStyle = .transfrom` | `indicatorType = .cover` `titleStyle = .transfrom` | `isShowIndicatorView = false`  `titleStyle = .gradient` |

---
###  菜单指示器和标题样式

- **使用枚举定义 `LCSlideMenuTitleStyle`和 `LCSlideMenuTitleStyle` 类型**



```swift


/// 选择菜单标题样式
///
/// - normal: 默认
/// - gradient: 渐变颜色
/// - transfrom: 放大
public enum LCSlideMenuTitleStyle {
    case normal
    case gradient
    case transfrom
}

/// 选择菜单指示器风格
///
/// - normal: 默认
/// - stretch: 伸缩
/// - followText: 跟随文本长度
/// - cover: 遮罩
public enum LCSlideMenuIndicatorStyle {
    case normal
    case stretch
    case followText
    case cover
}

```

### 属性

|  属性名称	|  特定的属性介绍	|
| :------------: | :------------: | 
| `coverView` 		|  遮罩视图 |
|  `indicatorType `  	|  指示器类型  |
|  `titleStyle`			|  标题样式  |
| `itemFont`			|  字体大小  |
|  `isShowIndicatorView` |  是否显示指示器视图  |
|  `isNeedMask`  		|  是否需要遮罩  |
| `coverHeight`		| 遮罩视图的高度  |
|  `coverColor` 		|  遮罩视图的背景色  |
|  `selectedColor` 		| 选中状态下的颜色   |
|  `unSelectedColor` 	| 未选中状态下的颜色 |
| `bottomPadding`		| 指示器距离底部距离 |
| `indicatorHeight`		| 指示器的高度 |


---


### 需求

- iOS 11.2
- Xcode 9.2
- Swift 4.0.3+

### 安装

[CocoaPods](http://cocoapods.org/) 是Cocoa项目的依赖项管理器。您可以使用以下命令安装它:


```swift
$ gem install cocoapods
```

- 只需将 `LCSlideMenu` 文件夹添加到项目中

- 或者将其添加到您的 `Podfile` 文件中来安装 **LCSlideMenu**


```swift
platform :ios, '11.2'
target '<Your Target Name>' do
use_frameworks!
pod 'LCSlideMenu'
end
```


然后，运行以下命令:


```swift
$ pod install
```


### 用法举例:


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
        slideMenu.coverColor = .black
        slideMenu.selectedColor = .white
        slideMenu.unSelectedColor = .black
        slideMenu.indicatorView.backgroundColor = .red
        view.addSubview(slideMenu)
    }
}
```
