//
//  MainArrangedRankHeader.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 13..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class MainArrangedRankHeader: UITableViewCell {

    @IBOutlet weak var arrangedRecentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrangedRecentButton.layer.borderColor = UIColor.black.cgColor
        arrangedRecentButton.layer.borderWidth = 3
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
