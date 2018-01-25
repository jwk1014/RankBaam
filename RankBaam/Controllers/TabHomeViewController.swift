//
//  TabHomeViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 10..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabHomeViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    var loadThreshold: Int = 6
    var mainRankCellDatas = [Topic]()
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviLargeTitle()
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        mainTableView.register(UINib.init(nibName: "MainHotRankCell", bundle: nil), forCellReuseIdentifier: "MainHotRankCell")
        mainTableView.register(UINib.init(nibName: "MainArrangedRankHeader", bundle: nil), forCellReuseIdentifier: "MainArrangedRankHeader")
        mainTableView.register(UINib.init(nibName: "loadIndicatorFooter", bundle: nil), forCellReuseIdentifier: "loadIndicatorFooter")
        mainTableView.register(UINib.init(nibName: "MainRankCell", bundle: nil), forCellReuseIdentifier: "MainRankCell")
        loadMainRankCellDatas()
//        mainTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
    }
    fileprivate func configureNaviLargeTitle() {
        navigationController?.navigationBar.topItem?.title = "Rank Baam"
        
        navigationController?.navigationBar.topItem?.titleView?.tintColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            let titleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            
            let largeTitleAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font:
                    UIFont.boldSystemFont(ofSize: 30),
                ]
            navigationController?.navigationBar.titleTextAttributes = titleAttributes
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        }
    }
}


extension TabHomeViewController: UITableViewDelegate, UITableViewDataSource, MainHotRankCollectionCellDetailDelege {
    
    func mainHotRankCollectionCellTapped() {
        let topicDetailViewCon = TopicDetailViewController()
        topicDetailViewCon.topicSN = 20
        present(topicDetailViewCon, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainHotRankCell", for: indexPath) as! MainHotRankCell
            cell.delegate = self
            
            return cell
            
        } else {
        let mainRankCell = tableView.dequeueReusableCell(withIdentifier: "MainRankCell", for: indexPath) as! MainRankCell
        mainRankCell.topicTitleLabel.text = self.mainRankCellDatas[indexPath.row].title
        mainRankCell.likeNumberLabel.text = "\(self.mainRankCellDatas[indexPath.row].likeCount)"
       
        return mainRankCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        } else {
            return 80
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return self.mainRankCellDatas.count
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
//            header?.backgroundColor = UIColor.clear
//            return header
//
//        } else {
//            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
//            header?.backgroundColor = UIColor.brown
//            return header
//        }
       let header = tableView.dequeueReusableCell(withIdentifier: "MainArrangedRankHeader")
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        } else {
        let footer = tableView.dequeueReusableCell(withIdentifier: "loadIndicatorFooter")
        return footer
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topicDetailViewCon = TopicDetailViewController()
        topicDetailViewCon.topicSN = self.mainRankCellDatas[indexPath.row].topicSN
        present(topicDetailViewCon, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ( indexPath.row > mainRankCellDatas.count - loadThreshold ) {
            // self.mainTableView.reloadData()
        }
    }
    
}

extension TabHomeViewController {
    
    func loadMainRankCellDatas() {
        
        TopicService.list(page: page, count: 15, categorySN: 1, order: .best) {
            switch $0.result {
            case .success(let result):
                if result.succ {
                    guard let topicDatas = result.topics else {return}
                    self.mainRankCellDatas += topicDatas
                    self.page += 1
                    self.mainTableView.reloadData()
                } else if let msg = result.msg {
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

