//
//  TopicCreateCameraCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 18..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TopicCreateCameraCell: UICollectionViewCell {
    var topicCreateCameraCellImageView: UIImageView = {
        let topicCreateCameraCellImageView = UIImageView()
        return topicCreateCameraCellImageView
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
        self.addSubview(topicCreateCameraCellImageView)
        let cameraImage = UIImage(named: "ic_photo_camera")?.withRenderingMode(.alwaysTemplate)
        
        topicCreateCameraCellImageView.image = cameraImage
        topicCreateCameraCellImageView.tintColor = UIColor.rankbaamOrange
        topicCreateCameraCellImageView.contentMode = .center
        
        
        topicCreateCameraCellImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
