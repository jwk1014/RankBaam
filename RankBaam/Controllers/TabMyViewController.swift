//
//  TabMyViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 10..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabMyViewController: UIViewController {

    @IBOutlet weak var myRankCommentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRankCommentTable.register(UINib.init(nibName: "MyRankTableHeader", bundle: nil), forCellReuseIdentifier: "MyRankTableHeader")
        myRankCommentTable.register(UINib.init(nibName: "MainRankCell", bundle: nil), forCellReuseIdentifier: "MainRankCell")
        
    }
}

extension TabMyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainRankCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "MyRankTableHeader")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

