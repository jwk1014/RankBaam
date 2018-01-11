//
//  MainTabViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 10..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabHomeVC = TabHomeViewController()
        tabHomeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "ic_comment"), tag: 1)
        addChildViewController(tabHomeVC)
        
        let tabSearchVC = TabSearchViewController()
        tabSearchVC.tabBarItem = UITabBarItem(title: "랭킹 검색", image: UIImage(named: "ic_comment"), tag: 2)
        addChildViewController(tabSearchVC)
        
        let tabLikeVC = TabLikeViewController()
        tabLikeVC.tabBarItem = UITabBarItem(title: "저장 랭킹", image: UIImage(named: "ic_comment"), tag: 3)
        addChildViewController(tabLikeVC)
        
        let tabMyVC = TabMyViewController()
        tabMyVC.tabBarItem = UITabBarItem(title: "내 글 관리", image: UIImage(named: "ic_comment"), tag: 4)
        addChildViewController(tabMyVC)
    }

}
