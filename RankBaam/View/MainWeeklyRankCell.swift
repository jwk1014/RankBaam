//
//  MainWeeklyRankCell.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 27..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

enum mainWeeklyBottomScrollDirection {
    case forward
    case backward
}

class MainWeeklyRankCell: UICollectionViewCell {
    
    var timer = Timer()
    var scrollDirection: mainWeeklyBottomScrollDirection = .forward
    let widthForScrolling = Constants.screenWidth * 0.7 * ( 258 / 375 )
    
    var mainWeeklyRankBackgroundView: UIView = {
        let mainWeeklyRankBackgroundView = UIView()
        mainWeeklyRankBackgroundView.backgroundColor = UIColor.white
        return mainWeeklyRankBackgroundView
    }()
    var mainWeeklyRankImageView: UIImageView = {
        let mainWeeklyRankImageView = UIImageView()
        return mainWeeklyRankImageView
    }()
    
    var mainWeeklyRankTitleLabel: UILabel = {
        let mainWeeklyRankTitleLabel = UILabel()
        return mainWeeklyRankTitleLabel
    }()
    
    var mainWeeklyNicknameStarImageView: UIImageView = {
        let mainWeeklyNicknameStarImageView = UIImageView()
        return mainWeeklyNicknameStarImageView
    }()
    
    var mainWeeklyNicknameLabel: UILabel = {
        let mainWeeklyNicknameLabel = UILabel()
        return mainWeeklyNicknameLabel
    }()
    
    var mainWeeklyVoteBoxImageView: UIImageView = {
        let mainWeeklyVoteBoxImageView = UIImageView()
        return mainWeeklyVoteBoxImageView
    }()
    
    var mainWeeklyVoteCountLabel: UILabel = {
        let mainWeeklyVoteCountLabel = UILabel()
        return mainWeeklyVoteCountLabel
    }()
    
    var mainWeeklyLikeThumbImageView: UIImageView = {
        let mainWeeklyLikeThumbImageView = UIImageView()
        return mainWeeklyLikeThumbImageView
    }()
    
    var mainWeeklyLikeCountLabel: UILabel = {
        let mainWeeklyLikeCountLabel = UILabel()
        return mainWeeklyLikeCountLabel
    }()
    
    var mainWeeklySeperatorLineView: UIView = {
        let mainWeeklySeperatorLineView = UIView()
        return mainWeeklySeperatorLineView
    }()
    
    var mainWeeklyBottomScrollView: UIScrollView = {
        let mainWeeklyBottomScrollView = UIScrollView()
        return mainWeeklyBottomScrollView
    }()
    
    var mainWeeklyBottomScrollViewContentsView: UIView = {
        let mainWeeklyBottomScrollViewContentsView = UIView()
        return mainWeeklyBottomScrollViewContentsView
    }()
    
    var mainWeeklyBottomRankFirstImageView: UIImageView = {
        let mainWeeklyBottomRankFirstImageView = UIImageView()
        return mainWeeklyBottomRankFirstImageView
    }()
    
    var mainWeeklyBottomRankFirstLabel: UILabel = {
        let mainWeeklyBottomRankFirstLabel = UILabel()
        return mainWeeklyBottomRankFirstLabel
    }()
    
    var mainWeeklyBottomRankFirstOptionLabel: UILabel = {
        let mainWeeklyBottomRankFirstOptionLabel = UILabel()
        return mainWeeklyBottomRankFirstOptionLabel
    }()
    
    var mainWeeklyBottomRankSecondImageView: UIImageView = {
        let mainWeeklyBottomRankSecondImageView = UIImageView()
        return mainWeeklyBottomRankSecondImageView
    }()
    
    var mainWeeklyBottomRankSecondLabel: UILabel = {
        let mainWeeklyBottomRankSecondLabel = UILabel()
        return mainWeeklyBottomRankSecondLabel
    }()
    
    var mainWeeklyBottomRankSecondOptionLabel: UILabel = {
        let mainWeeklyBottomRankSecondOptionLabel = UILabel()
        return mainWeeklyBottomRankSecondOptionLabel
    }()
    
    var mainWeeklyBottomRankThirdImageView: UIImageView = {
        let mainWeeklyBottomRankThirdImageView = UIImageView()
        return mainWeeklyBottomRankThirdImageView
    }()
    
    var mainWeeklyBottomRankThirdLabel: UILabel = {
        let mainWeeklyBottomRankThirdLabel = UILabel()
        return mainWeeklyBottomRankThirdLabel
    }()
    
    var mainWeeklyBottomRankThirdOptionLabel: UILabel = {
        let mainWeeklyBottomRankThirdOptionLabel = UILabel()
        return mainWeeklyBottomRankThirdOptionLabel
    }()
    
    var mainWeeklyBottomRankLeftScrollingButton: UIButton = {
        let mainWeeklyBottomRankLeftScrollingButton = UIButton()
        return mainWeeklyBottomRankLeftScrollingButton
    }()
    
    var mainWeeklyBottomRankRightScrollingButton: UIButton = {
        let mainWeeklyBottomRankRightScrollingButton = UIButton()
        return mainWeeklyBottomRankRightScrollingButton
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(autoCarouselEffectRankTop3), userInfo: nil, repeats: true)
//        timer = Timer(timeInterval: 0.6, target: self, selector: , userInfo: nil, repeats: true)
        viewInitConfigure()
        timer.fire()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(autoCarouselEffectRankTop3), userInfo: nil, repeats: true)        
        viewInitConfigure()
        timer.fire()
    }
    
    deinit {
        
        timer.invalidate()
    }
    
    fileprivate func viewInitConfigure() {
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowColor = UIColor.rankbaamDarkgray.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.7
        self.addSubview(mainWeeklyRankBackgroundView)
        mainWeeklyRankBackgroundView.layer.cornerRadius = 8
        mainWeeklyRankBackgroundView.layer.masksToBounds = true
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyRankImageView)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyRankTitleLabel)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyNicknameStarImageView)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyNicknameLabel)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyVoteBoxImageView)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyVoteCountLabel)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyLikeThumbImageView)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyLikeCountLabel)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklySeperatorLineView)
        mainWeeklyRankBackgroundView.addSubview(mainWeeklyBottomScrollView)
        
        mainWeeklyBottomScrollView
            .addSubview(mainWeeklyBottomScrollViewContentsView)
        mainWeeklyBottomScrollView.isPagingEnabled = true
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankFirstImageView)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankFirstLabel)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankFirstOptionLabel)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankSecondImageView)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankSecondLabel)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankSecondOptionLabel)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankThirdImageView)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankThirdLabel)
        mainWeeklyBottomScrollViewContentsView
            .addSubview(mainWeeklyBottomRankThirdOptionLabel)
        mainWeeklyRankBackgroundView
            .addSubview(mainWeeklyBottomRankLeftScrollingButton)
        mainWeeklyRankBackgroundView
            .addSubview(mainWeeklyBottomRankRightScrollingButton)
        mainWeeklyRankImageView.image = UIImage(named: "winter1")
        mainWeeklyRankTitleLabel.text = "2017년을 대표하는 한국영화는?"
        mainWeeklyRankTitleLabel.textColor = UIColor(red: 77/255,
                                                     green: 77/255,
                                                     blue: 77/255,
                                                     alpha: 1)
        mainWeeklyRankTitleLabel.font = mainWeeklyRankTitleLabel
            .font
            .withSize(self.frame.height * ( 14 / 406 ))
        mainWeeklyRankTitleLabel.sizeToFit()
        mainWeeklyNicknameStarImageView.image = UIImage(named: "starImg")
        mainWeeklyNicknameLabel.text = " iphoneuser1234"
        mainWeeklyNicknameLabel.font = mainWeeklyNicknameLabel
            .font
            .withSize(self.frame.height * ( 12 / 406 ))
        mainWeeklyNicknameLabel.textColor = UIColor.rankbaamDarkgray
        mainWeeklyVoteBoxImageView.image = UIImage(named: "voteImg")
        mainWeeklyVoteBoxImageView.contentMode = .scaleAspectFit
        mainWeeklyVoteCountLabel.text = "9999+"
        mainWeeklyVoteCountLabel.textColor = UIColor.rankbaamBlack
        mainWeeklyVoteCountLabel.font = mainWeeklyVoteCountLabel
            .font
            .withSize(self.frame.height * ( 11 / 406 ))
        mainWeeklyLikeThumbImageView.image = UIImage(named: "likeImg")
        mainWeeklyLikeCountLabel.text = "9999+"
        mainWeeklyLikeCountLabel.textColor = UIColor.rankbaamBlack
        mainWeeklyLikeCountLabel.font = mainWeeklyLikeCountLabel
            .font
            .withSize(self.frame.height * ( 11 / 406 ))
        mainWeeklySeperatorLineView.backgroundColor = UIColor.rankbaamSeperatorColor
        mainWeeklyBottomRankFirstImageView.image = UIImage(named: "1GradeImg")
        mainWeeklyBottomRankFirstImageView.contentMode = .scaleAspectFit
        mainWeeklyBottomRankFirstLabel.text = "1위"
        mainWeeklyBottomRankFirstLabel.textColor = UIColor.rankbaamOrange
        mainWeeklyBottomRankFirstLabel.font = mainWeeklyBottomRankFirstLabel
            .font
            .withSize(Constants.screenHeight * ( 9 / 667 ))
        mainWeeklyBottomRankFirstOptionLabel.text = "신과 함께"
        mainWeeklyBottomRankFirstOptionLabel.textAlignment = .center
        mainWeeklyBottomRankFirstOptionLabel.textColor = UIColor.rankbaamBlack
        mainWeeklyBottomRankFirstOptionLabel.font = mainWeeklyBottomRankFirstOptionLabel
            .font
            .withSize(Constants.screenHeight * ( 11 / 667 ))
        mainWeeklyBottomRankSecondImageView.image = UIImage(named: "2GradeImg")
        mainWeeklyBottomRankSecondImageView.contentMode = .scaleAspectFit
        mainWeeklyBottomRankSecondLabel.text = "2위"
        mainWeeklyBottomRankSecondLabel.textColor = UIColor.rankbaamDarkgray
        mainWeeklyBottomRankSecondLabel.font = mainWeeklyBottomRankSecondLabel
            .font
            .withSize(Constants.screenHeight * ( 9 / 667 ))
        mainWeeklyBottomRankSecondOptionLabel.text = "1987"
        mainWeeklyBottomRankSecondOptionLabel.textAlignment = .center
        mainWeeklyBottomRankSecondOptionLabel.textColor = UIColor.rankbaamBlack
        mainWeeklyBottomRankSecondOptionLabel.font = mainWeeklyBottomRankSecondOptionLabel
            .font
            .withSize(Constants.screenHeight * ( 11 / 667 ))
        mainWeeklyBottomRankThirdImageView.image = UIImage(named: "3GradeImg")
        mainWeeklyBottomRankThirdImageView.contentMode = .scaleAspectFit
        mainWeeklyBottomRankThirdLabel.text = "3위"
        mainWeeklyBottomRankThirdLabel.textColor = UIColor(red: 179/255, green: 146/255, blue: 105/255, alpha: 1)
        mainWeeklyBottomRankThirdLabel.font = mainWeeklyBottomRankThirdLabel
            .font
            .withSize(Constants.screenHeight * ( 9 / 667 ))
        mainWeeklyBottomRankThirdOptionLabel.text = "범죄도시"
        mainWeeklyBottomRankThirdOptionLabel.textAlignment = .center
        mainWeeklyBottomRankThirdOptionLabel.textColor = UIColor.rankbaamBlack
        mainWeeklyBottomRankThirdOptionLabel.font = mainWeeklyBottomRankThirdOptionLabel
            .font
            .withSize(Constants.screenHeight * ( 11 / 667 ))
        
        mainWeeklyBottomRankLeftScrollingButton
            .setImage(UIImage.init(named: "leftIcn"), for: .normal)
        mainWeeklyBottomRankLeftScrollingButton.contentMode = .scaleToFill
        mainWeeklyBottomRankRightScrollingButton
            .setImage(UIImage.init(named: "rightIcn"), for: .normal)
        mainWeeklyBottomRankRightScrollingButton.contentMode = .scaleToFill
        
        mainWeeklyRankBackgroundView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        mainWeeklyRankImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(self.frame.height * ( 177 / 406))
        }
        mainWeeklyRankTitleLabel.sizeToFit()
        mainWeeklyRankTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainWeeklyRankImageView.snp.bottom)
                .offset(self.frame.height * ( 17 / 406 ))
            $0.left.equalTo(self.frame.width * ( 20 / 258 ))
            $0.right.equalTo(-(self.frame.width * ( 20 / 258 )))
            $0.height.equalTo(self.frame.height * (40 / 406))
        }
        mainWeeklyNicknameStarImageView.snp.makeConstraints {
            $0.left.equalTo(mainWeeklyRankBackgroundView.snp.left)
                .offset(self.frame.width * (20 / 258))
            $0.top.equalTo(mainWeeklyRankTitleLabel.snp.bottom)
                .offset(self.frame.height * (10 / 406))
            $0.width.equalTo(self.frame.width * (14 / 258))
            $0.height.equalTo(self.frame.height * (14 / 406))
        }
        mainWeeklyNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(mainWeeklyRankTitleLabel.snp.bottom)
                .offset(self.frame.height * (11 / 406))
            $0.left.equalTo(mainWeeklyNicknameStarImageView.snp.right)
                .offset(self.frame.width * (3 / 258))
            $0.width.equalTo(self.frame.width * (120 / 258))
            $0.height.equalTo(self.frame.height * (13 / 406))
        }
        mainWeeklyVoteBoxImageView.snp.makeConstraints {
            $0.top.equalTo(mainWeeklyNicknameStarImageView.snp.bottom)
                .offset(self.frame.height * (11 / 406))
            $0.left.equalTo(mainWeeklyRankBackgroundView.snp.left)
                .offset(self.frame.width * (20 / 258))
            $0.width.equalTo(self.frame.width * (18 / 258))
            $0.height.equalTo(self.frame.height * (14 / 406))
        }
        mainWeeklyVoteCountLabel.snp.makeConstraints {
            $0.top.equalTo(mainWeeklyNicknameLabel.snp.bottom)
                .offset(self.frame.height * (10 / 406))
            $0.left.equalTo(mainWeeklyVoteBoxImageView.snp.right)
                .offset(self.frame.width * (4 / 258))
            $0.width.equalTo(self.frame.width * (43 / 258))
            $0.height.equalTo(self.frame.height * (16 / 406))
        }
        mainWeeklyLikeThumbImageView.snp.makeConstraints {
            $0.top.equalTo(mainWeeklyRankTitleLabel.snp.bottom)
                .offset(self.frame.height * (34 / 406))
            $0.left.equalTo(mainWeeklyVoteCountLabel.snp.right)
                .offset(self.frame.width * (57 / 258))
            $0.width.equalTo(self.frame.width * (15 / 258))
            $0.height.equalTo(self.frame.height * (15 / 406))
        }
        mainWeeklyLikeCountLabel.snp.makeConstraints {
            $0.top.equalTo(mainWeeklyRankTitleLabel.snp.bottom)
                .offset(self.frame.height * (34 / 406))
            $0.left.equalTo(mainWeeklyLikeThumbImageView.snp.right)
                .offset(self.frame.width * (5 / 258))
            $0.width.equalTo(self.frame.width * (43 / 258))
            $0.height.equalTo(self.frame.height * (16 / 406))
        }
        mainWeeklySeperatorLineView.snp.makeConstraints {
            $0.top.equalTo(mainWeeklyVoteCountLabel.snp.bottom)
                .offset(self.frame.height * ( 16 / 406 ))
            $0.left.right.equalToSuperview()
            $0.height.equalTo(self.frame.height * ( 1 / 406 ))
        }
        mainWeeklyBottomScrollView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(mainWeeklySeperatorLineView.snp.bottom)
        }
        mainWeeklyBottomScrollView.contentSize = CGSize(width: self.frame.width * 3, height: mainWeeklyBottomScrollView.frame.height)
        mainWeeklyBottomScrollViewContentsView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalTo(self.frame.width * 3)
            $0.height.equalTo(mainWeeklyBottomScrollView.snp.height)
        }
        mainWeeklyBottomRankFirstImageView.snp.makeConstraints {
            $0.top.equalTo(mainWeeklySeperatorLineView.snp.bottom)
                .offset(self.frame.height * ( 18 / 406 ))
            $0.left.equalTo(mainWeeklyBottomScrollViewContentsView.snp.left)
                .offset(self.frame.width / 2 - (self.frame.width * (17 / 258)))
            $0.width.equalTo(self.frame.width * (20 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankFirstLabel.snp.makeConstraints {
            $0.top.equalTo(mainWeeklySeperatorLineView.snp.bottom)
                .offset(self.frame.height * ( 19 / 406 ))
            $0.left.equalTo(mainWeeklyBottomRankFirstImageView.snp.right)
                .offset(self.frame.width * ( 4 / 258))
            $0.width.equalTo(self.frame.width * (25 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankFirstOptionLabel.snp.makeConstraints {
            $0.left.equalTo(mainWeeklyBottomScrollViewContentsView.snp.left)
                .offset(self.frame.width * ( 34 / 258))
            $0.bottom.equalTo(mainWeeklyBottomScrollViewContentsView.snp.bottom)
                .offset(-(self.frame.width * ( 36 / 258)))
            $0.width.equalTo(self.frame.width * (190 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankSecondImageView.snp.makeConstraints {
            $0.top.equalTo(mainWeeklySeperatorLineView.snp.bottom)
                .offset(self.frame.height * ( 18 / 406 ))
            $0.left.equalTo(mainWeeklyBottomScrollViewContentsView.snp.left)
                .offset(self.frame.width * 3 / 2 - (self.frame.width * (17 / 258)))
            $0.width.equalTo(self.frame.width * (20 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankSecondLabel.snp.makeConstraints {
            $0.top.equalTo(mainWeeklySeperatorLineView.snp.bottom)
                .offset(self.frame.height * ( 19 / 406 ))
            $0.left.equalTo(mainWeeklyBottomRankSecondImageView.snp.right)
                .offset(self.frame.width * ( 4 / 258))
            $0.width.equalTo(self.frame.width * (25 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankSecondOptionLabel.snp.makeConstraints {
            $0.left.equalTo(mainWeeklyBottomScrollViewContentsView.snp.left)
                .offset(self.frame.width * ( 34 / 258) + self.frame.width)
            $0.bottom.equalTo(mainWeeklyBottomScrollViewContentsView.snp.bottom)
                .offset(-(self.frame.width * ( 36 / 258)))
            $0.width.equalTo(self.frame.width * (190 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankThirdImageView.snp.makeConstraints {
            $0.top.equalTo(mainWeeklySeperatorLineView.snp.bottom)
                .offset(self.frame.height * ( 18 / 406 ))
            $0.left.equalTo(mainWeeklyBottomScrollViewContentsView.snp.left)
                .offset(self.frame.width * 5 / 2 - (self.frame.width * (17 / 258)))
            $0.width.equalTo(self.frame.width * (20 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankThirdLabel.snp.makeConstraints {
            $0.top.equalTo(mainWeeklySeperatorLineView.snp.bottom)
                .offset(self.frame.height * ( 19 / 406 ))
            $0.left.equalTo(mainWeeklyBottomRankThirdImageView.snp.right)
                .offset(self.frame.width * ( 4 / 258))
            $0.width.equalTo(self.frame.width * (25 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankThirdOptionLabel.snp.makeConstraints {
            $0.left.equalTo(mainWeeklyBottomScrollViewContentsView.snp.left)
                .offset(self.frame.width * ( 34 / 258) + (self.frame.width * 2))
            $0.bottom.equalTo(mainWeeklyBottomScrollViewContentsView.snp.bottom)
                .offset(-(self.frame.width * ( 36 / 258)))
            $0.width.equalTo(self.frame.width * (190 / 258))
            $0.height.equalTo(self.frame.height * (18 / 406))
        }
        mainWeeklyBottomRankLeftScrollingButton.snp.makeConstraints {
            $0.left.equalTo(mainWeeklyRankBackgroundView.snp.left)
                .offset(self.frame.width * ( 14 / 258))
            $0.bottom.equalTo(mainWeeklyRankBackgroundView.snp.bottom)
                .offset(-(self.frame.height * (39 / 406)))
            $0.width.equalTo(self.frame.width * (5 / 258))
            $0.height.equalTo(self.frame.height * (11 / 406))
        }
        mainWeeklyBottomRankRightScrollingButton.snp.makeConstraints {
            $0.right.equalTo(mainWeeklyRankBackgroundView.snp.right)
                .offset(-(self.frame.width * ( 14 / 258)))
            $0.bottom.equalTo(mainWeeklyRankBackgroundView.snp.bottom)
                .offset(-(self.frame.height * (39 / 406)))
            $0.width.equalTo(self.frame.width * (5 / 258))
            $0.height.equalTo(self.frame.height * (11 / 406))
        }
    }
    
    @objc fileprivate func autoCarouselEffectRankTop3() {
        if self.scrollDirection == .forward {
            if self.mainWeeklyBottomScrollView.contentOffset.x <= (widthForScrolling * 2) - 10 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mainWeeklyBottomScrollView.contentOffset.x += self.widthForScrolling
                                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mainWeeklyBottomScrollView.contentOffset.x -= self.widthForScrolling
                })
                self.scrollDirection = .backward
            }
        } else {
            if self.mainWeeklyBottomScrollView.contentOffset.x > 0 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mainWeeklyBottomScrollView.contentOffset.x -= self.widthForScrolling
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mainWeeklyBottomScrollView.contentOffset.x += self.widthForScrolling
                })
                self.scrollDirection = .forward
            }
        }
    }
}
