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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviLargeTitle()
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        mainTableView.register(UINib.init(nibName: "MainHotRankCell", bundle: nil), forCellReuseIdentifier: "MainHotRankCell")
//        mainTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    fileprivate func configureNaviLargeTitle() {
        navigationController?.navigationBar.topItem?.title = "Rank Baam"
        
        if #available(iOS 11.0, *) {
            let titleAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.red,
                NSAttributedStringKey.font:
                    UIFont.boldSystemFont(ofSize: 30),
                ]
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        }
    }
}


extension TabHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainHotRankCell", for: indexPath)
            return cell
            
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        } else {
            return 100
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return 10
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
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 100
        }
    }
}

