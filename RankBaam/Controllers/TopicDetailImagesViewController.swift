//
//  TopicDetailImagesViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 24..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit

class TopicDetailImagesViewController: UIViewController {

    @IBOutlet weak var topicImagesScrollView: UIScrollView!
    @IBOutlet weak var topicImagesScrollContentsView: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicImagesScrollViewConfigure()

       
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func topicImagesScrollViewConfigure() {
        topicImagesScrollView.contentSize = CGSize(width: self.view.frame.width,
                                                   height: self.view.frame.height)
        topicImagesScrollContentsView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.view.frame.width)
            make.center.equalToSuperview()
            
        }
        
        
    }
}
