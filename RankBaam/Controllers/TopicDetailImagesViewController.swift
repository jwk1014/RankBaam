//
//  TopicDetailImagesViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 24..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class TopicDetailImagesViewController: UIViewController, UIGestureRecognizerDelegate {
    var originalCenter: CGPoint?
    var firstTouchedPoint: CGPoint?
    var firstImageView: UIImageView?
    

    var topicImages: [Photo] = [Photo]()
    var topicImagesScrollView: UIScrollView = {
        let topicImagesScrollView = UIScrollView()
        return topicImagesScrollView
    }()
    
    var topicImagesScrollContentsView: UIView = {
        let topicImagesScrollContentsView = UIView()
        return topicImagesScrollContentsView
    }()
    
    var topicImagesDismissButton: UIButton = {
        let topicImagesDismissButton = UIButton()
        return topicImagesDismissButton
    }()
    
    var imagesPageCounterLabel: UILabel = {
        let imagesPageCounterLabel = UILabel()
        return imagesPageCounterLabel
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
    }
    
    @objc func swipeDismissActionHandler(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalCenter = view.center
            firstTouchedPoint = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: 0,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let movingVelocity = panGesture.velocity(in: view)
            
            if movingVelocity.y >= 170 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalCenter!
                })
            }
        }
    }
    
   
    
    fileprivate func topicImagesScrollViewConfigure() {
        if !topicImages.isEmpty {
            topicImagesScrollView.contentSize =
                CGSize(width: self.view.frame.width * CGFloat(topicImages.count),
                       height: self.view.frame.height)
        } else {
            topicImagesScrollView.contentSize =
                CGSize(width: self.view.frame.width,
                       height: self.view.frame.height)
        }
        topicImagesScrollView.delegate = self
        topicImagesScrollView.isPagingEnabled = true
        topicImagesScrollView.minimumZoomScale = 0.5
        topicImagesScrollView.maximumZoomScale = 3.0
        topicImagesScrollView.pinchGestureRecognizer?.isEnabled = true
        topicImagesScrollView.isMultipleTouchEnabled = true
       
    }
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(topicImagesScrollView)
        topicImagesScrollView.addSubview(topicImagesScrollContentsView)
        self.view.addSubview(topicImagesDismissButton)
        self.view.addSubview(imagesPageCounterLabel)
        self.view.backgroundColor = UIColor.clear
        self.topicImagesScrollView.backgroundColor = UIColor.clear
        self.topicImagesScrollContentsView.backgroundColor = UIColor.black
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeDismissActionHandler))
        panGesture.delegate = self
        topicImagesScrollView.addGestureRecognizer(panGesture)
        
        let dismissImage = UIImage.init(named: "ic_clear")?.withRenderingMode(.alwaysTemplate)
        topicImagesDismissButton.setImage(dismissImage, for: .normal)
        topicImagesDismissButton.tintColor = UIColor.white
        topicImagesDismissButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        imagesPageCounterLabel.textColor = UIColor.white
        imagesPageCounterLabel.font = imagesPageCounterLabel.font.withSize(Constants.screenWidth * (15 / 375))
        imagesPageCounterLabel.textAlignment = .center
        
        topicImagesScrollViewConfigure()
        topicImagesScrollView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        topicImagesScrollContentsView.snp.makeConstraints {
            let multiplier = topicImages.isEmpty ? 1 : topicImages.count
            $0.top.left.equalToSuperview()
            $0.height.equalTo(self.view.frame.height)
            $0.width.equalTo(self.view.frame.width * CGFloat(multiplier))
        }
        for count in 0...topicImages.count - 1 {
            let topicImageView = UIImageView()
            topicImagesScrollContentsView.addSubview(topicImageView)
            let imgURL = URL(string: topicImages[count].realUrl)
            topicImageView.sd_setImage(with: imgURL, completed: nil)
           
            topicImageView.snp.makeConstraints({
                $0.left.equalTo(topicImagesScrollContentsView.snp.left)
                    .offset(self.view.frame.width * CGFloat(count))
                $0.top.equalToSuperview()
                $0.width.equalTo(self.view.frame.width)
                $0.height.equalTo(self.view.frame.height)
            })
            topicImageView.contentMode = .scaleAspectFit
            topicImageView.backgroundColor = UIColor.clear
            
        }
        topicImagesDismissButton.snp.makeConstraints {
            $0.right.equalTo(self.view.snp.right).offset(-(Constants.screenWidth * (15 / 375)))
            $0.top.equalTo(self.view.snp.top)
                .offset(Constants.screenHeight * ( 15 / 667))
            $0.width.equalTo(Constants.screenWidth * (30 / 375))
            $0.height.equalTo(Constants.screenHeight * ( 30 / 667))
        }
        imagesPageCounterLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.snp.top)
                .offset(Constants.screenHeight * ( 30 / 667))
            $0.width.equalTo(Constants.screenWidth * (100 / 375))
            $0.height.equalTo(Constants.screenHeight * ( 17 / 667))
        }
    }
    
    @objc fileprivate func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TopicDetailImagesViewController: UIScrollViewDelegate {
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber: Int = Int(scrollView.contentOffset.x / (self.view.frame.width))
        print("\(pageNumber)")
        self.imagesPageCounterLabel.text = "\(pageNumber + 1) / \(topicImages.count)"
    }
}
