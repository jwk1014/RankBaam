//
//  MainAllRankLoadingFooterView.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 18..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class MainAllRankLoadingFooterView: UICollectionReusableView {

    @IBOutlet weak var loadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lastDataLoadedIndicator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadActivityIndicator.isHidden = true
        lastDataLoadedIndicator.isHidden = true
    }
    
    func backToInit(){
        loadActivityIndicator.isHidden = true
        lastDataLoadedIndicator.isHidden = true
    }
    
    func endLoad() {
        loadActivityIndicator.isHidden = true
        lastDataLoadedIndicator.isHidden = false
    }
    
    func startLoad() {
        loadActivityIndicator.isHidden = false
    }
}
