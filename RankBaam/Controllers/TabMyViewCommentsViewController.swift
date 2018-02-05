//
//  TabMyViewCommentsViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 31..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabMyViewCommentsViewController: UIViewController {

    var tabMyViewCommentsCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let tabMyViewRankingsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        flowlayout.scrollDirection = .vertical
        return tabMyViewRankingsCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(tabMyViewCommentsCollectionView)
        tabMyViewCommentsCollectionView.backgroundColor = UIColor.rankbaamGray
        tabMyViewCommentsCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Constants.screenHeight * (103 / 667))
        }
    }
}
