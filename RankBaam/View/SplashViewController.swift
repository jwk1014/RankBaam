//
//  SplashViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //if let signForm = SignManager.keychain {
            let signformTemp = SignForm(email: "fgfg4514@naver.com", identification: "test1234")
                AlamofireManager.request(.SignIn(signForm: signformTemp))
                    .responseRankBaam { (error, errorClosure, result: SResult?, date) in
                        
                        if let errorClosure = errorClosure {
                            errorClosure(self)
                            return
                        }
                        
                        if let result = result {
                            if result.succ {
                                
                            } else {
                                switch result.msg {
                                default:
                                    break
                                }
                            }
                            let vc = TopicListViewController()
                            let naviVC = UINavigationController(rootViewController: vc)
                            self.present(naviVC, animated: true, completion: nil)
                        }
                    }
            /*} else {
                let vc = TopicListViewController()
                let naviVC = UINavigationController(rootViewController: vc)
                self.present(naviVC, animated: true, completion: nil)
            }*/
        }
        
    }

}
