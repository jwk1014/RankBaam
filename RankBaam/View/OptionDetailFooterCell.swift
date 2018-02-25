//
//  OptionDetailFooterCell.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 24..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

protocol OptionDetailFooterCellDelegate: class {
  func footerCell(section: Int, text: String?, clearClosure: @escaping ()->Void)
  func footerCell(section: Int, action: OptionDetailFooterCell.Action)
}

class OptionDetailFooterCell: UICollectionViewCell {
  class CustomTextField: UITextField {
    var insetX: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
      var rect = bounds
      rect.origin.x += insetX
      rect.size.width -= (insetX + (rightView?.bounds.width ?? 0))
      return rect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return textRect(forBounds: bounds)
    }
  }
  
  public enum Action {
    case more( (Bool) -> Void )
    case hide
  }
  
  var section: Int?
  weak var delegate: OptionDetailFooterCellDelegate?
  var isButtonHidden: Bool {
    get {
      return moreButton?.isHidden ?? false || hideButton?.isHidden ?? false
    }
    set {
      moreButton?.isHidden = newValue
      hideButton?.isHidden = newValue
    }
  }
  private weak var moreAreaView: UIView?
  private var moreAreaViewHeightConstraint: NSLayoutConstraint?
  private weak var moreButton: UIButton?
  private weak var moreIndicatorView: UIActivityIndicatorView?
  private weak var textField: UITextField?
  private weak var hideButton: UIButton?
  private var isLoadingAnimating: Bool = false {
    didSet {
      moreButton?.isHidden = isLoadingAnimating
      if let moreIndicatorView = moreIndicatorView {
        moreIndicatorView.isHidden = !isLoadingAnimating
        if isLoadingAnimating {
          if !moreIndicatorView.isAnimating {
            moreIndicatorView.startAnimating()
          }
        } else if moreIndicatorView.isAnimating {
          moreIndicatorView.stopAnimating()
        }
      }
    }
  }
  
  func fitView(data: OptionCommentData) {
    if data.more {
      moreAreaViewHeightConstraint?.isActive = true
      isLoadingAnimating = false
    } else {
      moreAreaViewHeightConstraint?.isActive = false
    }
    moreAreaView?.layoutIfNeeded()
  }
  
  func initView() {
    backgroundColor = UIColor(r: 247, g: 247, b: 247)
    
    let moreAreaView = UIView()
    
    let moreButton = UIButton()
    
    let expandDownLayer = CALayer()
    
    expandDownLayer.backgroundColor = UIColor.clear.cgColor
    expandDownLayer.contents = UIImage(named: "expand_down_less_icn")?.cgImage
    expandDownLayer.frame = .init(
      x: width375(203.0), y: height667(16.0),
      width: width375(10.0), height: height667(5.0))
    
    moreButton.layer.addSublayer(expandDownLayer)
    
    let moreTextLayer = CATextLayer()
    
    moreTextLayer.alignmentMode = kCAAlignmentRight
    moreTextLayer.string = "더보기"
    moreTextLayer.font = "NanumSquareR" as CFTypeRef
    moreTextLayer.fontSize = 12.0
    moreTextLayer.foregroundColor = UIColor(r: 77, g: 77, b: 77).cgColor
    moreTextLayer.backgroundColor = UIColor.clear.cgColor
    moreTextLayer.frame = .init(
      x: 0, y: 0, width: width375(35.0), height: height667(13.0))
    moreTextLayer.frame.origin.x =
      expandDownLayer.frame.origin.x - (moreTextLayer.frame.width + 8)
    moreTextLayer.frame.origin.y =
      expandDownLayer.frame.origin.y + expandDownLayer.frame.height / 2.0
      - moreTextLayer.frame.height / 2.0
    
    moreButton.layer.addSublayer(moreTextLayer)
    
    moreButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    
    self.moreButton = moreButton
    moreAreaView.addSubview(moreButton)
    moreButton.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(moreAreaView)
    }
    
    let moreIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    moreIndicatorView.isHidden = true
    self.moreIndicatorView = moreIndicatorView
    moreAreaView.addSubview(moreIndicatorView)
    moreIndicatorView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(moreAreaView)
    }
    
    self.moreAreaView = moreAreaView
    moreAreaView.clipsToBounds = true
    contentView.addSubview(moreAreaView)
    moreAreaView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(contentView)
    }
    let moreAreaViewZeroHeightConstraint = moreAreaView.heightAnchor.constraint(equalToConstant: 0)
    moreAreaViewZeroHeightConstraint.priority = .defaultLow
    moreAreaViewZeroHeightConstraint.isActive = true
    moreAreaViewHeightConstraint = moreAreaView.heightAnchor.constraint(equalToConstant: height667(36.0))
    moreAreaViewHeightConstraint?.isActive = true
    
    let middleView = UIView()
    contentView.addSubview(middleView)
    middleView.snp.makeConstraints {
      $0.top.equalTo(moreAreaView.snp.bottom)
      $0.leading.trailing.equalTo(contentView)
      $0.height.equalTo(height667(72.0))
    }
    
    let lineLayer = CAShapeLayer()
    let lineLength = width375(12.0)
    let bezierPath = UIBezierPath()
    bezierPath.move(to: .zero)
    bezierPath.addLine(to: .init(x: 0, y: lineLength))
    bezierPath.addLine(to: .init(x: lineLength, y: lineLength))
    lineLayer.path = bezierPath.cgPath
    lineLayer.fillColor = UIColor.clear.cgColor
    lineLayer.strokeColor = UIColor(r: 151, g: 151, b: 151).cgColor
    lineLayer.lineWidth = 1.0
    lineLayer.backgroundColor = UIColor.clear.cgColor
    lineLayer.frame = CGRect(x: width375(30.0), y: height667(8.0),
                             width: lineLength, height: lineLength)
    middleView.layer.addSublayer(lineLayer)
    
    let textField = CustomTextField()
    textField.font = UIFont(name: "NanumSquareR", size: 12.0)
    textField.textColor = UIColor(r: 77, g: 77, b: 77)
    textField.placeholder = "답글을 입력해주세요."
    textField.layer.borderColor = UIColor(r: 217, g: 217, b: 217).cgColor
    textField.layer.borderWidth = 1.0
    textField.backgroundColor = UIColor.white
    textField.insetX = 10.0
    self.textField = textField
    middleView.addSubview(textField)
    textField.snp.makeConstraints {
      $0.leading.equalTo(width375(52.0))
      $0.centerY.equalTo(middleView)
      $0.width.equalTo(width375(299.0))
      $0.height.equalTo(height667(36.0))
    }
    
    let submitButton = UIButton()
    if let font = UIFont(name: "NanumSquareB", size: 14.0) {
      submitButton.setAttributedTitle(
        NSAttributedString(
          string: "등록",
          attributes: [
            .font: font,
            .foregroundColor: UIColor(r: 255, g: 195, b: 75)]
        ),
        for: .normal)
    }
    submitButton.layer.borderColor = UIColor(r: 217, g: 217, b: 217).cgColor
    submitButton.layer.borderWidth = 1.0
    submitButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    submitButton.frame = CGRect(
      x: width375(299.0 - 64.0), y: 0.0,
      width: width375(64.0), height: 36.0)
    textField.rightView = submitButton
    textField.rightViewMode = .always
    /*textField.rightViewRect(forBounds: CGRect(
      x: width375(299.0 - 64.0), y: 0.0,
      width: width375(64.0), height: 36.0))*/
    
    let hideButton = UIButton()
    
    let expandUpLayer = CALayer()
    
    expandUpLayer.backgroundColor = UIColor.clear.cgColor
    expandUpLayer.contents = UIImage(named: "expand_up_less_icn")?.cgImage
    expandUpLayer.frame = .init(
      x: width375(210.0), y: height667(21.0),
      width: width375(10.0), height: height667(5.0))
    
    hideButton.layer.addSublayer(expandUpLayer)
    
    let hideTextLayer = CATextLayer()
    
    hideTextLayer.alignmentMode = kCAAlignmentRight
    hideTextLayer.string = "답글 접기"
    hideTextLayer.font = "NanumSquareR" as CFTypeRef
    hideTextLayer.fontSize = 12.0
    hideTextLayer.foregroundColor = UIColor(r: 77, g: 77, b: 77).cgColor
    hideTextLayer.backgroundColor = UIColor.clear.cgColor
    hideTextLayer.frame = .init(
      x: 0, y: 0,
      width: width375(50.0), height: height667(13.0))
    hideTextLayer.frame.origin.x =
      expandUpLayer.frame.origin.x - (hideTextLayer.frame.width + 8)
    hideTextLayer.frame.origin.y =
      expandUpLayer.frame.origin.y + expandUpLayer.frame.height / 2.0
      - hideTextLayer.frame.height / 2.0
    
    hideButton.layer.addSublayer(hideTextLayer)
    
    hideButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    
    self.hideButton = hideButton
    contentView.addSubview(hideButton)
    hideButton.snp.makeConstraints {
      $0.top.equalTo(middleView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(contentView)
      $0.height.equalTo(height667(46.0))
    }
  }
  
  @objc func handleButton(_ sender: UIButton){
    guard let section = section, let delegate = delegate else {return}
    if sender == moreButton {
      isLoadingAnimating = true
      delegate.footerCell(section: section, action: .more({
        more in
        if more {
          self.isLoadingAnimating = false
        } else {
          if self.moreIndicatorView?.isAnimating ?? false {
            self.moreIndicatorView?.stopAnimating()
          }
          self.moreAreaViewHeightConstraint?.isActive = false
        }
      }))
    } else if sender == hideButton {
      delegate.footerCell(section: section, action: .hide)
    } else {
      delegate.footerCell(section: section, text: textField?.text) {
        self.textField?.text = ""
        self.textField?.resignFirstResponder()
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}
