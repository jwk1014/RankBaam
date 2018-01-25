//
//  SpreadTransition.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 24..
//  Copyright © 2018년 김정원. All rights reserved.
//

import Foundation
import UIKit

class SpreadTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let durationTime = 0.4
    var startFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let transitionedView = transitionContext.view(forKey: .to)!
        
        
        let startFrameSize = startFrame
        let endFrameSize = transitionedView.frame
        
        transitionedView.transform = CGAffineTransform(scaleX: startFrameSize.width / endFrameSize.width, y: startFrameSize.height / endFrameSize.height)
        transitionedView.center = CGPoint(x: startFrameSize.midX, y: startFrameSize.midY)
        transitionedView.alpha = 0
        
        containerView.addSubview(transitionedView)
        
        UIView.animate(withDuration: durationTime, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, animations: {
            transitionedView.transform = CGAffineTransform.identity
            transitionedView.center = CGPoint(x: endFrameSize.midX, y: endFrameSize.midY)
            transitionedView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(true)
        }
      )
    }
}
