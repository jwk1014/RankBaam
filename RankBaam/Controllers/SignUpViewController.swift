//
//  SignUpViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var identificationTextField: UITextField!
    @IBOutlet weak var identificationConfirmTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    typealias CheckModel = (emptyMsg: String, regex: String?, regexMsg: String)

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        identificationTextField.delegate = self
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if ( checkField(textField) ) {
            if( textField == emailTextField ) {
                identificationTextField.becomeFirstResponder()
            } else {
                submitButtonTapped(submitButton)
            }
        }
        return true
    }
    
    func getCheckModel(textField: UITextField) -> CheckModel? {
        switch textField {
        case emailTextField:
            return (
                emptyMsg: "이메일를 입력해주세요",
                regex: "[0-9a-zA-Z_\\-]+@[0-9a-zA-Z_\\-]+(\\.[0-9a-zA-Z_\\-]+){1,2}",
                regexMsg: "아이디는 영소문자,숫자 8자이상입니다"
            )
        case identificationTextField:
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
    
    @objc func submitButtonTapped(_ sender: UIButton ) {
        guard ( checkField(emailTextField) { _ in
            self.emailTextField.becomeFirstResponder()
        } ) else {return}
        
        guard ( checkField(identificationTextField) { _ in
            self.identificationTextField.becomeFirstResponder()
        } ) else {return}
      
        UserService.singin(signData: SignData(email: emailTextField.text!, identification: identificationTextField.text!)) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    UIAlertController.alert(target: self, msg: "성공적으로 가입요청되었습니다.\n입력하신 이메일로 인증메일이 전송되었습니다.\n인증 후 로그인 해주세요.") { _ in
                        self.dismiss(animated: true, completion: nil)
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
        }
    }
    
    func validateDomainCheck(email: String) -> Bool {
        
        if let index = email.index(of: "@") {
            let emailDomain = String(email[ email.index(index, offsetBy: 1)... ])
            //let emailDomain = email.components(separatedBy: "@")[1]
            return UserService.EMAIL_DOMAINS.contains(emailDomain)
        }
        return false
    }

}


