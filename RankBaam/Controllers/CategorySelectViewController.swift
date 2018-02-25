//
//  CategorySelectViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 23..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

protocol CategoryDelegate {}
extension CategoryDelegate {
  private func selected(categorySN: Int, orderRawValue: Int) {
    if let delegate = self as? CategorySelectDelegate {
      delegate.selected(category: categories.first(where: {return $0.categorySN == categorySN}))
    } else if let delegate = self as? CategoryOrderSelectDelegate,
      let order = CategorySelectViewController.Order(rawValue: orderRawValue) {
      delegate.selected(category: categories.first(where: {return $0.categorySN == categorySN}), order: order)
    }
  }
}

protocol CategorySelectDelegate: CategoryDelegate {
  func selected(category: Category?)
}
protocol CategoryOrderSelectDelegate: CategoryDelegate {
  func selected(category: Category?, order: CategorySelectViewController.Order)
}

class CategorySelectViewController: UIViewController {
  enum Order: Int{
    case new = 1
    case best = 2
    case vote = 3
  }
  
  var isVisibleTitle = false
  var isVisibleCategoryAll = false
  
  private let snapshotCategories = categories
  private weak var selectedLabel: UILabel?
  var category: Category? = nil
  var order: Order? = nil
  var delegate: CategoryDelegate?
  
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
  
  @objc private func handleView(_ sender: UITapGestureRecognizer){
    close()
  }
  
  @objc private func handleCloseButton(_ button: UIButton){
    close()
  }
  
  private func close() {
    if let delegate = delegate as? CategorySelectDelegate {
      delegate.selected(category: category)
    } else if let delegate = delegate as? CategoryOrderSelectDelegate {
      delegate.selected(category: category, order: order ?? .new)
    }
    dismiss(animated: true, completion: nil)
  }
  
  private func initView() {
    view.backgroundColor = UIColor(r: 106, g: 106, b: 106, a: 0.3)
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleView)))
    
    var arrangedSubviews: [UIView] = []
    
    //TODO ORDER
    
    let categorySelectView = CategorySelectView(delegate: self)
    arrangedSubviews.append(categorySelectView)
    
    let mainStackView = UIStackView(arrangedSubviews: arrangedSubviews)
    mainStackView.setting(axis: .vertical, distribution: .fillProportionally, alignment: .fill)
    mainStackView.backgroundColor = UIColor.white
    mainStackView.layer.cornerRadius = 3.0
    view.addSubview(mainStackView)
    mainStackView.snp.makeConstraints {
      $0.centerX.equalTo(view)
      $0.centerY.equalTo(view).offset(height667(45.0/2.0))
      $0.width.equalTo(width375(321.0))
    }
    
    let backgroundLayer = CAShapeLayer()
    mainStackView.layer.insertSublayer(backgroundLayer, at: 0)
    backgroundLayer.path = UIBezierPath(
      roundedRect: .init(
        x: 0, y: 0,
        width: view.bounds.width * 321.0/375.0,
        height: view.bounds.height * 322.0/667.0),
      cornerRadius: 3.0).cgPath
    backgroundLayer.fillColor = UIColor.white.cgColor
    
    let button = UIButton()
    button.setImage(UIImage(named: "ic_close"), for: .normal)
    button.imageView?.tintColor = UIColor.white
    button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    view.addSubview(button)
    button.snp.makeConstraints {
      $0.width.equalTo(width375(41.0))
      $0.height.equalTo(height667(41.0))
      $0.trailing.equalTo(mainStackView)
      $0.bottom.equalTo(mainStackView.snp.top).offset(-height667(13.0))
    }
  }

}

extension CategorySelectViewController: CategorySelectViewDelegate {
  func selected(category: Category?) {
    self.category = category
    close()
  }
}

protocol CategorySelectViewDelegate: class {
  var isVisibleTitle: Bool { get }
  var isVisibleCategoryAll: Bool { get }
  var category: Category? { get }
  func selected(category: Category?)
}

class CategorySelectView: UIView{
  var selectedCategoryLabel: UILabel?
  private let snapshotCategories: [Category] = categories
  weak var delegate: CategorySelectViewDelegate?
  
  init(delegate: CategorySelectViewDelegate?) {
    super.init(frame: .zero)
    self.delegate = delegate
    initView()
  }
  
  var selectedTextColor: UIColor {
    return .init(r: 250, g: 84, b: 76)
  }
  var unselectedTextColor: UIColor {
    return .init(r: 191, g: 191, b: 191)
  }
  
  @objc func handleLabel(_ sender: UITapGestureRecognizer) {
    var category: Category? = nil
    if let tag = sender.view?.tag, tag >= 0 && tag < snapshotCategories.count {
      category = snapshotCategories[tag]
    }
    if let label = selectedCategoryLabel {
      changeTextColorLabel(label, selected: false)
    }
    if let label = sender.view as? UILabel {
      changeTextColorLabel(label, selected: true)
    }
    delegate?.selected(category: category)
  }
  
  func initView(){
    let verticalStackView = initVerticalStackView()
    addSubview(verticalStackView)
    verticalStackView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.bottom.equalTo(self).offset(-height667(23.0))
    }
    
    if delegate?.isVisibleTitle ?? false {
      let titleLabel = UILabel()
      titleLabel.font = UIFont(name: "NanumSquareB", size: 14.0)
      titleLabel.textColor = UIColor(r: 77, g: 77, b: 77)
      titleLabel.text = "카테고리"
      addSubview(titleLabel)
      titleLabel.snp.makeConstraints {
        $0.top.centerX.equalTo(self)
        $0.bottom.equalTo(verticalStackView.snp.top).offset(-height667(11.0))
      }
    } else {
      verticalStackView.snp.makeConstraints {
        $0.top.equalTo(self)
      }
    }
  }
  
  func changeTextColorLabel(_ label: UILabel, selected: Bool) {
    label.textColor = (selected) ? selectedTextColor : unselectedTextColor
  }
  
  func createLabel(category: Category) -> UILabel {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16.0)
    label.textAlignment = .center
    label.tag = category.categorySN
    label.text = category.name
    
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLabel)))
    
    let selected = { () -> Bool in
      guard let delegate = delegate,
            let selectedCategory = delegate.category else { return false }
      return selectedCategory == category
    }()
    changeTextColorLabel(label, selected: selected)
    if selected {
      selectedCategoryLabel = label
    }
    
    return label
  }
  
  func initVerticalStackView() -> UIStackView {
    let verticalStackView = UIStackView(arrangedSubviews: initMultipleHorizontalStackView())
    verticalStackView.setting(axis: .vertical, distribution: .fillEqually, alignment: .fill)
    verticalStackView.spacing = 0
    verticalStackView.setMargin(
      top: height667(23.0), left: 10,
      bottom: height667(23.0 + 5.0), right: 10)
    
    return verticalStackView
  }
  
  func initMultipleHorizontalStackView() -> [UIStackView] {
    var labels: [UILabel] = []
    if delegate?.isVisibleCategoryAll ?? false {
      let label = createLabel(category: Category(categorySN: 0, name: "전체"))
      if delegate?.category == nil {
        changeTextColorLabel(label, selected: true)
        selectedCategoryLabel = label
      }
      labels.append(label)
    }
    labels += snapshotCategories.map(createLabel)
    
    let columnCount = 3
    let rowCount = (labels.count-1)/columnCount+1
    let remain = labels.count % columnCount
    let remainInt = (remain > 0) ? 1 : 0
    
    var horizontalStackViews = [UIStackView]()
    horizontalStackViews.reserveCapacity(rowCount)
    
    for i in 0..<rowCount {
      var subLabels: [UILabel] = []
      if delegate?.isVisibleCategoryAll ?? false {
        subLabels += labels[i*columnCount..<min((i+1)*columnCount,labels.count)]
      } else {
        let startIndex = (i==0) ? 0 : (i-remainInt) * columnCount + remain
        let endIndex = startIndex + ((i==0) ? (labels.count-1) % columnCount + 1 : columnCount)
        subLabels += labels[startIndex..<endIndex]
      }
      
      let horizontalStackView = UIStackView(arrangedSubviews: subLabels)
      horizontalStackView.setting(axis: .horizontal, distribution: .fillEqually, alignment: .fill)
      horizontalStackView.spacing = 0
      horizontalStackViews.append(horizontalStackView)
      horizontalStackView.snp.makeConstraints {
        $0.height.equalTo(height667(64.0))
      }
    }
    
    return horizontalStackViews
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView(); }
  override init(frame: CGRect) { super.init(frame: frame); initView(); }
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




