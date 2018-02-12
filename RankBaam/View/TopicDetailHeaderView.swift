//
//  TopicDetailHeaderView2.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 28..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage


protocol TopicDetailHeaderViewDelegate {
    
    func topicDetailImagesTapped(_ startImageViewFrame: CGRect)
    func likeTextButtonTapped(_ isLiked: Bool)
}


class TopicDetailHeaderView: UICollectionReusableView {
    
    var topicDetailImages = [Photo]()
    var rankBaamActivityIndicator: RankBaamIndicator = RankBaamIndicator()
    var delegate: TopicDetailHeaderViewDelegate?
    let likedImg: (heartButton: UIImage?, textButton: UIImage?) = (heartButton: UIImage(named: "heartIcnF"), textButton: UIImage(named: "likeBtnF"))
    let unLikedImg: (heartButton: UIImage?, textButton: UIImage?) = (heartButton: UIImage(named: "heartIcnN"),  textButton: UIImage(named: "likeBtnN"))
    var likeCount: Int = 0 {
        didSet {
            likeCount = likeCount < 0 ? 0 : likeCount
            topicDetailHeaderLikeCountLabel.text = likeCount <= 9999 ?
                " \(likeCount)" : " 9999+"
        }
    }
    var voteCount: Int = 0 {
        didSet {
            voteCount = voteCount < 0 ? 0 : voteCount
            topicDetailHeaderVoteCountLabel.text = voteCount <= 9999 ?
                " \(voteCount)" : " 9999+"
        }
    }
    var votableCountPerUser: Int = 1 {
        didSet {
            topicDetailHeaderVoteCountCoachTextLabel
                .text = votableCountPerUser < 2 ?
                "중복 투표 불가 ( 투표권 1개 )" : "\(votableCountPerUser)개 복수 선택 가능"
        }
    }
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                guard let likedImgTextBtn = UIImage(named: "likeBtnF") else { return }
                topicDetailHeaderTextLikeButton.setImage(likedImgTextBtn, for: .normal)
            } else {
                guard let unlikedImgTextBtn = UIImage(named: "likeBtnN") else { return }
                topicDetailHeaderTextLikeButton.setImage(unlikedImgTextBtn, for: .normal)
            }
        }
    }
    
    var topicDetailHeaderBackgroundView: UIView = {
        let topicDetailHeaderBackgroundView = UIView()
        return topicDetailHeaderBackgroundView
    }()
    
    var topicDetailHeaderImagesCollectionViewDefaultImageView: UIImageView = {
        let topicDetailHeaderImagesCollectionViewDefaultImageView = UIImageView()
        return topicDetailHeaderImagesCollectionViewDefaultImageView
    }()
    
    var topicDetailHeaderImagesCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let topicDetailHeaderImagesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        return topicDetailHeaderImagesCollectionView
    }()
    
    var topicDetailImagesCollectionViewPageControl: UIPageControl = {
        let topicDetailImagesCollectionViewPageControl = UIPageControl()
        topicDetailImagesCollectionViewPageControl
            .currentPageIndicatorTintColor = UIColor.rankbaamOrange
        topicDetailImagesCollectionViewPageControl
            .pageIndicatorTintColor = UIColor.rankbaamDarkgray
        return topicDetailImagesCollectionViewPageControl
    }()
    
    var topicDetailHeaderTitleLabel: UILabel = {
        let topicDetailHeaderTitleLabel = UILabel()
        return topicDetailHeaderTitleLabel
    }()
    
    var topicDetailHeaderNicknameStarImageView: UIImageView = {
        let topicDetailHeaderNicknameStarImageView = UIImageView()
        return topicDetailHeaderNicknameStarImageView
    }()
    
    var topicDetailHeaderNicknameLabel: UILabel = {
        let topicDetailHeaderNicknameLabel = UILabel()
        return topicDetailHeaderNicknameLabel
    }()
    
    var topicDetailNicknameCreationDateSeperatorView: UIView = {
        let topicDetailNicknameCreationDateSeperatorView = UIView()
        return topicDetailNicknameCreationDateSeperatorView
    }()
    
    var topicDetailHeaderCreationDateLabel: UILabel = {
        let topicDetailHeaderCreationDateLabel = UILabel()
        return topicDetailHeaderCreationDateLabel
    }()
    
    var topicDetailHeaderVoteBoxImageView: UIImageView = {
        let topicDetailHeaderVoteBoxImageView = UIImageView()
        return topicDetailHeaderVoteBoxImageView
    }()
    
    var topicDetailHeaderVoteCountLabel: UILabel = {
        let topicDetailHeaderVoteCountLabel = UILabel()
        return topicDetailHeaderVoteCountLabel
    }()
    
    var topicDetailHeaderLikeThumbImageView: UIImageView = {
        let topicDetailHeaderLikeThumbImageView = UIImageView()
        return topicDetailHeaderLikeThumbImageView
    }()
    
    var topicDetailHeaderLikeCountLabel: UILabel = {
        let topicDetailHeaderLikeCountLabel = UILabel()
        return topicDetailHeaderLikeCountLabel
    }()
    
    var topicDetailHeaderTextLikeButton: UIButton = {
        let topicDetailHeaderTextLikeButton = UIButton()
        return topicDetailHeaderTextLikeButton
    }()
    
    var topicDetailHeaderDescriptionSeperatorView: UIView = {
        let topicDetailHeaderDescriptionSeperatorView = UIView()
        return topicDetailHeaderDescriptionSeperatorView
    }()
    
    var topicDetailHeaderDescriptionLabel: UILabel = {
        let topicDetailHeaderDescriptionLabel = UILabel()
        return topicDetailHeaderDescriptionLabel
    }()
    
    var topicDetailHeaderBottomOptionCellsTopView: UIView = {
        let topicDetailHeaderBottomOptionCellsTopView = UIView()
        return topicDetailHeaderBottomOptionCellsTopView
    }()
    
    var topicDetailHeaderVoteCountCoachTextLabel: UILabel = {
        let topicDetailHeaderVoteCountCoachTextLabel = UILabel()
        return topicDetailHeaderVoteCountCoachTextLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
        print("This is CollectionView Height : \(topicDetailHeaderImagesCollectionView.frame.height)")
        print("This is defaultimage Height : \(topicDetailHeaderImagesCollectionViewDefaultImageView.frame.height)")
        topicDetailHeaderImagesCollectionViewConfigure()
        topicDetailHeaderViewConfigure()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
        topicDetailHeaderImagesCollectionViewConfigure()
        topicDetailHeaderViewConfigure()
        
    }
    
    fileprivate func topicDetailHeaderImagesCollectionViewConfigure() {
        topicDetailHeaderImagesCollectionView.delegate = self
        topicDetailHeaderImagesCollectionView.dataSource = self
        topicDetailHeaderImagesCollectionView.isPagingEnabled = true
        topicDetailHeaderImagesCollectionView.showsHorizontalScrollIndicator = false
        topicDetailHeaderImagesCollectionView.register(TopicDetailImagesCell.self, forCellWithReuseIdentifier: "TopicDetailImagesCell")
    }
    
    func topicDetailHeaderDataConfigure(_ topic: Topic) {
        self.topicDetailHeaderTitleLabel.text = topic.title
        self.topicDetailHeaderNicknameLabel.text = topic.writer.nickname
        self.topicDetailHeaderDescriptionLabel.text = topic.description
        
        let createdDate = topic.createDate.tempDateFommatConverter()
        self.topicDetailHeaderCreationDateLabel.text = createdDate
        voteCount = topic.voteCount
        likeCount = topic.likeCount
        isLiked = topic.isLike
        votableCountPerUser = topic.votableCountPerUser
        topicDetailImages = topic.photos
        topicDetailImagesCollectionViewPageControl.numberOfPages = topicDetailImages.count > 1 ?
            topicDetailImages.count : 0
        topicDetailHeaderImagesCollectionView.reloadData()
    }
    
    fileprivate func topicDetailHeaderViewConfigure() {
        topicDetailHeaderTitleLabel.sizeToFit()
        topicDetailHeaderTextLikeButton.addTarget(self, action: #selector(topicDetailLikeButtonTapped), for: .touchUpInside)
    }
    
    
    
    fileprivate func viewInitConfigure() {
        self.addSubview(topicDetailHeaderBackgroundView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderImagesCollectionViewDefaultImageView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderImagesCollectionView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailImagesCollectionViewPageControl)
        topicDetailHeaderBackgroundView.addSubview(topicDetailHeaderTitleLabel)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderNicknameStarImageView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailNicknameCreationDateSeperatorView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderCreationDateLabel)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderVoteBoxImageView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderVoteCountLabel)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderLikeThumbImageView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderLikeCountLabel)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderDescriptionSeperatorView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderBottomOptionCellsTopView)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderDescriptionLabel)
        topicDetailHeaderBackgroundView
            .addSubview(topicDetailHeaderTextLikeButton)
        topicDetailHeaderBackgroundView.addSubview(topicDetailHeaderNicknameLabel)
        topicDetailHeaderBottomOptionCellsTopView
            .addSubview(topicDetailHeaderVoteCountCoachTextLabel)
        
        
        topicDetailHeaderBackgroundView.backgroundColor = UIColor.white
        topicDetailHeaderImagesCollectionViewDefaultImageView.image =
            UIImage(named: "noimage")
        topicDetailHeaderImagesCollectionViewDefaultImageView.contentMode = .scaleAspectFill
        topicDetailHeaderImagesCollectionViewDefaultImageView.clipsToBounds = true
        topicDetailHeaderImagesCollectionView.backgroundColor = UIColor.clear
        topicDetailHeaderImagesCollectionView.bounds.size.height = 100
        topicDetailImagesCollectionViewPageControl.hidesForSinglePage = true
        topicDetailImagesCollectionViewPageControl.numberOfPages = 0
        topicDetailHeaderTitleLabel.text = ""
        topicDetailHeaderTitleLabel.textColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
        topicDetailHeaderTitleLabel.font = UIFont(name: "NanumSquareB", size: 16)
        topicDetailHeaderNicknameStarImageView.image = UIImage(named: "starImg")
        topicDetailHeaderNicknameStarImageView.contentMode = .center
        topicDetailHeaderNicknameLabel.textColor = UIColor.rankbaamDarkgray
        topicDetailHeaderNicknameLabel.font = UIFont(name: "NanumSquareB", size: 12)
        topicDetailNicknameCreationDateSeperatorView
            .backgroundColor = UIColor.rankbaamSeperatorColor
        topicDetailHeaderCreationDateLabel.textColor = UIColor.rankbaamDarkgray
        topicDetailHeaderCreationDateLabel.font = UIFont(name: "NanumSquareB", size: 12)
        topicDetailHeaderVoteBoxImageView.image = UIImage(named: "voteImg")
        topicDetailHeaderVoteBoxImageView.contentMode = .scaleAspectFit
        topicDetailHeaderVoteCountLabel.textColor = UIColor.rankbaamBlack
        topicDetailHeaderVoteCountLabel.font = UIFont(name: "NanumSquareB", size: 13)
        topicDetailHeaderLikeThumbImageView.image = UIImage(named: "likeImg")
        topicDetailHeaderLikeThumbImageView.contentMode = .scaleAspectFit
        topicDetailHeaderLikeCountLabel.textColor = UIColor.rankbaamBlack
        topicDetailHeaderLikeCountLabel.font = UIFont(name: "NanumSquareB", size: 13)
        topicDetailHeaderTextLikeButton.setImage(UIImage.init(named: "likeBtnN"), for: .normal)
        topicDetailHeaderTextLikeButton.contentMode = .scaleToFill
        topicDetailHeaderDescriptionSeperatorView.backgroundColor = UIColor.rankbaamSeperatorColor
        topicDetailHeaderBottomOptionCellsTopView.backgroundColor = UIColor.rankbaamGray
        topicDetailHeaderDescriptionLabel.textColor =
            UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
        topicDetailHeaderDescriptionLabel.font = UIFont(name: "NanumSquareB", size: 13)
        topicDetailHeaderDescriptionLabel.sizeToFit()
        topicDetailHeaderDescriptionLabel.numberOfLines = 0
        topicDetailHeaderVoteCountCoachTextLabel
            .textColor = UIColor.rankbaamDarkgray
        topicDetailHeaderVoteCountCoachTextLabel.font =
            UIFont(name: "NanumSquareB", size: 12)
        
        
        topicDetailHeaderBackgroundView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        topicDetailHeaderImagesCollectionViewDefaultImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(height667(208))
            
        }
        topicDetailHeaderImagesCollectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(height667(208))
        }
        
        topicDetailHeaderImagesCollectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(height667(208))
        }
        topicDetailImagesCollectionViewPageControl.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderImagesCollectionView.snp.bottom)
                .offset(-(height667(3)))
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(width375(270))
            $0.height.equalTo(width375(32))
        }
        topicDetailHeaderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderImagesCollectionView.snp.bottom)
                .offset(height667(35))
            $0.left.equalTo(topicDetailHeaderBackgroundView.snp.left)
                .offset(width375(20))
            $0.width.equalTo(width375(335))
            $0.height.equalTo(height667(42))
        }
        topicDetailHeaderNicknameStarImageView.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderTitleLabel.snp.bottom)
                .offset(height667(10))
            $0.left.equalTo(topicDetailHeaderBackgroundView.snp.left)
                .offset(width375(20))
            $0.width.equalTo(width375(13))
            $0.height.equalTo(width375(13))
        }
        topicDetailHeaderNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderTitleLabel.snp.bottom)
                .offset(height667(11))
            $0.left.equalTo(topicDetailHeaderNicknameStarImageView.snp.right)
                .offset(height667(4))
            $0.width.equalTo(width375(50))
            $0.height.equalTo(height667(13))
        }
        topicDetailNicknameCreationDateSeperatorView.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderTitleLabel.snp.bottom)
                .offset(height667(12))
            $0.left.equalTo(topicDetailHeaderNicknameLabel.snp.right)
                .offset(width375(18))
            $0.width.equalTo(width375(2))
            $0.height.equalTo(height667(11))
        }
        topicDetailHeaderCreationDateLabel.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderTitleLabel.snp.bottom)
                .offset(height667(11))
            $0.left
                .equalTo(topicDetailNicknameCreationDateSeperatorView.snp.right)
                .offset(width375(18))
            $0.width.equalTo(width375(80))
            $0.height.equalTo(height667(13))
        }
        topicDetailHeaderVoteBoxImageView.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderNicknameStarImageView.snp.bottom)
                .offset(height667(11))
            $0.left.equalTo(topicDetailHeaderBackgroundView.snp.left)
                .offset(width375(20))
            $0.width.equalTo(width375(18))
            $0.height.equalTo(height667(14))
        }
        topicDetailHeaderVoteCountLabel.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderNicknameLabel.snp.bottom)
                .offset(height667(9))
            $0.left.equalTo(topicDetailHeaderVoteBoxImageView.snp.right)
                .offset(width375(4))
            $0.width.equalTo(width375(43))
            $0.height.equalTo(height667(16))
        }
        topicDetailHeaderLikeThumbImageView.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderCreationDateLabel.snp.bottom)
                .offset(height667(10))
            $0.left.equalTo(topicDetailHeaderVoteCountLabel.snp.right)
                .offset(width375(36))
            $0.width.equalTo(width375(15))
            $0.height.equalTo(height667(15))
        }
        topicDetailHeaderLikeCountLabel.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderCreationDateLabel.snp.bottom)
                .offset(height667(9))
            $0.left.equalTo(topicDetailHeaderLikeThumbImageView.snp.right)
                .offset(width375(4))
            $0.width.equalTo(width375(43))
            $0.height.equalTo(height667(16))
        }
        topicDetailHeaderTextLikeButton.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderTitleLabel.snp.bottom)
                .offset(height667(15))
            $0.left.equalTo(topicDetailHeaderLikeCountLabel.snp.right)
                .offset(width375(90))
            $0.width.equalTo(width375(76))
            $0.height.equalTo(height667(36))
        }
        topicDetailHeaderDescriptionSeperatorView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topicDetailHeaderTextLikeButton.snp.bottom)
                .offset(height667(14))
            $0.height.equalTo(height667(2))
        }
        topicDetailHeaderBottomOptionCellsTopView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(height667(36))
        }
        topicDetailHeaderDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderDescriptionSeperatorView.snp.bottom)
                .offset(height667(20))
            $0.left.equalTo(topicDetailHeaderBackgroundView.snp.left)
                .offset(width375(20))
            $0.bottom.equalTo(topicDetailHeaderBottomOptionCellsTopView.snp.top)
                .offset(-(height667(20)))
            $0.width.equalTo(width375(335))
        }
        topicDetailHeaderVoteCountCoachTextLabel.snp.makeConstraints {
            $0.top.equalTo(topicDetailHeaderBottomOptionCellsTopView.snp.top)
                .offset(height667(16))
            $0.left.equalTo(topicDetailHeaderBottomOptionCellsTopView.snp.left)
                .offset(width375(17))
            $0.height.equalTo(height667(13))
            $0.width.equalTo(width375(250))
        }
    }
}

extension TopicDetailHeaderView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        topicDetailImages.count > 0 ?
            ( collectionView.backgroundColor = UIColor.white ) :
            ( collectionView.backgroundColor = UIColor.clear )

        return topicDetailImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rankDetailImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicDetailImagesCell", for: indexPath) as! TopicDetailImagesCell
        let imgURL = URL(string: topicDetailImages[indexPath.item].realUrl)
        rankDetailImagesCell.topicDetailImagesCellImageView.sd_addActivityIndicator()
        rankDetailImagesCell.topicDetailImagesCellImageView.sd_setImage(with: imgURL, completed: nil)

        return rankDetailImagesCell
    }
    
    @objc func topicDetailLikeButtonTapped() {
        isLiked = !isLiked
        likeCount = isLiked ? likeCount + 1 : likeCount - 1
        delegate?.likeTextButtonTapped(isLiked)
    }
}



extension TopicDetailHeaderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let frame = topicDetailHeaderImagesCollectionView.superview?.superview?.convert((topicDetailHeaderImagesCollectionView.frame), to: nil) else { return }
        self.delegate?.topicDetailImagesTapped(frame)
    }
}

extension TopicDetailHeaderView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / self.frame.width)
        topicDetailImagesCollectionViewPageControl.currentPage = page
    }
}



