//
//  TopicCreateViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import Alamofire

class TopicCreateViewController: UIViewController {
  
  @IBOutlet weak var backButton: UIButton?
  @IBOutlet weak var titleLabel: UILabel?
  @IBOutlet weak var cancelButton: UIButton?
  @IBOutlet weak var customNaviBarView: UIView?
  
  @IBOutlet weak var scrollView: UIScrollView?
  
  @IBOutlet weak var categoryButton: UIButton?
  @IBOutlet weak var addImageButton: UIButton?
  @IBOutlet weak var addImageLabel: UILabel?
  @IBOutlet weak var imageAreaView: UIView?
  @IBOutlet weak var imageAreaHeightConstraint: NSLayoutConstraint?
  
  @IBOutlet weak var titleTextField: UITextField?
  @IBOutlet weak var titleSeperatorView: UIView?
  
  @IBOutlet weak var stackView: UIStackView?
  @IBOutlet weak var descriptionTextView: UITextView?
  @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint?
  
  @IBOutlet weak var submitButton: UIButton?
  
  lazy var presentFadeInOutManager = PresentFadeInOutManager()
  
  let descriptionPlaceholderAttributedString = NSAttributedString(
    string: "자유롭게 작성해주세요.",
    attributes: [.foregroundColor:UIColor(r: 194, g: 194, b: 194)])
  
  override func viewDidLoad() {
    super.viewDidLoad()

    initView()
  }
  
  @objc func handleButton(_ button: UIButton) {
    if button == backButton {
      self.dismiss(animated: true, completion: nil)
    }else if button == categoryButton {
      let vc = CategorySelectViewController()
      vc.delegate = self
      present(vc, animated: true, transitioningDelegate: presentFadeInOutManager, completion: nil)
    } else if button == addImageButton || button == submitButton {
      let alert = UIAlertController.init(title: nil, message: "준비중입니다.", preferredStyle: .alert)
      alert.addAction(.init(title: "확인", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }
  
  
  
  @objc func handleView(_ sender: UIGestureRecognizer) {
    if let titleTextField = titleTextField, titleTextField.isFirstResponder {
      titleTextField.resignFirstResponder()
    } else if let descriptionTextView = descriptionTextView, descriptionTextView.isFirstResponder {
      descriptionTextView.resignFirstResponder()
    }
  }
  
  func initView(){
    
    view.backgroundColor = .init(r: 246, g: 248, b: 250)
    
    view.addGestureRecognizer(UITapGestureRecognizer(
      target: self, action: #selector(handleView)))
    
    backButton?.imageView?.tintColor = UIColor.init(r: 255, g: 195, b: 75)
    //titleLabel?.text = "글쓰기"
    titleLabel?.textColor = UIColor.init(r: 255, g: 195, b: 75)
    //cancelButton?.setTitle("취소", for: .normal)
    cancelButton?.setTitleColor(.init(r: 191, g: 191, b: 191), for: .normal)
    
    scrollView?.backgroundColor = .init(r: 246, g: 248, b: 250)
    //addImageLabel?.text = "사진은 0~5장까지 추가 가능합니다."
    addImageLabel?.textColor = UIColor.init(r: 154, g: 154, b: 154)
    
    //titleTextField?.placeholder = "제목"
    titleSeperatorView?.backgroundColor = .init(r: 194, g: 194, b: 194)
    descriptionTextView?.textContainer.lineFragmentPadding = 0
    descriptionTextView?.textContainerInset = .init(
      top: 0, left: view.bounds.width * 26.0/375.0, bottom: 0, right: view.bounds.width * 26.0/375.0)
    descriptionTextView?.attributedText = descriptionPlaceholderAttributedString
    descriptionTextView?.allowsEditingTextAttributes = false
    descriptionTextView?.delegate = self
    
    backButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    categoryButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    addImageButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    submitButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
  }
  
}

extension TopicCreateViewController: PresentFadeInOutDelegate {
  func prepareFade(vc: UIViewController, fade: PresentationFade) {
    if fade == .out, let vc = vc as? CategorySelectViewController {
      let category = vc.snapshotCategories[vc.selectedIndex]
      print(category)
    }
  }
}

extension TopicCreateViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if checkPlaceHolder(textView) {
      textView.attributedText = NSAttributedString(
        string: "",
        attributes: [.foregroundColor:UIColor.black])
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: CharacterSet.init(charactersIn: " \n")).count == 0 {
      textView.attributedText = descriptionPlaceholderAttributedString
    }
  }
  func checkPlaceHolder(_ textView: UITextView) -> Bool {
    if  let attrText = textView.attributedText,
      let colorAttr = attrText.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor,
      colorAttr.cgColor.components?[0] == CGFloat(Double(194)/255.0) {
      return true
    }
    return false
  }
}

extension TopicCreateViewController: CategorySelectDelegate {
  func selectedCategory(category: Category?) {
    print("category : ", category)
  }
}
/*
protocol TopicCreateSettingViewDelegate {
  func topicCreateSettingViewDelegate(infoMesssage: String)
  func topicCreateSettingViewDelegate(buttonTag: TopicCreateSettingView.ButtonTag)
}

class TopicCreateSettingView: UIView {
  var delegate: TopicCreateSettingViewDelegate?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  func initView(){
    let titleLabel = UILabel()
    addSubview(titleLabel)
    
    let votableCountLabel = UILabel()
    addSubview(votableCountLabel)
    
    let votableCountInfoButton = UIButton()
    addSubview(votableCountInfoButton)
    
    let votableCountButton = UIButton()
    addSubview(votableCountButton)
    
    let onlyWriterCreateOptionLabel = UILabel()
    addSubview(onlyWriterCreateOptionLabel)
    
    let onlyWriterCreateOptionButton = UIButton()
    addSubview(onlyWriterCreateOptionButton)
    
    let onlyWriterCreateOptionButton = UIButton()
    addSubview(onlyWriterCreateOptionButton)
  }
  
  @objc func handleButtonInfo(_ button: UIButton) {
    guard let buttonTag = ButtonTag(rawValue: button.tag) else {return}
    var message: String
    switch buttonTag {
    case .votableCount:
      message = "3개까지 복수 선택 가능"
    case .onlyWriterCreateOption:
      message = "다른 유저가 랭킹 항목을 추가하게 허용"
    }
    delegate?.topicCreateSettingViewDelegate(infoMesssage: message)
  }
  
  @objc func handleButton(_ button: UIButton) {
    guard let buttonTag = ButtonTag(rawValue: button.tag) else {return}
    delegate?.topicCreateSettingViewDelegate(buttonTag: buttonTag)
  }
  
  public enum ButtonTag: Int {
    case votableCount = 1
    case onlyWriterCreateOption = 2
  }
  
}
 */

/*extension TopicCreateViewController: UITextViewDelegate {
  func textViewDidChangeSelection(_ textView: UITextView) {
    if checkPlaceHolder(textView) {
      let b = textView.beginningOfDocument
      textView.selectedTextRange = textView.textRange(from: b, to: b)
    }
  }
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if checkPlaceHolder(textView) && text.count > 0 {
      textView.attributedText = NSAttributedString(
        string: "", attributes: [.foregroundColor:UIColor.black])
    } else if text.count == 0 && range.location == 0 && range.length == textView.text.count {
      descriptionTextView?.attributedText = descriptionPlaceholderAttributedString
    }
    return true
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if !checkPlaceHolder(textView) &&
      textView.text.trimmingCharacters(in: .init(charactersIn: " \n")).count == 0 {
      descriptionTextView?.attributedText = descriptionPlaceholderAttributedString
    }
  }
  func checkPlaceHolder(_ textView: UITextView) -> Bool {
    if  let attrText = textView.attributedText,
      let colorAttr = attrText.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor,
      colorAttr.cgColor.components?[0] == CGFloat(Double(194)/255.0) {
      return true
    }
    return false
  }
}*/
