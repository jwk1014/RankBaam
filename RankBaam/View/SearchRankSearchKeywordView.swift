//
//  SearchRankSearchKeywordView.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 3. 13..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class SearchRankSearchKeywordView: UIView {

    private(set) weak var searchRankSearchKeywordTableView: UITableView?
    public var searchRankSearchKeywordTableViewHeight: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        let searchRankSearchKeywordTableView = UITableView()
        self.addSubview(searchRankSearchKeywordTableView)
        self.searchRankSearchKeywordTableView = searchRankSearchKeywordTableView
        searchRankSearchKeywordTableView.showsVerticalScrollIndicator = false
        searchRankSearchKeywordTableView.translatesAutoresizingMaskIntoConstraints = false
        searchRankSearchKeywordTableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchRankSearchKeywordTableView.backgroundColor = UIColor.rankbaamGray
        let leading = searchRankSearchKeywordTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        leading.constant = width375(22)
        let trailing = searchRankSearchKeywordTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        trailing.constant = width375(-22)
        let height = searchRankSearchKeywordTableView.heightAnchor.constraint(equalToConstant: 0)
        self.searchRankSearchKeywordTableViewHeight = height
        NSLayoutConstraint.activate([leading, trailing, height])
    }
}
