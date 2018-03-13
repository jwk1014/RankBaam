//
//  PhotoLibraryAuthManager.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 8..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos

protocol PhotoLibraryAuthManagerDelegate: class {
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

class PhotoLibraryAuthManager {
  private weak var delegate: PhotoLibraryAuthManagerDelegate?
  
  var deniedAlertMessage = "사진 앨범에 접근하기 위해서 권한을 허용해주세요."
  var restrictedAlertMessage = "사진 앨범에 접근할 수 없습니다."
  
  init(delegate: PhotoLibraryAuthManagerDelegate){
    self.delegate = delegate
  }
  
  func requestPhotoLibraryAuthorization( status: PHAuthorizationStatus? = nil, requestAuth: Bool = true, closure: @escaping ()->Void ) {
    
    switch status ?? PHPhotoLibrary.authorizationStatus() {
      
    case .notDetermined:
      if requestAuth {
        PHPhotoLibrary.requestAuthorization{
          self.requestPhotoLibraryAuthorization(status: $0, requestAuth: false, closure: closure)
        }
      } else {
        assertionFailure("requestPhotoLibraryAuthorization requestAuth")
      }
      
    case .authorized:
      closure()
      
    case .denied:
      let alert = UIAlertController(title: nil, message: deniedAlertMessage, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "설정", style: .default){ _ in
        if let settingUrl = URL(string: UIApplicationOpenSettingsURLString) {
          UIApplication.shared.open(settingUrl)
        }
      })
      alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
      delegate?.present(alert, animated: true, completion: nil)
      
    case .restricted:
      let alert = UIAlertController(title: nil, message: restrictedAlertMessage, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
      delegate?.present(alert, animated: true, completion: nil)
    }
  }
}


