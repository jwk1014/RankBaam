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
    var likeStoredRankDatas: [Topic] = [Topic]()
    
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
    
    var selectedLikedCellIndexPath: [(indexPath: Int, optionSN: Int)] = [(indexPath: Int, optionSN: Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        tabLikeStoredRankCollectionViewConfigure()
        fetchLikeStoredRankDatas()
        tabLikeStoredRankEditingButton.addTarget(self, action: #selector(tabLikeStoredRankButtonsHandler(_:)), for: .touchUpInside)
        tabLikeStoredRankEditingCancelButton.addTarget(self, action: #selector(tabLikeStoredRankButtonsHandler(_:)), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchLikeStoredRankDatas()
    }
    
    func fetchLikeStoredRankDatas() {
        
        TopicService.likeList(page: 1, order: OrderType.new) {
            switch $0.result {
            case .success(let result):
                if result.succ {
                    guard let topicDatas = result.topics else {return}
                    self.likeStoredRankDatas = topicDatas
                    print("This is WeeklyLike List Count : \(self.likeStoredRankDatas.count)")
                   
                    DispatchQueue.main.async {
                        self.tabLikeStoredRankCollectionView.reloadData()
                    }
                    
                } else if let msg = result.msg {
                    
                    switch msg {
                    default:
                        break
                    }
                }
            case .failure(let error):
                if let error = error as? SolutionProcessableProtocol {
                    error.handle(self)
                } else {
                    
                }
            }
        }
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
            print("\(selectedLikedCellIndexPath.count)")
            let selectedTopicSN = selectedLikedCellIndexPath.reduce([], { (result, item) -> [Int] in
                return result + [item.optionSN]
            })
            
            var selectedIndexPath = selectedLikedCellIndexPath.reduce([], { (result, item) -> [IndexPath] in
                return result + [ IndexPath(item: item.indexPath, section: 0) ]
            }).sorted(by: { $0 > $1 })
            TopicService.likes(topicSNs: selectedTopicSN, isLiked: false, completion: {
                switch $0.result {
                case .success(let result):
                    if result.succ {
                        print("삭제 성공")
                       
                        for index in selectedIndexPath {
                            print("This is Indices that will be removed : \(index)")
                            self.likeStoredRankDatas.remove(at: index.item)
                        }
                        self.selectedLikedCellIndexPath.removeAll()
                        self.tabLikeStoredRankCollectionView.performBatchUpdates({
                            self.tabLikeStoredRankCollectionView.deleteItems(at: selectedIndexPath)
                        }, completion: nil)
                        self.fetchLikeStoredRankDatas()
                    } else if let msg = result.msg {
                        
                        switch msg {
                        default:
                            break
                        }
                    }
                case .failure(let error):
                    if let error = error as? SolutionProcessableProtocol {
                        error.handle(self)
                    } else {
                        
                    }
                }
            })
            
            
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
        return likeStoredRankDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let likedStoredCell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedStoredCell", for: indexPath) as! MainAllRankCell
        let likedCellData = self.likeStoredRankDatas[indexPath.item]
        likedStoredCell.isEditingLikedCell = isEditingLikedCell
        likedStoredCell.cellDatasConfigure(topic: likedCellData)
        if selectedLikedCellIndexPath.contains(where: { (index, _) -> Bool in
            return index == indexPath.item
        }){
            likedStoredCell.isSelectedLikedCell = true
        }
        return likedStoredCell
    }
}

extension TabLikeStoredRankViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width375(343), height: height667(122))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.isEditingLikedCell {
            guard let seletedCell = collectionView.cellForItem(at: indexPath) as? MainAllRankCell else { return }
            seletedCell.isSelectedLikedCell = !seletedCell.isSelectedLikedCell
            if seletedCell.isSelectedLikedCell {
                let topicSN = likeStoredRankDatas[indexPath.item].topicSN
                self.selectedLikedCellIndexPath.append((indexPath.item, topicSN))
            } else {
                if let removeIndexPath = selectedLikedCellIndexPath.index(where: { (index, _) -> Bool in
                    return index == indexPath.item
                }){
                    self.selectedLikedCellIndexPath.remove(at: removeIndexPath)
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if selectedLikedCellIndexPath.contains(where: { (index, _) -> Bool in
            return index == indexPath.item
        }){
            if let selectedCell = collectionView.cellForItem(at: indexPath)
                as? MainAllRankCell {
                selectedCell.isSelectedLikedCell = true
            }
        }
    }
    
}

