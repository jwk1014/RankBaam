//
//  MainAllRankCell2.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 27..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class MainAllRankCell: UICollectionViewCell {
    
    var mainAllRankCellBackgroundView: UIView = {
        let mainAllRankCellBackgroundView = UIView()
        return mainAllRankCellBackgroundView
    }()
    
    var mainAllRankCellImageViewShadowView: UIView = {
        let mainAllRankCellImageViewShadowView = UIView()
        return mainAllRankCellImageViewShadowView
    }()
    
    var mainAllRankCellImageView: UIImageView = {
        let mainAllRankCellImageView = UIImageView()
        return mainAllRankCellImageView
    }()
    
    var mainAllRankCellTitleLabel: UILabel = {
        let mainAllRankCellTitleLabel = UILabel()
        return mainAllRankCellTitleLabel
    }()
    
    var mainAllRankCellNicknameStarImageView: UIImageView = {
        let mainAllRankCellNicknameStarImageView = UIImageView()
        return mainAllRankCellNicknameStarImageView
    }()
    
    var mainAllRankCellWriterNicknameLabel: UILabel = {
        let mainAllRankCellWriterNicknameLabel = UILabel()
        return mainAllRankCellWriterNicknameLabel
    }()
    
    var mainAllRankVoteBoxImageView: UIImageView = {
        let mainAllRankVoteBoxImageView = UIImageView()
        return mainAllRankVoteBoxImageView
    }()
    
    var mainAllRankVoteCountLabel: UILabel = {
        let mainAllRankVoteCountLabel = UILabel()
        return mainAllRankVoteCountLabel
    }()
    
    var mainAllRankLikeThumbImageView: UIImageView = {
        let mainAllRankLikeThumbImageView = UIImageView()
        return mainAllRankLikeThumbImageView
    }()
    
    var mainAllRankLikeCountLabel: UILabel = {
        let mainAllRankLikeCountLabel = UILabel()
        return mainAllRankLikeCountLabel
    }()
    
    var likedStoredRankCellEditingCheckBox: UIImageView = {
        let likedStoredRankCellEditingCheckBox = UIImageView()
        return likedStoredRankCellEditingCheckBox
    }()
    
    @IBOutlet weak var mainRankCellImgShadowView: UIView!
    
    var likeCount: Int = 0 {
        didSet {
            mainAllRankLikeCountLabel.text = likeCount <= 9999 ?
                " \(likeCount)" : " 9999+"
        }
    }
    
    var voteCount: Int = 0 {
        didSet {
            mainAllRankVoteCountLabel.text = likeCount <= 9999 ?
                " \(voteCount)" : " 9999+"
        }
    }
    
    var isEditingLikedCell: Bool = false {
        didSet {
           
            likedStoredRankCellEditingCheckBox.isHidden = !isEditingLikedCell
            
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
    func cellDatasConfigure(topic: Topic) {
        mainAllRankCellTitleLabel.text = topic.title
        likeCount = topic.likeCount
        voteCount = topic.voteCount
        mainAllRankCellWriterNicknameLabel.text = " \(topic.writer.nickname)"
        if !topic.photos.isEmpty {
            if topic.photos.count > 1 {
                guard let mainPhoto = topic.photos.first(where: { photo -> Bool in
                    return photo.order == topic.photoMain
                }) else { return }
                let imgURL = URL(string: mainPhoto.realUrl)
                mainAllRankCellImageView.sd_setImage(with: imgURL, completed: nil)
            } else {
                let imgURL = URL(string: topic.photos[0].realUrl)
                mainAllRankCellImageView.sd_setImage(with: imgURL, completed: nil)
            }
            
        }
    }
    
    fileprivate func viewInitConfigure() {
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.7
        self.addSubview(mainAllRankCellBackgroundView)
        self.addSubview(mainAllRankCellImageViewShadowView)
        self.addSubview(mainAllRankCellImageView)
        mainAllRankCellBackgroundView.addSubview(mainAllRankCellTitleLabel)
        mainAllRankCellBackgroundView
            .addSubview(mainAllRankCellNicknameStarImageView)
        mainAllRankCellBackgroundView.addSubview(mainAllRankCellWriterNicknameLabel)
        mainAllRankCellBackgroundView.addSubview(mainAllRankVoteBoxImageView)
        mainAllRankCellBackgroundView.addSubview(mainAllRankVoteCountLabel)
        mainAllRankCellBackgroundView.addSubview(mainAllRankLikeThumbImageView)
        mainAllRankCellBackgroundView.addSubview(mainAllRankLikeCountLabel)
        mainAllRankCellBackgroundView
            .addSubview(likedStoredRankCellEditingCheckBox)
        
        
        mainAllRankCellBackgroundView.backgroundColor = UIColor.white
        mainAllRankCellBackgroundView.layer.cornerRadius = 8
        mainAllRankCellBackgroundView.layer.masksToBounds = true
        mainAllRankCellImageViewShadowView.backgroundColor = UIColor.white
        mainAllRankCellImageViewShadowView.layer.cornerRadius = 8
        mainAllRankCellImageViewShadowView.layer.shadowOpacity = 0.7
        mainAllRankCellImageViewShadowView.layer.shadowOffset =
            CGSize(width: 4, height: 4)
        mainAllRankCellImageViewShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        mainAllRankCellImageViewShadowView.layer.shadowRadius = 5
        mainAllRankCellImageView.image = UIImage(named: "noimage")
        mainAllRankCellImageView.contentMode = .scaleAspectFit
        mainAllRankCellImageView.layer.cornerRadius = 8
        mainAllRankCellImageView.layer.masksToBounds = true
        mainAllRankCellTitleLabel.text = "겨울에 가기 좋은 해외 여행지는?"
        mainAllRankCellTitleLabel.font = mainAllRankCellTitleLabel
            .font
            .withSize( self.frame.height * (14 / 122))
        mainAllRankCellNicknameStarImageView.image = UIImage(named: "starImg")
        mainAllRankCellNicknameStarImageView.contentMode = .scaleAspectFit
        mainAllRankCellWriterNicknameLabel.text = "iphoneuser1234"
        mainAllRankCellWriterNicknameLabel.textColor = UIColor.rankbaamDarkgray
        mainAllRankCellWriterNicknameLabel.font = mainAllRankCellWriterNicknameLabel
            .font
            .withSize(self.frame.height * (12 / 122))
        mainAllRankVoteBoxImageView.image = UIImage(named: "voteImg")
        mainAllRankVoteBoxImageView.contentMode = .scaleAspectFit
        mainAllRankVoteCountLabel.text = "9999+"
        mainAllRankVoteCountLabel.textColor = UIColor.rankbaamBlack
        mainAllRankVoteCountLabel.font = mainAllRankVoteCountLabel
            .font
            .withSize(self.frame.height * (13 / 122))
        mainAllRankLikeThumbImageView.image = UIImage(named: "likeImg")
        mainAllRankLikeThumbImageView.contentMode = .scaleAspectFit
        mainAllRankLikeCountLabel.text = "9999+"
        mainAllRankLikeCountLabel.textColor = UIColor.rankbaamBlack
        mainAllRankLikeCountLabel.font = mainAllRankVoteCountLabel
            .font
            .withSize(self.frame.height * (13 / 122))
        likedStoredRankCellEditingCheckBox.image = UIImage(named: "bcheckBoxIcn")
        likedStoredRankCellEditingCheckBox.contentMode = .center
        likedStoredRankCellEditingCheckBox.isHidden = true
        
        mainAllRankCellBackgroundView.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(self.frame.width * ( 24 / 343 ))
            $0.top.right.bottom.equalToSuperview()
        }
        mainAllRankCellImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(self.snp.top).offset(self.frame.height * (13 / 122))
            $0.bottom.equalTo(self.snp.bottom).offset(-(self.frame.height * (13 / 122)))
            $0.width.equalTo(self.frame.width * (96 / 343))
        }
        mainAllRankCellImageViewShadowView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(self.snp.top).offset(self.frame.height * (15 / 122))
            $0.bottom.equalTo(self.snp.bottom).offset(-(self.frame.height * (15 / 122)))
            $0.width.equalTo(self.frame.width * (94 / 343))
        }
        mainAllRankCellTitleLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellImageView.snp.right)
                .offset(self.frame.width * (17 / 343))
            $0.top.equalTo(mainAllRankCellBackgroundView.snp.top)
                .offset(self.frame.height * (18 / 122))
            $0.width.equalTo(self.frame.width * (212 / 343))
            $0.height.equalTo(self.frame.height * ( 40 / 122 ))
        }
        mainAllRankCellNicknameStarImageView.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellImageView.snp.right)
                .offset(self.frame.width * (17 / 343))
            $0.top.equalTo(mainAllRankCellTitleLabel.snp.bottom)
                .offset(self.frame.height * (10 / 122))
            $0.width.equalTo(self.frame.width * (14 / 343))
            $0.height.equalTo(self.frame.height * ( 14 / 122 ))
        }
        mainAllRankCellWriterNicknameLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellNicknameStarImageView.snp.right)
                .offset(self.frame.width * (3 / 343))
            $0.top.equalTo(mainAllRankCellTitleLabel.snp.bottom)
                .offset(self.frame.height * (11 / 122))
            $0.width.equalTo(self.frame.width * (170 / 343))
            $0.height.equalTo(self.frame.height * ( 13 / 122 ))
        }
        mainAllRankVoteBoxImageView.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellImageView.snp.right)
                .offset(self.frame.width * (17 / 343))
            $0.top.equalTo(mainAllRankCellNicknameStarImageView.snp.bottom)
                .offset(self.frame.height * (11 / 122))
            $0.width.equalTo(self.frame.width * (18 / 343))
            $0.height.equalTo(self.frame.height * ( 14 / 122 ))
        }
        mainAllRankVoteCountLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankVoteBoxImageView.snp.right)
                .offset(self.frame.width * (4 / 343))
            $0.top.equalTo(mainAllRankCellWriterNicknameLabel.snp.bottom)
                .offset(self.frame.height * (10 / 122))
            $0.width.equalTo(self.frame.width * (43 / 343))
            $0.height.equalTo(self.frame.height * ( 16 / 122 ))
        }
        mainAllRankLikeThumbImageView.snp.makeConstraints {
            $0.left.equalTo(mainAllRankVoteCountLabel.snp.right)
                .offset(self.frame.width * (57 / 343))
            $0.top.equalTo(mainAllRankCellWriterNicknameLabel.snp.bottom)
                .offset(self.frame.height * (10 / 122))
            $0.width.equalTo(self.frame.width * (15 / 343))
            $0.height.equalTo(self.frame.height * ( 15 / 122 ))
        }
        mainAllRankLikeCountLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankLikeThumbImageView.snp.right)
                .offset(self.frame.width * (4 / 343))
            $0.top.equalTo(mainAllRankCellWriterNicknameLabel.snp.bottom)
                .offset(self.frame.height * (10 / 122))
            $0.width.equalTo(self.frame.width * (43 / 343))
            $0.height.equalTo(self.frame.height * ( 16 / 122 ))
        }
        likedStoredRankCellEditingCheckBox.snp.makeConstraints {
            $0.right.equalTo(mainAllRankCellBackgroundView.snp.right)
                .offset(-(self.frame.width * (10 / 343)))
            $0.bottom.equalTo(mainAllRankCellBackgroundView.snp.bottom)
                .offset(-(self.frame.height * (10 / 122)))
            $0.width.equalTo(self.frame.width * (24 / 343))
            $0.height.equalTo(self.frame.height * ( 24 / 122 ))
        }
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: CGRect.init(x: 2, y: self.frame.height * (16 / 122), width: self.frame.width * (85 / 343), height: self.frame.height - (self.frame.height * (20 / 122) * 2)), cornerRadius: 0).cgPath
    }
    
    
    override func prepareForReuse() {
        mainAllRankCellImageView.image = UIImage(named: "noimage")
    }
    
}


