//
//  TabHomeViewController2.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 18..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Kingfisher




protocol CellDataRefreshable: class {
    
    associatedtype dataType
    var cellDatas: [dataType] { get set }
    var refreshAllDataNeeded: Bool { get set }
}

extension CellDataRefreshable {

    // class 일때는 접근가능
    func setRefreshAllDataNeeded() {
        refreshAllDataNeeded = true
    }
    
    func refreshCellDataIfNeeded() {
        if refreshAllDataNeeded {
           cellDatas = []
           refreshAllDataNeeded = false
        }
    }
    
}

class TabHomeViewController: UIViewController, CellDataRefreshable {
    
    var loadThreshold: Int = 3
    typealias dataType = Topic
    var isOnGoingLoading: Bool = false
    var cellDatas = [Topic]()
    var page: Int = 1
    var isMoreDataExist: Bool = true
    var refreshAllDataNeeded: Bool = false
    var isLoading: Bool = false
    var mainAllRankLoadingFooterView: MainAllRankLoadingFooterView?
    let mainRankRefreshControl: UIRefreshControl = UIRefreshControl()
    
    var mainAllRankCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let mainAllRankCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        return mainAllRankCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInitConfigure()
        loadMainRankCellDatas()
        mainRankCollectionViewConfigure()
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(mainAllRankCollectionView)
        mainAllRankCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Constants.screenHeight * (103 / 667))
        }
      
        
    }
    
    func mainRankCollectionViewConfigure() {
        mainAllRankCollectionView.dataSource = self
        mainAllRankCollectionView.delegate = self
        let footerNib = UINib(nibName: "MainAllRankLoadingFooterView", bundle: nil)
        mainAllRankCollectionView.register(MainAllRankCell.self, forCellWithReuseIdentifier: ConstantsNames.TabHomeViewControllerNames.MAINALLRANKCELL)
        mainAllRankCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "loadingFooterView")
        mainRankRefreshControl.tintColor = UIColor.rankbaamOrange
        mainAllRankCollectionView.refreshControl = mainRankRefreshControl
        mainRankRefreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        mainAllRankCollectionView.backgroundColor = UIColor.rankbaamGray
       
        mainAllRankCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 110, right: 0)
        
    }
    
    @objc func pullToRefresh() {
        self.page = 1
        isMoreDataExist = true
        setRefreshAllDataNeeded()
        loadMainRankCellDatas()
        self.mainAllRankLoadingFooterView?.backToInit()
    }
    
    func loadMainRankCellDatas() {
        
        if !isOnGoingLoading {
        isOnGoingLoading = true
        TopicService.list(page: page, count: 15, order: .new) {
            switch $0.result {
            case .success(let result):
                if result.succ {
                    guard let topicDatas = result.topics else {return}
                    self.loadedDataHandle(topicDatas)
                } else if let msg = result.msg {
                    self.mainAllRankLoadingFooterView?.endLoad()
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
            self.isOnGoingLoading = false
          }
        
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
            mainAllRankLoadingFooterView?.endLoad()
        } else {
            self.cellDatas += loadedData
            self.mainAllRankCollectionView.reloadData()
        }
        self.mainRankRefreshControl.endRefreshing()
    }
    
    func footerViewLoadDataHandler(_ indexPath: IndexPath){
        if indexPath.item >= cellDatas.count - loadThreshold,
            isMoreDataExist, !isOnGoingLoading {
            mainAllRankLoadingFooterView?.startLoad()
            loadMainRankCellDatas()
        }
    }
}

extension TabHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainAllRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsNames.TabHomeViewControllerNames.MAINALLRANKCELL, for: indexPath) as! MainAllRankCell
        
        mainAllRankCell.cellDatasConfigure(topic: cellDatas[indexPath.item])
        return mainAllRankCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let loadingFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                           withReuseIdentifier: "loadingFooterView",
                                                          for: indexPath) as! MainAllRankLoadingFooterView
            self.mainAllRankLoadingFooterView = loadingFooterView
            return loadingFooterView
        default:
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topicDetailViewController = TopicDetailViewController()
        let topicSN = cellDatas[indexPath.item].topicSN
        
        if let _ = self.parent as? TabMyViewPageViewController {
            topicDetailViewController.bottomButtonTitleConverter =
                .isForRevisingTopic
            topicDetailViewController.navigationTitleConverter =
                .isSettingMyView
        }
        topicDetailViewController.topicSN = topicSN
        navigationController?.pushViewController(topicDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        footerViewLoadDataHandler(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.screenHeight * (12 / 667)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return /*Constants.screenHeight == 812 ?
            CGSize(width: Constants.screenWidth * (343 / 375), height: 122) :*/
            CGSize(width: Constants.screenWidth * (343 / 375), height: Constants.screenHeight * (122 / 667))
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//         print("\(scrollView.contentOffset.x)")
//    }
}
//
//extension TabHomeViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//    }
//}

