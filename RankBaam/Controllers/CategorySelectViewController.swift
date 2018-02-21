//
//  CategorySelectViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 23..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

protocol CategorySelectDelegate {
  func selectedCategory(category: Category?)
}

class CategorySelectViewController: UIViewController {
  
  let snapshotCategories = categories
  weak var selectedLabel: UILabel?
  var selectedIndex: Int = 0
  var delegate: CategorySelectDelegate?
  
  var selectedTextColor: UIColor {
    return .init(r: 250, g: 84, b: 76)
  }
  var unselectedTextColor: UIColor {
    return .init(r: 191, g: 191, b: 191)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    initView()
  }
  
  @objc func handleLabel(_ sender: UITapGestureRecognizer){
    guard let label = sender.view as? UILabel, label != selectedLabel else {return}
    if let previousSelectedlabel = selectedLabel {
      previousSelectedlabel.textColor = unselectedTextColor
    }
    
    label.textColor = selectedTextColor
    selectedLabel = label
    selectedIndex = label.tag
    
    delegate?.selectedCategory(category: snapshotCategories[selectedIndex])
    dismiss(animated: true, completion: nil)
  }
  
  func createLabel(index: Int) -> UILabel {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16.0)
    label.textAlignment = .center
    label.tag = index
    label.text = snapshotCategories[index].name
    
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleLabel)))
    
    if selectedIndex == index {
      label.textColor = selectedTextColor
      selectedLabel = label
    } else {
      label.textColor = unselectedTextColor
    }
    
    return label
  }
  
  @objc func handleButton(_ button: UIButton) {
    delegate?.selectedCategory(category: nil)
    self.dismiss(animated: true, completion: nil)
  }
  
  func initView(){
    
    self.view.backgroundColor = UIColor.init(r: 106, g: 106, b: 106, a: 0.3)
    
    let verticalStackView = initVerticalStackView()
    view.addSubview(verticalStackView)
    verticalStackView.snp.makeConstraints {
      $0.width.equalTo(view.bounds.width * 321.0/375.0)
      $0.height.equalTo(view.bounds.height * 322.0/667.0)
      $0.center.equalTo(view)
    }
    
    let button = UIButton()
    let image = UIImage(named: "ic_close")
    button.setImage(image, for: .normal)
    button.imageView?.tintColor = UIColor.white
    button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    
    view.addSubview(button)
    button.snp.makeConstraints {
      $0.width.equalTo(view.bounds.width * 46.0/375.0)
      $0.height.equalTo(view.bounds.height * 46.0/667.0)
      $0.trailing.equalTo(verticalStackView).offset(-(view.bounds.width * 20.0/667.0))
      $0.bottom.equalTo(verticalStackView.snp.top).offset(-(view.bounds.width * 22.0/667.0))
    }
  }
  
  func initVerticalStackView() -> UIStackView {
    let verticalStackView = UIStackView(arrangedSubviews: initMultipleHorizontalStackView())
    verticalStackView.setting(axis: .vertical, distribution: .fillEqually, alignment: .fill)
    verticalStackView.spacing = 0
    verticalStackView.setMargin(
      top: view.bounds.height * 25.0/667.0,
      left: 10,
      bottom: view.bounds.height * 25.0/667.0,
      right: 10)
    
    let backgroundLayer = CAShapeLayer()
    verticalStackView.layer.insertSublayer(backgroundLayer, at: 0)
    backgroundLayer.path = UIBezierPath(
      roundedRect: .init(
        x: 0, y: 0,
        width: view.bounds.width * 321.0/375.0,
        height: view.bounds.height * 322.0/667.0),
      cornerRadius: 3.0).cgPath
    backgroundLayer.fillColor = UIColor.white.cgColor
    
    return verticalStackView
  }
  
  func initMultipleHorizontalStackView() -> [UIStackView] {
    let columnCount = 3
    let rowCount = (snapshotCategories.count-1)/columnCount+1
    let remain = snapshotCategories.count % columnCount
    let remainInt = (remain > 0) ? 1 : 0
    
    var horizontalStackViews = [UIStackView]()
    horizontalStackViews.reserveCapacity(rowCount)
    
    for i in 0..<rowCount {
      var labels: [UILabel] = []
      for j in 0..<((i==0) ? (snapshotCategories.count-1) % columnCount + 1 : columnCount) {
        let index = ((i == 0) ? 0 : (i-remainInt) * columnCount + remain) + j
        labels.append(createLabel(index: index))
      }
      
      let horizontalStackView = UIStackView.init(arrangedSubviews: labels)
      horizontalStackView.axis = .horizontal
      horizontalStackView.distribution = .fillEqually
      horizontalStackView.alignment = .fill
      horizontalStackView.spacing = 0
      horizontalStackViews.append(horizontalStackView)
      
      if i == 0 && labels.count > 1 && labels.count < columnCount {
        let sub = CGFloat(columnCount - labels.count)
        let w = view.bounds.width * CGFloat((321.0/375.0) / Double(columnCount) / 2.0)
        horizontalStackView.setMargin(left: sub * w, right: sub * w)
      }
    }
    
    return horizontalStackViews
  }

}

extension UIStackView {
  func setting(axis: UILayoutConstraintAxis, distribution: UIStackViewDistribution, alignment: UIStackViewAlignment) {
    self.axis = axis
    self.distribution = distribution
    self.alignment = alignment
  }
    
  func setMargin(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
    self.layoutMargins = .init(top: top, left: left, bottom: bottom, right: right)
    self.isLayoutMarginsRelativeArrangement = true
  }
}




