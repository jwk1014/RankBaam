//
//  OptionDetailTopHeaderCell.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 19..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

protocol OptionDetailTopHeaderCellDelegate: class {
  func submitCommentDescriptionTextView(
    text: String,
    supportType: OptionDetailTopHeaderCell.SupportType,
    clearTextClosure: @escaping ()->Void)
}

class OptionDetailTopHeaderCell: UICollectionViewCell {
  weak var delegate: OptionDetailTopHeaderCellDelegate?
  var descriptionText: String? {
    get { return descriptionTextLabel?.text }
    set { descriptionTextLabel?.text = newValue }
  }
  var commentCount: Int? {
    willSet {
      if let commentCount = newValue {
        commentLabel?.text = "댓글(\(commentCount))"
      } else {
        commentLabel?.text = "댓글"
      }
    }
  }
  private var photoImageViewHeightConstrant: NSLayoutConstraint?
  private weak var photoImageView: UIImageView?
  private weak var descriptionTextLabel: UILabel?
  private weak var commentLabel: UILabel?
  private(set) weak var supportBarView: OptionDetailSupportVersusGaugeBarView?
  private(set) weak var commentDescriptionTextView: UITextView?
  private weak var commentTextCountingLabel: UILabel?
  
  private weak var positiveButton: UIButton?
  private weak var negativeButton: UIButton?
  private var positiveBigHeightConstraint: NSLayoutConstraint?
  private var positiveSmallHeightConstraint: NSLayoutConstraint?
  private var negativeBigHeightConstraint: NSLayoutConstraint?
  private var negativeSmallHeightConstraint: NSLayoutConstraint?
  
  public enum SupportType {
    case none, positive, negative
  }
  private(set) var supportType: SupportType = .none {
    didSet {
      if oldValue != supportType {
        if oldValue != .none && supportType != .none {
          for item in [positiveBigHeightConstraint, positiveSmallHeightConstraint,
                       negativeBigHeightConstraint, negativeSmallHeightConstraint]
          where item?.isActive ?? false {
              item?.isActive = false
          }
        }
        positiveBigHeightConstraint?.isActive = (supportType == .positive)
        positiveSmallHeightConstraint?.isActive = (supportType == .negative)
        negativeBigHeightConstraint?.isActive = (supportType == .negative)
        negativeSmallHeightConstraint?.isActive = (supportType == .positive)
        UIView.animate(withDuration: 0.55, animations: {
          self.positiveButton?.layoutIfNeeded()
          self.negativeButton?.layoutIfNeeded()
        })
      }
    }
  }
  
  var commentDescriptionTextViewConvertFrame: CGRect? {
    guard let borderView = commentDescriptionTextView?.superview else { return nil }
    return borderView.convert(borderView.bounds, to: self.contentView)
  }
  
  var commentDescriptionText: String? {
    if let commentDescriptionTextView = commentDescriptionTextView,
      commentDescriptionTextView.textColor?.hashValue != commentDescriptionPlaceholderTextColor.hashValue{
      return commentDescriptionTextView.text
    }
    return nil
  }
  
  private var commentDescriptionAttributedString: NSAttributedString? {
    if let font = UIFont(name: "NanumSquareR", size: 12.0) {
      return .init( string: commentDescriptionPlaceholderString,
                    attributes: [
                      .font: font,
                      .foregroundColor: commentDescriptionPlaceholderTextColor
        ])
    }
    return nil
  }
  
  private var commentDescriptionPlaceholderString: String {
    return "댓글을 남겨주세요."
  }
  
  private var commentDescriptionPlaceholderTextColor: UIColor {
    return .init(r: 154, g: 154, b: 154)
  }
  
  private var commentDescriptionTextColor: UIColor {
    return .init(r: 77, g: 77, b: 77)
  }
  
  func setPhoto(url: String) {
    photoImageView?.sd_setImage(with: URL(string: url), completed: {
      (image, _, _, _) in
      guard let image = image else {return}
      var ratio = image.size.height / image.size.width
      ratio = max( 2.0, min( 0.5, ratio ) )
      self.photoImageViewHeightConstrant?.constant = width375(272.0) * ratio
      self.photoImageView?.layoutIfNeeded()
      (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
    })
  }
  
  func initView() {
    contentView.snp.makeConstraints {
      $0.width.equalTo(width375(375.0))
    }
    
    let photoImageView = UIImageView()
    self.photoImageView = photoImageView
    contentView.addSubview(photoImageView)
    photoImageView.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(height667(16.0))
      $0.centerX.equalTo(contentView)
      $0.width.equalTo(width375(272.0))
    }
    photoImageViewHeightConstrant = photoImageView.heightAnchor.constraint(
      equalToConstant: height667( 12.0 ))
    photoImageViewHeightConstrant?.isActive = true
    
    let descriptionTextLabel = UILabel()
    descriptionTextLabel.font = UIFont(name: "NanumSquareB", size: 16.0)
    self.descriptionTextLabel = descriptionTextLabel
    contentView.addSubview(descriptionTextLabel)
    descriptionTextLabel.snp.makeConstraints {
      $0.centerX.equalTo(contentView)
      $0.top.equalTo(photoImageView.snp.bottom).offset(height667(16.0))
    }
    
    // normalTopOffset + normalHeight + labelTopOffset + 16.0(labelHeight) <= 122.0
    // 22.0 + 56.0 + 6.0 + 16.0(labelHeight) == 100.0 <= 122.0
    let normalTopOffset = height667(22.0)
    let normalCenterXOffset = width375(63.5)
    let normalHeight = height667(56.0)
    let bigHeight = height667(90.0)
    let smallHeight = height667(50.0)
    let labelTopOffset = height667(8.0)
    
    let supportViewCreateClosure: ((String, String, UIColor)) -> UIButton = { info -> UIButton in
      let (imageName, text, textColor) = info
      let supportImageButton = UIButton()
      supportImageButton.setImage(UIImage(named: imageName), for: .normal)
      self.contentView.addSubview(supportImageButton)
      supportImageButton.snp.makeConstraints {
        $0.width.equalTo(supportImageButton.snp.height)
      }
      
      let supportTextLabel = UILabel()
      supportTextLabel.font = UIFont(name: "NanumSquareB", size: 14.0)
      supportTextLabel.textColor = textColor
      supportTextLabel.text = text
      self.contentView.addSubview(supportTextLabel)
      supportTextLabel.snp.makeConstraints {
        $0.centerX.equalTo(supportImageButton)
        $0.top.equalTo(supportImageButton.snp.centerY).offset((normalHeight/2.0)+labelTopOffset)
      }
      
      return supportImageButton
    }
    
    let heightConstrantCreateClosure: (UIView) -> (NSLayoutConstraint, NSLayoutConstraint) = {
      let normalHeightConstraint = $0.heightAnchor.constraint(equalToConstant: normalHeight)
      normalHeightConstraint.priority = UILayoutPriority(999.0)
      normalHeightConstraint.isActive = true
      
      return (  $0.heightAnchor.constraint(equalToConstant: bigHeight),
                $0.heightAnchor.constraint(equalToConstant: smallHeight) )
    }
    
    let positiveButton = supportViewCreateClosure(
      (imageName: "good_btn", text: "공감", textColor: UIColor(r: 101, g: 184, b: 233)))
    self.positiveButton = positiveButton
    positiveButton.addTarget(self, action: #selector(handleSupportTypeButton), for: .touchUpInside)
    positiveButton.snp.makeConstraints {
      $0.centerX.equalTo(contentView).offset(-normalCenterXOffset)
      $0.centerY.equalTo(descriptionTextLabel.snp.bottom).offset((normalHeight/2.0)+normalTopOffset)
    }
    
    let (positiveBigHeightConstraint, positiveSmallHeightConstraint) =
      heightConstrantCreateClosure(positiveButton)
    self.positiveBigHeightConstraint = positiveBigHeightConstraint
    self.positiveSmallHeightConstraint = positiveSmallHeightConstraint
    
    let negativeButton = supportViewCreateClosure(
      (imageName: "bad_btn", text: "비공감", textColor: UIColor(r: 255, g: 112, b: 105)))
    self.negativeButton = negativeButton
    negativeButton.addTarget(self, action: #selector(handleSupportTypeButton), for: .touchUpInside)
    negativeButton.snp.makeConstraints {
      $0.centerX.equalTo(contentView).offset(normalCenterXOffset)
      $0.centerY.equalTo(descriptionTextLabel.snp.bottom).offset((normalHeight/2.0)+normalTopOffset)
    }
    
    let (negativeBigHeightConstraint, negativeSmallHeightConstraint) =
      heightConstrantCreateClosure(negativeButton)
    self.negativeBigHeightConstraint = negativeBigHeightConstraint
    self.negativeSmallHeightConstraint = negativeSmallHeightConstraint
    
    let supportBarView = OptionDetailSupportVersusGaugeBarView()
    self.supportBarView = supportBarView
    contentView.addSubview(supportBarView)
    supportBarView.snp.makeConstraints {
      $0.top.equalTo(descriptionTextLabel.snp.bottom).offset(height667(122.0))
      $0.width.centerX.equalTo(contentView)
      //$0.leading.trailing.equalTo(self)
    }
    
    let whiteView = UIView()
    whiteView.backgroundColor = UIColor.white
    contentView.addSubview(whiteView)
    whiteView.snp.makeConstraints {
      $0.top.equalTo(supportBarView.snp.bottom)
      //$0.leading.trailing.equalTo(self)
      $0.width.centerX.bottom.equalTo(contentView) ///
    }
    
    let commentLabel = UILabel()
    commentLabel.font = UIFont.init(name: "NanumSquareR", size: 14.0)
    commentLabel.textColor = UIColor(r: 44, g: 42, b: 42)
    commentLabel.text = "댓글"
    self.commentLabel = commentLabel
    whiteView.addSubview(commentLabel)
    commentLabel.snp.makeConstraints {
      $0.top.equalTo(whiteView).offset(height667(18.0))
      $0.leading.equalTo(whiteView).offset(width375(16.0))
    }
    
    let commentBorderView = UIView()
    commentBorderView.layer.borderColor = UIColor(r: 188, g: 188, b: 188).cgColor
    commentBorderView.layer.borderWidth = 1.0
    whiteView.addSubview(commentBorderView)
    commentBorderView.snp.makeConstraints {
      $0.top.equalTo(commentLabel.snp.bottom).offset(height667(7.0))
      $0.width.equalTo(whiteView).offset(-width375(16.0 * 2)) ////
      $0.centerX.equalTo(whiteView) ////
      //$0.leading.equalTo(commentLabel)
      //$0.trailing.equalTo(whiteView).offset(-width375(16.0))
      $0.height.equalTo(height667(126.0))////
    }
    
    let commentDescriptionTextView = UITextView()
    commentDescriptionTextView.backgroundColor = .clear
    commentDescriptionTextView.textContainerInset = .zero
    commentDescriptionTextView.textContainer.lineFragmentPadding = 0
    commentDescriptionTextView.allowsEditingTextAttributes = false
    commentDescriptionTextView.isScrollEnabled = true
    commentDescriptionTextView.attributedText = commentDescriptionAttributedString
    commentDescriptionTextView.delegate = self
    self.commentDescriptionTextView = commentDescriptionTextView
    commentBorderView.addSubview(commentDescriptionTextView)
    commentDescriptionTextView.snp.makeConstraints {
      $0.top.equalTo(commentBorderView).offset(height667(16.0))
      $0.width.equalTo(commentBorderView).offset(-width375(15.0 * 2))
      $0.centerX.equalTo(commentBorderView)
      //$0.leading.equalTo(commentBorderView).offset(width375(15.0))
      //$0.trailing.equalTo(commentBorderView).offset(-width375(15.0))
      $0.bottom.equalTo(commentBorderView).offset(-height667(16.0))
    }
    
    let commentTextCountingLabel = UILabel()
    commentTextCountingLabel.font = UIFont.init(name: "NanumSquareR", size: 12.0)
    commentTextCountingLabel.textColor = UIColor(r: 151, g: 151, b: 151)
    commentTextCountingLabel.text = "0/2000"
    self.commentTextCountingLabel = commentTextCountingLabel
    commentBorderView.addSubview(commentTextCountingLabel)
    commentTextCountingLabel.snp.makeConstraints {
      $0.trailing.equalTo(commentBorderView).offset(-width375(8.0))
      $0.bottom.equalTo(commentBorderView).offset(-height667(7.0))
    }
    
    let commentSubmitButton = UIButton()
    commentSubmitButton.setBackgroundImage(UIImage(named: "upload_bg_btn"), for: .normal)
    commentSubmitButton.setTitle("등록", for: .normal)
    commentSubmitButton.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
    whiteView.addSubview(commentSubmitButton)
    commentSubmitButton.snp.makeConstraints {
      $0.top.equalTo(commentBorderView.snp.bottom).offset(height667(10.0))
      $0.centerX.equalTo(whiteView)
      $0.width.equalTo(width375(94.0))
      $0.height.equalTo(height667(34.0))
      $0.bottom.equalTo(whiteView).offset(-height667(26.0))
    }
  }
  
  @objc func handleSupportTypeButton(_ button: UIButton) {
    if button == positiveButton {
      switch supportType {
      case .positive: supportType = .none
      default:        supportType = .positive
      }
    } else if button == negativeButton {
      switch supportType {
      case .negative: supportType = .none
      default:        supportType = .negative
      }
    }
  }
  
  @objc func handleSubmitButton(_ button: UIButton) {
    delegate?.submitCommentDescriptionTextView(
      text: self.commentDescriptionText ?? "", supportType: self.supportType, clearTextClosure: {
      self.commentDescriptionTextView?.text = self.commentDescriptionPlaceholderString
      self.commentDescriptionTextView?.textColor = self.commentDescriptionPlaceholderTextColor
      self.supportType = .none
      if let textView = self.commentDescriptionTextView, textView.isFirstResponder {
        textView.resignFirstResponder()
      }
    })
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}


//MARK: - TopHeaderCell TextViewDelegateEX
extension OptionDetailTopHeaderCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor?.hashValue == commentDescriptionPlaceholderTextColor.hashValue {
      textView.text = ""
      textView.textColor = commentDescriptionTextColor
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: CharacterSet(charactersIn: " \n")).count == 0 {
      textView.text = commentDescriptionPlaceholderString
      textView.textColor = commentDescriptionPlaceholderTextColor
    }
  }
  func textViewDidChange(_ textView: UITextView) {
    commentTextCountingLabel?.text = "\(textView.text.trimmingCharacters(in: CharacterSet(charactersIn: " \n")).count)/2000"
  }
}
