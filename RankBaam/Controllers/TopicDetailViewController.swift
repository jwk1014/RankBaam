//
//  TopicReadViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import SnapKit

enum optionDataFetchState {
    case FetchAllDatas
    case NewOptionAdded
}

enum BottomButtonTitleConverter: CustomStringConvertible {
    
    case isAlreadyVoted
    case isForRevisingTopic
    case isFirstTimeForVote
    
    var description: String {
        get{
            switch self {
            case .isAlreadyVoted:
                return "다시 투표하기"
            case .isFirstTimeForVote:
                return "투표하기"
            case .isForRevisingTopic:
                return "수정하기"
            }
        }
    }
}

enum NavigationTitleConverter: CustomStringConvertible {
    
    case isMain
    case isSettingMyView
    
    var description: String {
        get{
            switch self {
            case .isMain:
                return "RANK BAAM"
            case .isSettingMyView:
                return "내 글 관리"
            }
        }
    }
}


class TopicDetailViewController: UIViewController {
    
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
    var topicDetailFooterView: TopicDetailFooterView?
    var semaphore = DispatchSemaphore(value: 1)
    var optionDataFetchState: optionDataFetchState = .FetchAllDatas
    var navigationTitleConverter: NavigationTitleConverter?
    var bottomButtonTitleConverter: BottomButtonTitleConverter?

     var selectedOptionIndexPath: [(indexPath: Int, optionSN: Int)] = [] {
         didSet {
             if selectedOptionIndexPath.isEmpty {
                 topicDetailRankVoteButton
                    .backgroundColor = UIColor.rankbaamDarkgray
             } else {
                 topicDetailRankVoteButton
                    .backgroundColor = UIColor.rankbaamOrange
             }
         }
     }
    
    var isLikedForHeartButton: Bool = false {
        didSet {
            topicDetailHeartLikeButtonImageView.image = isLikedForHeartButton ?heartButtonImgForLiked : heartButtonImgForUnliked
            semaphore.wait()
            TopicService.like(topicSN: topicSN, isLike: isLikedForHeartButton) {
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
                self.semaphore.signal()
            }
        }
    }
    
    lazy var heartButtonImgForLiked: UIImage? = UIImage(named: "heartIcnF")
    lazy var heartButtonImgForUnliked: UIImage? = UIImage(named: "heartIcnN")
    
   
    
    var topicDetailScrollViewForRankOptionCollectionView: UIScrollView = {
        let topicDetailScrollViewForRankOptionCollectionView = UIScrollView()
        return topicDetailScrollViewForRankOptionCollectionView
    }()
    
    var topicDetailScrollViewContentsView: UIView = {
        let topicDetailScrollViewContentsView = UIView()
        return topicDetailScrollViewContentsView
    }()
    
    var topicDetailRankOptionCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let topicDetailRankOptionCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return topicDetailRankOptionCollectionView
    }()
    
    var topicDetailTopCustomNavigationBar: UIView = {
        let topicDetailTopCustomNavigationBar = UIView()
        return topicDetailTopCustomNavigationBar
    }()
    
    var topicDetailrankMainBackButtonImageView: UIImageView = {
        let topicDetailrankMainBackButtonImageView = UIImageView()
        return topicDetailrankMainBackButtonImageView
    }()
    
    var topicDetailrankMainBackButton: UIButton = {
        let topicDetailrankMainBackButton = UIButton()
        return topicDetailrankMainBackButton
    }()
    
    var topicDetailNavigationBarTitleLabel: UILabel = {
        let topicDetailNavigationBarTitleLabel = UILabel()
        return topicDetailNavigationBarTitleLabel
    }()
    
    var topicDetailMoreFunctionsButtonImageView: UIImageView = {
        let topicDetailMoreFunctionsButtonImageView = UIImageView()
        return topicDetailMoreFunctionsButtonImageView
    }()
    
    var topicDetailHeartLikeButtonImageView: UIImageView = {
        let topicDetailHeartLikeButtonImageView = UIImageView()
        return topicDetailHeartLikeButtonImageView
    }()
    
    var topicDetailShareButtonImageView: UIImageView = {
        let topicDetailShareButtonImageView = UIImageView()
        return topicDetailShareButtonImageView
    }()
    
    var topicDetailMoreFunctionsButton: UIButton = {
        let topicDetailMoreFunctionsButton = UIButton()
        return topicDetailMoreFunctionsButton
    }()
    
    var topicDetailHeartLikeButton: UIButton = {
        let topicDetailHeartLikeButton = UIButton()
        return topicDetailHeartLikeButton
    }()
    
    var topicDetailShareButton: UIButton = {
        let topicDetailShareButton = UIButton()
        return topicDetailShareButton
    }()
    
    var topicDetailRankVoteButton: UIButton = {
        let topicDetailRankVoteButton = UIButton()
        return topicDetailRankVoteButton
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInitConfigure()
        topicDetailTopicDataFetch()
        topicDetailOptionDataFetch()
        topicDetailRankOpitonCollectionConfigure()
        rankMainButtonsConfigure()
        self.view.backgroundColor = UIColor.white
        navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowUp(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(topicDetailTopCustomNavigationBar)
        self.view.addSubview(topicDetailScrollViewForRankOptionCollectionView)
        topicDetailScrollViewForRankOptionCollectionView
            .addSubview(topicDetailScrollViewContentsView)
        topicDetailScrollViewContentsView
            .addSubview(topicDetailRankOptionCollectionView)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailrankMainBackButtonImageView)
        topicDetailTopCustomNavigationBar.addSubview(topicDetailrankMainBackButton)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailNavigationBarTitleLabel)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailMoreFunctionsButtonImageView)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailHeartLikeButtonImageView)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailShareButtonImageView)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailMoreFunctionsButton)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailHeartLikeButton)
        topicDetailTopCustomNavigationBar
            .addSubview(topicDetailShareButton)
        self.view.addSubview(topicDetailRankVoteButton)
        
        self.view.backgroundColor = UIColor.white
        topicDetailTopCustomNavigationBar.backgroundColor = UIColor.white
        topicDetailScrollViewForRankOptionCollectionView
            .backgroundColor = UIColor.white
        topicDetailScrollViewContentsView.backgroundColor = UIColor.rankbaamOrange
        topicDetailRankOptionCollectionView.backgroundColor = UIColor.rankbaamBlue
        topicDetailScrollViewForRankOptionCollectionView
            .contentSize = CGSize(width: Constants.screenWidth, height: Constants.screenHeight * ( 591 / 667))
        topicDetailrankMainBackButtonImageView.image = UIImage(named: "back")?
            .withRenderingMode(.alwaysTemplate)
        topicDetailrankMainBackButtonImageView.tintColor = UIColor.rankbaamOrange
        topicDetailrankMainBackButton.addTarget(self, action: #selector(rankMainBackButtonTapped), for: .touchUpInside)
        topicDetailNavigationBarTitleLabel.text = navigationTitleConverter?.description ?? "RANK BAAM"
        topicDetailNavigationBarTitleLabel.textColor = UIColor.rankbaamOrange
        topicDetailNavigationBarTitleLabel.font = topicDetailNavigationBarTitleLabel
                                                    .font
                                                    .withSize(Constants.screenWidth * (16 / 375))
        topicDetailMoreFunctionsButtonImageView.image = UIImage(named: "moreIcn")
        topicDetailMoreFunctionsButtonImageView.contentMode = .center
        topicDetailHeartLikeButtonImageView.image = UIImage(named: "heartIcnN")
        topicDetailHeartLikeButtonImageView.contentMode = .center
        topicDetailShareButtonImageView.image = UIImage(named: "shareIcn")
        topicDetailShareButtonImageView.contentMode = .center
        /*topicDetailMoreFunctionsButton.backgroundColor = UIColor.rankbaamOrange
        topicDetailHeartLikeButton.backgroundColor = UIColor.rankbaamBlue
        topicDetailShareButton.backgroundColor = UIColor.rankbaamDarkgray*/
        topicDetailRankVoteButton.backgroundColor = UIColor.rankbaamDarkgray
        topicDetailRankVoteButton.setTitle(bottomButtonTitleConverter?.description ?? "투표하기", for: .normal)
        topicDetailRankVoteButton.titleLabel?.font = topicDetailRankVoteButton.titleLabel?
            .font
            .withSize(Constants.screenHeight * (16 / 667))
        topicDetailRankVoteButton.setTitleColor(UIColor.init(r: 77, g: 77, b: 77), for: .normal)
        
        
        topicDetailTopCustomNavigationBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(Constants.screenHeight * (76 / 667))
        }
        topicDetailrankMainBackButtonImageView.snp.makeConstraints {
            $0.left.equalTo(topicDetailTopCustomNavigationBar.snp.left)
                .offset(Constants.screenWidth * (16 / 375))
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (42 / 667))
            $0.width.equalTo(Constants.screenWidth * (24 / 375))
            $0.height.equalTo(Constants.screenHeight * (24 / 667))
        }
        topicDetailrankMainBackButton.snp.makeConstraints {
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (42 / 667))
            $0.left.bottom.equalToSuperview()
            $0.width.equalTo(Constants.screenWidth * (56 / 375))
        }
        topicDetailNavigationBarTitleLabel.snp.makeConstraints {
            $0.left.equalTo(topicDetailrankMainBackButton.snp.right)
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (45 / 667))
            $0.width.equalTo(Constants.screenWidth * (100 / 375))
            $0.height.equalTo(Constants.screenHeight * (18 / 667))
        }
        topicDetailMoreFunctionsButtonImageView.snp.makeConstraints {
            $0.right.equalTo(topicDetailTopCustomNavigationBar.snp.right)
                .offset(-(Constants.screenWidth * (10 / 375)))
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (42 / 667))
            $0.width.equalTo(Constants.screenWidth * (24 / 375))
            $0.height.equalTo(Constants.screenHeight * (24 / 667))
        }
        topicDetailHeartLikeButtonImageView.snp.makeConstraints {
            $0.right.equalTo(topicDetailMoreFunctionsButtonImageView.snp.left)
                .offset(-(Constants.screenWidth * (26 / 375)))
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (42 / 667))
            $0.width.equalTo(Constants.screenWidth * (24 / 375))
            $0.height.equalTo(Constants.screenHeight * (24 / 667))
        }
        topicDetailShareButtonImageView.snp.makeConstraints {
            $0.right.equalTo(topicDetailHeartLikeButtonImageView.snp.left)
                .offset(-(Constants.screenWidth * (26 / 375)))
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (42 / 667))
            $0.width.equalTo(Constants.screenWidth * (24 / 375))
            $0.height.equalTo(Constants.screenHeight * (24 / 667))
        }
        topicDetailMoreFunctionsButton.snp.makeConstraints {
            $0.right.bottom.equalToSuperview()
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (21 / 667))
            $0.left.equalTo(topicDetailHeartLikeButtonImageView.snp.right)
                .offset(Constants.screenWidth * (13 / 375))
        }
        topicDetailHeartLikeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (21 / 667))
            $0.left.equalTo(topicDetailShareButtonImageView.snp.right)
                .offset(Constants.screenWidth * (13 / 375))
            $0.right.equalTo(topicDetailMoreFunctionsButton.snp.left)
        }
        topicDetailShareButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (21 / 667))
            $0.left.equalTo(topicDetailNavigationBarTitleLabel.snp.right)
                .offset(Constants.screenWidth * (70 / 375))
            $0.right.equalTo(topicDetailHeartLikeButton.snp.left)
        }
        topicDetailScrollViewForRankOptionCollectionView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(topicDetailTopCustomNavigationBar.snp.bottom)
        }
        topicDetailScrollViewContentsView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.width.equalTo(Constants.screenWidth)
            $0.height.equalTo(Constants.screenHeight * (591 / 667))
        }
        topicDetailRankOptionCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        topicDetailRankVoteButton.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(Constants.screenHeight * (56 / 667))
        }
        
    }
    
    fileprivate func topicDetailTopicDataFetch() {
        TopicService.read(topicSN: self.topicSN) {

            switch($0.result) {

            case .success(let sResult):
                if sResult.succ {
                    guard let topic = sResult.topic else {return}
                    DispatchQueue.main.async {
                        self.topic = topic
                        self.topicDetailHeartLikeButtonImageView.image = topic.isLike ? self.heartButtonImgForLiked : self.heartButtonImgForUnliked
                        self.topicDetailRankOptionCollectionView.reloadData()
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
    
    fileprivate func topicDetailOptionDataFetch(){
        OptionService.list(topicSN: self.topicSN, page: 1, count: 15) {
            
            switch $0.result {
                
            case .success(let sResult):
                if sResult.succ {
                    guard let options = sResult.options else { return }
                    
                    print("#### OptionData count is :\(self.optionDatas.count)")
                    switch self.optionDataFetchState {
                    case .FetchAllDatas:
                        DispatchQueue.main.async {
                            self.optionDatas = options
                            self.topicDetailRankOptionCollectionView.reloadData()
                        }
                    case .NewOptionAdded:
                        DispatchQueue.main.async {
                        var newIndex = IndexPath()
                        self.optionDatas = options
                        self.topicDetailRankOptionCollectionView
                            .performBatchUpdates({
                                newIndex = IndexPath(item: self.optionDatas.count - 1, section: 0)
                                self.topicDetailRankOptionCollectionView
                                    .insertItems(at: [newIndex])
                                self.optionDataFetchState = .FetchAllDatas
                            }, completion: { (isCompleted) in
                                
                                let index = IndexPath(row: 0, section: 0)
                                if isCompleted {
                                    self.topicDetailRankOptionCollectionView
                                        .reloadData()
                                    self.topicDetailRankOptionCollectionView
                                        .collectionViewLayout
                                        .invalidateLayout()
//                                    self.topicDetailRankOptionCollectionView
//                                        .scrollToItem(
//                                            at: index,
//                                            at: UICollectionViewScrollPosition
//                                                .right,
//                                            animated: true)
                                    self.topicDetailRankOptionCollectionView.scrollRectToVisible(CGRect.init(x: 0, y:Constants.screenHeight * (440 / 667), width: 10, height: 10), animated: true)
                                }
                            })
                        }
                        
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

    fileprivate func rankMainButtonsConfigure() {

        topicDetailHeartLikeButton.addTarget(self, action: #selector(heartLikeButtonTapped), for: .touchUpInside)
        topicDetailRankVoteButton.addTarget(self, action: #selector(topicDetailRankVoteButtonTapped(_:)), for: .touchUpInside)
    }

    @objc fileprivate func heartLikeButtonTapped() {
        self.isLikedForHeartButton = !isLikedForHeartButton
        topicDetailHeaderView?.isLiked = isLikedForHeartButton
        topicDetailHeaderView?.likeCount = isLikedForHeartButton ? (topicDetailHeaderView?.likeCount)! + 1 : (topicDetailHeaderView?.likeCount)! - 1
    }

    @objc fileprivate func rankMainBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    fileprivate func topicDetailRankOpitonCollectionConfigure() {
        topicDetailRankOptionCollectionView.delegate = self
        topicDetailRankOptionCollectionView.dataSource = self
        
        let upperLayer = CAShapeLayer()
        topicDetailRankOptionCollectionView.layer.insertSublayer(upperLayer, at: 0)
        upperLayer.path = UIBezierPath.init(rect: CGRect.init(
            x: 0, y: -(Constants.screenHeight * (591 / 667)), width: view.bounds.width, height: Constants.screenHeight * (591 / 667)
        )).cgPath
        upperLayer.fillColor = UIColor.white.cgColor
        
       
        topicDetailRankOptionCollectionView.register(TopicDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "TopicDetailHeaderView")
        topicDetailRankOptionCollectionView.register(TopicDetailFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "TopicDetailFooterView")
        topicDetailRankOptionCollectionView.register(TopicDetailOptionCell.self, forCellWithReuseIdentifier: "TopicDetailOptionCell")
        topicDetailRankOptionCollectionView.showsVerticalScrollIndicator = false
        topicDetailRankOptionCollectionView.backgroundColor = UIColor.rankbaamGray
        topicDetailRankOptionCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.screenHeight * ( 60 / 667 ), right: 0)
    }

    /*@IBAction func createOptionButtonTapped(_ sender: UIButton) {

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
                    guard let topic = sResult.topic else {return}
                    DispatchQueue.main.async {

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

    }*/

    @objc fileprivate func keyboardDidShowUp(_ notification: Notification) {

        if let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect{
            self.topicDetailScrollViewForRankOptionCollectionView
                .contentInset.top = -keyboardFrame.height
           
        } else {
            self.topicDetailScrollViewForRankOptionCollectionView
                .contentInset.top -= Constants.screenHeight * (170 / 667)
        }
    }

    @objc fileprivate func keyboardDidDisappear(_ notification: Notification) {
        topicDetailScrollViewForRankOptionCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.screenHeight * (56 / 667), right: 0)
    }
    
    @objc fileprivate func topicDetailRankVoteButtonTapped(_ sender: UIButton) {
        
        voteListTest()
        for (_, optionSN) in selectedOptionIndexPath {
            OptionService.vote(topicSN: self.topicSN, optionSN: optionSN, isVoted: true, completion: {
                switch $0.result {
                case .success(let sResult):
                    if sResult.succ {
                        print("Vote Action is Success")
                        
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
            })
        }
        
        
    }
    
    func voteListTest() {
        
        OptionService.voteList(topicSN: self.topicSN) {
            switch $0.result {
            case .success(let sResult):
                if sResult.succ {
                    
                    
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

   /* @IBAction func deleteTopicButtonTapped(_ sender: UIButton) {
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

*/
}
extension TopicDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionDatas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicDetailOptionCell", for: indexPath) as! TopicDetailOptionCell
        let optionData = optionDatas[indexPath.item]
        optionCell.topicDetailOptionCellDataConfigure(optionData)
        if selectedOptionIndexPath.contains(where: { (index, _) -> Bool in
            return index == indexPath.item
        }){
            optionCell.isSelectedForVote = true
        }
        
        return optionCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.screenWidth * (342 / 375),
                      height: Constants.screenHeight * (72 / 667))
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
            as! TopicDetailFooterView
            optionFooter.delegate = self
            self.topicDetailFooterView = optionFooter
            return optionFooter
        default:
            return UICollectionReusableView()
        }
    }
}

extension TopicDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let targetSize = CGSize(width: self.view.frame.width, height: Constants.screenHeight * (520 / 667))
        
        guard let topicDetailHeaderView = topicDetailHeaderView else { return targetSize }
        
        let fittingSizeHeight = topicDetailHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height > 520 ? topicDetailHeaderView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height : 520
        return .init(width: self.view.frame.width, height: fittingSizeHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let standardHeight = Constants.screenHeight == 812 ? 700 : Constants.screenHeight
        
        return CGSize(width: Constants.screenWidth * (342 / 375), height: standardHeight * (120 / 667))
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (Constants.screenHeight * (16 / 667))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: Constants.screenHeight * (7 / 667), right: 0)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let selectedCell = collectionView.cellForItem(at: indexPath) as! TopicDetailOptionCell
        selectedCell.isSelectedForVote = !selectedCell.isSelectedForVote
        if selectedCell.isSelectedForVote {
            let optionSN = optionDatas[indexPath.item].optionSN
            self.selectedOptionIndexPath.append((indexPath.item, optionSN))
        } else {
            if let removeIndexPath = selectedOptionIndexPath.index(where: { (index, _) -> Bool in
                return index == indexPath.item
            }){
                self.selectedOptionIndexPath.remove(at: removeIndexPath)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if selectedOptionIndexPath.contains(where: { (index, _) -> Bool in
            return index == indexPath.item
        }){
            if let selectedCell = collectionView.cellForItem(at: indexPath)
                as? TopicDetailOptionCell {
                selectedCell.isSelectedForVote = true
            }
        }
    }
}


extension TopicDetailViewController: TopicDetailHeaderViewDelegate {
    func topicDetailImagesTapped(_ startImageViewFrame: CGRect) {
        guard let topic = self.topic else { return }
        let topicDetailImagesViewCon = TopicDetailImagesViewController()
        topicDetailImagesViewCon.transitioningDelegate = self
        topicDetailImagesViewCon.topicImages = topic.photos
        self.startFrameForspreadTransition = startImageViewFrame
        topicDetailImagesViewCon.modalPresentationStyle = .overCurrentContext
       
        present(topicDetailImagesViewCon, animated: true, completion: nil)
    }
    func likeTextButtonTapped(_ isLiked: Bool) {
        isLikedForHeartButton = isLiked
    }
}

extension TopicDetailViewController: TopicDetailFooterViewDelegate {
    func optionCreateButtonTapped(_ optionTitle: String) {
        if (optionTitle.count <= 5) {
            let alertCon = UIAlertController(title: "최소 글자수 미달", message: "최소 5자 이상 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil)
            alertCon.addAction(alertAction)
            present(alertCon, animated: true, completion: nil)
        } else {
            let newOption = OptionWrite(topicSN: topicSN,
                                        optionSN: nil,
                                        title: optionTitle,
                                        description: nil)
            OptionService.create(optionWrite: newOption) {
                switch $0.result {
                    case .success(let sResult):
                        if sResult.succ {
                            guard let newOption = sResult.optionSN else {return}
                            
                            print("new Option is Added : \(newOption)")
                            DispatchQueue.main.async {
                                guard let topicDetailFooterView = self.topicDetailFooterView else { return }
                                self.optionDataFetchState = .NewOptionAdded
                            topicDetailFooterView.topicDetailFooterWriteCellTextField.text = ""
                                topicDetailFooterView
                                    .topicDetailFooterCreateOrCancelButton.setTitle("취소", for: .normal)
                                self.topicDetailFooterView?
                                    .topicDetailFooterCreateOrCancelButtonTapped(topicDetailFooterView.topicDetailFooterCreateOrCancelButton)
                                self.topicDetailOptionDataFetch()
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
    }
}

extension TopicDetailViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        /*let test = self.rankOptionCollectionView.visibleCells[0].superview?.superview
        print("####SuperView is :\(test)####")*/

        spreadTransition.startFrame = self.startFrameForspreadTransition!
        return spreadTransition
    }
}




