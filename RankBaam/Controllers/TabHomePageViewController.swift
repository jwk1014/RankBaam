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
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    var scrollDelegate: MainUpperTabScrollViewDelegate?
    
    var upperTabView: MainAllRankTopTabbar =  {
       let upperTabView = MainAllRankTopTabbar()
       return upperTabView
    }()
    
    var mainCustomNavigationBar: UIView = {
        let customNavigationBar = UIView()
        customNavigationBar.backgroundColor = UIColor.white
        return customNavigationBar
    }()
    
    var mainNavigationBarTitle: UILabel = {
        let mainnaviTitle = UILabel()
        mainnaviTitle.textColor = UIColor.rankbaamOrange
        return mainnaviTitle
    }()
    
    lazy var mainViewControllers: [UIViewController] = {
        let tabHomeViewController = TabHomeViewController()
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
            make.height.equalTo(screenHeight * (68/667))
        }
        mainCustomNavigationBar.addSubview(mainNavigationBarTitle)
        mainNavigationBarTitle.text = "RANK BAAM"
        mainNavigationBarTitle.font = UIFont.boldSystemFont(ofSize: 18)
        mainNavigationBarTitle.snp.makeConstraints { (make) in
            make.top.equalTo(mainCustomNavigationBar.snp.top).offset(screenHeight * (38 / 667))
            make.left.equalTo(mainCustomNavigationBar.snp.left).offset(screenWidth * (136 / 375))
            make.height.equalTo(screenHeight * (21 / 667))
        }
        self.view.addSubview(upperTabView)
        upperTabView.translatesAutoresizingMaskIntoConstraints = false
        upperTabView.topAnchor.constraint(equalTo: mainCustomNavigationBar.bottomAnchor).isActive = true
        upperTabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        upperTabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        upperTabView.heightAnchor.constraint(equalToConstant: screenHeight * (35 / 667)).isActive = true
        upperTabView.delegate = self
        
        
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
    
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.upperTabView.selectedUnderBarLeadingConstraint?.constant  =
                ((x < self.view.bounds.width) ? 0 : (self.view.bounds.width)/2 ) + 61
            self.upperTabView.layoutIfNeeded()
        }, completion: nil)
        
        
        ( x < view.bounds.width ) ? (upperTabView.weeklyRankTab.setTitleColor(UIColor.rankbaamDarkgray, for: .normal)) : (upperTabView.weeklyRankTab.setTitleColor(UIColor.rankbaamOrange, for: .normal))
        ( x < view.bounds.width ) ? (upperTabView.allRankTab.setTitleColor(UIColor.rankbaamOrange, for: .normal)) : ( upperTabView.allRankTab.setTitleColor(UIColor.rankbaamDarkgray, for: .normal))
            
        
        
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

extension TabHomePageViewController: UpperCustomTabbarDelegate {
    func upperCustomTabbarTapped(sender: UIButton) {
        let scrollView = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
        scrollView.delegate = nil
        
        if sender == self.upperTabView.allRankTab {
            
            if let firstViewController = mainViewControllers.first {
                self.setViewControllers([firstViewController], direction: .reverse, animated: true, completion: nil)
            }
        } else {
            let scrollView = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
            scrollView.delegate = nil
            if let lastViewController = mainViewControllers.last {
                self.setViewControllers([lastViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            scrollView.delegate = self
        }
    }
}

