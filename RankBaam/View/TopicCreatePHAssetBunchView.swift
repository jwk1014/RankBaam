//
//  TopicCreatePHAssetBunchView.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 14..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TopicCreatePHAssetBunchView: UIView {

    var topicCreatePHAssetBunchViewUpwardArrowImageView: UIImageView = {
        let topicCreatePHAssetBunchViewUpwardArrowImageView = UIImageView()
        return topicCreatePHAssetBunchViewUpwardArrowImageView
    }()

    var topicCreatePHAssetBunchViewTableView: UITableView = {
        let TopicCreatePHAssetBunchViewTableView = UITableView()
        return TopicCreatePHAssetBunchViewTableView
    }()
    
    var topicCreatePHAssetBunchViewTableViewHeightConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        self.backgroundColor = UIColor.rankbaamOrange.withAlphaComponent(0.6)
        self.addSubview(topicCreatePHAssetBunchViewUpwardArrowImageView)
        self.addSubview(topicCreatePHAssetBunchViewTableView)
        
        topicCreatePHAssetBunchViewUpwardArrowImageView.image = UIImage(named: "ic_arrow_drop_up")?.withRenderingMode(.alwaysTemplate)
        topicCreatePHAssetBunchViewUpwardArrowImageView.tintColor = UIColor.white
        //topicCreatePHAssetBunchViewUpwardArrowImageView.backgroundColor = UIColor.rankbaamOrange
        topicCreatePHAssetBunchViewUpwardArrowImageView.contentMode = .scaleToFill
        topicCreatePHAssetBunchViewTableView.backgroundColor = UIColor.white
        topicCreatePHAssetBunchViewTableView.register(TopicCreatePHAssetBunchViewCell.self, forCellReuseIdentifier: String(describing: TopicCreatePHAssetBunchViewCell.self))
        
        topicCreatePHAssetBunchViewUpwardArrowImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(80)
        }
        topicCreatePHAssetBunchViewTableView.translatesAutoresizingMaskIntoConstraints = false
        let topCon = topicCreatePHAssetBunchViewTableView.topAnchor
            .constraint(equalTo: topicCreatePHAssetBunchViewUpwardArrowImageView.bottomAnchor)
        topCon.constant = -35
        topCon.isActive = true
        topicCreatePHAssetBunchViewTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topicCreatePHAssetBunchViewTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        let heightCon = topicCreatePHAssetBunchViewTableView.heightAnchor.constraint(equalToConstant: height667(250))
        heightCon.isActive = true
        topicCreatePHAssetBunchViewTableViewHeightConstraint = heightCon
    }
}
