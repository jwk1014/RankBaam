//
//  TabSearchViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 10..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TabSearchViewController: UIViewController {

    @IBOutlet weak var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchResultTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barStyle = .blackOpaque
        searchController.searchBar.searchBarStyle = .prominent
        searchResultTableView.register(UINib.init(nibName: "MainRankCell", bundle: nil), forCellReuseIdentifier: "RankSearchResultCell")
        
        
        /*let searchBarWrapperView = UIView(frame: CGRect(x: 0, y: 30, width:
            view.frame.width, height: 44))
        searchBarWrapperView.backgroundColor = UIColor.black
        self.view.addSubview(searchBarWrapperView)*/
        


        // Do any additional setup after loading the view.
    }

}

extension TabSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankSearchResultCell", for: indexPath)
        
        return cell
    }
    
    
    
}
