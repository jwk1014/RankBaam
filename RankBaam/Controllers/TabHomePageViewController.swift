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
    
    var scrollDelegate: MainUpperTabScrollViewDelegate?
    
    var upperTabView: MainAllRankTopTabbar =  {
       let upperTabView = MainAllRankTopTabbar(frame: CGRect.zero, leftTabTitle: "모든랭킹", rightTabTitle: "주간랭킹")
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
    
    var mainFilterButton: UIButton = {
        let mainFilterButton = UIButton()
        return mainFilterButton
    }()
    
    var mainViewControllers: [UIViewController] = {
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
        mainCustomNavigationBar.addSubview(mainNavigationBarTitle)
        mainCustomNavigationBar.addSubview(mainFilterButton)
        mainFilterButton.setImage(UIImage(named: "filterIcnN"), for: .normal)
        mainFilterButton.contentMode = .scaleAspectFit
        
        mainCustomNavigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(height667(68, forX: 68))
        }
        
        mainNavigationBarTitle.text = "RANK BAAM"
        mainNavigationBarTitle.font = UIFont.boldSystemFont(ofSize: Constants.screenHeight * (18 / 667))
        mainNavigationBarTitle.snp.makeConstraints {
            $0.top.equalTo(mainCustomNavigationBar.snp.top)
                .offset(height667(38, forX: 38))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(height667(21))
        }
        mainFilterButton.snp.makeConstraints {
           
            $0.left.equalTo(mainNavigationBarTitle.snp.right)
                .offset(Constants.screenWidth * (335 / 375))
            $0.top.equalTo(mainCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (36 / 667))
            $0.width.equalTo(Constants.screenWidth * (24 / 375))
            $0.height.equalTo(Constants.screenHeight * (24 / 667))
        }
        self.view.addSubview(upperTabView)
        upperTabView.translatesAutoresizingMaskIntoConstraints = false
        upperTabView.topAnchor.constraint(equalTo: mainCustomNavigationBar.bottomAnchor).isActive = true
        upperTabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        upperTabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        upperTabView.heightAnchor.constraint(equalToConstant: Constants.screenHeight * (35 / 667)).isActive = true
        upperTabView.delegate = self
        
        
    }
  
  override func viewDidLayoutSubviews() {
    print("a")
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
                ((x < self.view.bounds.width) ? 0 : (self.view.bounds.width)/2 ) + Constants.screenWidth * (61 / 375)
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

