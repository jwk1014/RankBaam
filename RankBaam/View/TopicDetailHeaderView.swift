//
//  TopicDetailHeaderView.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 19..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Kingfisher

protocol TopicDetailHeaderViewDelegate {
    
    func topicDetailImagesTapped(_ startImageViewFrame: CGRect)
    func likeTextButtonTapped(_ isLiked: Bool)
}

class TopicDetailHeaderView: UICollectionReusableView {

    @IBOutlet weak var bottomCelltopView: UIView!
    @IBOutlet weak var topicDetailImgCollectionView: UICollectionView!
    @IBOutlet weak var topicDetailImgPageControl: UIPageControl!
    @IBOutlet weak var topicDetailTitleLabel: UILabel!
    @IBOutlet weak var topicDetailNicknameLabel: UILabel!
    @IBOutlet weak var topicDetailDescriptionLable: UILabel!
    @IBOutlet weak var topicDetailLikeCountLabel: UILabel!
    @IBOutlet weak var topicDetailVoteCountLabel: UILabel!
    @IBOutlet weak var topicDetailVoteCoachMarkLabel: UILabel!
    @IBOutlet weak var topicDetailCreationDateLabel: UILabel!
    @IBOutlet weak var topicDetailLikeButton: UIButton!
    var topicDetailImages = [Photo]()
    var rankBaamActivityIndicator: RankBaamIndicator = RankBaamIndicator()
    var delegate: TopicDetailHeaderViewDelegate?
    let likedImg: (heartButton: UIImage?, textButton: UIImage?) = (heartButton: UIImage(named: "heartIcnF"), textButton: UIImage(named: "likeBtnF"))
    let unLikedImg: (heartButton: UIImage?, textButton: UIImage?) = (heartButton: UIImage(named: "heartIcnN"),  textButton: UIImage(named: "likeBtnN"))
    
    var likeCount: Int = 0 {
        didSet {
            likeCount = likeCount < 0 ? 0 : likeCount
            topicDetailLikeCountLabel.text = likeCount <= 9999 ?
                " \(likeCount)" : " 9999+"
        }
    }
    var voteCount: Int = 0 {
        didSet {
            voteCount = voteCount < 0 ? 0 : voteCount
            topicDetailVoteCountLabel.text = voteCount <= 9999 ?
                " \(voteCount)" : " 9999+"
        }
    }
    var votableCountPerUser: Int = 1 {
        didSet {
            topicDetailVoteCoachMarkLabel.text = votableCountPerUser < 2 ?
                "중복 투표 불가 ( 투표권 1개 )" : "\(votableCountPerUser)개 복수 선택 가능"
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                guard let likedImgTextBtn = UIImage(named: "likeBtnF") else { return }
                topicDetailLikeButton.setImage(likedImgTextBtn, for: .normal)
            } else {
                guard let unlikedImgTextBtn = UIImage(named: "likeBtnN") else { return }
                topicDetailLikeButton.setImage(unlikedImgTextBtn, for: .normal)
            }
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomCelltopView.backgroundColor = UIColor.rankbaamGray
        topicDetailCollectionViewConfigure()
        topicDetailHeaderViewConfigure()
        
    }
    
    func topicDetailHeaderDataConfigure(_ topic: Topic) {
        self.topicDetailTitleLabel.text = topic.title
        self.topicDetailNicknameLabel.text = topic.writer.nickname
        self.topicDetailDescriptionLable.text = topic.description
        self.topicDetailCreationDateLabel.text = topic.createDate
        voteCount = topic.voteCount
        likeCount = topic.likeCount
        isLiked = topic.isLike
        votableCountPerUser = topic.votableCountPerUser
        topicDetailImages = topic.photos
        topicDetailImgPageControl.numberOfPages = topicDetailImages.count > 1 ?
            topicDetailImages.count : 0
        topicDetailImgCollectionView.reloadData()
    }
    
    fileprivate func topicDetailHeaderViewConfigure() {
        topicDetailTitleLabel.sizeToFit()
        topicDetailLikeButton.addTarget(self, action: #selector(topicDetailLikeButtonTapped), for: .touchUpInside)
    }
    
    fileprivate func topicDetailCollectionViewConfigure() {
        topicDetailImgCollectionView.delegate = self
        topicDetailImgCollectionView.dataSource = self
        topicDetailImgCollectionView.isPagingEnabled = true
        topicDetailImgCollectionView.showsHorizontalScrollIndicator = false
        let topicDetailImgCellNib = UINib(nibName: "TopicDetailImgCell", bundle: nil)
        topicDetailImgCollectionView.register(topicDetailImgCellNib, forCellWithReuseIdentifier: "TopicDetailImgCell")
    }
    
    fileprivate func topicDetailPageControlConfigure() {
        topicDetailImgPageControl.numberOfPages = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottomCelltopView.backgroundColor = UIColor.rankbaamGray
        topicDetailCollectionViewConfigure()
        topicDetailHeaderViewConfigure()
    }
    
    @objc func topicDetailLikeButtonTapped() {
        isLiked = !isLiked
        likeCount = isLiked ? likeCount + 1 : likeCount - 1
        delegate?.likeTextButtonTapped(isLiked)
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
        let rankDetailImgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicDetailImgCell", for: indexPath) as! TopicDetailImgCell
        let imgURL = URL(string: topicDetailImages[indexPath.item].realUrl)
        rankDetailImgCell.topicDetailCellImageView.kf.indicatorType = .activity
        rankDetailImgCell.topicDetailCellImageView.kf.indicator?.startAnimatingView()
        rankDetailImgCell.topicDetailCellImageView.kf.setImage(with: imgURL) { (image, error, _, _) in
            rankDetailImgCell.topicDetailCellImageView.kf.indicator?.stopAnimatingView()
        }
        rankDetailImgCell.topicDetailCellImageView.kf.setImage(with: imgURL)
        return rankDetailImgCell
    }
}


extension TopicDetailHeaderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 208)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let frame = topicDetailImgCollectionView.superview?.superview?.convert((topicDetailImgCollectionView.frame), to: nil)
        self.delegate?.topicDetailImagesTapped(frame!)
    }
}


extension TopicDetailHeaderView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / self.frame.width)
        topicDetailImgPageControl.currentPage = page
    }
}
