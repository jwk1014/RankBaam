//
//  TopicEditTopView.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 26..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos
import SnapKit

protocol TopicEditTopViewDelegate: class {
  func topViewHandleTapCategory()
  func topViewHandleTapAddImage()
  func topViewValueUpdate(title: String)
  func topViewValueUpdate(description: String)
  func topViewValueRemove(index: Int)
}

protocol TopicEditTopViewProtocol {
  var firstResponder: UIResponder? { get }
  var isVisibleAddButton: Bool { get set }
  var countImageViews: Int { get }
  var isVisibleImageArea: Bool { get set }
  var isVisibleButtomArea: Bool { get set }
  var isNeedFrameHeightUpdate: Bool { get }
  
  func setValue(categoryName: String?)
  func setValue(title: String)
  func setValue(description: String)
  
  func resetImages(imageBindDatas: [ImageBindData])
}

class TopicEditTopView: UIView, TopicEditTopViewProtocol{
  
  private let imagesAreaScrollViewHeight = height667(170.0)
  
  weak var delegate: TopicEditTopViewDelegate?
  
  private var descriptionPlaceholderString: String {
    return "자유롭게 작성해주세요."
  }
  
  private var descriptionPlaceholderTextColor: UIColor {
    return .init(r: 154, g: 154, b: 154)
  }
  
  private var descriptionTextColor: UIColor {
    return .init(r: 77, g: 77, b: 77)
  }
  
  private weak var categoryButton: UIButton?
  private weak var addImageButton: UIButton?
  private weak var imagesAreaScrollView: UIScrollView?
  private weak var imageAreaStackView: UIStackView?
  private weak var titleTextField: UITextField?
  private weak var descriptionTextView: UITextView?
  private weak var descriptionSeperatorView: UIView?
  private weak var optionsLabel: UILabel?
  
  private(set) weak var firstResponder: UIResponder?
  
  private var addImageButtonZeroWidthConstraint: NSLayoutConstraint?
  private var addImageLabelZeroLeadingOffsetConstraint: NSLayoutConstraint?
  private var imagesAreaScrollViewHeightConstraint: NSLayoutConstraint?
  
  var isVisibleAddButton: Bool = true {
    didSet {
      if oldValue != isVisibleAddButton {
        addImageButtonZeroWidthConstraint?.isActive = !isVisibleAddButton
        addImageLabelZeroLeadingOffsetConstraint?.isActive = !isVisibleAddButton
      }
    }
  }
  
  var countImageViews: Int {
    return imageAreaStackView?.arrangedSubviews.count ?? 0
  }
  
  var isVisibleImageArea: Bool = false {
    didSet {
      if oldValue != isVisibleImageArea {
        imagesAreaScrollViewHeightConstraint?.isActive = isVisibleImageArea
      }
    }
  }
  
  var isVisibleButtomArea: Bool = false {
    didSet {
      if oldValue != isVisibleButtomArea {
        descriptionSeperatorView?.isHidden = !isVisibleButtomArea
        optionsLabel?.isHidden = !isVisibleButtomArea
      }
    }
  }
  
  var isNeedFrameHeightUpdate: Bool {
    return bounds.height != realHeight
  }
  
  var realHeight: CGFloat {
    if let lastView = subviews.last {
      setNeedsLayout()
      layoutIfNeeded()
      return lastView.frame.maxY + 10.0
    }
    return 0
  }
  
  func updateFrameHeight() -> Bool {
    let realheight = self.realHeight
    if bounds.height != realheight {
      frame.size.height = realheight
      return true
    }
    return false
  }
  
  func setValue(title: String) {
    titleTextField?.text = title
  }
  
  func setValue(description: String) {
    descriptionTextView?.text = description
  }
  
  func setValue(categoryName: String?) {
    if let categoryName = categoryName {
      if let image = UIImage(named: "category_resizable_btn") {
        if let font = UIFont(name: "NanumSquareB", size: 14.0) {
          categoryButton?.setAttributedTitle(NSAttributedString(
            string: categoryName,
            attributes: [
              .font: font,
              .foregroundColor: UIColor(r: 250, g: 84, b: 76)
            ]), for: .normal)
        }
        categoryButton?.setBackgroundImage(
          image.resizableImage(withCapInsets: .init(
            top: image.size.height/2,
            left: image.size.width/2,
            bottom: image.size.height/2,
            right: image.size.width/2), resizingMode: .tile),
          for: .normal)
      }
    } else {
      categoryButton?.setAttributedTitle(NSAttributedString(
        string: " ",
        attributes: [
          .foregroundColor: UIColor.white
        ]), for: .normal)
      categoryButton?.setBackgroundImage(UIImage(named: "category_btn"), for: .normal)
    }
  }
  
  func resetImages(imageBindDatas: [ImageBindData]) {
    guard let imageAreaStackView = imageAreaStackView else { return }
    let dataCount = imageBindDatas.count
    let subViewCount = imageAreaStackView.arrangedSubviews.count
    let minCount = min(dataCount, subViewCount)
    for i in 0..<minCount {
      imageBindDatas[i].imageView = imageAreaStackView.arrangedSubviews[i] as? UIImageView
    }
    if dataCount < subViewCount {
      imageAreaStackView.arrangedSubviews[minCount...].forEach{
        $0.removeFromSuperview()
      }
    } else if dataCount > subViewCount {
      for i in subViewCount..<dataCount {
        if let imageView = createImageView() {
          imageBindDatas[i].imageView = imageView
        }
      }
    }
  }
  
  private func createImageView() -> UIImageView? {
    
    guard let imageAreaStackView = imageAreaStackView
      else { assertionFailure(); return nil }
    
    let imageView = UIImageView()
    imageAreaStackView.addArrangedSubview(imageView)
    imageView.layer.cornerRadius = 10.0
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    
    imageView.snp.makeConstraints{
      $0.top.bottom.equalToSuperview()
      $0.height.equalTo(imagesAreaScrollViewHeight)
    }
    imageView.isUserInteractionEnabled = true
    
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "group3"), for: .normal)
    imageView.addSubview(button)
    button.addTarget(self, action: #selector(handleTapRemoveButtonInImageArea), for: .touchUpInside)
    button.snp.makeConstraints {
      $0.top.equalToSuperview().offset(width375(6.0))
      $0.trailing.equalToSuperview().offset(-width375(6.0))
      $0.width.equalTo(width375(30.0))
      $0.height.equalTo(button.snp.width)
    }
    
    return imageView
  }
  
  @objc private func handleTapRemoveButtonInImageArea(_ sender: UIButton) {
    guard let imageView = (sender.superview as? UIImageView),
          let imageAreaStackView = imageAreaStackView else {return}
    let index = imageAreaStackView.arrangedSubviews.index(where: { $0 == imageView })
    imageView.removeFromSuperview()
    
    if let index = index {
      delegate?.topViewValueRemove(index: index)
    }
  }
  
  @objc private func handleTapCategory(){
    delegate?.topViewHandleTapCategory()
  }
  
  @objc private func handleTapAddImage(){
    delegate?.topViewHandleTapAddImage()
  }
  
  private func initView(){
    
    let categoryButton = UIButton()
    categoryButton.setBackgroundImage(UIImage(named: "category_btn"), for: .normal)
    categoryButton.addTarget(self, action: #selector(handleTapCategory), for: .touchUpInside)
    self.categoryButton = categoryButton
    self.addSubview(categoryButton)
    categoryButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(height667(24.0))
      $0.leading.equalToSuperview().offset(width375(26.0))
      $0.width.equalTo(width375(126.0))
      $0.height.equalTo(height667(34.0))
    }
    
    let addImageButton = UIButton()
    addImageButton.setImage(UIImage(named: "image_plus_btn"), for: .normal)
    addImageButton.addTarget(self, action: #selector(handleTapAddImage), for: .touchUpInside)
    self.addImageButton = addImageButton
    self.addSubview(addImageButton)
    addImageButton.snp.makeConstraints {
      $0.top.equalTo(categoryButton.snp.bottom)
        .offset(height667(16.0))
      $0.leading.equalTo(categoryButton)
      $0.width.equalTo(width375(102.0)).priority(ConstraintPriority(800))
      $0.height.equalTo(height667(34.0))
    }
    
    addImageButtonZeroWidthConstraint = addImageButton.widthAnchor.constraint(equalToConstant: 0.0)
    addImageButtonZeroWidthConstraint?.priority = .required
    addImageButtonZeroWidthConstraint?.isActive = false
    
    let addImageLabel = UILabel()
    addImageLabel.text = "사진은 0~5장까지 추가 가능합니다."
    addImageLabel.font = UIFont(name: "NanumSquareR", size: 12.0)
    addImageLabel.textColor = UIColor(r: 154, g: 154, b: 154)
    self.addSubview(addImageLabel)
    
    addImageLabel.snp.makeConstraints {
      $0.leading.equalTo(addImageButton.snp.trailing).offset(10.0).priority(.high)
      $0.centerY.equalTo(addImageButton)
    }
    
    addImageLabelZeroLeadingOffsetConstraint = addImageLabel.leadingAnchor.constraint(equalTo: addImageButton.trailingAnchor)
    addImageLabelZeroLeadingOffsetConstraint?.priority = .required
    addImageLabelZeroLeadingOffsetConstraint?.isActive = false
    
    let imagesAreaScrollView = UIScrollView()
    imagesAreaScrollView.showsHorizontalScrollIndicator = false
    imagesAreaScrollView.showsVerticalScrollIndicator = false
    imagesAreaScrollView.alwaysBounceVertical = false
    imagesAreaScrollView.contentInset = .init(
      top: 0, left: width375(24.0),
      bottom: 0, right: width375(24.0))
    self.imagesAreaScrollView = imagesAreaScrollView
    self.addSubview(imagesAreaScrollView)
    imagesAreaScrollView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(addImageButton.snp.bottom).offset(height667(21.0))
      $0.height.equalTo(0).priority(ConstraintPriority.high)
    }
    imagesAreaScrollViewHeightConstraint = imagesAreaScrollView.heightAnchor.constraint(equalToConstant: imagesAreaScrollViewHeight)
    imagesAreaScrollViewHeightConstraint?.priority = .required
    imagesAreaScrollViewHeightConstraint?.isActive = false
    
    let imageAreaStackView = UIStackView()
    imageAreaStackView.axis = .horizontal
    imageAreaStackView.alignment = .fill
    imageAreaStackView.distribution = .fillProportionally
    imageAreaStackView.spacing = width375(8.0)
    self.imageAreaStackView = imageAreaStackView
    imagesAreaScrollView.addSubview(imageAreaStackView)
    imageAreaStackView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    let titleTextField = UITextField()
    titleTextField.autocapitalizationType = .none
    titleTextField.autocorrectionType = .no
    if let font = UIFont(name: "NanumSquareR", size: 16.0) {
      titleTextField.attributedPlaceholder = NSAttributedString(
        string: "제목",
        attributes: [
          .foregroundColor: UIColor(r: 154, g: 154, b: 154),
          .font: font
        ])
    }
    if let font = UIFont(name: "NanumSquareB", size: 16.0) {
      titleTextField.attributedText = NSAttributedString(
        string: "",
        attributes: [
          .foregroundColor: UIColor(r: 77, g: 77, b: 77),
          .font: font
        ])
    }
    titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    titleTextField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
    titleTextField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
    self.titleTextField = titleTextField
    self.addSubview(titleTextField)
    titleTextField.snp.makeConstraints {
      $0.top.equalTo(imagesAreaScrollView.snp.bottom)
        .offset(height667(23.0))
      $0.leading.equalTo(categoryButton)
      $0.width.equalTo(width375(323.0))
    }
    
    let titleSeperatorView = UIView()
    titleSeperatorView.backgroundColor = .init(r: 194, g: 194, b: 194)
    self.addSubview(titleSeperatorView)
    titleSeperatorView.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom)
        .offset(height667(6.0))
      $0.leading.equalTo(titleTextField)
      $0.trailing.equalTo(titleTextField)
      $0.height.equalTo(height667(2.0))
    }
    
    let descriptionTextView = UITextView()
    descriptionTextView.backgroundColor = .clear
    descriptionTextView.textContainer.lineFragmentPadding = 0
    descriptionTextView.allowsEditingTextAttributes = false
    descriptionTextView.isScrollEnabled = false
    descriptionTextView.delegate = self
    if let font = UIFont(name: "NanumSquareR", size: 16.0) {
      descriptionTextView.attributedText =
        NSAttributedString( string: descriptionPlaceholderString,
                    attributes: [
                      .font: font,
                      .foregroundColor: descriptionPlaceholderTextColor
        ])
    }
    
    self.descriptionTextView = descriptionTextView
    self.addSubview(descriptionTextView)
    descriptionTextView.snp.makeConstraints {
      $0.top.equalTo(titleSeperatorView.snp.bottom)
        .offset(height667(26.0))
      $0.leading.trailing.equalTo(titleTextField)
    }
    
    let descriptionSeperatorView = UIView()
    descriptionSeperatorView.backgroundColor = .init(r: 233, g: 233, b: 233)
    descriptionSeperatorView.isHidden = true
    self.descriptionSeperatorView = descriptionSeperatorView
    self.addSubview(descriptionSeperatorView)
    descriptionSeperatorView.snp.makeConstraints {
      $0.top.equalTo(descriptionTextView.snp.bottom)
        .offset(height667(46.0))
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(height667(2.0))
    }
    
    let optionsLabel = UILabel()
    optionsLabel.text = "랭킹 항목 추가 / 사진 생략 가능"
    optionsLabel.font = UIFont(name: "NanumSquareB", size: 16.0)
    optionsLabel.textColor = UIColor(r: 112, g: 112, b: 112)
    optionsLabel.isHidden = true
    self.optionsLabel = optionsLabel
    self.addSubview(optionsLabel)
    optionsLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionSeperatorView.snp.bottom)
        .offset(height667(24.0))
      $0.leading.equalTo(titleTextField)
    }
    
    clipsToBounds = true
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}

extension TopicEditTopView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    firstResponder = textView
    if textView.textColor?.hashValue == descriptionPlaceholderTextColor.hashValue {
      textView.text = ""
      textView.textColor = descriptionTextColor
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if firstResponder == textView {
      firstResponder = nil
    }
    if textView.text.trimmingCharacters(in: CharacterSet(charactersIn: " \n")).count == 0 {
      textView.text = descriptionPlaceholderString
      textView.textColor = descriptionPlaceholderTextColor
    }
  }
  func textViewDidChange(_ textView: UITextView) {
    delegate?.topViewValueUpdate(description:
      textView.text.trimmingCharacters(in: CharacterSet(charactersIn: " \n")))
  }
}

extension TopicEditTopView {
  @objc func textFieldDidBeginEditing(_ textField: UITextField) {
    firstResponder = textField
  }
  @objc func textFieldDidEndEditing(_ textField: UITextField) {
    if firstResponder == textField {
      firstResponder = nil
    }
  }
  @objc func textFieldDidChange(_ textField: UITextField) {
    delegate?.topViewValueUpdate(title:
      textField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " \n")) ?? "")
  }
}
