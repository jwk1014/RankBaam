//
//  TabMyViewProfileResetNicknameViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 3. 11..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TabMyViewProfileResetNicknameViewController: UIViewController {

    private weak var tabMyViewResetNicknameCustomNavigationBar: UIView?
    private weak var tabMyViewResetNicknameBackImageView: UIImageView?
    private weak var tabMyViewResetNicknameBackButton: UIButton?
    private weak var tabMyViewResetNicknameNavigationBarTitleLabel: UILabel?
    private weak var tabMyViewResetNicknameNavigationBarSeperatorView: UIView?
    private weak var tabMyVieWResetNicknameLabel: UILabel?
    private weak var tabMyViewResetNicknameTextField: UITextField?
    private weak var tabMyViewResetNicknameCompleteButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()

        
    }
    
    fileprivate func viewInitConfigure() {
        self.view.backgroundColor = UIColor.white
        
        let tabMyViewResetNicknameCustomNavigationBar = UIView()
        self.tabMyViewResetNicknameCustomNavigationBar = tabMyViewResetNicknameCustomNavigationBar
        self.view.addSubview(tabMyViewResetNicknameCustomNavigationBar)
        tabMyViewResetNicknameCustomNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(height667(76, forX: 99))
        }
        
        let tabMyViewResetNicknameBackImageView = UIImageView()
        self.tabMyViewResetNicknameBackImageView = tabMyViewResetNicknameBackImageView
        tabMyViewResetNicknameBackImageView.image = UIImage(named: "back")
        tabMyViewResetNicknameBackImageView.contentMode = .scaleAspectFit
        tabMyViewResetNicknameBackImageView.tintColor = UIColor.rankbaamDeepBlack
        tabMyViewResetNicknameCustomNavigationBar
            .addSubview(tabMyViewResetNicknameBackImageView)
        tabMyViewResetNicknameBackImageView.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetNicknameCustomNavigationBar)
                .offset(height667(42, forX: 65))
            $0.left.equalTo(tabMyViewResetNicknameCustomNavigationBar)
                .offset(width375(16))
            $0.width.height.equalTo(width375(24))
        }
        
        let tabMyViewResetNicknameBackButton = UIButton()
        self.tabMyViewResetNicknameBackButton = tabMyViewResetNicknameBackButton
        tabMyViewResetNicknameCustomNavigationBar
            .addSubview(tabMyViewResetNicknameBackButton)
        tabMyViewResetNicknameBackButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(width375(56))
        }
        
        let tabMyViewResetNicknameNavigationBarSeperatorView = UIView()
        self.tabMyViewResetNicknameNavigationBarSeperatorView = tabMyViewResetNicknameNavigationBarSeperatorView
        self.view.addSubview(tabMyViewResetNicknameNavigationBarSeperatorView)
        tabMyViewResetNicknameNavigationBarSeperatorView.backgroundColor = UIColor.rankbaamSeperatorColor
        tabMyViewResetNicknameNavigationBarSeperatorView.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetNicknameCustomNavigationBar.snp.bottom)
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(height667(2))
        }
        
        let tabMyViewResetNicknameNavigationBarTitleLabel = UILabel()
        self.tabMyViewResetNicknameNavigationBarTitleLabel = tabMyViewResetNicknameNavigationBarTitleLabel
        tabMyViewResetNicknameCustomNavigationBar
            .addSubview(tabMyViewResetNicknameNavigationBarTitleLabel)
        tabMyViewResetNicknameNavigationBarTitleLabel.text = "닉네임 변경"
        tabMyViewResetNicknameNavigationBarTitleLabel.textColor = UIColor.rankbaamDeepBlack
        tabMyViewResetNicknameNavigationBarTitleLabel
            .font = UIFont(name: "NanumSquareB", size: 16)
        tabMyViewResetNicknameNavigationBarTitleLabel.snp.makeConstraints {
            $0.left.equalTo(tabMyViewResetNicknameBackButton.snp.right)
            $0.top.equalTo(height667(45, forX: 68))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(200))
        }
        
        let tabMyVieWResetNicknameLabel = UILabel()
        self.tabMyVieWResetNicknameLabel = tabMyVieWResetNicknameLabel
        self.view.addSubview(tabMyVieWResetNicknameLabel)
        tabMyVieWResetNicknameLabel.text = "닉네임"
        tabMyVieWResetNicknameLabel.textColor = UIColor.rankbaamDeepBlack
        tabMyVieWResetNicknameLabel.font = UIFont(name: "NanumSquareB", size: 16)
        tabMyVieWResetNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetNicknameNavigationBarSeperatorView.snp.bottom)
                .offset(height667(16))
            $0.left.equalTo(self.view)
                .offset(width375(16))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(50))
        }
        
        let tabMyViewResetNicknameTextField = UITextField()
        self.tabMyViewResetNicknameTextField = tabMyViewResetNicknameTextField
        self.view.addSubview(tabMyViewResetNicknameTextField)
        var attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        tabMyViewResetNicknameTextField.attributedPlaceholder = attributedPlaceholder
        tabMyViewResetNicknameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: tabMyViewResetNicknameTextField.frame.height))
        tabMyViewResetNicknameTextField.leftViewMode = .always
        tabMyViewResetNicknameTextField.layer.borderWidth = 1
        tabMyViewResetNicknameTextField.layer.cornerRadius = 3
        tabMyViewResetNicknameTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        tabMyViewResetNicknameTextField.snp.makeConstraints {
            $0.top.equalTo(tabMyVieWResetNicknameLabel.snp.bottom)
                .offset(height667(14))
            $0.left.equalTo(self.view).offset(width375(16))
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        let tabMyViewResetNicknameCompleteButton = UIButton()
        self.tabMyViewResetNicknameCompleteButton = tabMyViewResetNicknameCompleteButton
        self.view.addSubview(tabMyViewResetNicknameCompleteButton)
        tabMyViewResetNicknameCompleteButton.backgroundColor = UIColor.rankbaamOrange
        tabMyViewResetNicknameCompleteButton.setTitle("닉네임 변경", for: .normal)
        tabMyViewResetNicknameCompleteButton.titleLabel?.font = UIFont(name: "NanumSquareB", size: 16)
        tabMyViewResetNicknameCompleteButton.setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
        tabMyViewResetNicknameCompleteButton.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(height667(56))
        }
        
        tabMyViewResetNicknameBackButton.addTarget(self, action: #selector(tabMyViewResetNicknameBackButtonTapped), for: .touchUpInside)
        
        
    }
    
    @objc func tabMyViewResetNicknameBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
