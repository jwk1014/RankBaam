//
//  TabMyViewRankingsViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 31..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabMyViewRankingsViewController: UIViewController {

    var myViewRankingDatas: [Topic] = [Topic]()
    
    var tabMyViewRankingsCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let tabMyViewRankingsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        flowlayout.scrollDirection = .vertical
        return tabMyViewRankingsCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        tabMyViewRankingsCollectionViewConfigure()
        fetchMyViewDatas()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(tabMyViewRankingsCollectionView)
        tabMyViewRankingsCollectionView.backgroundColor = UIColor.rankbaamGray
        tabMyViewRankingsCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(height667(103, forX: 125))
        }
    }
    
    func fetchMyViewDatas() {
        TopicService.myList(page: 1, order: OrderType.new) {
            switch $0.result {
            case .success(let sResult):
                if sResult.succ {
                    guard let myViewTopics = sResult.topics else {return}
                    self.myViewRankingDatas = myViewTopics
                    DispatchQueue.main.async {
                        self.tabMyViewRankingsCollectionView.reloadData()
                    }
                    
                } else if let msg = sResult.msg {
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
    
    fileprivate func tabMyViewRankingsCollectionViewConfigure() {
        tabMyViewRankingsCollectionView.dataSource = self
        tabMyViewRankingsCollectionView.delegate = self
        tabMyViewRankingsCollectionView.register(MainAllRankCell.self,
                                                 forCellWithReuseIdentifier: ConstantsNames.TabMyViewRankingControllerNames.MYVIEWRANKCELL)
        tabMyViewRankingsCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 110, right: 0)
        
    }
}

extension TabMyViewRankingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myViewRankingDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myViewRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsNames.TabMyViewRankingControllerNames.MYVIEWRANKCELL,
                                                                for: indexPath) as! MainAllRankCell
        let myViewRankData = self.myViewRankingDatas[indexPath.item]
        myViewRankCell.cellDatasConfigure(topic: myViewRankData)
        return myViewRankCell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}

extension TabMyViewRankingsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width375(343), height: height667(122))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topicDetailViewController = TopicDetailViewController()
        let topicSN = myViewRankingDatas[indexPath.item].topicSN
        
        if let _ = self.parent as? TabMyViewPageViewController {
            topicDetailViewController.bottomButtonTitleConverter =
                .isForRevisingTopic
            topicDetailViewController.navigationTitleConverter =
                .isSettingMyView
        }
        topicDetailViewController.topicSN = topicSN
        navigationController?.pushViewController(topicDetailViewController, animated: true)
    }
}



