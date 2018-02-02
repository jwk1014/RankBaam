//
//  TopicDetailImagesCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 30..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TopicDetailImagesCell: UICollectionViewCell {
    
    var topicDetailImagesCellImageView: UIImageView = {
        let topicDetailImagesCellImageView = UIImageView()
        return topicDetailImagesCellImageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        self.addSubview(topicDetailImagesCellImageView)
        topicDetailImagesCellImageView.contentMode = .scaleAspectFit
        topicDetailImagesCellImageView.image = UIImage(named: "noimage")
        topicDetailImagesCellImageView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
}
