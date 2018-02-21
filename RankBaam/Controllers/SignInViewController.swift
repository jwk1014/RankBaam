//
//  SignInViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    var signInLogoImageview: UIImageView = {
        let signInLogoImageview = UIImageView()
        return signInLogoImageview
    }()
    
    var signInEmailTextField: UITextField = {
        let signInEmailTextField = UITextField()
        return signInEmailTextField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(signInLogoImageview)
        self.view.backgroundColor = UIColor.white
        
        signInLogoImageview.image = UIImage(named: "logoIcn")
        
        signInLogoImageview.snp.makeConstraints {
            $0.top.equalTo(self.view).offset(height667(122, forX: 145))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(width375(191))
            $0.height.equalTo(height667(36))
        }
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func signUpButtonTapped(_ sender: UIButton) {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func emailSignInButtonTapped(_ sender: UIButton) {
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
