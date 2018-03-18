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
    var selectedOrder: OrderType?
    var selectedCategory: Category?
    var isLoading: Bool = false
    var isCategorySet: Bool = false
    var isCategorySelectionCompleted: Bool = false {
        didSet {
            if isCategorySelectionCompleted {
                self.mainRankActivityIndicatorHandler(isAnimated: true)
                self.fetchMainRankCellDatas(nil, selectedCategory?.categorySN, selectedOrder)
            }
        }
    }
    
    var mainAllRankLoadingFooterView: MainAllRankLoadingFooterView?
    let mainRankRefreshControl: UIRefreshControl = UIRefreshControl()
    
    var mainRankActivityIndicator: UIActivityIndicatorView = {
        let mainRankActivityIndicator = UIActivityIndicatorView()
        mainRankActivityIndicator.activityIndicatorViewStyle = .whiteLarge
        mainRankActivityIndicator.color = UIColor.rankbaamOrange
        mainRankActivityIndicator.hidesWhenStopped = true
        return mainRankActivityIndicator
    }()
    
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
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(mainAllRankCollectionView)
        self.view.addSubview(mainRankActivityIndicator)
        
        
        mainAllRankCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(height667(103, forX: 125))
        }
        
        mainRankActivityIndicator.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        mainRankActivityIndicator.isHidden = true
        mainRankActivityIndicator.stopAnimating()
    }
    
    func mainRankActivityIndicatorHandler(isAnimated: Bool) {
        if isAnimated {
            mainRankActivityIndicator.isHidden = false
            mainRankActivityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        } else {
            mainRankActivityIndicator.isHidden = true
            mainRankActivityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func mainRankCollectionViewConfigure() {
        mainAllRankCollectionView.dataSource = self
        mainAllRankCollectionView.delegate = self
        mainAllRankCollectionView.prefetchDataSource = self
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
        fetchMainRankCellDatas(nil, selectedCategory?.categorySN, selectedOrder)
        self.mainAllRankLoadingFooterView?.backToInit()
    }
    
    func categorySetFetchingPreset() {
        self.page = 1
        setRefreshAllDataNeeded()
    }
    
    func fetchMainRankCellDatas(_ pageInput: Int? = nil, _ category: Int? = nil, _ order: OrderType? = nil) {
        
//        if let _ = category {
//
//            isCategorySet = true
//
//        }
        if isCategorySelectionCompleted {
            self.page = 1
            setRefreshAllDataNeeded()
        }
        
        if !isOnGoingLoading {
        isOnGoingLoading = true
        TopicService.list(page: pageInput ?? self.page, count: 15, categorySN: category, order: order ?? .new) {
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
            case .failure(let error): break
             }
            self.isOnGoingLoading = false
          }
       }
    }
    
    func categoryFetchingRefreshData(loadedData: [Topic]) -> [Topic]{
        if isCategorySet {
            return [Topic]()
        }
        return loadedData
    }
    
    func loadedDataHandle(_ loadedData: [Topic]) {
        
        refreshCellDataIfNeeded()
        
        let preCount = loadedData.count
        
        let loadedData = loadedData.reduce([Topic]()) { (tmp, item) -> [Topic] in
            var item = item
            if !cellDatas.contains{ $0.topicSN == item.topicSN } {
                item.sortPhotos()
                return tmp + [item]
            }
            return tmp
        }
        
//        loadedData = categoryFetchingRefreshData(loadedData: loadedData)
        
        page += 1
        
        if loadedData.isEmpty || (preCount == loadedData.count && loadedData.count < 15) {
            isMoreDataExist = false
            mainAllRankLoadingFooterView?.endLoad()
            if isCategorySelectionCompleted {
                isCategorySelectionCompleted = false
                self.cellDatas += loadedData
                self.mainAllRankCollectionView.reloadData()
            }
        } else {
            self.cellDatas += loadedData
            self.mainAllRankCollectionView.reloadData()
        }
        self.mainRankRefreshControl.endRefreshing()
        self.mainRankActivityIndicatorHandler(isAnimated: false)
    }
    
    func footerViewLoadDataHandler(_ indexPath: IndexPath){
        
        if indexPath.item >= cellDatas.count - loadThreshold,
            isMoreDataExist, !isOnGoingLoading {
            mainAllRankLoadingFooterView?.startLoad()
            fetchMainRankCellDatas(nil, selectedCategory?.categorySN, selectedOrder)
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
      topicDetailViewController.topicSN = cellDatas[indexPath.item].topicSN
      if self.parent is TabMyViewPageViewController {
        topicDetailViewController.bottomButtonTitleConverter = .isForRevisingTopic
        topicDetailViewController.navigationTitleConverter = .isSettingMyView
      }
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

extension TabHomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
}

