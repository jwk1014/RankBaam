//
//  TabLikeStoredRankViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 31..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TabLikeStoredRankViewController: UIViewController {

    
    var isEditingLikedCell: Bool = false
    
    var tabLikeStoredRankCustomNavigationBar: UIView = {
        let tabLikeStoredRankCustomNavigationBar = UIView()
        return tabLikeStoredRankCustomNavigationBar
    }()
    
    var tabLikeStoredRankCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let tabLikeStoredRankCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        return tabLikeStoredRankCollectionView
    }()
    
    var tabLikeStoredRankCustomNavigationBarTitleLabel: UILabel = {
        let tabLikeStoredRankCustomNavigationBarTitleLabel = UILabel()
        tabLikeStoredRankCustomNavigationBarTitleLabel.textColor = UIColor.rankbaamOrange
        return tabLikeStoredRankCustomNavigationBarTitleLabel
    }()
    
    var tabLikeStoredRankEditingButton: UIButton = {
        let tabLikeStoredRankEditingButton = UIButton()
        return tabLikeStoredRankEditingButton
    }()
    
    var tabLikeStoredRankEditingCancelButton: UIButton = {
        let tabLikeStoredRankEditingCancelButton = UIButton()
        return tabLikeStoredRankEditingCancelButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        tabLikeStoredRankCollectionViewConfigure()
        tabLikeStoredRankEditingButton.addTarget(self, action: #selector(tabLikeStoredRankButtonsHandler(_:)), for: .touchUpInside)
        tabLikeStoredRankEditingCancelButton.addTarget(self, action: #selector(tabLikeStoredRankButtonsHandler(_:)), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(tabLikeStoredRankCollectionView)
        self.view.addSubview(tabLikeStoredRankCustomNavigationBar)
        tabLikeStoredRankCustomNavigationBar
            .addSubview(tabLikeStoredRankCustomNavigationBarTitleLabel)
        tabLikeStoredRankCustomNavigationBar
            .addSubview(tabLikeStoredRankEditingButton)
        tabLikeStoredRankCustomNavigationBar
            .addSubview(tabLikeStoredRankEditingCancelButton)
        
        
        
        tabLikeStoredRankCustomNavigationBar.backgroundColor = UIColor.white
        tabLikeStoredRankCustomNavigationBar.layer.shadowRadius = 7
        tabLikeStoredRankCustomNavigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        tabLikeStoredRankCustomNavigationBar.layer.shadowOpacity = 0.7
        tabLikeStoredRankCustomNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 12)
        tabLikeStoredRankCustomNavigationBar.layer.masksToBounds = false
        tabLikeStoredRankCustomNavigationBarTitleLabel.text = "저장 랭킹"
        tabLikeStoredRankCustomNavigationBarTitleLabel.font = UIFont.boldSystemFont(ofSize: Constants.screenWidth * (18 / 375))
        tabLikeStoredRankCustomNavigationBarTitleLabel.textAlignment = .center
        tabLikeStoredRankEditingButton
            .setTitle("편집", for: .normal)
        tabLikeStoredRankEditingButton
            .setTitleColor(UIColor.rankbaamDarkgray, for: .normal)
        tabLikeStoredRankEditingButton.titleLabel?.font =
        tabLikeStoredRankEditingButton
                .titleLabel?.font.withSize(Constants.screenWidth * (16 / 375))
        
        tabLikeStoredRankEditingCancelButton.setTitle("취소", for: .normal)
        tabLikeStoredRankEditingCancelButton
            .setTitleColor(UIColor.init(r: 250, g: 84, b: 76), for: .normal)
        tabLikeStoredRankEditingCancelButton.titleLabel?.font =
            tabLikeStoredRankEditingCancelButton
                .titleLabel?.font.withSize(Constants.screenWidth * (16 / 375))
        tabLikeStoredRankEditingCancelButton.isHidden = true
        
        
        
        tabLikeStoredRankCustomNavigationBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(Constants.screenHeight * (76 / 667))
        }
        tabLikeStoredRankCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Constants.screenHeight * (76 / 667))
        }
        tabLikeStoredRankCustomNavigationBarTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tabLikeStoredRankCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (38 / 667))
            $0.centerX.equalTo(tabLikeStoredRankCustomNavigationBar.snp.centerX)
            $0.height.equalTo(Constants.screenHeight * (21 / 667))
            $0.width.equalTo(Constants.screenWidth * (80 / 375))
        }
        tabLikeStoredRankEditingButton.snp.makeConstraints {
            $0.top.equalTo(tabLikeStoredRankCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (40 / 667))
            $0.left.equalTo(tabLikeStoredRankCustomNavigationBar.snp.left)
                .offset(Constants.screenWidth * (329 / 375))
            $0.height.equalTo(Constants.screenHeight * (18 / 667))
            $0.width.equalTo(Constants.screenWidth * (40 / 375))
        }
        tabLikeStoredRankEditingCancelButton.snp.makeConstraints {
            $0.top.equalTo(tabLikeStoredRankCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (40 / 667))
            $0.right.equalTo(tabLikeStoredRankCustomNavigationBar.snp.right)
                .offset(-(Constants.screenWidth * (329 / 375)))
            $0.height.equalTo(Constants.screenHeight * (18 / 667))
            $0.width.equalTo(Constants.screenWidth * (40 / 375))
        }
    }
    
    fileprivate func tabLikeStoredRankCollectionViewConfigure() {
        tabLikeStoredRankCollectionView.backgroundColor = UIColor.rankbaamGray
        tabLikeStoredRankCollectionView.dataSource = self
        tabLikeStoredRankCollectionView.delegate = self
        tabLikeStoredRankCollectionView.register(MainAllRankCell.self, forCellWithReuseIdentifier: "likedStoredCell")
        tabLikeStoredRankCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 110, right: 0)
    }
    
    @objc fileprivate func tabLikeStoredRankButtonsHandler(_ sender: UIButton) {
        guard let buttonTitle = sender.currentTitle else { return }
        switch buttonTitle {
        case "편집":
            sender.setTitle("삭제", for: .normal)
            sender.setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
            tabLikeStoredRankEditingCancelButton.isHidden = false
            isEditingLikedCell = true
            tabLikeStoredRankCollectionView.reloadData()
            tabLikeStoredRankCollectionView.collectionViewLayout
                .invalidateLayout()
        case "삭제":
            //TODO : FIXME
            break
        case "취소":
            sender.isHidden = true
            tabLikeStoredRankEditingButton.setTitle("편집", for: .normal)
            tabLikeStoredRankEditingButton
                .setTitleColor(UIColor.rankbaamDarkgray, for: .normal)
            isEditingLikedCell = false
            tabLikeStoredRankCollectionView.reloadData()
            tabLikeStoredRankCollectionView.collectionViewLayout
                .invalidateLayout()
            break
        default:
            fatalError()
        }
    }
}

extension TabLikeStoredRankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let likedStoredCell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedStoredCell", for: indexPath) as! MainAllRankCell
        likedStoredCell.isEditingLikedCell = isEditingLikedCell
        return likedStoredCell
    }
}

extension TabLikeStoredRankViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.screenHeight == 812 ?
            CGSize(width: Constants.screenWidth * (343 / 375), height: 122) :
            CGSize(width: Constants.screenWidth * (343 / 375), height: Constants.screenHeight * (122 / 667))
    }
}

