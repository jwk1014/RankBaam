//
//  TopicDetailOptionCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 22..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TopicDetailOptionCell: UICollectionViewCell {

    @IBOutlet weak var commentDetailButton: UIButton!
    @IBOutlet weak var optionCellBackgroundView: UIView!
    @IBOutlet weak var optionCellTitleLabel: UILabel!
    @IBOutlet weak var optionCellVoteCountLabel: UILabel!
    @IBOutlet weak var optionCellImageView: UIImageView!
    @IBOutlet weak var optionCellVotedMarkImgView: UIImageView!
    @IBOutlet weak var leadingConstraintForOptionTitle: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintForOptionVoteCount: NSLayoutConstraint!
    var isSelectedForVote: Bool = false {
        willSet {
            if newValue == true {
                optionCellBackgroundView.layer.borderColor =
                    UIColor.rankbaamOrange.cgColor
                optionCellBackgroundView.layer.borderWidth = 3
                leadingConstraintForOptionTitle.constant += 20
                optionCellVotedMarkImgView.isHidden = false
            } else {
                optionCellBackgroundView.layer.borderWidth = 0
                optionCellVotedMarkImgView.isHidden = true
                leadingConstraintForOptionTitle.constant -= 20
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewComponentConfigure()
        
    }
    
    func commentPartConfigure() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        viewComponentConfigure()
    }
    
    func viewComponentConfigure() {
        commentDetailButton.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        optionCellBackgroundView.layer.cornerRadius = 8
        optionCellBackgroundView.layer.masksToBounds = true
    }
    override func prepareForReuse() {
        if isSelectedForVote {
            isSelectedForVote = false
        }
    }
    
}
