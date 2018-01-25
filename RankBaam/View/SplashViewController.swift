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
    
    let testVCClosure: () -> Void = {
      let vc = MainTabViewController()
      self.present(vc, animated: true, completion: nil)
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      //if let signForm = SignManager.keychain {
      let signDataTemp = SignData(email: "fgfg4514@naver.com", identification: "test1234")
      UserService.singin(signData: signDataTemp) {
        switch($0.result) {
        case .success(let sResult):
          if sResult.succ {
            testVCClosure()
          }
        default:
          print("splash login fail")
        }
      }
    }
    
  }
}
