//
//  TabHomeWeeklyRankViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 20..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabHomeWeeklyRankViewController: UIViewController {

    @IBOutlet weak var weeklyRankCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weeklyRankCellNib = UINib(nibName: "MainWeeklyRankCell", bundle: nil)
        weeklyRankCollectionView.register(weeklyRankCellNib, forCellWithReuseIdentifier: "MainWeeklyRankCell")
        weeklyRankCollectionView.backgroundColor = UIColor.rankbaamGray
       
    }

}

extension TabHomeWeeklyRankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let weeklyRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainWeeklyRankCell", for: indexPath)
        return weeklyRankCell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TabHomeWeeklyRankViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.bounds.size.height * 0.35, height: collectionView.bounds.size.height * 0.6)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = (collectionView.bounds.size.width - collectionView.bounds.size.height * 0.35)/2
        
        return UIEdgeInsets(top: 0, left:sideInset , bottom: 0, right: sideInset)
    }
}
