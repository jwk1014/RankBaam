//
//  TopicCreatePhotosCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 9..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TopicCreatePhotosCell: UICollectionViewCell {
    
    var topicCreatePhotosCellImageView: UIImageView = {
        var topicCreatePhotosCellImageView = UIImageView()
        return topicCreatePhotosCellImageView
    }()
    var selectedLogoImageView: UIImageView = {
        var selectedLogoImageView = UIImageView()
        return selectedLogoImageView
    }()
    
    var isSelectedPhoto: Bool = false {
        didSet {
            self.selectedAlpha = isSelectedPhoto ? 0.6 : 0
        }
    }
    var selectedAlpha: CGFloat = 0 {
        didSet{
            selectedLogoImageView.alpha = selectedAlpha
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        self.addSubview(topicCreatePhotosCellImageView)
        self.addSubview(selectedLogoImageView)
        
        selectedLogoImageView.image = UIImage(named: "noimage")
        selectedLogoImageView.alpha = 0
        
        
        topicCreatePhotosCellImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        selectedLogoImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectedAlpha = 0
        isSelectedPhoto = false
    }
}
