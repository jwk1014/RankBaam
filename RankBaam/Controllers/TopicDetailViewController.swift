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
    @IBOutlet weak var rankVoteButton: UIButton!
    @IBOutlet weak var rankOptionCollectionBackgroundScrollView: UIScrollView!
    @IBOutlet weak var rankDetailHeartLikeButton: UIImageView!
    
    var topicSN: Int!
    var topic: Topic?
    var optionDatas: [Option] = []
    var votableCountPerUser: Int?
    var isLogin: Bool?
    var isAlreadyVoted: Bool?
    var isOnlyWriterCreateOption: Bool?
    var spreadTransition = SpreadTransition()
    var startFrameForspreadTransition: CGRect?
    var topicDetailHeaderView: TopicDetailHeaderView?
    var selectedOptionIndexPath: [Int] = [] {
        didSet {
            if selectedOptionIndexPath.isEmpty {
                
            } else {
                
            }
        }
    }
    
    var isLikedForHeartButton: Bool = false {
        didSet {
            rankDetailHeartLikeButton.image = isLikedForHeartButton ?heartButtonImgForLiked : heartButtonImgForUnliked
        }
    }
    
    lazy var heartButtonImgForLiked: UIImage? = UIImage(named: "heartIcnF")
    lazy var heartButtonImgForUnliked: UIImage? = UIImage(named: "heartIcnN")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankOpitonCollectionConfigure()
        rankMainButtonsConfigure()
        navigationController?.isNavigationBarHidden = true
        topicDetailDataFetch()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowUp(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    fileprivate func topicDetailDataFetch() {
        TopicService.read(topicSN: self.topicSN) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    guard let topic = sResult.topic else {return}
                    DispatchQueue.main.async {
                        self.topic = topic
                        self.isLikedForHeartButton = topic.isLike
                        self.rankOptionCollectionView.reloadData()
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
        
        OptionService.list(topicSN: self.topicSN, page: 1, count: 15) {
            
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
    
    fileprivate func rankMainButtonsConfigure() {
        
        rankMainBackButton.isUserInteractionEnabled = true
        rankMainBackButton.image?.withRenderingMode(.alwaysTemplate)
        rankMainBackButton.tintColor = UIColor.rankbaamOrange
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rankMainBackButtonTapped))
        rankMainBackButton.addGestureRecognizer(tapGesture)
        rankDetailHeartLikeButton.isUserInteractionEnabled = true
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(heartLikeButtonTapped))
        rankDetailHeartLikeButton.addGestureRecognizer(likeTapGesture)
    }
    
    @objc fileprivate func heartLikeButtonTapped() {
        self.isLikedForHeartButton = !isLikedForHeartButton
        topicDetailHeaderView?.isLiked = isLikedForHeartButton
        topicDetailHeaderView?.likeCount = isLikedForHeartButton ? (topicDetailHeaderView?.likeCount)! + 1 : (topicDetailHeaderView?.likeCount)! - 1
    }
    
    @objc func rankMainBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func rankOpitonCollectionConfigure() {
        let upperLayer = CAShapeLayer()
        rankOptionCollectionView.layer.insertSublayer(upperLayer, at: 0)
        upperLayer.path = UIBezierPath.init(rect: CGRect.init(
            x: 0, y: -view.bounds.height, width: rankOptionCollectionView.bounds.width, height: view.bounds.height
        )).cgPath
        upperLayer.fillColor = UIColor.white.cgColor
        
        let headerNib = UINib(nibName: "TopicDetailHeaderView", bundle: nil)
        let optionCellNib = UINib(nibName: "TopicDetailOptionCell", bundle: nil)
        let footerNib = UINib(nibName: "TopicDetailFooterView", bundle: nil)
        rankOptionCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopicDetailHeaderView")
        rankOptionCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "TopicDetailFooterView")
        rankOptionCollectionView.register(optionCellNib, forCellWithReuseIdentifier: "TopicDetailOptionCell")
        rankOptionCollectionView.showsVerticalScrollIndicator = false
        rankOptionCollectionView.backgroundColor = UIColor.rankbaamGray
        rankOptionCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        rankVoteButton.backgroundColor = UIColor.rankbaamDarkgray
        
    }
    
    @IBAction func createOptionButtonTapped(_ sender: UIButton) {
      
        //TODO title description
        OptionService.create(
            optionWrite: OptionWrite(
                topicSN: self.topicSN,
                optionSN: nil,
                title: "test",
                description: "test")
        ) { (response) in
            
            DispatchQueue.main.async {
              
            }
        }
        
        TopicService.read(topicSN: self.topicSN) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    //guard let topic = sResult.topic else {return}
                    //DispatchQueue.main.async {
//                        topicDetailHeader.titleLabel.text = topic.title
//                        topicDetailHeader.descriptionLabel.text = topic.description ?? ""
//                        topicDetailHeader.likeCountButton.titleLabel?.text = "\(topic.likeCount ?? 0)"
                    //}
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
    
    @objc fileprivate func keyboardDidShowUp(_ notification: Notification) {
        
        self.rankOptionCollectionBackgroundScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
    }
    
    @objc fileprivate func keyboardDidDisappear(_ notification: Notification) {
        rankOptionCollectionBackgroundScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    @IBAction func deleteTopicButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "확인", style: .default) { _ in
            TopicService.delete(topicSN: self.topicSN)  {
                
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
        let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicDetailOptionCell", for: indexPath)
        return optionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 342, height: 72)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let optionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopicDetailHeaderView", for: indexPath) as! TopicDetailHeaderView
            optionHeader.delegate = self
            self.topicDetailHeaderView = optionHeader
            if let topic = self.topic {
                optionHeader.topicDetailHeaderDataConfigure(topic)
            }
            return optionHeader
        case UICollectionElementKindSectionFooter:
            let optionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TopicDetailFooterView", for: indexPath)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 342, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicDetailOptionCell
        selectedCell.isSelectedForVote = !selectedCell.isSelectedForVote
        rankVoteButton.backgroundColor = UIColor.rankbaamOrange
    }
}

protocol TopicDetailHeaderDelegate{
    func likeButtonTapped()
}

extension TopicDetailViewController: TopicDetailHeaderDelegate {
    func likeButtonTapped() {
        TopicService.like(topicSN: topicSN, isLike: true) {
            
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

extension TopicDetailViewController: TopicDetailHeaderViewDelegate {
    func topicDetailImagesTapped(_ startImageViewFrame: CGRect) {
        let topicDetailImagesViewCon = TopicDetailImagesViewController()
        topicDetailImagesViewCon.transitioningDelegate = self
        self.startFrameForspreadTransition = startImageViewFrame
        present(topicDetailImagesViewCon, animated: true, completion: nil)
    }
    func likeTextButtonTapped(_ isLiked: Bool) {
        isLikedForHeartButton = isLiked
    }
}

extension TopicDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        spreadTransition.startFrame = self.startFrameForspreadTransition ?? CGRect.zero
        
        //let test = self.view.convert(rankOptionCollectionView.visibleCells[0].frame, to: nil)
        
        /*let test = self.rankOptionCollectionView.visibleCells[0].superview?.superview
        print("####SuperView is :\(test)####")*/
        
        spreadTransition.startFrame = self.startFrameForspreadTransition!
        return spreadTransition
    }
}
