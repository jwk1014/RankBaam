//
//  TabHomePageViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 20..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

protocol MainUpperTabScrollViewDelegate {
    func mainUpperTabScrollViewDidScroll()
}

class TabHomePageViewController: UIPageViewController {


//    fileprivate var currentIndex = 0
//    fileprivate var lastPosition: CGFloat = 0
    
    var scrollDelegate: MainUpperTabScrollViewDelegate?
    var upperTabView: MainAllRankTopTabbar?
    var mainCustomNavigationBar: UIView = {
       let customNavigationBar = UIView()
       customNavigationBar.backgroundColor = UIColor.white
       return customNavigationBar
    }()
    
    lazy var mainViewControllers: [UIViewController] = {
        let tabHomeViewController = TabHomeViewController2()
        let tabHomeWeeklyViewController = TabHomeWeeklyRankViewController()
        return [tabHomeViewController, tabHomeWeeklyViewController]
    }()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewControllerConfigure()
        customNavigationBarTabBarConfigure()
        
    }

    
    fileprivate func pageViewControllerConfigure() {
        let scrollView = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
        scrollView.delegate = self
        self.view.backgroundColor = UIColor.rankbaamGray
        self.dataSource = self
        if let firstViewController = mainViewControllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func customNavigationBarTabBarConfigure() {
        self.view.addSubview(mainCustomNavigationBar)
        mainCustomNavigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.view.frame.height * (68/667))
        }
        upperTabView = MainAllRankTopTabbar(frame: CGRect(x: 0, y: 68, width: self.view.frame.width, height: 35))
        self.view.addSubview(upperTabView!)
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
    /*func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            let pageContentViewController = pageViewController.viewControllers![0]
            currentIndex = mainViewControllers.index(of: pageContentViewController)!
        }
    }*/
}

extension TabHomePageViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.x)")
        
        let x = scrollView.contentOffset.x + scrollView.contentInset.left
    
        upperTabView?.selectedUnderBarLeadingConstraint?.constant  =
            ((x < view.bounds.width) ? 0 : (view.bounds.width)/2 ) + 61
        
        ( x < view.bounds.width ) ? (upperTabView?.weeklyRankTab.setTitleColor(UIColor.rankbaamDarkgray, for: .normal)) : ( upperTabView?.weeklyRankTab.setTitleColor(UIColor.rankbaamOrange, for: .normal))
        ( x < view.bounds.width ) ? (upperTabView?.allRankTab.setTitleColor(UIColor.rankbaamOrange, for: .normal)) : ( upperTabView?.allRankTab.setTitleColor(UIColor.rankbaamDarkgray, for: .normal))
            
        
        
        //upperTabView?.layoutIfNeeded()
        /*+= scrollView.contentOffset.x * 1 / 1000*/
        
        /*self.lastPosition = scrollView.contentOffset.x
        
        if (currentIndex == mainViewControllers.count - 1) && (lastPosition > scrollView.frame.width) {
            scrollView.contentOffset.x = scrollView.frame.width
            return

        } else if currentIndex == 0 && lastPosition < scrollView.frame.width {
            scrollView.contentOffset.x = scrollView.frame.width
            return
        }*/
    }
    
}

