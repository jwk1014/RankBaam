//
//  PresentFadeInOut.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 23..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

protocol PresentFadeInOutDelegate {
  func prepareFade(vc: UIViewController, fade: PresentationFade)
}

class PresentFadeInOutManager: NSObject, UIViewControllerTransitioningDelegate {
  var delegate: PresentFadeInOutDelegate?
  override init() {
    super.init()
  }
  convenience init(delegate: PresentFadeInOutDelegate) {
    self.init()
    self.delegate = delegate
  }
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    delegate?.prepareFade(vc: presented, fade: .in)
    return FadePresentationAnimator(fade: .in, isPresentation: true)
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    delegate?.prepareFade(vc: dismissed, fade: .out)
    return FadePresentationAnimator(fade: .out, isPresentation: false)
  }
}

enum PresentationFade {
  case `in`
  case `out`
}

final class FadePresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  let fade: PresentationFade
  let isPresentation: Bool
  
  init(fade: PresentationFade, isPresentation: Bool) {
    self.fade = fade
    self.isPresentation = isPresentation
    super.init()
  }
  
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.25
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromController = transitionContext.viewController(forKey: .from)!
    let toController = transitionContext.viewController(forKey: .to)!
    
    let (presentedView, dismissView) = (toController.view!, fromController.view!)
    
    if isPresentation {
      transitionContext.containerView.addSubview(presentedView)
    }
    
    switch self.fade {
    case .`in`:
      presentedView.alpha = 0.0
    case .`out`:
      presentedView.frame.size = dismissView.frame.size
    }
    
    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      animations: {
        switch self.fade {
        case .`in`:
          presentedView.alpha = 1.0
        case .`out`:
          dismissView.alpha = 0.0
        }
    },
      completion: { finished in
        transitionContext.completeTransition(finished)
        /*if self.isPresentation {
          dismissView.frame.size = CGSize.zero
        }*/
    })
  }
}
