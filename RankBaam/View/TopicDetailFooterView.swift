//
//  TopicDetailFooterView.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 23..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class TopicDetailFooterView: UICollectionReusableView {

    @IBOutlet weak var topicDetailFooterBackgroundView: UIView!
    @IBOutlet weak var topicOptionWriteCell: UIView!
    @IBOutlet weak var topicOptionAddButton: UIView!
    @IBOutlet weak var topicOptionTitleTextField: UITextField!
    @IBOutlet weak var topicOptionCreateOrCancelButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topicDetailFooterBackgroundView.backgroundColor = UIColor.rankbaamGray
        footerViewComponentConfigure()
        topicOptionAddButtonConfigure()
    }
    
    fileprivate func topicOptionAddButtonConfigure() {
        topicOptionAddButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topicOptionAddButtonTapped))
        topicOptionAddButton.addGestureRecognizer(tapGesture)
        topicOptionWriteCell.transform = CGAffineTransform(scaleX: 1, y: 0)
    }
    
    @objc func topicOptionAddButtonTapped() {
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.topicOptionAddButton.transform = CGAffineTransform(scaleX: 1, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.topicOptionWriteCell.transform = CGAffineTransform.identity
                self.topicOptionWriteCell.isHidden = false
            })
        }, completion: nil)
        
    }
    
    fileprivate func footerViewComponentConfigure() {
        topicOptionAddButton.layer.cornerRadius = 8
        topicOptionAddButton.layer.masksToBounds = true
        let shadowlayer = CAShapeLayer()
        shadowlayer.path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: topicOptionWriteCell.frame.width, height: topicOptionWriteCell.frame.height), cornerRadius: 8).cgPath
        shadowlayer.fillColor = UIColor.white.cgColor
        shadowlayer.shadowOpacity = 1
        shadowlayer.shadowRadius = 2
        shadowlayer.shadowOffset = CGSize(width: 3, height: 3)
        shadowlayer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        topicOptionWriteCell.layer.insertSublayer(shadowlayer, at: 0)
        topicOptionWriteCell.layer.cornerRadius = 8
        topicOptionTitleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        if let textWritten = textField.text, textWritten.isEmpty {
            topicOptionCreateOrCancelButton.setTitle("취소", for: .normal)
            topicOptionCreateOrCancelButton.setTitleColor(UIColor.rankbaamDarkgray, for: .normal)
        } else {
            topicOptionCreateOrCancelButton.setTitle("등록", for: .normal)
            topicOptionCreateOrCancelButton.setTitleColor(UIColor.rankbaamOrange, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topicDetailFooterBackgroundView.backgroundColor = UIColor.rankbaamGray
        footerViewComponentConfigure()
        topicOptionAddButtonConfigure()
    }
}



