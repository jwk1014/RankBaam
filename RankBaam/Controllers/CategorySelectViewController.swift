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
extension CategoryDelegate {}

protocol CategorySelectDelegate: CategoryDelegate {
  func submitted(category: Category?)
  func closed(category: Category?)
}
protocol CategoryOrderSelectDelegate: CategoryDelegate {
  func submitted(order: OrderType, category: Category?)
  func closed(order: OrderType, category: Category?)
}

class CategorySelectViewController: UIViewController {
  private var snapshotCategories: [Category] = []
  private var orders: [OrderType]? = nil
  private var selectedCategory: Category? = nil
  private var selectedOrder: OrderType? = nil
  var defaultOrder: OrderType = .new
  var delegate: CategoryDelegate?
  var defaultCategory: Category = .init(categorySN: 0, name: "전체")
  var categoryAll: Category {
    return .init(categorySN: 0, name: "전체")
  }
  
  static func createForOrderAndCategory(selectedOrder: OrderType, selectedCategory: Category) -> CategorySelectViewController {
    let vc = CategorySelectViewController()
    vc.orders = [OrderType.new, OrderType.best, OrderType.vote]
    vc.snapshotCategories = [vc.categoryAll] + categories
    vc.selectedOrder = selectedOrder
    vc.selectedCategory = selectedCategory
    return vc
  }
  
  static func createForCategory(selectedCategory: Category?) -> CategorySelectViewController {
    let vc = CategorySelectViewController()
    vc.snapshotCategories = categories
    vc.selectedCategory = selectedCategory
    return vc
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
      delegate.closed(category: selectedCategory)
    } else if let delegate = delegate as? CategoryOrderSelectDelegate {
      delegate.closed(order: selectedOrder ?? defaultOrder, category: selectedCategory)
    }
    dismiss(animated: true, completion: nil)
  }
  
  private func initView() {
    view.backgroundColor = UIColor.black.withAlphaComponent(106.0/255.0)
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleView)))
    
    let type: CategorySelectView.`Type` = (orders != nil) ? .orderAndCategory : .onlyCategory
    
    let categorySelectView = CategorySelectView(
      type: type,
      selectedOrderIndex: type == .orderAndCategory ? (selectedOrder ?? defaultOrder).rawValue : nil,
      orders: orders?.map({CategorySelectView.Order(index: $0.rawValue, name: $0.name)}),
      selectedCategoryIndex: selectedCategory?.categorySN,
      categories: categories.map({CategorySelectView.Category(index: $0.categorySN, name: $0.name)}),
      delegate: self)
    self.view.addSubview(categorySelectView)
    categorySelectView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
      $0.width.equalTo(width375(321.0))
    }
    
    if type == .onlyCategory {
      let label = UILabel()
      label.backgroundColor = UIColor.clear
      label.attributedText = .init(string: "카테고리를 선택해 주세요.", attributes: [
        .font: UIFont(name: "NanumSquareB", size: 16.0) ??
               UIFont.systemFont(ofSize: 16.0),
        .foregroundColor: UIColor.white
      ])
      view.addSubview(label)
      label.snp.makeConstraints {
        $0.leading.equalTo(categorySelectView.snp.leading)
        $0.bottom.equalTo(categorySelectView.snp.top).offset(-height667(8.0))
      }
    }
    
    let button = UIButton()
    let buttonPadding = width375(9.0)
    button.setImage(UIImage(named: "ic_close")?.copy(with: .init(
      top: buttonPadding, left: buttonPadding,
      bottom: buttonPadding, right: buttonPadding), isTemplate: true), for: .normal)
    button.imageView?.tintColor = UIColor.white
    button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    view.addSubview(button)
    button.snp.makeConstraints {
      $0.width.equalTo(width375(CGFloat(23.0 + Double(buttonPadding) * 2)))
      $0.height.equalTo(button.snp.width)
      $0.trailing.equalTo(categorySelectView)
      $0.bottom.equalTo(categorySelectView.snp.top).offset(-height667(13.0))
    }
  }

}

extension CategorySelectViewController: CategorySelectViewDelegate {
  func submitted(orderIndex: Int?, categoryIndex: Int?) {
    if let delegate = delegate as? CategorySelectDelegate {
      delegate.submitted(category: categories.first(where: { $0.categorySN == categoryIndex }))
    } else if let delegate = delegate as? CategoryOrderSelectDelegate {
      delegate.submitted(
        order: orders?.first(where: { $0.rawValue == orderIndex }) ?? defaultOrder,
        category: categories.first(where: { $0.categorySN == categoryIndex }) ?? defaultCategory )
    }
    dismiss(animated: true, completion: nil)
  }
}