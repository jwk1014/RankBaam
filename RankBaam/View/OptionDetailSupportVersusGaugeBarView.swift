//
//  OptionDetailSupportVersusGaugeBarView.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 19..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class OptionDetailSupportVersusGaugeBarView: UIView {
  var blueValue: Int? {
    willSet {
      if let blueValue = newValue {
        loadValue(blueValue: blueValue, redValue: redValue)
        blueLabel?.text = "\(blueValue)공감"
      }
    }
  }
  var redValue: Int? {
    willSet {
      if let redValue = newValue {
        loadValue(blueValue: blueValue, redValue: redValue)
        redLabel?.text = "\(redValue)비공감"
      }
    }
  }
  private weak var blueLabel: UILabel?
  private weak var redLabel: UILabel?
  private var blueWidthConstraint: NSLayoutConstraint?
  
  func loadValue(blueValue: Int?, redValue: Int?){
    guard let blueValue = blueValue, let redValue = redValue else {return}
    var blueRatio: Double
    let minRatio: Double = 0.0//0.175
    let maxRatio: Double = 1.0//(1.0 - minRatio)
    if blueValue == 0 || redValue == 0 {
      blueRatio = (blueValue > redValue) ? maxRatio : (blueValue == redValue) ? 0.5 : minRatio
    } else {
      blueRatio = Double(blueValue) / Double(blueValue + redValue)
      blueRatio = max(min(blueRatio, maxRatio), minRatio)
    }
    blueWidthConstraint?.constant = width375(CGFloat(375.0 * blueRatio))
  }
  
  private func initView(){
    backgroundColor = UIColor(r: 255, g: 112, b: 105)
    snp.makeConstraints {
      $0.height.equalTo(height667(32.0))
    }
    
    let blueView = UIView()
    blueView.backgroundColor = UIColor(r: 101, g: 184, b: 233)
    addSubview(blueView)
    blueView.snp.makeConstraints {
      $0.top.leading.bottom.equalTo(self)
    }
    blueWidthConstraint = blueView.widthAnchor.constraint(equalToConstant: width375(375.0/2))
    blueWidthConstraint?.isActive = true
    
    let blueLabel = UILabel()
    blueLabel.font = UIFont.init(name: "NanumSquareB", size: 16.0)
    blueLabel.textColor = UIColor.white
    blueLabel.text = "공감"
    self.blueLabel = blueLabel
    addSubview(blueLabel)
    blueLabel.snp.makeConstraints {
      $0.leading.equalTo(self).offset(width375(14.0))
      $0.centerY.equalTo(self)
    }
    
    let redLabel = UILabel()
    redLabel.font = UIFont(name: "NanumSquareB", size: 16.0)
    redLabel.textColor = UIColor.white
    redLabel.text = "비공감"
    self.redLabel = redLabel
    addSubview(redLabel)
    redLabel.snp.makeConstraints {
      $0.trailing.equalTo(self).offset(-width375(14.0))
      $0.centerY.equalTo(self)
    }
    
  }
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}
