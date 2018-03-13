//
//  SignUpViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var signUpBottomStackViewHeightConstraint: NSLayoutConstraint?
    let stackViewHeight = "stackViewHeight"
    
    var signUpBackgroundScrollView: UIScrollView = {
        let signUpBackgroundScrollView = UIScrollView()
        return signUpBackgroundScrollView
    }()
    
    var signUpBackgroundScrollViewContentsView: UIView = {
        let signUpBackgroundScrollViewContentsView = UIView()
        return signUpBackgroundScrollViewContentsView
    }()
    
    var signUpCustomNavigationBar: UIView = {
        let signUpCustomNavigationBar = UIView()
        return signUpCustomNavigationBar
    }()
    
    var signUpCustomNavigationBarTitleLabel: UILabel = {
        let signUpCustomNavigationBarTitleLabel = UILabel()
        return signUpCustomNavigationBarTitleLabel
    }()
    
    var signUpCustomNavigationBarBackImageView: UIImageView = {
        let signUpCustomNavigationBarBackImageView = UIImageView()
        return signUpCustomNavigationBarBackImageView
    }()
    
    var signUpCustomNavigationBarBackButton: UIButton = {
        let signUpCustomNavigationBarBackButton = UIButton()
        return signUpCustomNavigationBarBackButton
    }()
    
    var signUpCustomNavigationBarSeperatorView: UIView = {
        let signUpCustomNavigationBarSeperatorView = UIView()
        return signUpCustomNavigationBarSeperatorView
    }()
    
    var signUpEmailIdentificationComleteLabel: UILabel = {
        let signUpEmailIdentificationComleteLabel = UILabel()
        return signUpEmailIdentificationComleteLabel
    }()
    
    var signUpNicknameTextLabel: UILabel = {
        let signUpNicknameTextLabel = UILabel()
        return signUpNicknameTextLabel
    }()
    
    var signUpNicknameTextField: UITextField = {
        let signUpNicknameTextField = UITextField()
        return signUpNicknameTextField
    }()
    
    var signUpEmailTextLabel: UILabel = {
        let signUpEmailTextLabel = UILabel()
        return signUpEmailTextLabel
    }()
    
    var signUpEmailTextField: UITextField = {
        let signUpEmailTextField = UITextField()
        return signUpEmailTextField
    }()
    
    var signUpSubmissionStackView: UIStackView = {
        let signUpSubmissionStackView = UIStackView()
        signUpSubmissionStackView.axis = .vertical
        return signUpSubmissionStackView
    }()
    
    var signUpSubmissionInnerStackView: UIStackView = {
        let signUpSubmissionInnerStackView = UIStackView()
        signUpSubmissionInnerStackView.axis = .vertical
        return signUpSubmissionInnerStackView
    }()
    
    var signUpPasswordTextLabel: UILabel = {
        let signUpPasswordTextLabel = UILabel()
        return signUpPasswordTextLabel
    }()
    
    var signUpPasswordTextField: UITextField = {
        let signUpPasswordTextField = UITextField()
        return signUpPasswordTextField
    }()
    
    var signUpPasswordConfirmTextField: UITextField = {
        let signUpPasswordConfirmTextField = UITextField()
        return signUpPasswordConfirmTextField
    }()
    
    var signUpSummitButton: UIButton = {
        let signUpSummitButton = UIButton()
        return signUpSummitButton
    }()
    
    var signUpLoadingIndicator: UIActivityIndicatorView  = {
        let signUpLoadingIndicator = UIActivityIndicatorView()
        signUpLoadingIndicator.stopAnimating()
        return signUpLoadingIndicator
    }()
    
    var signUpStackViewHeightConstraint: NSLayoutConstraint?
    
    typealias CheckModel = (emptyMsg: String, regex: String?, regexMsg: String)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        self.navigationController?.isNavigationBarHidden = true
        signUpEmailTextField.delegate = self
        signUpPasswordTextField.delegate = self
        
        signUpSummitButton.addTarget(self, action: #selector(signUpSubmitButtonTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpKeyboardShowUpHandler(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signUpKeyboardGoesDownHandler(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func signUpKeyboardShowUpHandler(notification: Notification) {
        guard let notificationInfo = notification.userInfo,
            let keyboardFrame = notificationInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        print("\(keyboardFrame.height)")
        /*keyboardFrame.contains(CGPoint(x: signUpSummitButton.frame.origin.x + signUpSummitButton.frame.width / 2, y: signUpSummitButton.frame.origin.y + signUpSummitButton.frame.height / 2))*/
        //signUpBackgroundScrollView.contentInset = UIEdgeInsets(top: -keyboardFrame.height, left: 0, bottom: 0, right: 0)
        
        /*let intersectionFrame = keyboardFrame.intersection(signUpSubmissionStackView.frame)
        signUpBackgroundScrollView.contentInset = UIEdgeInsets(top: -intersectionFrame.height, left: 0, bottom: 0, right: 0)*/
        var intersectionFrame = signUpPasswordConfirmTextField.convert(signUpPasswordConfirmTextField.bounds, to: signUpBackgroundScrollViewContentsView)
        signUpBackgroundScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        if keyboardFrame.intersects(signUpPasswordConfirmTextField.convert(signUpPasswordConfirmTextField.frame, to: signUpBackgroundScrollViewContentsView)), (signUpPasswordTextField.isFirstResponder || signUpPasswordConfirmTextField.isFirstResponder) {
            //signUpBackgroundScrollView.contentSize.height += intersectionFrame.height
            //signUpBackgroundScrollView.contentOffset = CGPoint(x: signUpBackgroundScrollView.contentOffset.x, y: intersectionFrame.height)
            intersectionFrame.size.height += 10
            self.signUpBackgroundScrollView.scrollRectToVisible(intersectionFrame, animated: false)
            /*var point = CGPoint(x: 0, y: intersectionFrame.origin.y + intersectionFrame.height)
            point.y -= signUpBackgroundScrollView.frame.height - keyboardFrame.height
            signUpBackgroundScrollView.setContentOffset(point, animated: true)*/
        }
    }
    
    @objc fileprivate func signUpKeyboardGoesDownHandler(notification: Notification) {
        guard let notificationInfo = notification.userInfo,
            let keyboardFrame = notificationInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        print("\(keyboardFrame.height)")
        signUpBackgroundScrollView.contentInset.bottom = 0
        
    }
    
    
    
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(signUpBackgroundScrollView)
        self.view.addSubview(signUpCustomNavigationBar)
        self.view.addSubview(signUpCustomNavigationBarSeperatorView)
        signUpCustomNavigationBar.addSubview(signUpCustomNavigationBarBackImageView)
        signUpCustomNavigationBar.addSubview(signUpCustomNavigationBarBackButton)
        signUpCustomNavigationBar.addSubview(signUpCustomNavigationBarTitleLabel)
        signUpBackgroundScrollView.addSubview(signUpBackgroundScrollViewContentsView)
        signUpBackgroundScrollViewContentsView.addSubview(signUpEmailIdentificationComleteLabel)
        signUpBackgroundScrollViewContentsView.addSubview(signUpSubmissionStackView)
        signUpEmailIdentificationComleteLabel.addSubview(signUpNicknameTextLabel)
        signUpEmailIdentificationComleteLabel.addSubview(signUpNicknameTextField)
        signUpEmailIdentificationComleteLabel.addSubview(signUpEmailTextLabel)
        signUpEmailIdentificationComleteLabel.addSubview(signUpEmailTextField)
        signUpSubmissionStackView.addArrangedSubview(signUpSubmissionInnerStackView)
        signUpSubmissionStackView.addArrangedSubview(signUpSummitButton)
        signUpSubmissionInnerStackView.addArrangedSubview(signUpPasswordTextLabel)
        signUpSubmissionInnerStackView.addArrangedSubview(signUpPasswordTextField)
        signUpSubmissionInnerStackView.addArrangedSubview(signUpPasswordConfirmTextField)
        signUpBackgroundScrollViewContentsView.addSubview(signUpLoadingIndicator)
        
        signUpLoadingIndicator.activityIndicatorViewStyle  = .gray
        self.view.backgroundColor = UIColor.white
        /*signUpBackgroundScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - height667(78, forX: 101))*/
        signUpCustomNavigationBarTitleLabel.text = "회원가입"
        signUpCustomNavigationBarTitleLabel.textColor = UIColor.rankbaamDeepBlack
        signUpCustomNavigationBarTitleLabel.font = UIFont(name: "NanumSquareB", size: 16)
        signUpCustomNavigationBarBackImageView.image = UIImage(named: "back")
        signUpCustomNavigationBarBackImageView.contentMode = .scaleAspectFit
        signUpCustomNavigationBarBackImageView.tintColor = UIColor.rankbaamDeepBlack
        signUpCustomNavigationBarBackButton.addTarget(self, action: #selector(signUpBackButtonTapped(sender:)), for: .touchUpInside)
        signUpCustomNavigationBarSeperatorView.backgroundColor = UIColor.rankbaamSeperatorColor
        signUpEmailIdentificationComleteLabel.isUserInteractionEnabled = true
        signUpEmailIdentificationComleteLabel.numberOfLines = 0
        signUpEmailIdentificationComleteLabel.textAlignment = .center
        //signUpEmailIdentificationComleteLabel.text = "해당 이메일로 인증 메일이 전송되었습니다"
        signUpNicknameTextLabel.text = "닉네임"
        signUpNicknameTextLabel.textColor = UIColor.rankbaamDeepBlack
        signUpNicknameTextLabel.font = UIFont(name: "NanumSquareB", size: 16)
        var attributedPlaceholder = NSAttributedString(string: "3자리 이상 한글, 영문 또는 숫자", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        signUpNicknameTextField.attributedPlaceholder = attributedPlaceholder
        signUpNicknameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: signUpNicknameTextField.frame.height))
        signUpNicknameTextField.leftViewMode = .always
        signUpNicknameTextField.layer.borderWidth = 1
        signUpNicknameTextField.layer.cornerRadius = 3
        signUpNicknameTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        signUpEmailTextLabel.text = "이메일"
        signUpEmailTextLabel.textColor = UIColor.rankbaamDeepBlack
        signUpEmailTextLabel.font = UIFont(name: "NanumSquareB", size: 16)
        signUpEmailTextField.layer.borderWidth = 1
        signUpEmailTextField.layer.cornerRadius = 3
        signUpEmailTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        attributedPlaceholder = NSAttributedString(string: "가입 가능한 이메일 계정을 확인하세요", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        signUpEmailTextField.attributedPlaceholder = attributedPlaceholder
        signUpEmailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: signUpNicknameTextField.frame.height))
        signUpEmailTextField.leftViewMode = .always
        signUpPasswordTextLabel.text = "비밀번호"
        attributedPlaceholder = NSAttributedString(string: "8자리 이상 영문 또는 숫자", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        signUpPasswordTextField.attributedPlaceholder = attributedPlaceholder
        signUpPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: signUpNicknameTextField.frame.height))
        signUpPasswordTextField.leftViewMode = .always
        signUpPasswordTextField.layer.borderWidth = 1
        signUpPasswordTextField.layer.cornerRadius = 3
        signUpPasswordTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        attributedPlaceholder = NSAttributedString(string: "비밀번호 확인", attributes: [NSAttributedStringKey.foregroundColor : UIColor.rankbaamDarkgray, NSAttributedStringKey.font : UIFont(name: "NanumSquareB", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)])
        signUpPasswordConfirmTextField.attributedPlaceholder = attributedPlaceholder
        signUpPasswordConfirmTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: signUpNicknameTextField.frame.height))
        signUpPasswordConfirmTextField.leftViewMode = .always
        signUpPasswordConfirmTextField.layer.borderWidth = 1
        signUpPasswordConfirmTextField.layer.cornerRadius = 3
        signUpPasswordConfirmTextField.layer.borderColor = UIColor(r: 216, g: 216, b: 216).cgColor
        signUpSummitButton.backgroundColor = UIColor.rankbaamOrange
        signUpSummitButton.layer.cornerRadius = 3
        signUpSummitButton.setTitle("이메일 인증", for: .normal)
        signUpSummitButton.setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
        signUpLoadingIndicator.isHidden = true
        
        
        signUpCustomNavigationBar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(height667(76, forX: 99))
        }
        
        signUpCustomNavigationBarBackImageView.snp.makeConstraints {
            $0.top.equalTo(signUpCustomNavigationBar).offset(height667(42, forX: 65))
            $0.left.equalTo(signUpCustomNavigationBar).offset(width375(16))
            $0.width.height.equalTo(width375(24))
        }
        
        signUpCustomNavigationBarBackButton.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(width375(56))
        }
        
        signUpCustomNavigationBarTitleLabel.snp.makeConstraints {
            $0.left.equalTo(signUpCustomNavigationBarBackButton.snp.right)
            $0.top.equalTo(height667(45, forX: 68))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(65))
        }
        
        signUpCustomNavigationBarSeperatorView.snp.makeConstraints {
            $0.top.equalTo(signUpCustomNavigationBar.snp.bottom)
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(height667(2))
        }
        
        signUpBackgroundScrollView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(signUpCustomNavigationBarSeperatorView.snp.bottom)
        }
        
        signUpBackgroundScrollViewContentsView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(self.view)
            $0.height.equalTo(self.view.frame.height - height667(76))
            
            //$0.height.equalTo(Constants.screenHeight - height667(78, forX: 101))
        }
        
        signUpEmailIdentificationComleteLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(height667(236))
        }
        
        signUpNicknameTextLabel.snp.makeConstraints {
            $0.top.equalTo(signUpEmailIdentificationComleteLabel).offset(height667(16))
            $0.left.equalTo(signUpEmailIdentificationComleteLabel).offset(width375(16))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(50))
        }
        
        signUpNicknameTextField.snp.makeConstraints {
            $0.top.equalTo(signUpNicknameTextLabel.snp.bottom).offset(height667(13))
            $0.centerX.equalTo(signUpEmailIdentificationComleteLabel)
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        signUpEmailTextLabel.snp.makeConstraints {
            $0.top.equalTo(signUpNicknameTextField.snp.bottom).offset(height667(33))
            $0.left.equalTo(signUpEmailIdentificationComleteLabel).offset(width375(16))
            $0.height.equalTo(height667(18))
            $0.width.equalTo(width375(50))
        }
        
        signUpEmailTextField.snp.makeConstraints {
            $0.top.equalTo(signUpEmailTextLabel.snp.bottom).offset(height667(13))
            $0.centerX.equalTo(signUpEmailIdentificationComleteLabel)
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        
        /*let bottomLine = CALayer()
        bottomLine.frame = CGRect.init(x: 0, y: signUpCustomNavigationBar.frame.height, width: signUpCustomNavigationBar.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.black.cgColor
        signUpCustomNavigationBar.layer.addSublayer(bottomLine)*/
        
//        signUpSubmissionStackView.snp.makeConstraints {
//               $0.top.equalTo(signUpEmailIdentificationComleteLabel.snp.bottom).constraint
//            $0.centerX.equalTo(signUpBackgroundScrollViewContentsView)
//            $0.width.equalTo(width375(343))
//            $0.height.equalTo(height667(206))
//        }
        

        signUpSubmissionStackView.translatesAutoresizingMaskIntoConstraints = false
        signUpSubmissionStackView.centerXAnchor.constraint(equalTo: signUpBackgroundScrollViewContentsView.centerXAnchor).isActive = true
        signUpSubmissionStackView.topAnchor.constraint(equalTo: signUpEmailIdentificationComleteLabel.bottomAnchor).isActive = true
        signUpSubmissionStackView.widthAnchor.constraint(equalToConstant: width375(343)).isActive = true
        let heightCon = signUpSubmissionStackView.heightAnchor.constraint(equalToConstant: height667(206))
        heightCon.identifier = stackViewHeight
        heightCon.isActive = true

        signUpBottomStackViewHeightConstraint = heightCon
//        signUpLoadingIndicator.snp.makeConstraints {
//            $0.top.left.right.bottom.equalToSuperview()
//        }
        
        //signUpSubmissionStackView.heightAnchor.constraint(equalToConstant: height667(206))
        
        signUpSubmissionStackView.distribution = .equalSpacing
        signUpSubmissionStackView.spacing = height667(24)
        //signUpSubmissionInnerStackView.heightAnchor.constraint(equalToConstant: height667(110)).isActive = true
        signUpSubmissionInnerStackView.distribution = .equalSpacing
        signUpSubmissionInnerStackView.spacing = height667(13)
        signUpPasswordTextLabel.heightAnchor.constraint(equalToConstant: height667(18)).isActive = true
        signUpPasswordTextField.heightAnchor.constraint(equalToConstant: height667(46)).isActive = true
        signUpPasswordConfirmTextField.heightAnchor.constraint(equalToConstant: height667(46)).isActive = true
        signUpSummitButton.heightAnchor.constraint(equalToConstant: height667(46)).isActive = true
        
    }
    
    @objc fileprivate func signUpBackButtonTapped(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if ( checkField(textField) ) {
            if( textField == signUpEmailTextField ) {
                signUpPasswordTextField.becomeFirstResponder()
            } else {
                signUpSubmitButtonTapped(signUpSummitButton)
            }
        }
        return true
    }
    
    func getCheckModel(textField: UITextField) -> CheckModel? {
        switch textField {
        case signUpEmailTextField:
            return (
                emptyMsg: "이메일를 입력해주세요",
                regex: "[0-9a-zA-Z_\\-]+@[0-9a-zA-Z_\\-]+(\\.[0-9a-zA-Z_\\-]+){1,2}",
                regexMsg: "아이디는 영소문자,숫자 8자이상입니다"
            )
        case signUpPasswordTextField:
            return (
                emptyMsg: "비밀번호를 입력해주세요",
                regex: "(?=.*[a-zA-Z])(?=.*[0-9]).{9,16}",
                regexMsg: "비밀번호는 영문,숫자 조합 9자이상입니다(특수문자가능)"
            )
        default: fatalError("getCheckModel")
        }
    }
    
    func checkField(_ textField: UITextField, alertCompleteClosure: ((UIAlertAction)->Void)? = nil) -> Bool {
        guard let checkModel = getCheckModel(textField: textField) else {return false}
        
        if textField.isEmpty {
            UIAlertController.alert(target: self, msg: checkModel.emptyMsg, actionClosure: alertCompleteClosure)
            return false
        } else if let regex = checkModel.regex, textField.text?.isMatch(regex: regex) ?? false {
            UIAlertController.alert(target: self, msg: checkModel.regexMsg, actionClosure: alertCompleteClosure)
            return false
        }
        return true
    }
    
    @objc func signUpSubmitButtonTapped(_ sender: UIButton ) {
        
        for (index, item) in self.signUpEmailIdentificationComleteLabel.subviews.enumerated() {
            print("""
                This is index : \(index)
                This is Item : \(item)
                """
            )
            self.signUpSubmissionInnerStackView.isHidden = true
            
            UIView.animate(withDuration: 0.1, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                item.transform = CGAffineTransform(translationX: 0, y: 20)
            }, completion: { (isCompleted) in
                UIView.animate(withDuration: 0.6, animations: {
                    /*let test = self.signUpSubmissionStackView.constraints.filter({
                     guard let string = $0.identifier else { return false }
                     return string == "stackViewHeight"
                     })
                     print("This is test Count : \(test.count)")*/
                    NSLayoutConstraint.deactivate([self.signUpBottomStackViewHeightConstraint!])
                    let height = self.signUpSubmissionInnerStackView.heightAnchor.constraint(equalToConstant: 50)
                    height.isActive = true
                    
                    item.transform = CGAffineTransform(translationX: 0, y: -250)
                    //item.isHidden = true
                    self.signUpSubmissionStackView.distribution = .equalCentering
                    self.signUpEmailIdentificationComleteLabel.text = """
                    \(self.signUpEmailTextField.text!)로
                    인증 메일을 전송하였습니다.
                    
                    """
                    self.signUpSubmissionStackView.layoutIfNeeded()
                })
            })
        }
        
        /*
        guard ( checkField(signUpEmailTextField) { _ in
            self.signUpEmailTextField.becomeFirstResponder()
        } ) else {return}
        
        guard ( checkField(signUpPasswordTextField) { _ in
            self.signUpPasswordTextField.becomeFirstResponder()
        } ) else {return}
      
        UserService.singin(signData: SignData(email: signUpEmailTextField.text!, identification: signUpPasswordTextField.text!)) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    
                    
                    UIAlertController.alert(target: self, msg: "성공적으로 가입요청되었습니다.\n입력하신 이메일로 인증메일이 전송되었습니다.\n인증 후 로그인 해주세요.") { _ in
                        self.dismiss(animated: true, completion: {
                            
                        })
                    }
                } else if let msg = sResult.msg {
                    switch msg {
                    case "AlreadyJoinEmail":
                        UIAlertController.alert(target: self, msg: "이미 가입된 이메일입니다.", actionClosure: nil)
                    default:
                        break
                    }
                }
                
            case .failure(let error):
                if let error = error as? SolutionProcessableProtocol {
                    error.handle(self)
                } else {
                    
                }
            }
        }*/
    }
    
    func validateDomainCheck(email: String) -> Bool {
        
        if let index = email.index(of: "@") {
            let emailDomain = String(email[ email.index(index, offsetBy: 1)... ])
            // let emailDomain = email.components(separatedBy: "@")[1]
            return UserService.EMAIL_DOMAINS.contains(emailDomain)
        }
        return false
    }
}


