//
//  SplashViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import Photos

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          TopicService.categoryList{
            if let resultCategoryList = $0.value {
              categories = resultCategoryList.categories
            }
            //if let signData = SignManager.keychain {
            let signDataTemp = SignData(email: "fgfg4514@naver.com", identification: "test1234")
            UserService.singin(signData: signDataTemp) {
                
                        switch($0.result) {
                            
                        case .success(let sResult):
                            if sResult.succ {
                                
                                
                                let vc = MainTabViewController()
                                let naviVC = UINavigationController(rootViewController: vc)

                                self.present(naviVC, animated: true, completion: nil)
                            } else if let msg = sResult.msg {
                                switch msg {
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
                    /*
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
                    }*/
            /*} else {
                let vc = TopicListViewController()
                let naviVC = UINavigationController(rootViewController: vc)
                self.present(naviVC, animated: true, completion: nil)
            }*/
        }
      }
    }
}
