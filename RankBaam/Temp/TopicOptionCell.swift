//
//  TopicOptionCell.swift
//  RankBaamProtoType
//
//  Created by 황재욱 on 2018. 1. 2..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit

class TopicOptionCell: UITableViewCell {

    @IBOutlet weak var optionTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
