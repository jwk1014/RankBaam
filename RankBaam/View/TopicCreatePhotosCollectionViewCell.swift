//
//  TopicCreatePhotosCollectionViewCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 14..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TopicCreatePHAssetBunchViewCell: UITableViewCell {

    var bunchViewThumbnailImageView: UIImageView = {
        let bunchViewThumbnailImageView = UIImageView()
        return bunchViewThumbnailImageView
    }()
    
    var bunchViewStackView: UIStackView = {
        let bunchViewStackView = UIStackView()
        bunchViewStackView.axis = .vertical
        return bunchViewStackView
    }()
    
    var bunchViewTitleLabel: UILabel = {
        let collectionTitleLabel = UILabel()
        return collectionTitleLabel
    }()
    
    var bunchViewPhotosCountLabel: UILabel = {
        let collectionPhotosCountLabel = UILabel()
        return collectionPhotosCountLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewInitConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        self.addSubview(bunchViewThumbnailImageView)
        self.addSubview(bunchViewStackView)
        bunchViewStackView.addArrangedSubview(bunchViewTitleLabel)
        bunchViewStackView.addArrangedSubview(bunchViewPhotosCountLabel)
        
        bunchViewTitleLabel.text = "카메라 롤"
        bunchViewTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        bunchViewPhotosCountLabel.text = "754"
        bunchViewPhotosCountLabel.font = UIFont.systemFont(ofSize: 11)
        bunchViewStackView.distribution = .fillProportionally
        
        bunchViewThumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(self.snp.left).offset(width375(15))
            $0.height.width.equalTo(width375(50))
        }
        bunchViewStackView.snp.makeConstraints {
            $0.left.equalTo(bunchViewThumbnailImageView.snp.right).offset(15)
            $0.top.equalTo(self.snp.top).offset(10)
            $0.bottom.equalTo(self.snp.bottom).offset(-10)
            $0.right.equalTo(self.snp.right).offset(-10)
        }
    }
}
