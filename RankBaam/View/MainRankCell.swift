//
//  MainRankCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 13..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class MainRankCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userIDlabel: UILabel!
    @IBOutlet weak var votedNumberLabel: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var topicTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
