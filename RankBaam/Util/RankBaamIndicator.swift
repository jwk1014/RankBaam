//
//  RankBaamIndicator.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 24..
//  Copyright © 2018년 김정원. All rights reserved.
//

import Foundation
import Kingfisher

struct RankBaamIndicator: Indicator {
    var view: IndicatorView = UIView()
    
    
    let orangeIndicator = UIActivityIndicatorView()
    
    
    func startAnimatingView() {
        orangeIndicator.startAnimating()
        orangeIndicator.isHidden = false
    }
    func stopAnimatingView() {
        orangeIndicator.stopAnimating()
        orangeIndicator.isHidden = true
    }
    
    init() {
        view.backgroundColor = UIColor.clear
        view.addSubview(orangeIndicator)
        orangeIndicator.color = UIColor.rankbaamOrange
    }
    
}
