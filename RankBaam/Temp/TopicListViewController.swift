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
        TopicService.topicList(page: self.page, count: nil) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    guard let topicDatas = sResult.topics else {return}
                    self.topicDatas += topicDatas
                    self.page += 1
                    self.topicCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.bounds.size.height * 0.25, height: collectionView.bounds.size.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sideInset = (collectionView.bounds.size.width - collectionView.bounds.size.height * 0.25)/2
        
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: FIXME
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
        //DataManager.shared.loadTopicData(page: 1)
        //self.topicDatas = DataManager.shared.topicData
    }
}
