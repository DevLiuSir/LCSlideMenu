//
//  ViewController.swift
//  LCSlideMenuExample
//
//  Created by Liu Chuan on 2017/1/15.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        example()
    }

    private func example() {
        
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
        slideMenu.indicatorType = .stretch
        slideMenu.titleStyle = .gradient
        slideMenu.isShowIndicatorView = true
        slideMenu.isNeedMask = false
        slideMenu.selectedColor = .red
        slideMenu.unSelectedColor = .black
        slideMenu.indicatorView.backgroundColor = .red
        view.addSubview(slideMenu)
    }
}

