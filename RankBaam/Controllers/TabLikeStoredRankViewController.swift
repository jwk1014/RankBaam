//
//  TabLikeStoredRankViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 31..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TabLikeStoredRankViewController: UIViewController, CellDataRefreshable {
    var page: Int = 1
    var loadThreshold: Int = 3
    var isMoreDataExist: Bool = true
    var isOnGoingLoading: Bool = false
    var refreshAllDataNeeded: Bool = false
    typealias dataType = Topic
    var isEditingLikedCell: Bool = false
    var tabLikeStoredRankFooterView: MainAllRankLoadingFooterView?
    var cellDatas: [Topic] = [Topic]()
    var isEditingMode: Bool = false
    let likeStoredRankRefreshControl = UIRefreshControl()
    
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
    
    var selectedLikedCellIndexPath: [(indexPath: Int, optionSN: Int)] = [(indexPath: Int, optionSN: Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        tabLikeStoredRankCollectionViewConfigure()
        fetchLikeStoredRankDatas()
        tabLikeStoredRankEditingButton.addTarget(self, action: #selector(tabLikeStoredRankButtonsHandler(_:)), for: .touchUpInside)
        //tabLikeStoredRankEditingCancelButton.addTarget(self, action: #selector(tabLikeStoredRankButtonsHandler(_:)), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        fetchLikeStoredRankDatas()
    }*/
    
    func fetchLikeStoredRankDatas() {
        if !isOnGoingLoading {
            isOnGoingLoading = true
        TopicService.likeList(page: self.page, order: OrderType.new) {
            switch $0.result {
            case .success(let result):
                if result.succ {
                    guard let topicDatas = result.topics else {return}
                    print("This is LikedCellDatas Count : \(topicDatas.count)")
                    /*self.likeStoredRankDatas = topicDatas
                    print("This is WeeklyLike List Count : \(self.likeStoredRankDatas.count)")
                   
                    DispatchQueue.main.async {
                        self.tabLikeStoredRankCollectionView.reloadData()
                    }*/
                    self.loadedDataHandle(topicDatas)
                    
                } else if let msg = result.msg {
                    self.tabLikeStoredRankFooterView?.endLoad()
                    switch msg {
                    default:
                        break
                    }
                }
            case .failure(let error): break
             }
             self.isOnGoingLoading = false
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
        
        
        
        tabLikeStoredRankCustomNavigationBar.backgroundColor = UIColor.white
        tabLikeStoredRankCustomNavigationBar.layer.shadowRadius = 7
        tabLikeStoredRankCustomNavigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        tabLikeStoredRankCustomNavigationBar.layer.shadowOpacity = 0.7
        tabLikeStoredRankCustomNavigationBar.layer.shadowOffset = CGSize(width: 0, height: 12)
        tabLikeStoredRankCustomNavigationBar.layer.masksToBounds = false
        tabLikeStoredRankCustomNavigationBarTitleLabel.text = "저장 랭킹"
        tabLikeStoredRankCustomNavigationBarTitleLabel.font = UIFont(name: "NanumSquareB", size: 18)
        tabLikeStoredRankCustomNavigationBarTitleLabel.textAlignment = .center
        tabLikeStoredRankEditingButton
            .setTitle("편집", for: .normal)
        tabLikeStoredRankEditingButton
            .setTitleColor(UIColor.rankbaamDarkgray, for: .normal)
        tabLikeStoredRankEditingButton.titleLabel?.font = UIFont(name: "NanumSquareB", size: 16)
        tabLikeStoredRankCollectionView.isUserInteractionEnabled = true
        
        
        
        
        tabLikeStoredRankCustomNavigationBar.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(height667(76, forX: 98))
        }
        tabLikeStoredRankCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(height667(76, forX: 98))
        }
        tabLikeStoredRankCustomNavigationBarTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tabLikeStoredRankCustomNavigationBar.snp.top)
                .offset(height667(38, forX: 60))
            $0.centerX.equalTo(tabLikeStoredRankCustomNavigationBar.snp.centerX)
            $0.height.equalTo(height667(21))
        }
        tabLikeStoredRankEditingButton.snp.makeConstraints {
            $0.top.equalTo(tabLikeStoredRankCustomNavigationBar.snp.top)
                .offset(height667(40))
            $0.left.equalTo(tabLikeStoredRankCustomNavigationBar.snp.left)
                .offset(width375(329))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(40))
        }
    }
    
    fileprivate func tabLikeStoredRankCollectionViewConfigure() {
        
        tabLikeStoredRankCollectionView.backgroundColor = UIColor.rankbaamGray
        tabLikeStoredRankCollectionView.dataSource = self
        tabLikeStoredRankCollectionView.delegate = self
        tabLikeStoredRankCollectionView.register(MainAllRankCell.self, forCellWithReuseIdentifier: "likedStoredCell")
        tabLikeStoredRankCollectionView.register(MainAllRankLoadingFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LikedRankFooterView")
        tabLikeStoredRankCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 110, right: 0)
        tabLikeStoredRankCollectionView.refreshControl = likeStoredRankRefreshControl
        likeStoredRankRefreshControl.tintColor = UIColor.rankbaamOrange
        likeStoredRankRefreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc fileprivate func pullToRefresh() {
        self.page = 1
        isMoreDataExist = true
        setRefreshAllDataNeeded()
        fetchLikeStoredRankDatas()
        //self.mainAllRankLoadingFooterView?.backToInit()
    }
    
    @objc fileprivate func tabLikeStoredRankButtonsHandler(_ sender: UIButton) {
        
        guard let buttonTitle = sender.currentTitle else { return }
        switch buttonTitle {
        case "편집":
            sender.setTitle("완료", for: .normal)
            sender.setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
            isEditingMode = true
            //tabLikeStoredRankEditingCancelButton.isHidden = false
            //isEditingLikedCell = true
            let visibleIndice = tabLikeStoredRankCollectionView.indexPathsForVisibleItems
            tabLikeStoredRankCollectionView.reloadItems(at: visibleIndice)
//            tabLikeStoredRankCollectionView.reloadData()
//            tabLikeStoredRankCollectionView.collectionViewLayout
//                .invalidateLayout()
        case "삭제":
            //TODO : FIXME
            print("\(selectedLikedCellIndexPath.count)")
            let selectedTopicSN = selectedLikedCellIndexPath.reduce([], { (result, item) -> [Int] in
                return result + [item.optionSN]
            })
            
            let selectedIndexPath = selectedLikedCellIndexPath.reduce([], { (result, item) -> [IndexPath] in
                return result + [ IndexPath(item: item.indexPath, section: 0) ]
            }).sorted(by: { $0 > $1 })
            
            TopicService.likes(topicSNs: selectedTopicSN, isLiked: false, completion: {
                switch $0.result {
                case .success(let result):
                    if result.succ {
                        print("삭제 성공")
                       
                        for index in selectedIndexPath {
                            print("This is Indices that will be removed : \(index)")
                            self.cellDatas.remove(at: index.item)
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
                case .failure(let error): break
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
            
        case "완료":
            sender.setTitle("편집", for: .normal)
            isEditingMode = false
            let visibleIndice = tabLikeStoredRankCollectionView.indexPathsForVisibleItems
            tabLikeStoredRankCollectionView.reloadItems(at: visibleIndice)
            
        default:
            fatalError()
        }
    }
    
    func loadedDataHandle(_ loadedData: [Topic]) {
        
        refreshCellDataIfNeeded()
        
        let loadedData = loadedData.reduce([Topic]()) { (tmp, item) -> [Topic] in
            var item = item
            if !cellDatas.contains{ $0.topicSN == item.topicSN } {
                item.sortPhotos()
                return tmp + [item]
            }
            return tmp
        }
        
        page += 1
        
        if loadedData.isEmpty {
            isMoreDataExist = false
            tabLikeStoredRankFooterView?.endLoad()
        } else {
            print("This is Processd Data Count : \(loadedData.count)")
            self.cellDatas += loadedData
            self.tabLikeStoredRankCollectionView.reloadData()
        }
        self.likeStoredRankRefreshControl.endRefreshing()
    }
    
    func footerViewLoadDataHandler(_ indexPath: IndexPath){
        if indexPath.item >= cellDatas.count - loadThreshold,
            isMoreDataExist, !isOnGoingLoading {
            tabLikeStoredRankFooterView?.startLoad()
            fetchLikeStoredRankDatas()
        }
    }
}

extension TabLikeStoredRankViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let likedStoredCell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedStoredCell", for: indexPath) as! MainAllRankCell
        let likedCellData = self.cellDatas[indexPath.item]
        likedStoredCell.isEditingLikedCell = isEditingLikedCell
        likedStoredCell.cellDatasConfigure(topic: likedCellData)
        likedStoredCell.delegate = self
        likedStoredCell.isUserInteractionEnabled = true
        likedStoredCell.contentView.isUserInteractionEnabled = true
        if selectedLikedCellIndexPath.contains(where: { (index, _) -> Bool in
            return index == indexPath.item
        }){
            likedStoredCell.isSelectedLikedCell = true
        }
        
        if isEditingMode {
            UIView.animate(withDuration: 0.7, animations: {
                likedStoredCell.mainAllRankCellDeleteImageView.isHidden = false
//                let aaa = CGAffineTransform(translationX: 55, y: 0)
//                let bbb = CGAffineTransform(scaleX: 0.9, y: 0.9)
                likedStoredCell.transform = CGAffineTransform.identity.translatedBy(x: 48, y: 0)//.scaledBy(x: 0.9, y: 0.9)
            })
            //likedStoredCell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        
        return likedStoredCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let loadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                    withReuseIdentifier: "LikedRankFooterView",
                                                                                    for: indexPath) as! MainAllRankLoadingFooterView
            self.tabLikeStoredRankFooterView = loadingFooterView
            return loadingFooterView
        default:
            return UICollectionReusableView()
        }
    }
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }*/
}

extension TabLikeStoredRankViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width375(343), height: height667(122))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*guard let seletedCell = collectionView.cellForItem(at: indexPath) as? MainAllRankCell else { return }
        
        seletedCell.transform = CGAffineTransform(translationX: 48, y: 0)
        seletedCell.transform = CGAffineTransform(scaleX: 0.8, y: 0.9)
        /*let button = UIButton(frame: CGRect(x: seletedCell.frame.origin.x - 36, y: seletedCell.frame.origin.y + 48, width: 24, height: 24))
        button.setImage(UIImage(named: "icCancel"), for: .normal)
        button.contentMode = .scaleAspectFit
        collectionView.addSubview(button)*/
        
        if self.isEditingLikedCell {
            guard let seletedCell = collectionView.cellForItem(at: indexPath) as? MainAllRankCell else { return }
            seletedCell.isSelectedLikedCell = !seletedCell.isSelectedLikedCell
            if seletedCell.isSelectedLikedCell {
                let topicSN = cellDatas[indexPath.item].topicSN
                self.selectedLikedCellIndexPath.append((indexPath.item, topicSN))
            } else {
                if let removeIndexPath = selectedLikedCellIndexPath.index(where: { (index, _) -> Bool in
                    return index == indexPath.item
                }){
                    self.selectedLikedCellIndexPath.remove(at: removeIndexPath)
                }
            }
        }*/
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
        footerViewLoadDataHandler(indexPath)
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return !isEditingMode
//    }
}

extension TabLikeStoredRankViewController: LikeStoredRankCellDelegate {
    func likeStoredRankCellDeleteHandler(with cell: UICollectionViewCell) {
        guard let deleteCell = cell as? MainAllRankCell,
            let deleteIndexPath = tabLikeStoredRankCollectionView.indexPath(for: deleteCell)
        else { return }
        print("This is IndexPath for deleteCell : \(deleteIndexPath)")
        
        TopicService.like(topicSN: cellDatas[deleteIndexPath.item].topicSN, isLiked: false, completion: {
            switch $0.result {
            case .success(let result):
                if result.succ {
                    print("삭제 성공")
                    self.cellDatas.remove(at: deleteIndexPath.item)
                    self.tabLikeStoredRankCollectionView.performBatchUpdates({
                        self.tabLikeStoredRankCollectionView.deleteItems(at: [deleteIndexPath])
                    }, completion: nil)
                    self.fetchLikeStoredRankDatas()
                } else if let msg = result.msg {
                    
                    switch msg {
                    default:
                        break
                    }
                }
            case .failure(let error): break
            }
        })
    }
}

