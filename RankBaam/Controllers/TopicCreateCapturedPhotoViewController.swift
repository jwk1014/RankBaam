//
//  TopicCreateCapturedPhotoViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 20..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TopicCreateCapturedPhotoViewController: UIViewController {

    var capturedPhoto: UIImage?
    private weak var tabMyViewResetPasswordCustomNavigationBar: UIView?
    
    var topicCreateCapturedPhotoImageView: UIImageView = {
       let topicCreateCapturedPhotoImageView = UIImageView()
       return topicCreateCapturedPhotoImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white
        let tabMyViewResetPasswordCustomNavigationBar = UIView()
        
        
        self.view.addSubview(topicCreateCapturedPhotoImageView)
        topicCreateCapturedPhotoImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(self.view)
        }
        
        guard let capturedPhoto = capturedPhoto else { return }
        topicCreateCapturedPhotoImageView.image = capturedPhoto
    }
}
