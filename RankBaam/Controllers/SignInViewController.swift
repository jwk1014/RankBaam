//
//  SignInViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var kakaoSignInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        emailSignInButton.addTarget(self, action: #selector(emailSignInButtonTapped), for: .touchUpInside)
        facebookSignInButton.addTarget(self, action: #selector(facebookSignInButtonTapped), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)
        kakaoSignInButton.addTarget(self, action: #selector(kakaoSignInButtonTapped), for: .touchUpInside)
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
