//
//  TopicDetailHeader.swift
//  RankBaamProtoType
//
//  Created by 황재욱 on 2018. 1. 2..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit

class TopicDetailHeader: UITableViewHeaderFooterView {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var likeCountButton: UIButton!
    var delegate: TopicDetailHeaderDelegate?
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func likeButtonTapped(){
        
        self.delegate?.likeButtonTapped()
        likeCountButton.imageView?.image = #imageLiteral(resourceName: "like-full")
        likeCountButton.setImage(#imageLiteral(resourceName: "like-full"), for: .selected)
        //likeCountButton.currentImage = #imageLiteral(resourceName: "like-full")
        //likeCountButton.isSelected
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}
