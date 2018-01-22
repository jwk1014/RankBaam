//
//  TopicReadViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit

class TopicDetailViewController: UIViewController {
    @IBOutlet weak var rankOptionCollectionView: UICollectionView!
    @IBOutlet weak var rankMainBackButton: UIImageView!
    var topicSN: Int!
    var topic: Topic?
    var optionDatas: [Option] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankOpitonCollectionConfigure()
        rankMainBackButtonConfigure()
        navigationController?.isNavigationBarHidden = true
        OptionService.optionList(topicSN: 12, pagingParam: PagingParam(page: 1, count: 20)) {
                
            switch $0.result {
                
            case .success(let sResult):
                if sResult.succ {
                    guard let options = sResult.options else { return }
                    self.optionDatas = options
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
    
    fileprivate func rankMainBackButtonConfigure() {
        rankMainBackButton.isUserInteractionEnabled = true
        rankMainBackButton.image?.withRenderingMode(.alwaysTemplate)
        rankMainBackButton.tintColor = UIColor.rankbaamOrange
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rankMainBackButtonTapped))
        rankMainBackButton.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func rankMainBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func rankOpitonCollectionConfigure() {
        
        let headerNib = UINib(nibName: "TopicDetailHeaderView", bundle: nil)
        
        rankOptionCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopicDetailHeader")
        rankOptionCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "tempCell")
        
    }
    
    @IBAction func createOptionButtonTapped(_ sender: UIButton) {
        OptionService.optionCreate(topicSN: self.topicSN, optionParam: VoteOptionType(title: "선택지1 입니다", description: "선택지 설명")) { (response) in
            
            DispatchQueue.main.async {
              
            }
        }
        
        TopicService.topicRead(topicSN: self.topicSN) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    guard let topic = sResult.topic else {return}
                    DispatchQueue.main.async {
//                        topicDetailHeader.titleLabel.text = topic.title
//                        topicDetailHeader.descriptionLabel.text = topic.description ?? ""
//                        topicDetailHeader.likeCountButton.titleLabel?.text = "\(topic.likeCount ?? 0)"
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
    
    @IBAction func deleteTopicButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "확인", style: .default) { _ in
            TopicService.topicDelete(topicSN: self.topicSN)  {
                
                switch($0.result) {
                    
                case .success(let sResult):
                    if sResult.succ {
                        UIAlertController.alert(target: self, msg: "삭제되었습니다.") { _ in
                            self.navigationController?.popViewController(animated: true)
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
        })
        present(alert, animated: true, completion: nil)
    }
}

extension TopicDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tempCell", for: indexPath)
        return optionCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let optionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopicDetailHeader", for: indexPath)
            return optionHeader
        case UICollectionElementKindSectionFooter:
            let optionFooter = UICollectionReusableView()
            return optionFooter
        default:
            return UICollectionReusableView()
        }
    }
}

extension TopicDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 478)
    }
}

protocol TopicDetailHeaderDelegate{
    func likeButtonTapped()
}

extension TopicDetailViewController: TopicDetailHeaderDelegate {
    func likeButtonTapped() {
        TopicService.topicLike(topicSN: topicSN, isLike: true) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    //TODO
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
}
