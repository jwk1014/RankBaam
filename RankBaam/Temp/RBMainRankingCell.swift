//
//  RBMainRankingCell.swift
//  RankBaamProtoType
//
//  Created by 황재욱 on 2018. 1. 2..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit

class RBMainRankingCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var likeCount: Int = 0 {
        
        didSet{
            likeCountLabel.text = "\(likeCount)"
            //likeButton.isSelected = true
        }
    }
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        //self.layer.shadowPath = CGPath(ellipseIn: self.bounds, transform: nil)
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        // likeButton.setImage(#imageLiteral(resourceName: "like-full"), for: .selected)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.backgroundImg.layer.shadowColor = UIColor.red.cgColor
        self.backgroundImg.layer.shadowOffset = CGSize(width: 0, height: 2)
        //self.layer.shadowPath = CGPath(ellipseIn: self.bounds, transform: nil)
        self.backgroundImg.layer.masksToBounds = false
        self.backgroundImg.layer.shadowRadius = 3
        self.backgroundImg.layer.shadowOpacity = 1
        
    }
}
