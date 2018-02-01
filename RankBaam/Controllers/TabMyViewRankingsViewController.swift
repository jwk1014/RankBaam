//
//  TabMyViewRankingsViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 31..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabMyViewRankingsViewController: UIViewController {

    var tabMyViewRankingsCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let tabMyViewRankingsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        return tabMyViewRankingsCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(tabMyViewRankingsCollectionView)
        tabMyViewRankingsCollectionView.backgroundColor = UIColor.rankbaamGray
        tabMyViewRankingsCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Constants.screenHeight * (103 / 667))
        }
    }
}


