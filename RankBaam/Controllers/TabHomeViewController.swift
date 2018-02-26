//
//  TabHomeViewController2.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 18..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

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
        fetchMainRankCellDatas()
        mainRankCollectionViewConfigure()
        
        navigationController?.navigationBar.isHidden = true
        
    }
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadMainRankCellDatas(1)
        mainAllRankCollectionView.reloadData()
    }*/
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(mainAllRankCollectionView)
        
        mainAllRankCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(height667(103, forX: 125))
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
        mainAllRankCollectionView.showsVerticalScrollIndicator = false
        mainAllRankCollectionView.contentOffset = CGPoint(x: 0, y: -mainRankRefreshControl.bounds.size.height)
        mainRankRefreshControl.beginRefreshing()
    }
    
    @objc func pullToRefresh() {
        self.page = 1
        isMoreDataExist = true
        setRefreshAllDataNeeded()
        fetchMainRankCellDatas()
        self.mainAllRankLoadingFooterView?.backToInit()
    }
    
    func fetchMainRankCellDatas(_ pageInput: Int? = nil) {
        
        if !isOnGoingLoading {
        isOnGoingLoading = true
        TopicService.list(page: pageInput ?? self.page, count: 15, order: .new) {
            switch $0.result {
            case .success(let result):
                if result.succ {
                    guard let topicDatas = result.topics else {return}
                    print("This is topicDatas Count : \(topicDatas.count)")
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
            fetchMainRankCellDatas()
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
        return height667(12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width375(343), height: height667(122))
    }
}


