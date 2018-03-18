//
//  TabHomeWeeklyRankViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 20..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabHomeWeeklyRankViewController: UIViewController {

    var weeklyRankDatas: [Topic] = []
    
    var tabHomeWeeklyRankCollectionView: UICollectionView = {
        let coverFlowlayout = CoverFlowLayout()
        coverFlowlayout.scrollDirection = .horizontal
        let tabHomeWeeklyRankCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: coverFlowlayout)
        return tabHomeWeeklyRankCollectionView
    }()
    
    var tabHomeWeeklyRankCollectionViewCustomNumberPageControl: UILabel = {
        let tabHomeWeeklyRankCollectionViewCustomNumberPageControl = UILabel()
        return tabHomeWeeklyRankCollectionViewCustomNumberPageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        fetchWeeklyRankDatas()
        tabHomeWeeklyRankCollectionViewConfigure()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let firstIndex = IndexPath(item: 0, section: 0)
        if tabHomeWeeklyRankCollectionView.indexPathsForVisibleItems.contains(firstIndex),
            tabHomeWeeklyRankCollectionView.contentOffset.x == 0 {
            let firstRank = tabHomeWeeklyRankCollectionView
                .cellForItem(at: firstIndex) as! MainWeeklyRankCell
            firstRank.isTimerValid = true
        }
    }
    
    func fetchWeeklyRankDatas() {
        
        TopicService.weekList(page: 1, count: 10) {
            switch $0.result {
            case .success(let result):
                if result.succ {
                    guard let topicDatas = result.topics else {return}
                    self.weeklyRankDatas = topicDatas
                    print("This is WeeklyLike List Count : \(self.weeklyRankDatas.count)")
                    self.tabHomeWeeklyRankCollectionView.reloadData()
                } else if let msg = result.msg {
                    
                    
                    switch msg {
                    default:
                        break
                    }
                }
            case .failure(let error): break
            }
        }
        
    }
    
    fileprivate func tabHomeWeeklyRankCollectionViewConfigure() {
        tabHomeWeeklyRankCollectionView.dataSource = self
        tabHomeWeeklyRankCollectionView.delegate = self
        // tabHomeWeeklyRankCollectionView.isPagingEnabled = true
        tabHomeWeeklyRankCollectionView.showsHorizontalScrollIndicator = false
        tabHomeWeeklyRankCollectionView.register(MainWeeklyRankCell.self, forCellWithReuseIdentifier: "MainWeeklyRankCell")
        tabHomeWeeklyRankCollectionView.backgroundColor = UIColor.rankbaamGray
        tabHomeWeeklyRankCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)

    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(tabHomeWeeklyRankCollectionView)
        self.view.addSubview(tabHomeWeeklyRankCollectionViewCustomNumberPageControl)
        tabHomeWeeklyRankCollectionViewCustomNumberPageControl.text = "1 / 10"
        tabHomeWeeklyRankCollectionViewCustomNumberPageControl.textColor =  UIColor.rankbaamDarkgray
        tabHomeWeeklyRankCollectionViewCustomNumberPageControl.textAlignment = .right
        tabHomeWeeklyRankCollectionViewCustomNumberPageControl.font = UIFont(name: "NanumSquareB", size: 13)
        
        
        tabHomeWeeklyRankCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(height667(103, forX: 125))
        }
        tabHomeWeeklyRankCollectionViewCustomNumberPageControl
            .snp.makeConstraints {
            let standardHeight =
                    Constants.screenHeight == 812 ? 1010 : Constants.screenHeight
            $0.right.equalTo(self.view.snp.right)
                .offset(-(Constants.screenWidth * (61 / 375)))
            $0.bottom.equalTo(self.view.snp.bottom)
                .offset(-(standardHeight * (70 / 667)))
            $0.width.equalTo(Constants.screenWidth * (70 / 375))
            $0.height.equalTo(Constants.screenHeight * (15 / 667))
        }
    }

}

extension TabHomeWeeklyRankViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weeklyRankDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let weeklyRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainWeeklyRankCell", for: indexPath) as! MainWeeklyRankCell
        let cellData = self.weeklyRankDatas[indexPath.item]
        weeklyRankCell.mainWeeklyRankCellDatasConfigure(with: cellData)
        return weeklyRankCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension TabHomeWeeklyRankViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Constants.screenHeight == 812 {
            return CGSize(width:collectionView.bounds.size.width * 0.7 * ( 258 / 375 ), height: 625 * 0.7 * ( 406 / 564 ))
        }
        return CGSize(width:collectionView.bounds.size.width * 0.7 * ( 258 / 375 ), height: collectionView.bounds.size.height * 0.7 * ( 406 / 564 ))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = (collectionView.bounds.size.width - collectionView.bounds.size.width * 0.7 * ( 258 / 375 ))/2
        
        return UIEdgeInsets(top: 0, left:sideInset , bottom: 0, right: sideInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! MainWeeklyRankCell
        selectedCell.isTimerValid = false
        let topicDetailViewController = TopicDetailViewController()
        topicDetailViewController.delegate = self
        let topicSN = weeklyRankDatas[indexPath.item].topicSN
        topicDetailViewController.topicSN = topicSN
        navigationController?.pushViewController(topicDetailViewController, animated: true)
    }
    
}

extension TabHomeWeeklyRankViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber: Int = Int(scrollView.contentOffset.x / (self.view.frame.width / 2))
        print("\(pageNumber)")
        self.tabHomeWeeklyRankCollectionViewCustomNumberPageControl.text =
                "\(pageNumber + 1) / 10"
        /*if pageNumber == 0 {
            timerControl(isOn: true, scrollView: scrollView)
        }*/
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timerControl(isOn: false, scrollView: scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        timerControl(isOn: true, scrollView: scrollView)
    }
    func timerControl(isOn state: Bool, scrollView: UIScrollView) {
        let pageNumber: Int = Int(scrollView.contentOffset.x / (self.view.frame.width / 2))
        let indexPath = IndexPath(item: pageNumber, section: 0)
        let recentCell = tabHomeWeeklyRankCollectionView.cellForItem(at: indexPath) as! MainWeeklyRankCell
        recentCell.isTimerValid = state
    }
}

extension TabHomeWeeklyRankViewController: TopicDetailViewControllerDelegate {
    func tabHomeWeeklyRankCellTimerRestartHander() {
        let centerCells = self.tabHomeWeeklyRankCollectionView.visibleCells.filter { cell -> Bool in
            return Int(cell.frame.width) > Int(Constants.screenWidth * 0.7 * ( 258 / 375 ))
        }
        guard let centerCell = centerCells.first as? MainWeeklyRankCell else { return }
        centerCell.isTimerValid = true
    }
}
