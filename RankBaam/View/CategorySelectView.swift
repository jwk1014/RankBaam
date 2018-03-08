//
//  CategorySelectView.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 7..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

protocol CategorySelectViewDelegate: class {
  func submitted(
    orderIndex: Int?,
    categoryIndex: Int?)
}

class CategorySelectView: UIView{
  enum `Type` {
    case orderAndCategory, onlyCategory
    
    var fitFront: Bool {
      switch self {
      case .orderAndCategory: return true
      case .onlyCategory: return false
      }}
    var fitBack: Bool { return !fitFront }
    
    var categoryTopMargin: CGFloat {
      switch self {
      case .orderAndCategory: return height667(16.0)
      case .onlyCategory: return height667(23.0)
      }}
    
    var categoryBottomMargin: CGFloat {
      switch self {
      case .orderAndCategory: return height667(15.0)
      case .onlyCategory: return height667(38.0)
      }}
    
    var categoryLabelHeight: CGFloat {
      switch self {
      case .orderAndCategory:
        return height667(74.0) //28.0 + 18.0 + 28.0
      case .onlyCategory:
        return height667(64.0) //23.0 + 18.0 + 23.0
      }}
    
    var unselectableCategory: Bool {
      switch self {
      case .orderAndCategory: return false
      case .onlyCategory: return true
      }}
  }
  
  public struct Order {
    let index: Int
    let name: String
  }
  
  public struct Category {
    let index: Int
    let name: String
  }
  
  var type: Type!
  weak var delegate: CategorySelectViewDelegate?
  
  private weak var selectedOrderLabel: UILabel?
  var selectedOrderIndex: Int? {
    return selectedOrderLabel?.tag
  }
  
  private weak var selectedCategoryLabel: UILabel?
  var selectedCategoryIndex: Int? {
    return selectedCategoryLabel?.tag
  }
  
  init(
    type: Type,
    selectedOrderIndex: Int?,
    orders: [Order]?,
    selectedCategoryIndex: Int?,
    categories: [Category],
    delegate: CategorySelectViewDelegate?) {
    super.init(frame: .zero)
    self.type = type
    self.delegate = delegate
    initView(
      selectedOrderIndex: selectedOrderIndex,
      orders: orders,
      selectedCategoryIndex: selectedCategoryIndex,
      categories: categories)
  }
  
  private func initView(
    selectedOrderIndex: Int?,
    orders: [Order]?,
    selectedCategoryIndex: Int?,
    categories: [Category]){
    self.backgroundColor = .white
    self.layer.cornerRadius = 3.0
    self.clipsToBounds = true
    
    var categoryVerticalTopConstraintItem: ConstraintItem
    
    if type == .orderAndCategory {
      #if DEBUG
        if orders == nil { assertionFailure("orders nil") }
      #endif
      let orders = orders ?? [OrderType.new,OrderType.best,OrderType.vote]
        .map({CategorySelectView.Order(index: $0.rawValue, name: $0.name)})
      
      let orderHorizontalStackView = UIStackView(arrangedSubviews:
        createOrderMultipleViews(orders: orders, selectedOrderIndex: selectedOrderIndex))
      orderHorizontalStackView.backgroundColor = .clear
      orderHorizontalStackView.axis = .horizontal
      orderHorizontalStackView.distribution = .fillProportionally
      orderHorizontalStackView.alignment = .center
      orderHorizontalStackView.spacing = 0
      self.addSubview(orderHorizontalStackView)
      orderHorizontalStackView.snp.makeConstraints {
        $0.top.equalToSuperview().offset(height667(20.0))
        $0.leading.trailing.equalToSuperview()
        $0.height.equalTo(height667(54.0))
      }
      
      let seperatorView = UIView()
      seperatorView.backgroundColor = UIColor(r: 233, g: 233, b: 233)
      self.addSubview(seperatorView)
      seperatorView.snp.makeConstraints {
        $0.top.equalTo(orderHorizontalStackView.snp.bottom)
        $0.leading.equalToSuperview().offset(width375(10.0))
        $0.trailing.equalToSuperview().offset(-width375(10.0))
        $0.height.equalTo(height667(2.0))
      }
      
      categoryVerticalTopConstraintItem = seperatorView.snp.bottom
    } else {
      categoryVerticalTopConstraintItem = self.snp.top
    }
    
    let categoryVerticalStackView = createCategoryVerticalStackView(
      categories: categories, selectedCategoryIndex: selectedCategoryIndex)
    self.addSubview(categoryVerticalStackView)
    categoryVerticalStackView.snp.makeConstraints {
      $0.top.equalTo(categoryVerticalTopConstraintItem)
        .offset(type.categoryTopMargin)
      $0.leading.trailing.equalToSuperview()
    }
    
    let submitButton = UIButton()
    submitButton.backgroundColor = UIColor(r: 248, g: 194, b: 73)
    submitButton.setAttributedTitle( .init(string: "완료", attributes: [
      .font: UIFont(name: "NanumSquareB", size: 16.0) ??
        UIFont.systemFont(ofSize: 16.0),
      .foregroundColor: UIColor(r: 77, g: 77, b: 77)
      ]), for: .normal)
    submitButton.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
    self.addSubview(submitButton)
    submitButton.snp.makeConstraints {
      $0.top.equalTo(categoryVerticalStackView.snp.bottom)
        .offset(type.categoryBottomMargin)
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(height667(56.0))
    }
  }
  
  private func createOrderMultipleViews(
    orders: [CategorySelectView.Order],
    selectedOrderIndex: Int?) -> [UIView] {
    let font = labelFont
    var views = [UIView]()
    for order in orders {
      let label = createOrderLabel(order: order, selectedOrderIndex: selectedOrderIndex, font: font)
      label.snp.makeConstraints {
        $0.height.equalTo(height667(56.0))
      }
      views.append(label)
      if order.index != orders.last?.index {
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(r: 233, g: 233, b: 233)
        seperatorView.snp.makeConstraints {
          $0.width.equalTo(width375(2.0))
          $0.height.equalTo(height667(16.0))
        }
        views.append(seperatorView)
      }
    }
    
    return views
  }
  
  private func createCategoryVerticalStackView(
    categories: [CategorySelectView.Category],
    selectedCategoryIndex: Int?) -> UIStackView {
    let verticalStackView = UIStackView(arrangedSubviews:
      createCategoryMultipleHorizontalStackViews(
        categories: categories, selectedCategoryIndex: selectedCategoryIndex))
    verticalStackView.backgroundColor = .clear
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .fillEqually
    verticalStackView.alignment = .fill
    verticalStackView.spacing = 0
    verticalStackView.layoutMargins = .init(
      top: 0, left: width375(10.0), bottom: 0, right: width375(10.0))
    verticalStackView.isLayoutMarginsRelativeArrangement = true
    
    return verticalStackView
  }
  
  private func createCategoryMultipleHorizontalStackViews(
    categories: [CategorySelectView.Category],
    selectedCategoryIndex: Int?) -> [UIStackView] {
    let font = labelFont
    
    let labels: [UILabel] = categories.map({
      createCategoryLabel(category: $0, selectedCategoryIndex: selectedCategoryIndex, font: font) })
    
    let columnCount = 3
    let rowCount = (labels.count-1)/columnCount+1
    let remain = labels.count % columnCount
    let remainInt = (remain > 0) ? 1 : 0
    
    var horizontalStackViews = [UIStackView]()
    horizontalStackViews.reserveCapacity(rowCount)
    
    for i in 0..<rowCount {
      var subLabels: [UILabel] = []
      if type.fitFront {
        subLabels += labels[i*columnCount..<min((i+1)*columnCount,labels.count)]
      } else {
        let startIndex = (i==0) ? 0 : (i-remainInt) * columnCount + remain
        let endIndex = startIndex + ((i==0) ? (labels.count-1) % columnCount + 1 : columnCount)
        subLabels += labels[startIndex..<endIndex]
      }
      
      let horizontalStackView = UIStackView(arrangedSubviews: subLabels)
      horizontalStackView.backgroundColor = .clear
      horizontalStackView.axis = .horizontal
      horizontalStackView.distribution = .fillEqually
      horizontalStackView.alignment = .fill
      horizontalStackView.spacing = 0
      horizontalStackViews.append(horizontalStackView)
      horizontalStackView.snp.makeConstraints {
        $0.height.equalTo(type.categoryLabelHeight)
      }
    }
    
    return horizontalStackViews
  }
  
  private func createOrderLabel(order: CategorySelectView.Order, selectedOrderIndex: Int?, font: UIFont) -> UILabel {
    
    let label = createLabel(font: font, tag: order.index, name: order.name,
                            selector: #selector(handleTapOrderLabel), isSelected: order.index == selectedOrderIndex)
    if order.index == selectedOrderIndex {
      selectedOrderLabel = label
    }
    
    return label
  }
  
  private func createCategoryLabel(category: CategorySelectView.Category, selectedCategoryIndex: Int?, font: UIFont) -> UILabel {
    
    let label = createLabel(font: font, tag: category.index, name: category.name,
                            selector: #selector(handleTapCategoryLabel), isSelected: category.index == selectedCategoryIndex)
    if category.index == selectedCategoryIndex {
      selectedCategoryLabel = label
    }
    
    return label
  }
  
  private func createLabel(font: UIFont, tag: Int, name: String, selector: Selector, isSelected: Bool) -> UILabel {
    let label = UILabel()
    label.font = font
    label.backgroundColor = .clear
    label.textAlignment = .center
    label.tag = tag
    label.text = name
    
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: selector))
    
    changeTextColorLabel(label, selected: isSelected)
    
    return label
  }
  
  private var labelFont: UIFont {
    return UIFont(name: "NanumSquareB", size: 16.0) ??
      UIFont.systemFont(ofSize: 16.0)
  }
  
  private var selectedLabelTextColor: UIColor {
    return .init(r: 250, g: 84, b: 76)
  }
  
  private var unselectedLabelTextColor: UIColor {
    return .init(r: 191, g: 191, b: 191)
  }
  
  private func changeTextColorLabel(_ label: UILabel, selected: Bool) {
    label.textColor = (selected) ? selectedLabelTextColor : unselectedLabelTextColor
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  override init(frame: CGRect) { super.init(frame: frame) }
}

extension CategorySelectView {
  @objc private func handleTapOrderLabel(_ sender: UITapGestureRecognizer) {
    guard let label = sender.view as? UILabel else { return }
    if selectedOrderLabel?.tag != label.tag {
      if let oldLabel = selectedOrderLabel {
        changeTextColorLabel(oldLabel, selected: false)
      }
      selectedOrderLabel = label
      changeTextColorLabel(label, selected: true)
    }
  }
  
  @objc private func handleTapCategoryLabel(_ sender: UITapGestureRecognizer) {
    guard let label = sender.view as? UILabel else { return }
    if (type.unselectableCategory || selectedCategoryLabel?.tag != label.tag),
      let oldLabel = selectedCategoryLabel {
      changeTextColorLabel(oldLabel, selected: false)
    }
    if selectedCategoryLabel?.tag != label.tag {
      selectedCategoryLabel = label
      changeTextColorLabel(label, selected: true)
    }
  }
  
  @objc private func handleSubmitButton(_ button: UIButton) {
    delegate?.submitted(
      orderIndex: selectedOrderIndex,
      categoryIndex: selectedCategoryIndex)
  }
}
