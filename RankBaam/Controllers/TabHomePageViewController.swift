//
//  TabHomePageViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 20..
//  Copyright © 2018년 김정원. All rights reserved.
//


import UIKit
import SnapKit

protocol TabHomeCategorySelectionDelegate: class {
    func categorySelectionCancelled()
    func categorySelectionCompleted()
}

protocol MainUpperTabScrollViewDelegate: class {
    func mainUpperTabScrollViewDidScroll()
}

class TabHomePageViewController: UIPageViewController {
    
    var scrollDelegate: MainUpperTabScrollViewDelegate?
    var selectedOrderType: OrderType = .new
    var selectedCategory: Category?
    var presentFadeInOutManager = PresentFadeInOutManager()
    
    
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
    
    var mainFilterButtonImageView: UIImageView = {
        let mainFilterButtonImageView = UIImageView()
        return mainFilterButtonImageView
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
        mainCustomNavigationBar.addSubview(mainFilterButtonImageView)
        mainCustomNavigationBar.addSubview(mainFilterButton)
        //mainFilterButton.setImage(UIImage(named: "filterIcnN"), for: .normal)
        mainFilterButton.contentMode = .scaleAspectFit
        mainFilterButtonImageView.image = UIImage(named: "filterIcnN")
        mainFilterButtonImageView.contentMode = .scaleAspectFit
        mainFilterButton.addTarget(self, action: #selector(mainFilterButtonTapped), for: .touchUpInside)
        
        mainCustomNavigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top)
                /*.offset(UIApplication.shared.statusBarFrame.height)*/
            $0.left.right.equalToSuperview()
            $0.height.equalTo(height667(68, forX: 90))
        }
        
        mainNavigationBarTitle.text = "RANK BAAM"
        mainNavigationBarTitle.font = UIFont(name: "NanumSquareB", size: 18)
        mainNavigationBarTitle.textAlignment = .center
        mainNavigationBarTitle.snp.makeConstraints {
            $0.top.equalTo(mainCustomNavigationBar.snp.top)
                .offset(height667(38, forX: 60))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(height667(21))
        }
        
        mainFilterButtonImageView.snp.makeConstraints {
           
            $0.right.equalTo(mainCustomNavigationBar.snp.right)
                .offset(-(width375(16)))
            $0.top.equalTo(mainCustomNavigationBar.snp.top)
                .offset(height667(36, forX: 58))
            $0.width.equalTo(width375(24))
            $0.height.equalTo(height667(24))
        }
        
        mainFilterButton.snp.makeConstraints {
            
            $0.right.equalTo(mainCustomNavigationBar.snp.right)
            $0.top.equalTo(mainCustomNavigationBar.snp.top)
            $0.width.equalTo(width375(40))
            $0.height.equalTo(height667(60, forX: 82))
        }
        
        self.view.addSubview(upperTabView)
        upperTabView.snp.makeConstraints {
            $0.top.equalTo(mainCustomNavigationBar.snp.bottom)
            $0.leading.trailing.equalTo(self.view)
            $0.height.equalTo(height667(35))
        }
        
        /*upperTabView.translatesAutoresizingMaskIntoConstraints = false
        upperTabView.topAnchor.constraint(equalTo: mainCustomNavigationBar.bottomAnchor).isActive = true
        upperTabView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        upperTabView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        upperTabView.heightAnchor.constraint(equalToConstant: height667(35)).isActive = true*/
        upperTabView.delegate = self
        
        
    }
  
    @objc fileprivate func mainFilterButtonTapped() {
        let defaultCategory = Category(categorySN: 0, name: "전체")
        let categorySelectViewController = CategorySelectViewController.createForOrderAndCategory(selectedOrder: selectedOrderType, selectedCategory: selectedCategory ?? defaultCategory)
        categorySelectViewController.delegate = self
        categorySelectViewController.transitioningDelegate = presentFadeInOutManager
        categorySelectViewController.modalPresentationStyle = .custom
        present(categorySelectViewController, animated: true, completion: nil)
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

extension TabHomePageViewController: CategoryOrderSelectDelegate {
    
    func submitted(order: OrderType, category: Category?) {
        guard let tabHomeViewController = mainViewControllers[0] as? TabHomeViewController else { return }
        tabHomeViewController.selectedCategory = category
        tabHomeViewController.selectedOrder = order
        tabHomeViewController.isCategorySelectionCompleted = true
        
        print("\(#function) is called")
    }
    
    func closed(order: OrderType, category: Category?) {
        print("\(#function) is called")
    }
}

