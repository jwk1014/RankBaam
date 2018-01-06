//
//  TopicListViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit

class TopicListViewController: UIViewController {
    @IBOutlet weak var topicCollectionView: UICollectionView!
    @IBOutlet weak var createTopicButton: UIButton!
    
    var page: Int = 1
    var topicDatas: [Topic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        topicCollectionView.refreshControl = refreshControl
        topicCollectionView.refreshControl?.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        topicCollectionView.register(UINib.init(
                                        nibName: "RBMainRankingCell",
                                        bundle: nil),
                                        forCellWithReuseIdentifier: NamesWithCollectionView.MAINRANKINGCELL)
        topicCollectionView.dataSource = self
        topicCollectionView.delegate = self
        createTopicButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        refreshControl.beginRefreshing()
        refreshControlPulled(refreshControl)
    }
    
    @objc func createButtonTapped(_ sender: UIButton) {
        let vc = TopicCreateViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func refreshControlPulled(_ sender: UIRefreshControl) {
        topicDatas.removeAll()
        topicCollectionView.reloadData()
        AlamofireManager.request(
            .TopicList(pagingParam: PagingParam(page: page, count: nil))
            ).responseRankBaam { (error, errorClosure, result: SResultTopicList?, date) in
                print("에러 : \(String(describing: error?.localizedDescription)), 결과 : \(String(describing: result))")
                if let result = result {
                    if result.succ {
                        guard let topicDatas = result.topics else {return}
                        self.topicDatas += topicDatas
                        self.page += 1
                        print("############### 타이틀 \(topicDatas[1])")
                        self.topicCollectionView.reloadData()
                    }
                }
                sender.endRefreshing()
        }
    }
    
}

extension TopicListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topicDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainCell = collectionView.dequeueReusableCell(withReuseIdentifier: NamesWithCollectionView.MAINRANKINGCELL, for: indexPath) as! RBMainRankingCell
        mainCell.topicTitleLabel.text = topicDatas[indexPath.item].title
        mainCell.likeCount = topicDatas[indexPath.item].likeCount ?? 0
        return mainCell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NamesWithCollectionView.MAINRANKINGHEADER, for: indexPath)
    //        return header
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.bounds.size.height * 0.25, height: collectionView.bounds.size.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sideInset = (collectionView.bounds.size.width - collectionView.bounds.size.height * 0.25)/2
        
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: FIXME
        //        let naviController = UINavigationController()
        //        let backBtn = UIBarButtonItem(title: "back", style: .plain, target: self, action: nil)
        //naviController.navigationItem.backBarButtonItem = backBtn
        let topicDetailController = TopicDetailViewController()
        topicDetailController.topicSN = topicDatas[indexPath.item].topicSN
        navigationController?.pushViewController(topicDetailController, animated: true)
    }
    
}

extension TopicListViewController: UICollectionViewDelegateFlowLayout {
    
}

protocol TopicCreationCompletionDelegate {
    func TopicCreationCompleted()
}

extension TopicListViewController: TopicCreationCompletionDelegate {
    func TopicCreationCompleted() {
        // TODO: FIXME
        DataManager.shared.loadTopicData(page: 1)
        self.topicDatas = DataManager.shared.topicData
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
        //self.topicCollectionView.reloadData()
        // })
        //        let indexPath = IndexPath(row: topicDatas.count - 1, section: 0)
        //        topicCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
        //topicCollectionView.performBatchUpdates({
        //           topicCollectionView.insertItems(at: [indexPath])
        //}, completion: nil)
    }
}
