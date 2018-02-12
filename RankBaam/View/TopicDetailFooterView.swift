//
//  TopicDetailFooterView.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 29..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import SnapKit


protocol TopicDetailFooterViewDelegate {
    func optionCreateButtonTapped(_ optionTitle: String)
    func addOptionPhotoButtonTapped()
}


class TopicDetailFooterView: UICollectionReusableView {
    
    var delegate: TopicDetailFooterViewDelegate?
    
    var topicDetailFooterBackgroundView: UIView = {
        let topicDetailFooterBackgroundView = UIView()
        return topicDetailFooterBackgroundView
    }()
    
    var topicDetailFooterOptionWriteCell: UIView = {
        let topicDetailFooterOptionWriteCell = UIView()
        return topicDetailFooterOptionWriteCell
    }()
    
    var topicDetailFooterOptionWriteImageView: UIImageView = {
        let topicDetailFooterOptionWriteImageView = UIImageView()
        return topicDetailFooterOptionWriteImageView
    }()
    
    var topicDetailFooterCreateOrCancelButton: UIButton = {
        let topicDetailFooterCreateOrCancelButton = UIButton()
        return topicDetailFooterCreateOrCancelButton
    }()
    
    var topicDetailFooterInnerSeperatorView: UIView = {
        let topicDetailFooterInnerSeperatorView = UIView()
        return topicDetailFooterInnerSeperatorView
    }()
    
    var topicDetailFooterWriteCellTextField: UITextField = {
        let topicDetailFooterWriteCellTextField = UITextField()
        return topicDetailFooterWriteCellTextField
    }()
    
    var topicDetailFooterOptionAddButton: UIButton =  {
        let topicDetailFooterOptionAddButton = UIButton()
        return topicDetailFooterOptionAddButton
    }()
    
    var topicDetailFooterOptionAddButtonImageView: UIImageView =  {
        let topicDetailFooterOptionAddButtonImageView = UIImageView()
        return topicDetailFooterOptionAddButtonImageView
    }()
    
    var topicDetailFooterOptionAddButtonTextLabel: UILabel =  {
        let topicDetailFooterOptionAddButtonTextLabel = UILabel()
        return topicDetailFooterOptionAddButtonTextLabel
    }()
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
        topicOptionAddButtonConfigure()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
        topicOptionAddButtonConfigure()
        
    }
    
    fileprivate func viewInitConfigure() {
        self.addSubview(topicDetailFooterBackgroundView)
        self.addSubview(topicDetailFooterOptionWriteCell)
        topicDetailFooterOptionWriteCell
            .addSubview(topicDetailFooterOptionWriteImageView)
        topicDetailFooterOptionWriteCell
            .addSubview(topicDetailFooterCreateOrCancelButton)
        topicDetailFooterOptionWriteCell
            .addSubview(topicDetailFooterInnerSeperatorView)
        topicDetailFooterOptionWriteCell
            .addSubview(topicDetailFooterWriteCellTextField)
        self.addSubview(topicDetailFooterOptionAddButton)
        topicDetailFooterOptionAddButton
            .addSubview(topicDetailFooterOptionAddButtonImageView)
        topicDetailFooterOptionAddButton
            .addSubview(topicDetailFooterOptionAddButtonTextLabel)
        
        
        topicDetailFooterBackgroundView.backgroundColor = UIColor.rankbaamGray
        topicDetailFooterOptionWriteCell.backgroundColor = UIColor.white
        topicDetailFooterOptionWriteCell.layer.cornerRadius = 4
        topicDetailFooterOptionWriteCell.layer.shadowOffset = CGSize(width: 4, height: 4)
        topicDetailFooterOptionWriteCell.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        topicDetailFooterOptionWriteCell.layer.shadowRadius = 4
        topicDetailFooterOptionWriteCell.layer.shadowOpacity = 0.7
        
        topicDetailFooterOptionWriteImageView.image = UIImage(named: "ImageIcn")
        topicDetailFooterOptionWriteImageView.contentMode = .scaleAspectFit
        topicDetailFooterCreateOrCancelButton.setTitle("취소", for: .normal)
        topicDetailFooterCreateOrCancelButton
            .setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
        topicDetailFooterCreateOrCancelButton.titleLabel?.font = topicDetailFooterCreateOrCancelButton.titleLabel?
            .font
            .withSize(Constants.screenWidth * (14 / 375))
        topicDetailFooterInnerSeperatorView.backgroundColor = UIColor.rankbaamSeperatorColor
        if !(Constants.screenWidth < 375) {
            topicDetailFooterWriteCellTextField.placeholder = "항목을 입력해주세요"
        } else {
        guard let nanumFont = UIFont(name: "NanumSquareB", size: 16) else { return }
        let placeHolder = NSAttributedString(string: "항목을 입력해주세요", attributes: [NSAttributedStringKey.font : nanumFont])
             topicDetailFooterWriteCellTextField.attributedPlaceholder = placeHolder
        }
        topicDetailFooterOptionAddButton.backgroundColor = UIColor(r: 228, g: 228, b: 228)
        topicDetailFooterOptionWriteCell.isHidden = true
        topicDetailFooterOptionAddButton.isHidden = false
        topicDetailFooterOptionAddButton.layer.cornerRadius = 4
        topicDetailFooterOptionAddButtonImageView.image = UIImage(named: "addicn")
        topicDetailFooterOptionAddButtonImageView.contentMode = .scaleAspectFit
        topicDetailFooterOptionAddButtonTextLabel.text = "항목 추가"
        topicDetailFooterOptionAddButtonTextLabel.textColor = UIColor.black
        topicDetailFooterOptionAddButtonTextLabel.font =
            UIFont(name: "NanumSquareB", size: 14)
        
        
        
        topicDetailFooterBackgroundView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        topicDetailFooterOptionWriteCell.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(75))
        }
        topicDetailFooterOptionWriteCell.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(75))
        }
        topicDetailFooterOptionWriteImageView.snp.makeConstraints {
            $0.top.equalTo(topicDetailFooterOptionWriteCell.snp.top)
                .offset(height667(5))
            $0.left.equalTo(topicDetailFooterOptionWriteCell.snp.left)
                .offset(width375(5))
            $0.bottom.equalTo(topicDetailFooterOptionWriteCell.snp.bottom)
                .offset(-(height667(5)))
            $0.width.equalTo(width375(76))
        }
        topicDetailFooterCreateOrCancelButton.snp.makeConstraints {
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(width375(66))
        }
        topicDetailFooterInnerSeperatorView.snp.makeConstraints {
            $0.top.equalTo(topicDetailFooterOptionWriteCell.snp.top)
                .offset(height667(4))
            $0.right.equalTo(topicDetailFooterCreateOrCancelButton.snp.left)
            $0.bottom.equalTo(topicDetailFooterOptionWriteCell.snp.bottom)
                .offset(-(height667(4)))
            $0.width.equalTo(width375(2))
        }
        topicDetailFooterWriteCellTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(topicDetailFooterOptionWriteImageView.snp.right)
                .offset(width375(14))
            $0.width.equalTo(width375(180))
            $0.height.equalTo(height667(17))
        }
        topicDetailFooterOptionAddButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(46))
        }
        topicDetailFooterOptionAddButtonImageView.snp.makeConstraints {
            $0.top.equalTo(topicDetailFooterOptionAddButton.snp.top)
                .offset(height667(14))
            $0.left.equalTo(topicDetailFooterOptionAddButton.snp.left)
                .offset(width375(16))
            $0.height.equalTo(height667(15))
            $0.width.equalTo(width375(15))
        }
        topicDetailFooterOptionAddButtonTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(topicDetailFooterOptionAddButtonImageView.snp.right)
                .offset(width375(9))
            $0.width.equalTo(width375(70))
            $0.height.equalTo(height667(18))
        }
    }
    
    fileprivate func topicOptionAddButtonConfigure() {
        topicDetailFooterOptionAddButton.addTarget(self, action: #selector(topicOptionAddButtonTapped), for: .touchUpInside)
        topicDetailFooterWriteCellTextField.delegate = self
        topicDetailFooterWriteCellTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        topicDetailFooterCreateOrCancelButton.addTarget(self, action: #selector(topicDetailFooterCreateOrCancelButtonTapped(_:)), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topicOptionPhotoAddButtonTapped))
        topicDetailFooterOptionWriteImageView.isUserInteractionEnabled = true
        topicDetailFooterOptionWriteImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func topicOptionPhotoAddButtonTapped() {
        delegate?.addOptionPhotoButtonTapped()
    }
    
    @objc func topicOptionAddButtonTapped() {
        topicDetailFooterOptionWriteCell.transform =
            CGAffineTransform(scaleX: 1, y: 0)
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.topicDetailFooterOptionAddButton.transform = CGAffineTransform(scaleX: 1, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.topicDetailFooterOptionWriteCell.transform = CGAffineTransform.identity
                self.topicDetailFooterOptionWriteCell.isHidden = false
            })
        }, completion: { _ in
            self.topicDetailFooterOptionAddButton.isHidden = true
        })
    }
    
    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
        if let textWritten = textField.text, textWritten.isEmpty {
            topicDetailFooterCreateOrCancelButton.setTitle("취소", for: .normal)
            topicDetailFooterCreateOrCancelButton
                .setTitleColor(UIColor.rankbaamDeepBlack, for: .normal)
        } else {
            topicDetailFooterCreateOrCancelButton.setTitle("등록", for: .normal)
            topicDetailFooterCreateOrCancelButton
                .setTitleColor(UIColor.rankbaamOrange, for: .normal)
        }
    }
    
    @objc public func topicDetailFooterCreateOrCancelButtonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.currentTitle else { return }
        switch buttonTitle {
        case "취소" :
            topicDetailFooterOptionAddButton.transform =
                CGAffineTransform(scaleX: 1, y: 0)
            UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.topicDetailFooterOptionWriteCell.transform = CGAffineTransform(scaleX: 1, y: 0)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.topicDetailFooterOptionAddButton.transform = CGAffineTransform.identity
                    self.topicDetailFooterOptionAddButton.isHidden = false
                   
                })
            }, completion: { _ in
                 self.topicDetailFooterOptionWriteCell.isHidden = true
            })
            break
        case "등록" :
            guard let inputTitle = topicDetailFooterWriteCellTextField.text else { return }
            
                delegate?.optionCreateButtonTapped(inputTitle)
            
            break
        default:
            fatalError()
        }
    }
}

extension TopicDetailFooterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topicDetailFooterWriteCellTextField.endEditing(true)
        return true
    }
}


