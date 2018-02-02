//
//  TopicDetailOptionCell2.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 28..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

import UIKit


class TopicDetailOptionCell: UICollectionViewCell {
    
    var votePercentage: CGFloat = 0.0 {
        didSet {
            optionCellVotePercentageView.constraints.forEach { targetConstraint in
                if targetConstraint.identifier == "percentageWidth" {
                    NSLayoutConstraint.deactivate([targetConstraint])
                }
                let newPercentageConstraint = NSLayoutConstraint(
                    item: optionCellVotePercentageView,
                    attribute: NSLayoutAttribute.width,
                    relatedBy: NSLayoutRelation.equal,
                    toItem: optionCellVotePercentageView.superview,
                    attribute: NSLayoutAttribute.width,
                    multiplier: votePercentage,
                    constant: 0.0)
                newPercentageConstraint.identifier = "percentageWidth"
                newPercentageConstraint.isActive = true
            }
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    var isVoted: Bool = false {
        didSet {
            
        }
    }
    
    var optionCellBackgroundView: UIView = {
        let optionCellBackgroundView = UIView()
        return optionCellBackgroundView
    }()
    
    /*var optionCellVotePercentageViewPercentageConstraint: NSLayoutConstraint?*/
    
    var optionCellVotePercentageView: UIView = {
        let optionCellVotePercentageView = UIView()
        return optionCellVotePercentageView
    }()
    
    var optionCellImageView: UIImageView = {
        let optionCellImageView = UIImageView()
        return optionCellImageView
    }()
    
    var optionCellStackViewForTitle: UIStackView = {
        let optionCellStackViewForTitle = UIStackView()
        return optionCellStackViewForTitle
    }()
    
    var optionCellTitleLabel: UILabel = {
        let optionCellTitleLabel = UILabel()
        return optionCellTitleLabel
    }()
    
    var optionCellCheckMarkImageView: UIImageView = {
        let optionCellCheckMarkImageView = UIImageView()
        return optionCellCheckMarkImageView
    }()
    
    var optionCellNewOptionMarkImageView: UIImageView = {
        let optionCellNewOptionMarkImageView = UIImageView()
        return optionCellNewOptionMarkImageView
    }()
    
    var optionCellVoteCountLabel: UILabel = {
        let optionCellVoteCountLabel = UILabel()
        return optionCellVoteCountLabel
    }()
    
    var optionCellCommentDetailLabel: UILabel = {
        let optionCellCommentDetailLabel = UILabel()
        return optionCellCommentDetailLabel
    }()
    
    var optionCellCommentDetailButton: UIButton = {
        let optionCellCommentDetailButton = UIButton()
        return optionCellCommentDetailButton
    }()
    
    var optionCellCommentDetailRightShapeImageView: UIImageView = {
        let optionCellCommentDetailRightShapeImageView = UIImageView()
        return optionCellCommentDetailRightShapeImageView
    }()
    
    var optionCellCommentDetailSeperatorView: UIView = {
        let optionCellCommentDetailSeperatorView = UIView()
        return optionCellCommentDetailSeperatorView
    }()
    
    var isSelectedForVote: Bool = false {
        willSet {
            if newValue == true {
                optionCellBackgroundView.layer.borderColor =
                    UIColor.rankbaamOrange.cgColor
                optionCellBackgroundView.layer.borderWidth = 3
                optionCellCheckMarkImageView.isHidden = false
            } else {
                optionCellBackgroundView.layer.borderWidth = 0
                optionCellCheckMarkImageView.isHidden = true
            }
        }
    }
    
    func commentPartConfigure() {
        
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
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.7
        self.addSubview(optionCellBackgroundView)
        optionCellBackgroundView.addSubview(optionCellVotePercentageView)
        optionCellBackgroundView.addSubview(optionCellImageView)
        optionCellBackgroundView.addSubview(optionCellStackViewForTitle)
        optionCellBackgroundView.addSubview(optionCellCommentDetailLabel)
        optionCellBackgroundView.addSubview(optionCellCommentDetailButton)
        optionCellBackgroundView
            .addSubview(optionCellCommentDetailRightShapeImageView)
        optionCellBackgroundView.addSubview(optionCellVoteCountLabel)
        optionCellBackgroundView.addSubview(optionCellCommentDetailSeperatorView)
        optionCellStackViewForTitle.addArrangedSubview(optionCellCheckMarkImageView)
        optionCellStackViewForTitle.addArrangedSubview(optionCellTitleLabel)
        optionCellStackViewForTitle
            .addArrangedSubview(optionCellNewOptionMarkImageView)
        optionCellBackgroundView.layer.cornerRadius = 4
        optionCellBackgroundView.clipsToBounds = true
        
        
        optionCellStackViewForTitle.distribution = .fillProportionally
        
        if #available(iOS 11.0, *) {
            optionCellStackViewForTitle.setCustomSpacing(4, after: optionCellCheckMarkImageView)
        } else {
            optionCellStackViewForTitle.spacing = 4
        }
        optionCellCheckMarkImageView.image = UIImage(named: "checkIcn")
        optionCellCheckMarkImageView.contentMode = .center
        optionCellCheckMarkImageView.isHidden = true
        optionCellNewOptionMarkImageView.image = UIImage(named: "newImg")
        optionCellNewOptionMarkImageView.contentMode = .topLeft
        optionCellNewOptionMarkImageView.isHidden = true
        
        
        optionCellBackgroundView.backgroundColor = UIColor.white
        optionCellVotePercentageView.backgroundColor = UIColor.rankbaamOrange
        optionCellImageView.image = UIImage(named: "winter1")
        optionCellCommentDetailLabel.text = "댓글"
        optionCellCommentDetailLabel.textColor = UIColor.rankbaamBlue
        optionCellCommentDetailLabel.font = optionCellCommentDetailLabel
            .font
            .withSize(Constants.screenWidth * (14 / 375))
        optionCellTitleLabel.text = "인도네시아"
        optionCellTitleLabel.font = optionCellTitleLabel
            .font
            .withSize(Constants.screenHeight * (15 / 667))
        optionCellCommentDetailRightShapeImageView.image =
            UIImage(named: "rightIcn")?.withRenderingMode(.alwaysTemplate)
        optionCellCommentDetailRightShapeImageView.tintColor = UIColor.rankbaamBlue
        optionCellCommentDetailSeperatorView.backgroundColor = UIColor.rankbaamSeperatorColor
        optionCellVoteCountLabel.text = "???표"
        optionCellVoteCountLabel.font = optionCellVoteCountLabel
            .font
            .withSize(Constants.screenHeight * (14 / 667))
        
        
        
        optionCellBackgroundView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        optionCellVotePercentageView
            .translatesAutoresizingMaskIntoConstraints = false
        optionCellVotePercentageView.leadingAnchor.constraint(equalTo: optionCellBackgroundView.leadingAnchor).isActive = true
        optionCellVotePercentageView.topAnchor.constraint(equalTo: optionCellBackgroundView.topAnchor).isActive = true
        optionCellVotePercentageView.bottomAnchor.constraint(equalTo: optionCellBackgroundView.bottomAnchor).isActive = true
        let percentageWidth = optionCellVotePercentageView.widthAnchor.constraint(equalTo: optionCellBackgroundView.widthAnchor, multiplier: votePercentage)
        percentageWidth.isActive = true
        percentageWidth.identifier = "percentageWidth"
        
        optionCellCommentDetailButton.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(self.frame.width * (66 / 342))
        }
        optionCellCommentDetailLabel.snp.makeConstraints {
            $0.left.equalTo(optionCellCommentDetailButton.snp.left)
                .offset(self.frame.width * (14 / 342))
            $0.top.equalTo(optionCellCommentDetailButton.snp.top)
                .offset(self.frame.height * (28 / 72))
            $0.height.equalTo(self.frame.height * (16 / 72))
            $0.width.equalTo(self.frame.width * (26 / 342))
        }
        optionCellCommentDetailRightShapeImageView.snp.makeConstraints {
            $0.right.equalTo(optionCellBackgroundView.snp.right)
                .offset(-(self.frame.width * (14 / 342)))
            $0.top.equalTo(optionCellBackgroundView.snp.top)
                .offset(self.frame.height * (30 / 72))
            $0.bottom.equalTo(optionCellBackgroundView.snp.bottom)
                .offset(-(self.frame.height * (30 / 72)))
            $0.width.equalTo(self.frame.width * (5 / 342))
        }
        optionCellCommentDetailSeperatorView.snp.makeConstraints {
            $0.right.equalTo(optionCellCommentDetailButton.snp.left)
            $0.top.equalTo(optionCellBackgroundView.snp.top)
                .offset(self.frame.height * (4 / 72))
            $0.bottom.equalTo(optionCellBackgroundView.snp.bottom)
                .offset(-(self.frame.height * (4 / 72)))
            $0.width.equalTo(self.frame.width * (1 / 342))
        }
        optionCellImageView.snp.makeConstraints {
            $0.left.equalTo(optionCellBackgroundView.snp.left)
                .offset(self.frame.width * (5 / 342))
            $0.top.equalTo(optionCellBackgroundView.snp.top)
                .offset(self.frame.height * (5 / 72))
            $0.bottom.equalTo(optionCellBackgroundView.snp.bottom)
                .offset(-(self.frame.height * (5 / 72)))
            $0.width.equalTo(self.frame.width * (76 / 342))
        }
        optionCellStackViewForTitle.snp.makeConstraints {
            $0.left.equalTo(optionCellImageView.snp.right)
                .offset(self.frame.width * (14 / 342))
            $0.right.equalTo(optionCellCommentDetailSeperatorView.snp.left)
                .offset(-(self.frame.width * (14 / 342)))
            $0.top.equalTo(optionCellBackgroundView.snp.top)
                .offset(self.frame.height * (11 / 72))
            $0.bottom.equalTo(optionCellBackgroundView.snp.bottom)
                .offset(-(self.frame.height * (40 / 72)))
            
        }
        optionCellVoteCountLabel.snp.makeConstraints {
            $0.left.equalTo(optionCellImageView.snp.right)
                .offset(self.frame.width * (14 / 342))
            $0.right.equalTo(optionCellCommentDetailSeperatorView.snp.left)
                .offset(-(self.frame.width * (14 / 342)))
            $0.top.equalTo(optionCellStackViewForTitle.snp.bottom)
                .offset(self.frame.height * (10 / 72))
            $0.height.equalTo(self.frame.height * (16 / 72))
        }
    }
    
    func topicDetailOptionCellDataConfigure(_ option: Option) {
        self.optionCellTitleLabel.text = option.title
        let randomPercentage = Float(arc4random()) / Float(UInt32.max)
        self.votePercentage = CGFloat(randomPercentage)
    }
    override func prepareForReuse() {
        if isSelectedForVote {
            isSelectedForVote = false
        }
    }
}

