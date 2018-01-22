//
//  loadIndicatorFooter.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 13..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class loadIndicatorFooter: UITableViewCell {

    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        loadIndicator.startAnimating()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
