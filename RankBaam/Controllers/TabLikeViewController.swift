//
//  TabLikeViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 10..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabLikeViewController: UIViewController {

    @IBOutlet weak var likeArchiveTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let likeTableHeaderView = MainArrangedRankHeader()
        //likeArchiveTable.tableHeaderView = MainArrangedRankHeader()
        likeArchiveTable.register(UINib.init(nibName: "MainRankCell", bundle: nil), forCellReuseIdentifier: "likeArchiveCell")
        likeArchiveTable.register(UINib.init(nibName: "MainArrangedRankHeader", bundle: nil), forCellReuseIdentifier: "MainArrangedRankHeader")
        

        
    }

}

extension TabLikeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "likeArchiveCell", for: indexPath)
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "MainArrangedRankHeader")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
