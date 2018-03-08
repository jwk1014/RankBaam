//
//  MainTabViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 10..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class MainTabViewController: UIViewController {
  weak var contentView: UIView?
  var tabVCs = TabVC(count: 4)
  
  var currentFocusedTab: TabIcn = .home
  weak var selectedTabImageView: UIImageView?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tabVCs.addTabViewClosure(index: 0, closure: (TabHomePageViewController.init))
    tabVCs.addTabViewClosure(index: 1, closure: (TabSearchRankViewController.init))
    tabVCs.addTabViewClosure(index: 2, closure: (TabLikeStoredRankViewController.init))
    tabVCs.addTabViewClosure(index: 3, closure: (TabMyViewPageViewController.init))
    
    initView()
  }
  
  @objc func handleImageView(_ sender: UITapGestureRecognizer) {
    guard let tag = sender.view?.tag,
          tag != currentFocusedTab.rawValue,
          let tab = TabIcn(rawValue: tag),
          let imageView = sender.view as? UIImageView else {return}
    if let selectedTabImageView = selectedTabImageView {
      changeTabImage(tab: currentFocusedTab, imageView: selectedTabImageView, focused: false)
    }
    currentFocusedTab = tab
    selectedTabImageView = imageView
    changeTabImage(tab: currentFocusedTab, imageView: imageView, focused: true)
    
    changeTabContentView(tab: currentFocusedTab)
  }
  
  @objc func handleButton(_ button: UIButton) {
    let vc = TopicEditViewController()
    present(vc, animated: true, completion: nil)
  }
  
  func changeTabImage(tab: TabIcn, imageView: UIImageView, focused: Bool) {
    switch tab {
    case .home, .search, .heart:
      imageView.tintColor = (focused) ? UIColor(r: 255, g: 195, b: 75) : UIColor(r: 191, g: 191, b: 191)
    case .profile:
      imageView.image = tab.getImage(focused: focused, padding: view.bounds.width * 15.0 / 375.0)
    }
  }
  
  func changeTabContentView(tab: TabIcn){
    let vc = tabVCs[tab.rawValue-1]
    if vc.parent == nil {
      addChildViewController(vc)
    }
    if let count = contentView?.subviews.count, count > 0 {
      contentView?.subviews[0].removeFromSuperview()
    }
    contentView?.addSubview(vc.view)
  }
  
  override func viewDidLayoutSubviews() {
    print("a")
  }
  
  func initView() {
    let contentView = UIView()
    self.contentView = contentView
    view.addSubview(contentView)
    contentView.snp.makeConstraints {
      $0.top.equalTo(view)
      $0.leading.equalTo(view)
      $0.trailing.equalTo(view)
      $0.bottom.equalTo(view)
    }
    
    let gradientLayout = CAGradientLayer()
    gradientLayout.frame = .init(
      x: 0, y: view.bounds.height - height667(82.0),
      width: view.bounds.width, height: height667(82.0))
    gradientLayout.colors = [
      UIColor(r: 238, g: 238, b: 238).cgColor,
      UIColor(r: 246, g: 248, b: 250).cgColor
    ]
    view.layer.insertSublayer(gradientLayout, at: 0)
    
    guard let tabBarBgImage = UIImage(named: "tab_bar_bg") else {return}
    let vcSize = view.bounds.size
    
    let tabBarBackgroundView = UIImageView(image: tabBarBgImage)
    view.addSubview(tabBarBackgroundView)
    tabBarBackgroundView.snp.makeConstraints {
      $0.bottom.equalTo(view)
      $0.leading.equalTo(view)
      $0.trailing.equalTo(view)
      $0.height.equalTo(vcSize.height * 66.0/667.0)
    }
    tabBarBackgroundView.isUserInteractionEnabled = true
    
    let tabs: [TabIcn] = [.home, .search, .heart, .profile]
    for tab in tabs {
      let imageView = UIImageView(image: tab.getImage(
        focused: tab == currentFocusedTab, padding: view.bounds.width * 15.0 / 375.0))
      imageView.tag = tab.rawValue
      imageView.isUserInteractionEnabled = true
      imageView.addGestureRecognizer(UITapGestureRecognizer(
        target: self, action: #selector(handleImageView)))
      tabBarBackgroundView.addSubview(imageView)
      imageView.snp.makeConstraints{
        $0.width.equalTo(vcSize.width * 52.0/375.0)
        $0.height.equalTo(imageView.snp.width)
        $0.bottom.equalTo(tabBarBackgroundView).offset(-vcSize.height * 7.0/667.0)
      }
      switch tab {
      case .home: imageView.snp.makeConstraints{
        $0.leading.equalTo(tabBarBackgroundView).offset(vcSize.width * 11.0/375.0) }
        imageView.tintColor = UIColor(r: 191, g: 191, b: 191)
      case .search: imageView.snp.makeConstraints{
        $0.leading.equalTo(tabBarBackgroundView).offset(vcSize.width * 83.0/375.0) }
      imageView.tintColor = UIColor(r: 191, g: 191, b: 191)
      case .heart: imageView.snp.makeConstraints{
        $0.trailing.equalTo(tabBarBackgroundView).offset(-vcSize.width * 83.0/375.0) }
      imageView.tintColor = UIColor(r: 191, g: 191, b: 191)
      case .profile: imageView.snp.makeConstraints{
        $0.trailing.equalTo(tabBarBackgroundView).offset(-vcSize.width * 11.0/375.0) }
      }
      if tab == currentFocusedTab {
        selectedTabImageView = imageView
        changeTabImage(tab: tab, imageView: imageView, focused: true)
        contentView.frame = view.frame
        changeTabContentView(tab: tab)
      }
    }
    
    let button = UIButton()
    button.setImage(UIImage(named: "w_btn"), for: .normal)
    let padding = vcSize.width * 15.0/375.0
    button.imageEdgeInsets = .init(top: padding, left: padding, bottom: padding, right: padding)
    button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    view.addSubview(button)
    button.snp.makeConstraints {
      $0.width.equalTo(vcSize.width * 76.0/375.0)
      $0.height.equalTo(button.snp.width)
      $0.centerX.equalTo(view)
      $0.bottom.equalTo(view).offset((-vcSize.height * 40.0/667.0)+padding)
    }
  }
  
  enum TabIcn: Int {
    case home = 1
    case search = 2
    case heart = 3
    case profile = 4
    func getImageName(_ focused: Bool) -> String {
      switch self {
      case .home:     return "home_icn_n"
      case .search:   return "search_icn_n"
      case .heart:    return "heart_icn_n"
      case .profile:  return "profile_icn_\((focused) ? "f" : "n")"
      }
    }
    func getImage(focused: Bool, padding: CGFloat) -> UIImage? {
      let imageName: String = getImageName(focused)
      let image = UIImage(named: imageName)
      switch self {
      case .home, .search, .heart:
        return image?.copy(with: .init(top: padding, left: padding, bottom: padding, right: padding), isTemplate: true)
      case .profile:
        return image?.copy(with: .init(top: padding, left: padding, bottom: padding, right: padding), isTemplate: false)
      }
    }
  }
  
  struct TabVC {
    
    var tabVCs: [UIViewController?]
    var tabViewClosure: [(() -> UIViewController)?]
    
    init(count: Int) {
      tabVCs = .init(repeating: nil, count: count)
      tabViewClosure = .init(repeating: nil, count: count)
    }
    
    subscript(index: Int) -> UIViewController {
      mutating get {
        guard let vc = tabVCs[index] else {
          let vc = tabViewClosure[index]!()
          setTabVC(index: index, vc: vc)
          return vc
        }
        return vc
      }
      set(newValue) {
        self.tabVCs[index] = newValue
      }
    }
    
    mutating func setTabVC(index: Int, vc: UIViewController) {
      tabVCs[index] = vc
    }
    
    mutating func addTabViewClosure(index: Int, closure: @escaping () -> UIViewController) {
      tabViewClosure[index] = closure
    }
  }

}

extension UIImage {
  func copy(with: UIEdgeInsets, isTemplate: Bool) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(
      CGSize(width: self.size.width + with.left + with.right,
             height: self.size.height + with.top + with.bottom), false, self.scale)
    if let _ = UIGraphicsGetCurrentContext() {
      self.draw(at: .init(x: with.left, y: with.top))
      let result = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return (isTemplate) ? result?.withRenderingMode(.alwaysTemplate) : result
    }
    return nil
  }
}

extension UIColor {
  var image1x1: UIImage? {
    guard let components = cgColor.components else { return nil }
    UIGraphicsBeginImageContextWithOptions(
      CGSize(width: 1.0,height: 1.0), false, 1.0)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    //let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    context?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    //context?.setBlendMode(.sourceAtop)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
  }
}
