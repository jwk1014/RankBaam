//
//  SplashViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

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
            $0.height.equalTo(height667(31))
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNetwork()
        viewInitConfigure()
      
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
          UIView.transition(with: self.splashTitleLabel, duration: 1, options: .transitionCrossDissolve, animations: {
            self.view.backgroundColor = UIColor.white
            self.splashTitleLabel.text = "Rank Baam"
            self.splashTitleLabel.font = UIFont(name: "NanumSquareB", size: 28)
            self.splashTitleLabel.textColor = UIColor.rankbaamOrange
          }, completion: { success in
            if success {
              self.loadCompletionSemaphore.wait()
              self.isAnimationComplete = true
              self.loadCompletionSemaphore.signal()
              self.complete()
            }
          })
        }
    }
  
    private func loadNetworkStep1TopicCategoryList(response: DataResponse<SResultCategoryList>) {
      switch(response.result) {
      case .success(let result):
        if result.succ {
          if let topicCategories = result.categories {
            categories = topicCategories
            
            if let signData = SignManager.keychain {
              UserService.singin(signData: signData, completion: loadNetworkStep2UserSignIn)
            } else {
              loadNetworkComplete()
            }
          } else {
            assertionFailure("categories is nil")
          }
        } else if let msg = result.msg {
          switch msg {
          default: assertionFailure(msg)
          }
        } else {
          assertionFailure("succ is false and msg is nil")
        }
      case .failure(_): break
      }
    }
  
    private func loadNetworkStep2UserSignIn(response: DataResponse<SResult>) {
      switch(response.result) {
      case .success(let result):
        if result.succ {
          loadNetworkComplete()
        } else if let msg = result.msg {
          switch msg {
          case "UserNotFound":
            loadNetworkComplete()
          case "UserNeedNickname":
            loadNetworkCompleteWithOutNickname()
          default: assertionFailure(msg)
          }
        } else {
          assertionFailure("succ is false and msg is null")
        }
      case .failure(_): break
      }
    }
  
    private func loadNetworkCompleteWithOutNickname() {
      fatalError("TODO")////TODO
    }
  
    private func loadNetworkComplete() {
      self.loadCompletionSemaphore.wait()
      self.completionClosure = {
        let vc = MainTabViewController()
        let naviVC = UINavigationController(rootViewController: vc)
        self.present(naviVC, animated: true, completion: nil)
      }
      self.loadCompletionSemaphore.signal()
      self.complete()
    }
  
    private func loadNetwork() {
      TopicService.categoryList(completion: loadNetworkStep1TopicCategoryList)
    }
  
    private var loadCompletionSemaphore = DispatchSemaphore(value: 1)
    private var isAnimationComplete = false
    private var completionClosure: (()->Void)?
  
    private func complete(){
      loadCompletionSemaphore.wait()
      if isAnimationComplete, let completionClosure = completionClosure {
        loadCompletionSemaphore.signal()
        completionClosure()
        return
      }
      loadCompletionSemaphore.signal()
    }
}
