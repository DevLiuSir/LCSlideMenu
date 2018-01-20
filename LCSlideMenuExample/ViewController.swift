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
        
        let titles = ["头条", "精选", "娱乐", "手机","体育", "视频", "财经", "汽车","军事", "房产", "健康", "彩票", "搞笑"]
        
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

