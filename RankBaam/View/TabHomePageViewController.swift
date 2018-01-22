//
//  TabHomePageViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 20..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabHomePageViewController: UIPageViewController {

    lazy var mainViewControllers: [UIViewController] = {
        
        
        
        let tabHomeViewController = TabHomeViewController2()
        let tabHomeWeeklyViewController = TabHomeWeeklyRankViewController()
        return [tabHomeViewController, tabHomeWeeklyViewController]
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let firstViewController = mainViewControllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
}

extension TabHomePageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let presentIndex = mainViewControllers.index(of: viewController) else { return nil }
        let previousIndex = presentIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard mainViewControllers.count > previousIndex else { return nil }
        
        return mainViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let presentIndex = mainViewControllers.index(of: viewController) else { return nil }
        let nextIndex = presentIndex + 1
        
        
        guard mainViewControllers.count != nextIndex else { return nil }
        
        guard mainViewControllers.count > nextIndex else { return nil }
        
        return mainViewControllers[nextIndex]
        
    }
    
}
