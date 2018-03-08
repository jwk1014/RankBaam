//
//  TabMyViewProfileResetPasswordViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 3. 2..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TabMyViewProfileResetPasswordViewController: UIViewController {

    
    private weak var tabMyViewResetPasswordBackgroundScrollView: UIScrollView?
    private weak var tabMyViewResetPasswordScrollViewContentsView: UIView?
    private weak var tabMyViewResetPasswordCustomNavigationBar: UIView?
    private weak var tabMyViewResetPasswordBackImageView: UIImageView?
    private weak var tabMyViewResetPasswordBackButton: UIButton?
    private weak var tabMyViewResetPasswordNavigationBarTitleLabel: UILabel?
    private weak var tabMyViewResetPasswordNavigationBarSeperatorView: UIView?
    private weak var tabMyVieWResetPasswordEmailTitleLabel: UILabel?
    private weak var tabMyViewResetPasswordEmailLabel: UILabel?
    private weak var tabMyViewResetPasswordPasswordTitleLabel: UILabel?
    private weak var tabMyViewResetPasswordPresentPasswordTextField: UITextField?
    private weak var tabMyViewResetPasswordRenewedPasswordTextField: UITextField?
    private weak var tabMyViewResetPasswordConfirmPasswordTextField: UITextField?
    private weak var tabMyViewResetPasswordCompleteButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        
        
    }
    
    
    
    fileprivate func viewInitConfigure() {
        self.view.backgroundColor = UIColor.white
        self.view.isUserInteractionEnabled = true
        
        
        
        let tabMyViewResetPasswordCustomNavigationBar = UIView()
        self.tabMyViewResetPasswordCustomNavigationBar = tabMyViewResetPasswordCustomNavigationBar
        self.view.addSubview(tabMyViewResetPasswordCustomNavigationBar)
        tabMyViewResetPasswordCustomNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(height667(76, forX: 99))
        }
        
        let tabMyViewResetPasswordBackImageView = UIImageView()
        self.tabMyViewResetPasswordBackImageView = tabMyViewResetPasswordBackImageView
        tabMyViewResetPasswordBackImageView.image = UIImage(named: "back")
        tabMyViewResetPasswordBackImageView.contentMode = .scaleAspectFit
        tabMyViewResetPasswordBackImageView.tintColor = UIColor.rankbaamDeepBlack
        tabMyViewResetPasswordCustomNavigationBar
            .addSubview(tabMyViewResetPasswordBackImageView)
        tabMyViewResetPasswordBackImageView.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetPasswordCustomNavigationBar)
                .offset(height667(42, forX: 65))
            $0.left.equalTo(tabMyViewResetPasswordCustomNavigationBar)
                .offset(width375(16))
            $0.width.height.equalTo(width375(24))
        }
        
        let tabMyViewResetPasswordBackButton = UIButton()
        self.tabMyViewResetPasswordBackButton = tabMyViewResetPasswordBackButton
        tabMyViewResetPasswordCustomNavigationBar
            .addSubview(tabMyViewResetPasswordBackButton)
        tabMyViewResetPasswordBackButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(width375(56))
        }
       
        let tabMyViewResetPasswordNavigationBarSeperatorView = UIView()
        self.tabMyViewResetPasswordNavigationBarSeperatorView = tabMyViewResetPasswordNavigationBarSeperatorView
        self.view.addSubview(tabMyViewResetPasswordNavigationBarSeperatorView)
        tabMyViewResetPasswordNavigationBarSeperatorView.backgroundColor = UIColor.rankbaamSeperatorColor
        tabMyViewResetPasswordNavigationBarSeperatorView.snp.makeConstraints {
                $0.top.equalTo(tabMyViewResetPasswordCustomNavigationBar.snp.bottom)
                $0.width.centerX.equalToSuperview()
                $0.height.equalTo(height667(2))
        }
        
        let tabMyViewResetPasswordNavigationBarTitleLabel = UILabel()
        self.tabMyViewResetPasswordNavigationBarTitleLabel = tabMyViewResetPasswordNavigationBarTitleLabel
        tabMyViewResetPasswordCustomNavigationBar
            .addSubview(tabMyViewResetPasswordNavigationBarTitleLabel)
        tabMyViewResetPasswordNavigationBarTitleLabel.text = "비밀번호 변경"
        tabMyViewResetPasswordNavigationBarTitleLabel.textColor = UIColor.rankbaamDeepBlack
        tabMyViewResetPasswordNavigationBarTitleLabel
            .font = UIFont(name: "NanumSquareB", size: 16)
        tabMyViewResetPasswordNavigationBarTitleLabel.snp.makeConstraints {
            $0.left.equalTo(tabMyViewResetPasswordBackButton.snp.right)
            $0.top.equalTo(height667(45, forX: 68))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(200))
        }
        
        
        let tabMyViewResetPasswordBackgroundScrollView = UIScrollView()
        self.tabMyViewResetPasswordBackgroundScrollView = tabMyViewResetPasswordBackgroundScrollView
        tabMyViewResetPasswordBackgroundScrollView.isUserInteractionEnabled = true
        self.view.addSubview(tabMyViewResetPasswordBackgroundScrollView)
        tabMyViewResetPasswordBackgroundScrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(tabMyViewResetPasswordNavigationBarSeperatorView.snp.bottom)
        }
        
        let tabMyViewResetPasswordScrollViewContentsView = UIView()
        //tabMyViewResetPasswordScrollViewContentsView.clipsToBounds = true
        self.tabMyViewResetPasswordScrollViewContentsView = tabMyViewResetPasswordScrollViewContentsView
        tabMyViewResetPasswordBackgroundScrollView
            .addSubview(tabMyViewResetPasswordScrollViewContentsView)
        tabMyViewResetPasswordScrollViewContentsView.isUserInteractionEnabled = true
        tabMyViewResetPasswordScrollViewContentsView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(self.view)
            $0.height.equalTo(self.view.frame.height - height667(76))
        }
        
        let tabMyVieWResetPasswordEmailTitleLabel = UILabel()
        self.tabMyVieWResetPasswordEmailTitleLabel = tabMyVieWResetPasswordEmailTitleLabel
        tabMyViewResetPasswordScrollViewContentsView
            .addSubview(tabMyVieWResetPasswordEmailTitleLabel)
        tabMyVieWResetPasswordEmailTitleLabel.text = "이메일"
        tabMyVieWResetPasswordEmailTitleLabel.textColor = UIColor.rankbaamDeepBlack
        tabMyVieWResetPasswordEmailTitleLabel.font = UIFont(name: "NanumSquareB", size: 16)
        tabMyVieWResetPasswordEmailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetPasswordScrollViewContentsView)
                .offset(height667(16))
            $0.left.equalTo(self.view)
                .offset(width375(16))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(50))
        }
        
        let tabMyViewResetPasswordEmailLabel = UILabel()
        self.tabMyViewResetPasswordEmailLabel = tabMyViewResetPasswordEmailLabel
        tabMyViewResetPasswordScrollViewContentsView
            .addSubview(tabMyViewResetPasswordEmailLabel)
        tabMyViewResetPasswordEmailLabel.text = "emailAddress@rankbaam.com"
        tabMyViewResetPasswordEmailLabel.textColor = UIColor.rankbaamDeepBlack
        tabMyViewResetPasswordEmailLabel.font = UIFont(name: "NanumSquareB", size: 14)
        tabMyViewResetPasswordEmailLabel.snp.makeConstraints {
            $0.top.equalTo(tabMyVieWResetPasswordEmailTitleLabel.snp.bottom)
                .offset(height667(28))
            $0.left.equalTo(tabMyViewResetPasswordNavigationBarSeperatorView)
                .offset(width375(16))
            $0.height.equalTo(height667(16))
            $0.width.equalTo(width375(343))
        }
        
        let tabMyViewResetPasswordPasswordTitleLabel = UILabel()
        self.tabMyViewResetPasswordPasswordTitleLabel = tabMyViewResetPasswordPasswordTitleLabel
        tabMyViewResetPasswordScrollViewContentsView
            .addSubview(tabMyViewResetPasswordPasswordTitleLabel)
        tabMyViewResetPasswordPasswordTitleLabel.text = "비밀번호"
        tabMyViewResetPasswordPasswordTitleLabel.textColor = UIColor.rankbaamDeepBlack
        tabMyViewResetPasswordPasswordTitleLabel.font = UIFont(name: "NanumSquareB", size: 16)
        tabMyViewResetPasswordPasswordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetPasswordEmailLabel.snp.bottom)
                .offset(height667(48))
            $0.left.equalTo(tabMyViewResetPasswordNavigationBarSeperatorView)
                .offset(width375(16))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(200))
        }
        
        let tabMyViewResetPasswordPresentPasswordTextField = UITextField()
        self.tabMyViewResetPasswordPresentPasswordTextField = tabMyViewResetPasswordPresentPasswordTextField
        tabMyViewResetPasswordScrollViewContentsView
            .addSubview(tabMyViewResetPasswordPresentPasswordTextField)
        var attributedPlaceholder = NSAttributedString(string: "현재 비밀번호", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        tabMyViewResetPasswordPresentPasswordTextField.attributedPlaceholder = attributedPlaceholder
        tabMyViewResetPasswordPresentPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: tabMyViewResetPasswordPresentPasswordTextField.frame.height))
        tabMyViewResetPasswordPresentPasswordTextField.leftViewMode = .always
        tabMyViewResetPasswordPresentPasswordTextField.layer.borderWidth = 1
        tabMyViewResetPasswordPresentPasswordTextField.layer.cornerRadius = 3
        tabMyViewResetPasswordPresentPasswordTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        tabMyViewResetPasswordPresentPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetPasswordPasswordTitleLabel.snp.bottom)
                .offset(height667(14))
            $0.left.equalTo(self.view).offset(width375(16))
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        
        let tabMyViewResetPasswordRenewedPasswordTextField = UITextField()
        self.tabMyViewResetPasswordRenewedPasswordTextField = tabMyViewResetPasswordRenewedPasswordTextField
        tabMyViewResetPasswordScrollViewContentsView
            .addSubview(tabMyViewResetPasswordRenewedPasswordTextField)
        attributedPlaceholder = NSAttributedString(string: "새로운 비밀번호 ( 8자리 이상 영문자, 숫자 )", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        tabMyViewResetPasswordRenewedPasswordTextField.attributedPlaceholder = attributedPlaceholder
        tabMyViewResetPasswordRenewedPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: tabMyViewResetPasswordPresentPasswordTextField.frame.height))
        tabMyViewResetPasswordRenewedPasswordTextField.leftViewMode = .always
        tabMyViewResetPasswordRenewedPasswordTextField.layer.borderWidth = 1
        tabMyViewResetPasswordRenewedPasswordTextField.layer.cornerRadius = 3
        tabMyViewResetPasswordRenewedPasswordTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        tabMyViewResetPasswordRenewedPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetPasswordPresentPasswordTextField.snp.bottom)
                .offset(height667(14))
            $0.left.equalTo(self.view).offset(width375(16))
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        let tabMyViewResetPasswordConfirmPasswordTextField = UITextField()
        self.tabMyViewResetPasswordConfirmPasswordTextField = tabMyViewResetPasswordConfirmPasswordTextField
        tabMyViewResetPasswordScrollViewContentsView
            .addSubview(tabMyViewResetPasswordConfirmPasswordTextField)
        attributedPlaceholder = NSAttributedString(string: "비밀번호 확인", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        tabMyViewResetPasswordConfirmPasswordTextField.attributedPlaceholder = attributedPlaceholder
        tabMyViewResetPasswordConfirmPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: tabMyViewResetPasswordConfirmPasswordTextField.frame.height))
        tabMyViewResetPasswordConfirmPasswordTextField.leftViewMode = .always
        tabMyViewResetPasswordConfirmPasswordTextField.layer.borderWidth = 1
        tabMyViewResetPasswordConfirmPasswordTextField.layer.cornerRadius = 3
        tabMyViewResetPasswordConfirmPasswordTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        tabMyViewResetPasswordConfirmPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(tabMyViewResetPasswordRenewedPasswordTextField.snp.bottom)
                .offset(height667(14))
            $0.left.equalTo(self.view).offset(width375(16))
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        let tabMyViewResetPasswordCompleteButton = UIButton()
        self.tabMyViewResetPasswordCompleteButton = tabMyViewResetPasswordCompleteButton
        self.view.addSubview(tabMyViewResetPasswordCompleteButton)
        tabMyViewResetPasswordCompleteButton.backgroundColor = UIColor.rankbaamOrange
        tabMyViewResetPasswordCompleteButton.setTitle("비밀번호 변경", for: .normal)
        tabMyViewResetPasswordCompleteButton.titleLabel?.font = UIFont(name: "NanumSquareB", size: 16)
        tabMyViewResetPasswordCompleteButton.setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
        tabMyViewResetPasswordCompleteButton.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(height667(56))
        }
        
        tabMyViewResetPasswordCompleteButton.addTarget(self, action: #selector(tabMyViewResetPasswordButtonTapped), for: .touchUpInside)
        tabMyViewResetPasswordBackButton.addTarget(self, action: #selector(tabMyViewResetPasswordBackButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func tabMyViewResetPasswordButtonTapped() {
        
        //TODO:
        
    }
    
    @objc func tabMyViewResetPasswordBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
