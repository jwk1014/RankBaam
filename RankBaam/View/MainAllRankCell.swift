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
import AssetsLibrary

class MainAllRankCell: UICollectionViewCell {
    
    let placeHolderImage = UIImage(named: "noimage")
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
    
    var isSelectedLikedCell: Bool = false {
        didSet {
                if isSelectedLikedCell {
                    self.mainAllRankCellBackgroundView.layer.borderWidth = 3
                    self.likedStoredRankCellEditingCheckBox.image = UIImage(named: "bcheckBtn")
                } else {
                    self.mainAllRankCellBackgroundView.layer.borderWidth = 0
                    self.likedStoredRankCellEditingCheckBox.image = UIImage(named: "bcheckBoxIcn")
                }
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
               mainAllRankCellImageView.sd_setImage(with: imgURL, placeholderImage: placeHolderImage)
            } else {
                let imgURL = URL(string: topic.photos[0].realUrl)
                mainAllRankCellImageView.sd_setImage(with: imgURL, placeholderImage: placeHolderImage)
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
        mainAllRankCellBackgroundView.layer.borderColor = UIColor.rankbaamOrange.cgColor
        mainAllRankCellImageViewShadowView.backgroundColor = UIColor.white
        mainAllRankCellImageViewShadowView.layer.cornerRadius = 8
        mainAllRankCellImageViewShadowView.layer.shadowOpacity = 0.7
        mainAllRankCellImageViewShadowView.layer.shadowOffset =
            CGSize(width: 4, height: 4)
        mainAllRankCellImageViewShadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        mainAllRankCellImageViewShadowView.layer.shadowRadius = 5
        mainAllRankCellImageView.image = UIImage(named: "noimage")
        mainAllRankCellImageView.contentMode = .scaleAspectFill
        mainAllRankCellImageView.layer.cornerRadius = 8
        mainAllRankCellImageView.layer.masksToBounds = true
        mainAllRankCellTitleLabel.font = UIFont(name: "NanumSquareB", size: 14)
        mainAllRankCellNicknameStarImageView.image = UIImage(named: "starImg")
        mainAllRankCellNicknameStarImageView.contentMode = .scaleAspectFit
        mainAllRankCellWriterNicknameLabel.textColor = UIColor.rankbaamDarkgray
        mainAllRankCellWriterNicknameLabel.font = UIFont(name: "NanumSquareB", size: 12)
        mainAllRankVoteBoxImageView.image = UIImage(named: "voteImg")
        mainAllRankVoteBoxImageView.contentMode = .scaleAspectFit
        mainAllRankVoteCountLabel.text = "0"
        mainAllRankVoteCountLabel.textColor = UIColor.rankbaamBlack
        mainAllRankVoteCountLabel.font = UIFont(name: "NanumSquareB", size: 13)
        mainAllRankLikeThumbImageView.image = UIImage(named: "likeImg")
        mainAllRankLikeThumbImageView.contentMode = .scaleAspectFit
        mainAllRankLikeCountLabel.text = "0"
        mainAllRankLikeCountLabel.textColor = UIColor.rankbaamBlack
        mainAllRankLikeCountLabel.font = UIFont(name: "NanumSquareB", size: 13)
        likedStoredRankCellEditingCheckBox.image = UIImage(named: "bcheckBoxIcn")
        likedStoredRankCellEditingCheckBox.contentMode = .center
        likedStoredRankCellEditingCheckBox.isHidden = true
        
        mainAllRankCellBackgroundView.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(width375(24))
            $0.top.right.bottom.equalToSuperview()
        }
        mainAllRankCellImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(self.snp.top).offset(height667(13))
            $0.bottom.equalTo(self.snp.bottom).offset(-(height667(13)))
            $0.width.equalTo(width375(96))
        }
        mainAllRankCellImageViewShadowView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(self.snp.top).offset(height667(15))
            $0.bottom.equalTo(self.snp.bottom).offset(-(height667(15)))
            $0.width.equalTo(width375(94))
        }
        mainAllRankCellTitleLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellImageView.snp.right)
                .offset(width375(17))
            $0.top.equalTo(mainAllRankCellBackgroundView.snp.top)
                .offset(height667(18))
            $0.width.equalTo(width375(212))
            $0.height.equalTo(height667(40))
        }
        mainAllRankCellNicknameStarImageView.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellImageView.snp.right)
                .offset(width375(17))
            $0.top.equalTo(mainAllRankCellTitleLabel.snp.bottom)
                .offset(height667(10))
            $0.width.equalTo(width375(14))
            $0.height.equalTo(width375(14))
        }
        mainAllRankCellWriterNicknameLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellNicknameStarImageView.snp.right)
                .offset(width375(3))
            $0.top.equalTo(mainAllRankCellTitleLabel.snp.bottom)
                .offset(height667(11))
            $0.width.equalTo(width375(170))
            $0.height.equalTo(height667(13))
        }
        mainAllRankVoteBoxImageView.snp.makeConstraints {
            $0.left.equalTo(mainAllRankCellImageView.snp.right)
                .offset(width375(17))
            $0.top.equalTo(mainAllRankCellNicknameStarImageView.snp.bottom)
                .offset(height667(11))
            $0.width.equalTo(width375(18))
            $0.height.equalTo(height667(14))
        }
        mainAllRankVoteCountLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankVoteBoxImageView.snp.right)
                .offset(width375(4))
            $0.top.equalTo(mainAllRankCellWriterNicknameLabel.snp.bottom)
                .offset(height667(10))
            $0.width.equalTo(width375(43))
            $0.height.equalTo(height667(16))
        }
        mainAllRankLikeThumbImageView.snp.makeConstraints {
            $0.left.equalTo(mainAllRankVoteCountLabel.snp.right)
                .offset(width375(57))
            $0.top.equalTo(mainAllRankCellWriterNicknameLabel.snp.bottom)
                .offset(height667(10))
            $0.width.equalTo(width375(15))
            $0.height.equalTo(height667(15))
        }
        mainAllRankLikeCountLabel.snp.makeConstraints {
            $0.left.equalTo(mainAllRankLikeThumbImageView.snp.right)
                .offset(width375(4))
            $0.top.equalTo(mainAllRankCellWriterNicknameLabel.snp.bottom)
                .offset(height667(10))
            $0.width.equalTo(width375(43))
            $0.height.equalTo(height667(16))
        }
        likedStoredRankCellEditingCheckBox.snp.makeConstraints {
            $0.right.equalTo(mainAllRankCellBackgroundView.snp.right)
                .offset(-(width375(10)))
            $0.bottom.equalTo(mainAllRankCellBackgroundView.snp.bottom)
                .offset(-(height667(10)))
            $0.width.equalTo(width375(24))
            $0.height.equalTo(height667(24))
        }
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: CGRect.init(x: 2, y: height667(16), width: width375(85), height: self.frame.height - (height667(20) * 2)), cornerRadius: 0).cgPath
    }
    
    override func prepareForReuse() {
        mainAllRankCellImageView.image = UIImage(named: "noimage")
        isSelectedLikedCell = false
    }
}


