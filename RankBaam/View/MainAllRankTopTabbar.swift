//
//  MainAllRankTopTabbar.swift
//  0116#RankBaamMainCollectionProto
//
//  Created by 황재욱 on 2018. 1. 17..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit

protocol UpperCustomTabbarDelegate {
    func upperCustomTabbarTapped(sender: UIButton)
}

class MainAllRankTopTabbar: UIView {
    
    var selectedUnderBarLeadingConstraint: NSLayoutConstraint?
    var delegate: UpperCustomTabbarDelegate?
    
    var allRankTab: UIButton = {
        let allranktab = UIButton()
        allranktab.backgroundColor = UIColor.white
        allranktab.tag = 0
        return allranktab
    }()
    
    var weeklyRankTab: UIButton = {
        let weeklyranktab = UIButton()
        weeklyranktab.backgroundColor = UIColor.white
        weeklyranktab.tag = 1
        return weeklyranktab
    }()
    
    var mainRankUpperTabStackView: UIStackView = {
        let mainrankupperstack = UIStackView()
        return mainrankupperstack
    }()
    
    
    var isAllRankTabSelected: Bool = true {
        didSet{
            if isAllRankTabSelected {
                allRankTab.setTitleColor(UIColor.rankbaamOrange, for: .normal)
            } else {
                allRankTab.setTitleColor(UIColor.gray, for: .normal)
            }
        }
    }
    
    var isWeeklyRankTabSelected: Bool = false {
        didSet{
            if isWeeklyRankTabSelected {
                weeklyRankTab.setTitleColor(UIColor.rankbaamOrange, for: .normal)
            } else {
                weeklyRankTab.setTitleColor(UIColor.gray, for: .normal)
            }
        }
    }
    
    
    var selectedUnderBar: UIView = {
       let selectedunderbar = UIView()
       return selectedunderbar
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience init(frame: CGRect, leftTabTitle: String, rightTabTitle: String) {
        self.init(frame: frame)
        self.layer.shadowRadius = 7
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 12)
        self.layer.masksToBounds = false
        setupStackView(leftTabTitle, rightTabTitle)
    }
    
    
    func setupStackView(_ leftTabTitle: String?, _ rightTabTitle: String?) {
        
        self.addSubview(mainRankUpperTabStackView)
        
        weeklyRankTab.addTarget(self, action: #selector(upperBarSelected), for: .touchUpInside)
        allRankTab.addTarget(self, action: #selector(upperBarSelected), for: .touchUpInside)
        
        mainRankUpperTabStackView.translatesAutoresizingMaskIntoConstraints = false
        mainRankUpperTabStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainRankUpperTabStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainRankUpperTabStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainRankUpperTabStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mainRankUpperTabStackView.addArrangedSubview(allRankTab)
        
        allRankTab.setTitle(leftTabTitle, for: .normal)
        allRankTab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        allRankTab.contentHorizontalAlignment = .center
        allRankTab.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        allRankTab.setTitleColor(UIColor.rankbaamOrange, for: .normal)
        weeklyRankTab.setTitle(rightTabTitle, for: .normal)
        weeklyRankTab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        weeklyRankTab.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        weeklyRankTab.setTitleColor(UIColor.gray, for: .normal)
        mainRankUpperTabStackView.addArrangedSubview(weeklyRankTab)
        mainRankUpperTabStackView.distribution = .fillEqually
        mainRankUpperTabStackView.backgroundColor = UIColor.green
        self.addSubview(selectedUnderBar)
        setupSelectedUnderBar()
    }
    
    @objc func upperBarSelected(_ sender: UIButton) {
        let constants = (self.frame.width / 2 * CGFloat(sender.tag) ) + CGFloat( width375(61))
        self.selectedUnderBarLeadingConstraint?.constant = constants
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        if sender == allRankTab {
            isAllRankTabSelected = true
            isWeeklyRankTabSelected = false
        } else {
            isWeeklyRankTabSelected = true
            isAllRankTabSelected = false
        }
        delegate?.upperCustomTabbarTapped(sender: sender)
        
    }
    
    func setupSelectedUnderBar() {
        selectedUnderBar.backgroundColor = UIColor.rankbaamOrange
        selectedUnderBar.translatesAutoresizingMaskIntoConstraints = false
        let leading = selectedUnderBar.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                            constant: width375(61))
        leading.isActive = true
        self.selectedUnderBarLeadingConstraint = leading
        selectedUnderBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            .isActive = true
        selectedUnderBar.widthAnchor.constraint(equalToConstant: width375(62))
            .isActive = true
        selectedUnderBar.heightAnchor.constraint(equalToConstant: height667(3))
            .isActive = true
    }
    
    
}
