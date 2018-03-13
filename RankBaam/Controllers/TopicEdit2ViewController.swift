//
//  TopicEdit2ViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 8..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos

class TopicEditViewController: UIViewController {
  enum EditType {
    case create, modify
    var titleLabelString: String {
      switch self {
      case .create: return "글쓰기"
      case .modify: return "내 글 관리"
    }}
    var submitButtonString: String {
      switch self {
      case .create: return "글 등록하기"
      case .modify: return "글 수정하기"
    }}
  }
  private(set) var editType: EditType = .create
  
  private let CellInfo = (type: TopicEditOptionCell.self, identifier: "cell")
  
  private var presenter = TopicEditPresenter()
  
  weak var collectionView: UICollectionView?
  weak var submitButton: UIButton?
  var presentFadeInOutManager = PresentFadeInOutManager()
  
  static func create(topicSN: Int) -> TopicEditViewController {
    let vc = TopicEditViewController()
    vc.editType = .modify
    vc.presenter.dataManager.topicSN = topicSN
    return vc
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initView()
    registEvent()
    presenter.delegate = self
    presenter.collectionView = self.collectionView
    
    if editType == .modify {
      guard let topicSN = presenter.dataManager.topicSN
        else { assertionFailure("topicSN is nil"); return }
      presenter.networkManager.requestTopicRead(topicSN: topicSN)
    }
  }
  
  func updateSubmitButtonColor(isActive: Bool) {
    submitButton?.backgroundColor =
      isActive ? UIColor(r: 255, g: 195, b: 75) : UIColor(r: 112, g: 112, b: 112)
  }
}

extension TopicEditViewController {
  func registEvent(){
    view.addGestureRecognizer(UITapGestureRecognizer(
      target: self, action: #selector(resignSubViewsFirstResponder)))
    
    NotificationCenter.default.addObserver(self,
     selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self,
     selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  @objc func resignSubViewsFirstResponder(_ sender: UITapGestureRecognizer) {
    /*if let responder = collectionViewManager.firstResponder {
      responder.resignFirstResponder()
    }*/
  }
  
  @objc func keyboardWillShow(_ noti: Notification){
    guard let collectionView = collectionView,
      let keyboardFrameHeight = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height else {return}
    
    collectionView.contentInset = .init(top: 0, left: 0,
                                        bottom: keyboardFrameHeight, right: 0)
    
    //collectionViewManager.collectionViewScrollForFirstResponder()
  }
  
  @objc func keyboardWillHide(_ noti: Notification){
    collectionView?.contentInset = .zero
  }
  
  @objc private func handleBackButton(_ button: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
}

extension TopicEditViewController: TopicEditPresenterDelegate {
  func pushViewController(_ viewController: UIViewController, animated: Bool) {
    (self.presentingViewController as? UINavigationController)?.pushViewController(viewController, animated: animated)
  }
  
  func changeValue(isSubmittable: Bool) {
    updateSubmitButtonColor(isActive: isSubmittable)
  }
  
  func presentFade(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (()->Void)?) {
    viewControllerToPresent.transitioningDelegate = presentFadeInOutManager
    viewControllerToPresent.modalPresentationStyle = .custom
    present(viewControllerToPresent, animated: animated, completion: completion)
  }
}

extension TopicEditViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.isSubmittable ? 1 : 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.isSubmittable ? presenter.dataManager.options.count : 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CellInfo.identifier, for: indexPath)
    
    if let cell = cell as? TopicEditOptionCell {
      cell.row = indexPath.row
      cell.delegate = presenter
      if presenter.dataManager.options.count > indexPath.row {
        cell.textField?.text = presenter.dataManager.options[indexPath.row].text
        cell.initImage()
        if let imageView = cell.imageView {
          presenter.dataManager.options[indexPath.row].imageData?.imageView = imageView
        }
      } else {
        cell.initImage()
      }
    }
    
    return cell
  }
}

extension TopicEditViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: width375(343.0), height: height667(72.0))
  }
}

extension TopicEditViewController {
  @objc private func handleTapSubmitButton(_ button: UIButton) {
    if presenter.isSubmittable {
      presenter.submit(editType: editType)
    }
  }
}

extension TopicEditViewController {
  private func initView(){
    self.view.backgroundColor = .init(r: 246, g: 248, b: 250)
    
    let customNaviBarView = UIView()
    self.view.addSubview(customNaviBarView)
    customNaviBarView.backgroundColor = .white
    customNaviBarView.isUserInteractionEnabled = true
    customNaviBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(height667(56.0) + UIApplication.shared.statusBarFrame.height )
    }
    
    let backButton = UIButton()
    let padding = width375(10.0)
    let backButtonImage = UIImage(named: "ic_keyboard_backspace")?
      .copy(
        with: .init(top: padding, left: padding, bottom: padding, right: padding),
        isTemplate: true)
    backButton.setImage(backButtonImage, for: .normal)
    backButton.imageView?.tintColor = UIColor(r: 255, g: 195, b: 75)
    customNaviBarView.addSubview(backButton)
    backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(width375(6.0))
      $0.bottom.equalToSuperview()
      $0.width.equalTo(width375(44.0))
      $0.height.equalTo(backButton.snp.width)
    }
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont(name: "NanumSquareB", size: 16.0)
    titleLabel.textColor = UIColor(r: 255, g: 195, b: 75)
    titleLabel.text = editType.titleLabelString
    customNaviBarView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(backButton.snp.trailing).offset(width375(6.0))
      $0.bottom.equalToSuperview().offset(-height667(13.0))
    }
    
    let cancelButton = UIButton()
    if let font = UIFont(name: "NanumSquareB", size: 16.0) {
      let attributedText = NSAttributedString(
        string: "취소",
        attributes: [
          .foregroundColor: UIColor(r: 191, g: 191, b: 191),
          .font: font
        ])
      cancelButton.setAttributedTitle(attributedText, for: .normal)
    }
    customNaviBarView.addSubview(cancelButton)
    cancelButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    cancelButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-width375(3.0))
      $0.bottom.equalToSuperview()
      $0.width.equalTo(width375(56.0))
      $0.height.equalTo(height667(44.0))
    }
    
    let layout = StaticHeaderFooterFlowLayout()
    let collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: layout)
    
    collectionView.backgroundColor = .init(r: 246, g: 248, b: 250)
    collectionView.alwaysBounceHorizontal = false
    collectionView.alwaysBounceVertical = true
    collectionView.showsVerticalScrollIndicator = false
    
    let topView = TopicEditTopView(frame:
      .init(x: 0, y: 0, width: view.bounds.width, height: 0))
    presenter.topView = topView
    let _ = topView.updateFrameHeight()
    collectionView.addSubview(topView)
    layout.staticHeaderView = topView
    
    let bottomView = TopicEditBottomView()
    presenter.bottomView = bottomView
    bottomView.isHidden = true
    bottomView.frame.size = bottomView.systemLayoutSizeFitting(
      .init(width: view.bounds.width, height: 0))
    collectionView.addSubview(bottomView)
    layout.staticFooterView = bottomView
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(CellInfo.type, forCellWithReuseIdentifier: CellInfo.identifier)
    
    self.collectionView = collectionView
    self.view.insertSubview(collectionView, at: 0)
    collectionView.snp.makeConstraints{
      $0.top.equalTo(customNaviBarView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    let submitButton = UIButton()
    let font = UIFont(name: "NanumSquareB", size: 16.0) ??
      UIFont.systemFont(ofSize: 16.0)
    submitButton.setAttributedTitle(.init(
      string: editType.submitButtonString,
      attributes: [
        .font: font,
        .foregroundColor: UIColor(r: 77, g: 77, b: 77)
      ]), for: .normal)
    submitButton.addTarget(self, action: #selector(handleTapSubmitButton), for: .touchUpInside)
    self.submitButton = submitButton
    self.updateSubmitButtonColor(isActive: false)
    self.view.addSubview(submitButton)
    submitButton.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(height667(56.0))
    }
    
    submitButton.isEnabled = false
  }
}
