//
//  TabSearchRankViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 1..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TabSearchRankViewController: UIViewController {

    var tabSearchCustomNavigationBar: UIView = {
        let tabSearchCustomNavigationBar = UIView()
        return tabSearchCustomNavigationBar
    }()
    
    var tabSearchRankCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let tabSearchRankCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowlayout)
        return tabSearchRankCollectionView
    }()
    
    var tabSearchCustomNavigationBarTitleLabel: UILabel = {
        let tabSearchCustomNavigationBarTitleLabel = UILabel()
        return tabSearchCustomNavigationBarTitleLabel
    }()
    
    var tabSearchCustomSearchBar: UITextField = {
        let tabSearchCustomSearchBar = UITextField()
        return tabSearchCustomSearchBar
    }()
    
    private weak var tabSearchRankSearchKeywordView: SearchRankSearchKeywordView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        tabSearchRankSearchKeywordViewConfigure()
        self.navigationController?.isNavigationBarHidden = true
      
      
    }

    fileprivate func viewInitConfigure() {
        self.view.addSubview(tabSearchRankCollectionView)
        self.view.addSubview(tabSearchCustomNavigationBar)
        tabSearchCustomNavigationBar
            .addSubview(tabSearchCustomNavigationBarTitleLabel)
        tabSearchCustomNavigationBar
            .addSubview(tabSearchCustomSearchBar)
        
        tabSearchCustomNavigationBar.backgroundColor = UIColor.white
        tabSearchCustomNavigationBar.layer.shadowRadius = 7
        tabSearchCustomNavigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        tabSearchCustomNavigationBar.layer.shadowOpacity = 0.7
        tabSearchCustomNavigationBar.layer.shadowOffset =
            CGSize(width: 0, height: 12)
        tabSearchCustomNavigationBar.layer.masksToBounds = false
        
        tabSearchCustomNavigationBar.backgroundColor = UIColor.white
        tabSearchRankCollectionView.backgroundColor = UIColor.rankbaamGray
        tabSearchCustomNavigationBarTitleLabel.text = "RANK BAAM"
        tabSearchCustomNavigationBarTitleLabel.textColor = UIColor.rankbaamOrange
        tabSearchCustomNavigationBarTitleLabel.textAlignment = .center
        tabSearchCustomNavigationBarTitleLabel.font = UIFont.boldSystemFont(ofSize: Constants.screenWidth * (18 / 375))
        tabSearchCustomSearchBar.borderStyle = .none
        tabSearchCustomSearchBar.layer.borderColor = UIColor.rankbaamOrange.cgColor
        tabSearchCustomSearchBar.layer.borderWidth = 1
        tabSearchCustomSearchBar.layer.cornerRadius = 3
        tabSearchCustomSearchBar.leftViewMode = .always
        tabSearchCustomSearchBar.delegate = self
        let attributedPlaceHolder = NSMutableAttributedString(string: "세상의 모든 랭킹을 검색하세요!")
        attributedPlaceHolder.addAttributes([.foregroundColor : UIColor.rankbaamOrange], range: NSRange(location: 0, length: 9))
        attributedPlaceHolder.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: Constants.screenHeight * (16 / 667)), range: NSRange(location: 0, length: attributedPlaceHolder.length))
        
        tabSearchCustomSearchBar.attributedPlaceholder = attributedPlaceHolder
        let searchMark = UIImageView(image: UIImage(named: "search_icn_n"))
        if let size = searchMark.image?.size {
            searchMark.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 24.0, height: size.height)
        }
        searchMark.contentMode = UIViewContentMode.center
        tabSearchCustomSearchBar.leftView = searchMark
        tabSearchCustomSearchBar.tintColor = UIColor.rankbaamOrange
        tabSearchCustomSearchBar.clearButtonMode = .whileEditing
        tabSearchCustomSearchBar.addTarget(self, action: #selector(searchBarTextDidChanged(_:)), for: .editingChanged)
        tabSearchCustomSearchBar.backgroundColor = UIColor.white
        
        tabSearchCustomNavigationBar.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(Constants.screenHeight * (132 / 667))
        }
        tabSearchRankCollectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Constants.screenHeight * (132 / 667))
        }
        tabSearchCustomNavigationBarTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(tabSearchCustomNavigationBar.snp.centerX)
            $0.top.equalTo(tabSearchCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (38 / 667))
            $0.width.equalTo(Constants.screenWidth * (120 / 375))
            $0.height.equalTo(Constants.screenHeight * (20 / 667))
        }
        tabSearchCustomSearchBar.snp.makeConstraints {
            $0.centerX.equalTo(tabSearchCustomNavigationBar.snp.centerX)
            $0.top.equalTo(tabSearchCustomNavigationBar.snp.top)
                .offset(Constants.screenHeight * (77 / 667))
            $0.width.equalTo(Constants.screenWidth * (343 / 375))
            $0.height.equalTo(Constants.screenHeight * (46 / 667))
        }
        
        
    }
    
    fileprivate func tabSearchRankSearchKeywordViewConfigure() {
        let tabSearchRankSearchKeywordView = SearchRankSearchKeywordView()
        self.tabSearchRankSearchKeywordView = tabSearchRankSearchKeywordView
        self.view.addSubview(tabSearchRankSearchKeywordView)
        tabSearchRankSearchKeywordView.backgroundColor = UIColor.rankbaamGray
        tabSearchRankSearchKeywordView.searchRankSearchKeywordTableView?.delegate = self
         tabSearchRankSearchKeywordView.searchRankSearchKeywordTableView?.dataSource = self
        tabSearchRankSearchKeywordView.snp.makeConstraints {
            $0.top.equalTo(tabSearchCustomNavigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        tabSearchRankSearchKeywordView.searchRankSearchKeywordTableView?
            .register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
         tabSearchRankSearchKeywordView.searchRankSearchKeywordTableView?
            .register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewHeaderFooterView.self))
       
        
        
    }
    
    @objc fileprivate func searchBarTextDidChanged(_ sender: UITextField) {
        if let textInput = sender.text, !textInput.isEmpty {
            UIView.animate(withDuration: 0.4, animations: {
                self.tabSearchCustomNavigationBar.backgroundColor = UIColor.rankbaamOrange
                self.tabSearchCustomNavigationBarTitleLabel.textColor = UIColor.white
            })
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.tabSearchCustomNavigationBar.backgroundColor = UIColor.white
                self.tabSearchCustomNavigationBarTitleLabel.textColor = UIColor.rankbaamOrange
            })
        }
    }
}

extension TabSearchRankViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, animations: {
            self.tabSearchCustomNavigationBar.backgroundColor = UIColor.rankbaamOrange
            self.tabSearchCustomNavigationBarTitleLabel.textColor = UIColor.white
            self.tabSearchRankSearchKeywordView?
                .searchRankSearchKeywordTableViewHeight?.constant = height667(70) + (height667(50) * 5)
            self.tabSearchRankSearchKeywordView?.layoutIfNeeded()
            
        })
        return true
    }
    
}

extension TabSearchRankViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchKeywordCell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        searchKeywordCell.backgroundColor = UIColor.rankbaamGray
        searchKeywordCell.textLabel?.text = "1. 인기검색어"
        searchKeywordCell.textLabel?.font = UIFont(name: "NanumSquareB", size: width375(14))
        searchKeywordCell.selectionStyle = .none
        searchKeywordCell.textLabel?.textColor = UIColor.rankbaamDeepBlack
        return searchKeywordCell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewHeaderFooterView.self))
        let searchKeywordHeader = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewHeaderFooterView.self))
        searchKeywordHeader?.textLabel?.text = "인기검색어"
        searchKeywordHeader?.textLabel?.font = UIFont(name: "NanumSquareB", size: width375(14))
        searchKeywordHeader?.textLabel?.textColor = UIColor.rankbaamDeepBlack
        searchKeywordHeader?.backgroundColor = UIColor.rankbaamGray
        return searchKeywordHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return height667(70)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height667(50)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
}
