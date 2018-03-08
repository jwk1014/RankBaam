//
//  SplashViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    var splashLogoImageView: UIImageView = {
        let splashLogoImageView = UIImageView()
        return splashLogoImageView
    }()
    
    var splashTitleLabel: UILabel = {
        let splashTitleLabel = UILabel()
        return splashTitleLabel
    }()
    
    fileprivate func viewInitConfigure() {
        self.view.backgroundColor = UIColor.rankbaamOrange
        self.view.addSubview(splashLogoImageView)
        self.view.addSubview(splashTitleLabel)
        
        splashLogoImageView.image = UIImage(named: "group")
        splashLogoImageView.contentMode = .center
        splashTitleLabel.text = "세상의 모든 랭킹"
        splashTitleLabel.font = UIFont(name: "NanumSquareB", size: 14)
        splashTitleLabel.textColor = UIColor.white
        splashTitleLabel.textAlignment = .center
        
        splashLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view).offset(height667(268, forX: 291))
            $0.width.equalTo(width375(85))
            $0.height.equalTo(height667(87, forX: 87))
        }
        
        splashTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(splashLogoImageView.snp.bottom).offset(height667(14))
            $0.width.equalTo(width375(152))
            $0.height.equalTo(height667(31))
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.animate(withDuration: 1, delay: 0, animations: {
                self.view.backgroundColor = UIColor.white
                self.splashTitleLabel.text = "Rank Baam"
                self.splashTitleLabel.font = UIFont(name: "NanumSquareB", size: 28)
                self.splashTitleLabel.textColor = UIColor.rankbaamOrange
            }, completion: nil)        
        }
        
        
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
