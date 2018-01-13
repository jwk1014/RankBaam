//
//  MainHotRankCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 13..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class MainHotRankCell: UITableViewCell {

    @IBOutlet weak var MainHotRankCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.MainHotRankCollectionView.delegate = self
        self.MainHotRankCollectionView.dataSource = self
        MainHotRankCollectionView.register(UINib.init(nibName: "MainHotRankCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MainHotRankCollectionCell")
        MainHotRankCollectionView.isPagingEnabled = true
        
      
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.MainHotRankCollectionView.delegate = self
        self.MainHotRankCollectionView.dataSource = self
        MainHotRankCollectionView.register(UINib.init(nibName: "MainHotRankCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MainHotRankCollectionCell")
    }
}

extension MainHotRankCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 220)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainHotRankCollectionCell", for: indexPath)
        return cell
    }

}

extension MainHotRankCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
