//
//  CustomCollectionViewFlowLayout.swift
//  CollectionViewTesting
//
//  Created by 김정원 on 2018. 3. 11..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class StaticHeaderFooterFlowLayout: UICollectionViewLayout {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(){
    super.init()
  }
  
  var minimumInteritemSpacing: CGFloat = 10.0
  var minimumLineSpacing: CGFloat = 10.0
  var sectionInset: UIEdgeInsets = .zero
  var itemSize: CGSize = .zero
  weak var staticHeaderView: UIView?
  weak var staticFooterView: UIView?
  
  private var contentSize: CGSize = .zero {
    didSet {
      staticFooterView?.frame.origin.y =
        ((staticHeaderView?.isHidden ?? true) ? 0.0 : staticHeaderView?.frame.maxY ?? 0.0) +
        contentSize.height
    }
  }
  
  override var collectionViewContentSize: CGSize {
    var size = contentSize
    size.height += (
      ((staticHeaderView?.isHidden ?? true) ? 0.0 : staticHeaderView?.frame.maxY ?? 0.0) + ((staticFooterView?.isHidden ?? true) ? 0.0 : staticFooterView?.bounds.height ?? 0.0)
    )
    return size
  }
  
  private var cache = [UICollectionViewLayoutAttributes]()
  
  override func prepare() {
    guard let collectionView = collectionView else { return }
    
    cache.removeAll()
    
    let delegateFlowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout
    
    let numberOfSections = collectionView.numberOfSections
    
    var tmpWidth: CGFloat = 0
    var tmpHeight: CGFloat = collectionView.contentInset.top
    var cellSize: CGSize = .zero
    
    var cellAttrCache = [(indexPath: IndexPath, cellSize: CGSize)]()
    
    let contentWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - sectionInset.left - sectionInset.right
    let contentInsetLeft = collectionView.contentInset.left + sectionInset.left
    
    for section in 0..<numberOfSections {
      let minItemSpacing = (delegateFlowLayout?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? self.minimumInteritemSpacing)
      let minLineSpacing = (delegateFlowLayout?.collectionView?(collectionView, layout: self,
          minimumLineSpacingForSectionAt: section) ?? self.minimumLineSpacing)
      
      if let headerSize = delegateFlowLayout?.collectionView?(collectionView, layout: self, referenceSizeForHeaderInSection: section) {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(row: 0, section: section))
        attributes.frame = CGRect(
          x: 0, y: tmpHeight, width: headerSize.width, height: headerSize.height)
        cache.append(attributes)
        tmpHeight += headerSize.height
      }
      tmpHeight += sectionInset.top
      
      for cellIndex in 0 ..< collectionView.numberOfItems(inSection: section) {
        let indexPath = IndexPath(item: cellIndex, section: section)
        cellSize = delegateFlowLayout?.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
        
        if tmpWidth + cellSize.width > contentWidth && !cellAttrCache.isEmpty {
          tmpHeight = nextLine(height: tmpHeight, minLineSpacing: minLineSpacing, contentWidth: contentWidth,  contentInsetLeft: contentInsetLeft, cellAttrs: &cellAttrCache)
          tmpWidth = 0
        }
        
        cellAttrCache.append((indexPath: indexPath, cellSize: cellSize))
        
        tmpWidth += cellSize.width + minItemSpacing
      }
      if !cellAttrCache.isEmpty {
        tmpHeight = nextLine(height: tmpHeight, minLineSpacing: 0, contentWidth: contentWidth,
                             contentInsetLeft: contentInsetLeft, cellAttrs: &cellAttrCache)
        tmpWidth = 0
      }
      tmpHeight += sectionInset.bottom
      
      if let footerSize = delegateFlowLayout?.collectionView?(collectionView, layout: self, referenceSizeForFooterInSection: section) {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath(row: 0, section: section))
        attributes.frame = CGRect(
          x: 0, y: tmpHeight, width: footerSize.width, height: footerSize.height)
        cache.append(attributes)
        tmpHeight += footerSize.height
      }
    }
    contentSize = .init(width: contentWidth, height: tmpHeight)
  }
  
  private func nextLine(height: CGFloat, minLineSpacing: CGFloat, contentWidth: CGFloat, contentInsetLeft: CGFloat, cellAttrs: inout [(indexPath: IndexPath, cellSize: CGSize)]) -> CGFloat{
    var nextLineHeight: CGFloat = height
    if cellAttrs.count == 1 {
      let cellAttr = cellAttrs[0]
      let attributes = UICollectionViewLayoutAttributes(forCellWith: cellAttr.indexPath)
      attributes.frame = CGRect(
        x: (contentWidth - cellAttr.cellSize.width)/2.0, y: height,
        width: cellAttr.cellSize.width, height: cellAttr.cellSize.height)
      cache.append(attributes)
      nextLineHeight += cellAttr.cellSize.height
    } else if cellAttrs.count > 1 {
      let remainWidth = contentWidth - cellAttrs.reduce(CGFloat(0.0),{ $0 + $1.cellSize.width })
      let maxHeight = cellAttrs.reduce(CGFloat(0.0), { max($0, $1.cellSize.height) })
      let itemSpacing = remainWidth / CGFloat(cellAttrs.count - 1)
      var tmpWidth: CGFloat = contentInsetLeft
      for cellAttr in cellAttrs {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: cellAttr.indexPath)
        attributes.frame = CGRect(
          x: tmpWidth, y: height + (maxHeight - cellAttr.cellSize.height) / CGFloat(2.0),
          width: cellAttr.cellSize.width, height: cellAttr.cellSize.height)
        cache.append(attributes)
        tmpWidth += cellAttr.cellSize.width + itemSpacing
      }
      nextLineHeight = height + maxHeight
    }
    cellAttrs.removeAll()
    return nextLineHeight + minLineSpacing
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let headerViewMaxY = ((staticHeaderView?.isHidden ?? true) ? 0.0 : staticHeaderView?.frame.maxY ?? 0.0)
    return cache.map({
      var attributes = UICollectionViewLayoutAttributes(forCellWith: $0.indexPath)
      attributes.frame = $0.frame
      attributes.frame.origin.y += headerViewMaxY
      return attributes
    }).filter{ $0.frame.intersects(rect) }
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache.filter({ $0.indexPath == indexPath }).first
  }
  
  override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
    
      attributes?.alpha = 0.0
      attributes?.transform = CGAffineTransform(
        translationX: 0,
        y: 200.0
      )
    
    return attributes
  }
  
  /*override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
    attributes?.copy()
    attributes?.transform3D = CATransform3DMakeTranslation(0.1, 0.0, 0.0)
    return attributes
  }*/
  
}
