//
//  SignInViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    var signInBackgroundScrollView: UIScrollView = {
        let signInBackgroundScrollView = UIScrollView()
        return signInBackgroundScrollView
    }()
    
    var signInBackgroundScrollViewContentsView: UIView = {
        let signInBackgroundScrollViewContentsView = UIView()
        return signInBackgroundScrollViewContentsView
    }()
    
    var signInDismissButtonImageView: UIImageView = {
        let signInDismissButtonImageView = UIImageView()
        return signInDismissButtonImageView
    }()
    
    var signInDismissButton: UIButton = {
        let signInDismissButton = UIButton()
        return signInDismissButton
    }()
    
    var signInLogoImageview: UIImageView = {
        let signInLogoImageview = UIImageView()
        return signInLogoImageview
    }()
    
    var signInEmailTextField: UITextField = {
        let signInEmailTextField = UITextField()
        return signInEmailTextField
    }()
    
    var signInPasswordTextField: UITextField = {
        let signInPasswordTextField = UITextField()
        return signInPasswordTextField
    }()
    
    var signInLoginButton: UIButton = {
        let signInLoginButton = UIButton()
        return signInLoginButton
    }()
    
    var signInFaceBookLoginButton: UIButton = {
        let signInFaceBookLoginButton = UIButton()
        return signInFaceBookLoginButton
    }()
    
    var signInKakaoLoginButton: UIButton = {
        let signInKakaoLoginButton = UIButton()
        return signInKakaoLoginButton
    }()
    
    var signInGoogleLoginButton: UIButton = {
        let signInGoogleLoginButton = UIButton()
        return signInGoogleLoginButton
    }()
    
    var signInNaverLoginButton: UIButton = {
        let signInNaverLoginButton = UIButton()
        return signInNaverLoginButton
    }()
    
    var signInBottomStackView: UIStackView = {
        let signInBottomStackView = UIStackView()
        return signInBottomStackView
    }()
    
    var signInFindPasswordTextLabel: UILabel = {
        let signInFindPasswordTextLabel = UILabel()
        return signInFindPasswordTextLabel
    }()
    
    var signInBottomStackviewSeparatorView: UIView = {
        let signInBottomStackviewSeparatorView = UIView()
        return signInBottomStackviewSeparatorView
    }()
    
    var signInSignUpTextLabel: UILabel = {
        let signInSignUpTextLabel = UILabel()
        return signInSignUpTextLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        NotificationCenter.default.addObserver(self, selector: #selector(signInKeyboardShowUpHandler(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signInKeyboardGoesDownHandler(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc fileprivate func signInKeyboardShowUpHandler(notification: Notification) {
        guard let notificationInfo = notification.userInfo,
              let keyboardFrame = notificationInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        signInBackgroundScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
    }
    
    @objc fileprivate func signInKeyboardGoesDownHandler(notification: Notification) {
        signInBackgroundScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func viewInitConfigure() {
        
        self.view.addSubview(signInBackgroundScrollView)
        signInBackgroundScrollView.addSubview(signInBackgroundScrollViewContentsView)
        signInBackgroundScrollViewContentsView.addSubview(signInLogoImageview)
        signInBackgroundScrollViewContentsView.addSubview(signInEmailTextField)
        signInBackgroundScrollViewContentsView.addSubview(signInPasswordTextField)
        signInBackgroundScrollViewContentsView.addSubview(signInLoginButton)
        signInBackgroundScrollViewContentsView.addSubview(signInFaceBookLoginButton)
        signInBackgroundScrollViewContentsView.addSubview(signInKakaoLoginButton)
        signInBackgroundScrollViewContentsView.addSubview(signInGoogleLoginButton)
        signInBackgroundScrollViewContentsView.addSubview(signInNaverLoginButton)
        signInBackgroundScrollViewContentsView.addSubview(signInBottomStackView)
        signInBackgroundScrollViewContentsView.addSubview(signInDismissButtonImageView)
        signInBackgroundScrollViewContentsView.addSubview(signInDismissButton)
        signInBottomStackView.addArrangedSubview(signInFindPasswordTextLabel)
        signInBottomStackView.addArrangedSubview(signInBottomStackviewSeparatorView)
        signInBottomStackView.addArrangedSubview(signInSignUpTextLabel)
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.backgroundColor = UIColor.white
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldResignedWithBackgroundTapping))
        self.view.addGestureRecognizer(tapGesture)
        signInLogoImageview.image = UIImage(named: "logoIcn")?.withRenderingMode(.alwaysTemplate)
        signInLogoImageview.tintColor = UIColor.rankbaamOrange
        signInEmailTextField.layer.cornerRadius = 3
        signInEmailTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        signInEmailTextField.layer.borderWidth = 1
        guard let nanumSquareBFont = UIFont(name: "NanumSquareB", size: 14) else { return }
        var attributedPlaceholer = NSAttributedString(string: "이메일", attributes: [NSAttributedStringKey.font : nanumSquareBFont, NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray ])
        signInEmailTextField.attributedPlaceholder = attributedPlaceholer
        signInEmailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: signInEmailTextField.frame.height))
        signInEmailTextField.leftViewMode = .always
        signInEmailTextField.backgroundColor = UIColor.white
        signInPasswordTextField.layer.cornerRadius = 3
        signInPasswordTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        signInPasswordTextField.layer.borderWidth = 1
        signInPasswordTextField.backgroundColor = UIColor.white
        attributedPlaceholer = NSAttributedString(string: "비밀번호", attributes: [NSAttributedStringKey.font : nanumSquareBFont, NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray ])
        signInPasswordTextField.attributedPlaceholder = attributedPlaceholer
        signInPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: signInEmailTextField.frame.height))
        signInPasswordTextField.leftViewMode = .always
        signInLoginButton.backgroundColor = UIColor.rankbaamOrange
        signInLoginButton.layer.cornerRadius = 3
        signInLoginButton.setTitle("로그인", for: .normal)
        signInLoginButton.setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
        signInLoginButton.titleLabel?.font = nanumSquareBFont
        signInFaceBookLoginButton.setBackgroundImage(UIImage(named: "facebookIcn"), for: .normal)
        signInFaceBookLoginButton.setTitle("페이스북으로 로그인", for: .normal)
        signInFaceBookLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        signInFaceBookLoginButton.titleLabel?.font = UIFont(name: "NanumSquareB", size: width375(14))
        signInFaceBookLoginButton.setTitleColor(UIColor.white, for: .normal)
        signInKakaoLoginButton.setBackgroundImage(UIImage(named: "kakaoIcn"), for: .normal)
        signInKakaoLoginButton.setTitle("카카오톡으로 로그인", for: .normal)
        signInKakaoLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        signInKakaoLoginButton.titleLabel?.font = UIFont(name: "NanumSquareB", size: width375(14))
        signInKakaoLoginButton.setTitleColor(UIColor.init(r: 80, g: 81, b: 53), for: .normal)
        signInGoogleLoginButton.setBackgroundImage(UIImage(named: "googleIcn"), for: .normal)
        signInGoogleLoginButton.setTitle("구글로 로그인", for: .normal)
        signInGoogleLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        signInGoogleLoginButton.titleLabel?.font = UIFont(name: "NanumSquareB", size: width375(14))
        signInGoogleLoginButton.setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
        signInNaverLoginButton.setBackgroundImage(UIImage(named: "naverIcn"), for: .normal)
        signInNaverLoginButton.setTitle("네이버로 로그인", for: .normal)
        signInNaverLoginButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        signInNaverLoginButton.titleLabel?.font = UIFont(name: "NanumSquareB", size: width375(14))
        signInNaverLoginButton.setTitleColor(UIColor.white, for: .normal)
        signInFindPasswordTextLabel.text = "비밀번호 찾기"
        signInFindPasswordTextLabel.textColor = UIColor(r: 134, g: 134, b: 134)
        signInFindPasswordTextLabel.font = UIFont(name: "NanumSquareB", size: width375(14))
        signInBottomStackviewSeparatorView.backgroundColor = UIColor(r: 134, g: 134, b: 134)
        signInBottomStackviewSeparatorView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        signInSignUpTextLabel.text = "이메일로 회원가입"
        signInSignUpTextLabel.textColor = UIColor(r: 134, g: 134, b: 134)
        signInSignUpTextLabel.font = UIFont(name: "NanumSquareB", size: width375(14))
        signInBottomStackView.axis = .horizontal
        signInBottomStackView.distribution = .fillProportionally
        signInBottomStackView.alignment = .fill
        signInBottomStackView.spacing = 14
        signInDismissButtonImageView.image = UIImage(named: "ic_clear")
        signInDismissButtonImageView.contentMode = .center
        signInDismissButton.backgroundColor = UIColor.clear
        signInDismissButton.addTarget(self, action: #selector(signInDismissButtonTapped(_:)), for: .touchUpInside)
        signInSignUpTextLabel.isUserInteractionEnabled = true
        let signUpTapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpButtonTapped))
        signInSignUpTextLabel.addGestureRecognizer(signUpTapGesture)
        
        
        signInBackgroundScrollView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        signInBackgroundScrollViewContentsView.snp.makeConstraints {
            $0.top.left.equalToSuperview()
            $0.height.width.equalTo(self.view)
        }
        
        signInLogoImageview.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(height667(122, forX: 145))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(width375(191))
            $0.height.equalTo(height667(31))
        }
        
        signInEmailTextField.snp.makeConstraints {
            $0.top.equalTo(signInLogoImageview.snp.bottom).offset(height667(91))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        signInPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(signInEmailTextField.snp.bottom).offset(height667(13))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        signInLoginButton.snp.makeConstraints {
            $0.top.equalTo(signInPasswordTextField.snp.bottom).offset(height667(16))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        signInFaceBookLoginButton.snp.makeConstraints {
            $0.top.equalTo(signInLoginButton.snp.bottom).offset(height667(50))
            $0.left.equalTo(self.view).offset(width375(16))
            $0.width.equalTo(width375(166))
            $0.height.equalTo(height667(46))
        }
        
        signInKakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(signInLoginButton.snp.bottom).offset(height667(50))
            $0.left.equalTo(signInFaceBookLoginButton.snp.right).offset(width375(11))
            $0.width.equalTo(width375(166))
            $0.height.equalTo(height667(46))
        }
        
        signInGoogleLoginButton.snp.makeConstraints {
            $0.top.equalTo(signInFaceBookLoginButton.snp.bottom).offset(height667(13))
            $0.left.equalTo(self.view).offset(width375(16))
            $0.width.equalTo(width375(166))
            $0.height.equalTo(height667(46))
        }
        
        signInNaverLoginButton.snp.makeConstraints {
            $0.top.equalTo(signInKakaoLoginButton.snp.bottom).offset(height667(13))
            $0.left.equalTo(signInGoogleLoginButton.snp.right).offset(width375(11))
            $0.width.equalTo(width375(166))
            $0.height.equalTo(height667(46))
        }
        
        signInBottomStackView.snp.makeConstraints {
            $0.top.equalTo(signInNaverLoginButton.snp.bottom).offset(height667(38))
            $0.centerX.equalToSuperview()
            //$0.width.equalTo(width375(217))
            $0.height.equalTo(height667(18))
        }
        
        signInDismissButtonImageView.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(height667(35, forX: 58))
            $0.right.equalTo(self.view).offset(-width375(16))
            $0.width.height.equalTo(width375(24))
        }
        signInDismissButton.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(height667(22, forX: 45))
            $0.right.equalTo(self.view)
            $0.width.height.equalTo(width375(45))
            
        }
        
    }
    
    @objc fileprivate func textFieldResignedWithBackgroundTapping() {
        if signInPasswordTextField.isFirstResponder || signInEmailTextField.isFirstResponder {
            signInPasswordTextField.resignFirstResponder()
            signInEmailTextField.resignFirstResponder()
        }
    }
    
    @objc func signInDismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc func emailSignInButtonTapped(_ sender: UIButton) {
        //SignData(email: <#T##String#>, identification: <#T##String#>)
        // TODO: FIXME
    }
    
    @objc func facebookSignInButtonTapped(_ sender: UIButton) {
        // TODO: FIXME
    }
    
    @objc func googleSignInButtonTapped(_ sender: UIButton) {
        // TODO: FIXME
    }
    
    @objc func kakaoSignInButtonTapped(_ sender: UIButton) {
        // TODO: FIXME
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
