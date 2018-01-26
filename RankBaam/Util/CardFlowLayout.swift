//
//  CardFlowLayout.swift
//  RankBaamProtoType
//
//  Created by 황재욱 on 2018. 1. 2..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import Foundation

import UIKit

class CoverFlowLayout : UICollectionViewFlowLayout {
    
    let itemScale:CGFloat = 0.5
    let itemAlpha:CGFloat = 0.5
    
    override func awakeFromNib() {
        self.minimumLineSpacing = 80.0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard  let attributes = super.layoutAttributesForElements(in: rect) else {return nil}
        
        var layoutAttribute:[UICollectionViewLayoutAttributes] = []
        for attribute in attributes
        {
            //change
            changeLayoutAttribute(attribute: attribute)
            //add
            layoutAttribute.append(attribute)
        }
        
        return layoutAttribute
    }
    
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView  else {
            return proposedContentOffset
        }
        
        guard let attributeList =  self.layoutAttributesForElements(in: collectionView.bounds) else {
            return proposedContentOffset
        }
        
       
        let sortedAttributeList = attributeList.sorted {
            (attribute1, attribute2) -> Bool in
            distance(ofCenter: attribute1.center.x) < distance(ofCenter: attribute2.center.x)
        }
       
        let xCenterOfMinimumAttributes = sortedAttributeList.first?.center.x
        
        let screenXCenter = collectionView.frame.size.width / 2
        let targetContentOffset = CGPoint(x:xCenterOfMinimumAttributes! - screenXCenter,
                                          y: proposedContentOffset.y)
        
        return targetContentOffset
    }
    
   
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
  
    func changeLayoutAttribute(attribute:UICollectionViewLayoutAttributes)
    {
        
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        
        
        
        let choiceDistance = min(distance(ofCenter: attribute.center.x), maxDistance)
        
       
        let ratio = (maxDistance - choiceDistance) / maxDistance
        
       
        let scale = ratio * (1 - self.itemScale) + 1.0
        let alpha = ratio * (1 - self.itemAlpha) + self.itemAlpha;
        
        attribute.alpha = alpha;
        attribute.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1);
        
        attribute.zIndex = NSInteger(alpha * 10.0)
    }
    
    func distance(ofCenter centerx:CGFloat) -> CGFloat
    {
        guard let collectionView = self.collectionView else {
            return 0
        }
        
     
        let offSet = collectionView.contentOffset.x + (collectionView.bounds.size.width/2)
        return  fabs(offSet - centerx)
    }
    
}

