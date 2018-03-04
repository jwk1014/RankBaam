//
//  TopicEditBottomView.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 1..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

protocol TopicEditBottomViewDelegate: class {
  func bottomViewHandleTapOptionAdd()
  func bottomViewHandleTapInfo(type: TopicEditBottomCheckType)
  func bottomViewHandleTapCheck(type: TopicEditBottomCheckType, isChecked: Bool)
}

enum TopicEditBottomCheckType: Int {
  case votableCount
  case onlyWriterCreateOption
}

class TopicEditBottomView: UICollectionReusableView {
  weak var delegate: TopicEditBottomViewDelegate?
  
  var isVotableCount: Bool = false {
    didSet { if oldValue != isVotableCount {
      votableCountCheckButton?.setImage(
        imageCheckButton(isCheck: isVotableCount), for: .normal)
      }}
  }
  var isOnlyWriterCreateOption: Bool = false {
    didSet { if oldValue != isOnlyWriterCreateOption {
      onlyWriterCreateOptionCheckButton?.setImage(
        imageCheckButton(isCheck: isOnlyWriterCreateOption), for: .normal)
      }}
  }
  
  private weak var optionAddButton: UIButton?
  private weak var votableCountCheckButton: UIButton?
  private weak var onlyWriterCreateOptionCheckButton: UIButton?
  
  private func imageCheckButton(isCheck: Bool) -> UIImage? {
    guard let image = UIImage(named: ((isCheck) ? "Wcheck_btn_F" : "Wcheck_btn_N") ) else { return nil }
    let padding = width375(20.0)
    return image.copy(with: .init(top: padding, left: padding, bottom: padding, right: padding), isTemplate: false)
  }
  
  @objc func handleTapOptionAdd(_ button: UIButton) {
    delegate?.bottomViewHandleTapOptionAdd()
  }
  
  @objc func handleTapInfo(_ button: UIButton) {
    guard let type = TopicEditBottomCheckType(rawValue: button.tag) else {return}
    delegate?.bottomViewHandleTapInfo(type: type)
  }
  
  @objc func handleTapCheck(_ button: UIButton) {
    guard let type = TopicEditBottomCheckType(rawValue: button.tag) else {return}
    switch type {
    case .votableCount:
      isVotableCount = !isVotableCount
      delegate?.bottomViewHandleTapCheck(type: type, isChecked: isVotableCount)
    case .onlyWriterCreateOption:
      isOnlyWriterCreateOption = !isOnlyWriterCreateOption
      delegate?.bottomViewHandleTapCheck(type: type, isChecked: isOnlyWriterCreateOption)
    }
  }
  
  private func initView(){
    let optionAddButton = UIButton()
    optionAddButton.backgroundColor = UIColor(r: 228, g: 228, b: 228)
    optionAddButton.layer.cornerRadius = 3.0
    
    let optionAddButtonWidth = width375(343.0)
    let optionAddButtonHeight = height667(46.0)
    let optionAddPlusShapeWidth = width375(14.0)
    
    let plusLayer = CAShapeLayer()
    let bezierPath = UIBezierPath()
    bezierPath.move(to: .init(x: optionAddPlusShapeWidth/2.0, y: 0.0))
    bezierPath.addLine(to: .init(x: optionAddPlusShapeWidth/2.0, y: optionAddPlusShapeWidth))
    bezierPath.move(to: .init(x: 0.0, y: optionAddPlusShapeWidth/2.0))
    bezierPath.addLine(to: .init(x: optionAddPlusShapeWidth, y: optionAddPlusShapeWidth/2.0))
    plusLayer.path = bezierPath.cgPath
    plusLayer.strokeColor = UIColor(r: 112, g: 112, b: 112).cgColor
    plusLayer.lineWidth = width375(2.0)
    plusLayer.frame = .init(
      x: (optionAddButtonHeight - optionAddPlusShapeWidth)/2.0,
      y: (optionAddButtonHeight - optionAddPlusShapeWidth)/2.0,
      width: optionAddPlusShapeWidth, height: optionAddPlusShapeWidth)
    plusLayer.backgroundColor = UIColor.clear.cgColor
    optionAddButton.layer.addSublayer(plusLayer)
    
    let textLayer = CATextLayer()
    textLayer.frame = .init( x: plusLayer.frame.maxX + width375(9.0), y: height667(14.0),
                             width: width375(170.0), height: height667(17.0))
    textLayer.alignmentMode = kCAAlignmentLeft
    textLayer.string = "항목추가"
    textLayer.font = "NanumSquareR" as CFTypeRef
    textLayer.fontSize = 14.0
    textLayer.contentsScale = UIScreen.main.scale
    textLayer.foregroundColor = UIColor(r: 112, g: 112, b: 112).cgColor
    textLayer.backgroundColor = UIColor.clear.cgColor
    optionAddButton.layer.addSublayer(textLayer)
    
    optionAddButton.addTarget(self, action: #selector(handleTapOptionAdd), for: .touchUpInside)
    self.optionAddButton = optionAddButton
    self.addSubview(optionAddButton)
    optionAddButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(height667(14.0))
      $0.centerX.equalToSuperview()
      $0.width.equalTo(optionAddButtonWidth)
      $0.height.equalTo(optionAddButtonHeight)
    }
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont(name: "NanumSquareB", size: 14.0)
    titleLabel.textColor = UIColor(r: 112, g: 112, b: 112)
    titleLabel.text = "랭킹 설정"
    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(optionAddButton.snp.bottom).offset(height667(46.0))
      $0.leading.equalToSuperview().offset(width375(24.0))
    }
    
    let seperatorView1 = UIView()
    self.addSubview(seperatorView1)
    seperatorView1.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(height667(10.0))
    }
    
    let votableCountLabel = UILabel()
    votableCountLabel.font = UIFont(name: "NanumSquareR", size: 14.0)
    votableCountLabel.textColor = UIColor(r: 112, g: 112, b: 112)
    votableCountLabel.text = "복수 선택 가능"
    let votableCountInfoButton = UIButton()
    votableCountInfoButton.tag = TopicEditBottomCheckType.votableCount.rawValue
    let votableCountCheckButton = UIButton()
    votableCountCheckButton.tag = TopicEditBottomCheckType.votableCount.rawValue
    self.votableCountCheckButton = votableCountCheckButton
    votableCountCheckButton.setImage(
      imageCheckButton(isCheck: isVotableCount), for: .normal)
    initSubView( seperatorView: seperatorView1, label: votableCountLabel,
                 infoButton: votableCountInfoButton, checkButton: votableCountCheckButton)
    
    let seperatorView2 = UIView()
    self.addSubview(seperatorView2)
    seperatorView2.snp.makeConstraints {
      $0.top.equalTo(votableCountLabel.snp.bottom).offset(height667(24.0))
    }
    let onlyWriterCreateOptionLabel = UILabel()
    onlyWriterCreateOptionLabel.font = UIFont(name: "NanumSquareR", size: 14.0)
    onlyWriterCreateOptionLabel.textColor = UIColor.init(r: 112, g: 112, b: 112)
    onlyWriterCreateOptionLabel.text = "랭킹 항목 추가 허용"
    let onlyWriterCreateOptionInfoButton = UIButton()
    onlyWriterCreateOptionInfoButton.tag = TopicEditBottomCheckType.onlyWriterCreateOption.rawValue
    let onlyWriterCreateOptionCheckButton = UIButton()
    onlyWriterCreateOptionCheckButton.tag = TopicEditBottomCheckType.onlyWriterCreateOption.rawValue
    self.onlyWriterCreateOptionCheckButton = onlyWriterCreateOptionCheckButton
    onlyWriterCreateOptionCheckButton.setImage(
      imageCheckButton(isCheck: isOnlyWriterCreateOption), for: .normal)
    initSubView( seperatorView: seperatorView2, label: onlyWriterCreateOptionLabel,
                 infoButton: onlyWriterCreateOptionInfoButton, checkButton: onlyWriterCreateOptionCheckButton)
    
    onlyWriterCreateOptionLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-height667(24.0 + 56.0))
    }
  }
  
  private func initSubView(seperatorView: UIView, label: UILabel, infoButton: UIButton, checkButton:UIButton) {
    seperatorView.backgroundColor = .init(r: 194, g: 194, b: 194)
    seperatorView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(1.0)
    }
    
    self.addSubview(label)
    label.snp.makeConstraints {
      $0.top.equalTo(seperatorView.snp.bottom).offset(height667(24.0))
      $0.leading.equalToSuperview().offset(width375(24.0))
    }
    
    if let infoImage = UIImage(named: "help_icn") {
      infoButton.setImage(
        infoImage.copy(
          with: .init(top: 10, left: 10, bottom: 10, right: 10),
          isTemplate: false),
        for: .normal)
    }
    self.addSubview(infoButton)
    infoButton.snp.makeConstraints {
      $0.leading.equalTo(label.snp.trailing)
      $0.width.equalTo(width375(36.0))
      $0.height.equalTo(infoButton.snp.width)
      $0.centerY.equalTo(label)
    }
    infoButton.addTarget(self, action: #selector(handleTapInfo(_:)), for: .touchUpInside)
    
    self.addSubview(checkButton)
    checkButton.snp.makeConstraints {
      $0.centerY.equalTo(infoButton)
      $0.width.equalTo(width375(56.0))
      $0.height.equalTo(checkButton.snp.width)
      $0.trailing.equalToSuperview().offset(-width375(4.0))
    }
    checkButton.addTarget(self, action: #selector(handleTapCheck(_:)), for: .touchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}
