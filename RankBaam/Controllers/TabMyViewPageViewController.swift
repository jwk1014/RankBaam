//
//  TabMyViewPageViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 31..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabMyViewPageViewController: UIPageViewController {

    var scrollDelegate: MainUpperTabScrollViewDelegate?
    
    var upperTabView: MainAllRankTopTabbar =  {
        let upperTabView = MainAllRankTopTabbar(frame: CGRect.zero, leftTabTitle: "내 글 관리", rightTabTitle: "프로필 설정")
        return upperTabView
    }()
    
    var tabMyViewCustomNavigationBar: UIView = {
        let tabMyViewCustomNavigationBar = UIView()
        tabMyViewCustomNavigationBar.backgroundColor = UIColor.white
        return tabMyViewCustomNavigationBar
    }()
    
    var tabMyViewNavigationBarTitle: UILabel = {
        let tabMyViewNavigationBarTitle = UILabel()
        tabMyViewNavigationBarTitle.textColor = UIColor.rankbaamOrange
        return tabMyViewNavigationBarTitle
    }()
    
    var tabMyViewEditingButton: UIButton = {
        let tabMyViewEditingButton = UIButton()
        return tabMyViewEditingButton
    }()
    
    var tabMyViewRankingsCommentsViewControllers: [UIViewController] = {
        let tabMyViewRankingsViewController = TabMyViewRankingsViewController()
        let tabMyViewCommentsViewController = TabMyViewCommentsViewController()
        
        return [tabMyViewRankingsViewController, tabMyViewCommentsViewController]
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
        if let firstViewController = tabMyViewRankingsCommentsViewControllers.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func customNavigationBarTabBarConfigure() {
        self.view.addSubview(tabMyViewCustomNavigationBar)
        tabMyViewCustomNavigationBar.addSubview(tabMyViewNavigationBarTitle)
        tabMyViewCustomNavigationBar.addSubview(tabMyViewEditingButton)
        tabMyViewEditingButton.setImage(UIImage(named: "icSettings"), for: .normal)
        tabMyViewEditingButton.contentMode = .scaleAspectFit
        
        tabMyViewCustomNavigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height667(68, forX: 90))
        }
        
        tabMyViewNavigationBarTitle.text = "마이페이지"
        tabMyViewNavigationBarTitle.font = UIFont(name: "NanumSquareB", size: 18)
        tabMyViewNavigationBarTitle.snp.makeConstraints {
            $0.top.equalTo(tabMyViewCustomNavigationBar.snp.top)
                .offset(height667(38, forX: 60))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(height667(21))
        }
        tabMyViewEditingButton.snp.makeConstraints {
            $0.left.equalTo(tabMyViewCustomNavigationBar.snp.left)
                .offset(width375(335))
            $0.top.equalTo(tabMyViewCustomNavigationBar.snp.top)
                .offset(height667(36))
            $0.width.equalTo(width375(24))
            $0.height.equalTo(height667(24))
        }
        self.view.addSubview(upperTabView)
        upperTabView.translatesAutoresizingMaskIntoConstraints = false
        upperTabView.topAnchor.constraint(equalTo: tabMyViewCustomNavigationBar.bottomAnchor).isActive = true
        upperTabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        upperTabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        upperTabView.heightAnchor.constraint(equalToConstant: height667(35)).isActive = true
        upperTabView.delegate = self
        
        
    }
}


extension TabMyViewPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let presentIndex = tabMyViewRankingsCommentsViewControllers.index(of: viewController) else { return nil }
        let previousIndex = presentIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard tabMyViewRankingsCommentsViewControllers.count > previousIndex else { return nil }
        
        return tabMyViewRankingsCommentsViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let presentIndex = tabMyViewRankingsCommentsViewControllers.index(of: viewController) else { return nil }
        let nextIndex = presentIndex + 1
        guard tabMyViewRankingsCommentsViewControllers.count != nextIndex else { return nil }
        guard tabMyViewRankingsCommentsViewControllers.count > nextIndex else { return nil }
        return tabMyViewRankingsCommentsViewControllers[nextIndex]
        
    }
    /*func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
     
     if completed {
     let pageContentViewController = pageViewController.viewControllers![0]
     currentIndex = mainViewControllers.index(of: pageContentViewController)!
     }
     }*/
}

extension TabMyViewPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.x)")
        
        let x = scrollView.contentOffset.x + scrollView.contentInset.left
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.upperTabView.selectedUnderBarLeadingConstraint?.constant  =
                ((x < self.view.bounds.width) ? 0 : (self.view.bounds.width)/2 ) + width375(61)
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

extension TabMyViewPageViewController: UpperCustomTabbarDelegate {
    func upperCustomTabbarTapped(sender: UIButton) {
        let scrollView = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
        scrollView.delegate = nil
        
        if sender == self.upperTabView.allRankTab {
            
            if let firstViewController = tabMyViewRankingsCommentsViewControllers.first {
                self.setViewControllers([firstViewController], direction: .reverse, animated: true, completion: nil)
            }
        } else {
            let scrollView = view.subviews.filter { $0 is UIScrollView }.first as! UIScrollView
            scrollView.delegate = nil
            if let lastViewController = tabMyViewRankingsCommentsViewControllers.last {
                self.setViewControllers([lastViewController], direction: .forward, animated: true, completion: nil)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            scrollView.delegate = self
        }
    }
}


