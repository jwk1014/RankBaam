//
//  MainAllRankCell.swift
//  0116#RankBaamMainCollectionProto
//
//  Created by 황재욱 on 2018. 1. 17..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit

class MainAllRankCell: UICollectionViewCell {

    @IBOutlet weak var mainRankCellImg: UIImageView!
    @IBOutlet weak var mainRankCellTitleLabel: UILabel!
    @IBOutlet weak var mainRankCellLikeCountLabel: UILabel!
    
    var likeCount: Int = 0 {
        
        didSet {
            
            mainRankCellLikeCountLabel.text = likeCount <= 9999 ?
                " \(likeCount)" : " 9999+"
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.black.cgColor
        
        // MARK: shadowOffset은 translate 같이 그림자를 이동시키는 역할
        
        self.layer.shadowOffset = CGSize(width: 6, height: 6)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
        /*self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath*/
        cellComponentConfigure()
    }
    
    func cellDatasConfigure(topic: Topic) {
        mainRankCellTitleLabel.text = topic.title
        likeCount = topic.likeCount
        
    }
    
    func cellComponentConfigure() {
        mainRankCellImg.layer.cornerRadius = 12
        mainRankCellImg.layer.masksToBounds = true
        mainRankCellImg.clipsToBounds = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        cellComponentConfigure()
    }
    

}
