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


    @IBOutlet weak var mainAllRankCollectionView: UICollectionView!
    @IBOutlet weak var mainAllRankCustomNavigationBar: UIView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //upperTabbarConfigure()
        loadMainRankCellDatas()
        mainRankCollectionViewConfigure()
        
        navigationController?.navigationBar.isHidden = true
        /*navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.rankbaamOrange
        ]
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.topItem?.title = "Rank Baam"
        
        navigationController?.navigationBar.barTintColor = UIColor.white*/
        
    }
    
    func mainRankCollectionViewConfigure() {
        let cellNib = UINib(nibName: "MainAllRankCell", bundle: nil)
        let footerNib = UINib(nibName: "MainAllRankLoadingFooterView", bundle: nil)
        mainAllRankCollectionView.register(cellNib, forCellWithReuseIdentifier: ConstantsNames.TabMainViewControllerNames.MAINALLRANKCELL)
        mainAllRankCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "loadingFooterView")
        mainRankRefreshControl.tintColor = UIColor.rankbaamOrange
        mainAllRankCollectionView.refreshControl = mainRankRefreshControl
        mainRankRefreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        mainAllRankCollectionView.backgroundColor = UIColor.rankbaamGray
        mainAllRankCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
    }
    
    @objc func pullToRefresh() {
        self.page = 1
        isMoreDataExist = true
        setRefreshAllDataNeeded()
        loadMainRankCellDatas()
        self.mainAllRankLoadingFooterView?.backToInit()
    }
    
    func upperTabbarConfigure() {
        
        let upperTabber = MainAllRankTopTabbar(frame: CGRect(x: 0, y: 68, width: self.view.frame.width, height: 35))
        self.view.addSubview(upperTabber)
        upperTabber.translatesAutoresizingMaskIntoConstraints = false
        upperTabber.topAnchor.constraint(equalTo: self.mainAllRankCustomNavigationBar.bottomAnchor).isActive = true
        upperTabber.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        upperTabber.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        upperTabber.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func loadMainRankCellDatas() {
        
        if !isOnGoingLoading {
        isOnGoingLoading = true
        TopicService.list(page: page, count: 15, categorySN: 12, order: .new) {
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
        page += 1
        if loadedData.isEmpty {
            isMoreDataExist = false
            mainAllRankLoadingFooterView?.endLoad()
        }
        self.mainRankRefreshControl.endRefreshing()
        self.cellDatas.append(contentsOf: loadedData)
        self.mainAllRankCollectionView.reloadData()
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
        let mainAllRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsNames.TabMainViewControllerNames.MAINALLRANKCELL, for: indexPath) as! MainAllRankCell
        
        mainAllRankCell.cellDatasConfigure(topic: cellDatas[indexPath.item])
        if !cellDatas[indexPath.item].photos.isEmpty {
            let imgURL = URL(string: cellDatas[indexPath.item].photos[0].realUrl)
            mainAllRankCell.mainRankCellImg.kf.indicatorType = .activity
            mainAllRankCell.mainRankCellImg.kf.indicator?.startAnimatingView()
            mainAllRankCell.mainRankCellImg.kf.setImage(with: imgURL) { (_, _, _, _) in
                mainAllRankCell.mainRankCellImg.kf.indicator?.stopAnimatingView()
            }
        }
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 327, height: 128)
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//         print("\(scrollView.contentOffset.x)")
//    }
}
//
//extension TabHomeViewController2: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//    }
//}

