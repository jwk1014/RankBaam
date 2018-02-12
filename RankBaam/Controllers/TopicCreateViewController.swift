//
//  TopicCreateViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit


fileprivate enum TopicCreateButtonTag: Int {
  case back = 1
  case cancel = 2
  case category = 3
  case addImage = 4
  case optionAdd = 5
  case submit = 6
}

class TopicCreateViewController: UIViewController, TopicCreateViewControllerCallback {
  typealias OptionCellData = (image: UIImage?, text: String?)
  var topicCategory: Category? = nil
  var topicTitle: String? = nil
  var topicDescription: String? = nil
  //var topicIsOnlyWriterCreateOption = false
  //var topicVotableCountPerUser = false
  
  weak var flowLayout: UICollectionViewFlowLayout?
  weak var collectionView: UICollectionView?
  
  weak var headerView: TopicCreateHeaderView?
  weak var footerView: TopicCreateFooterView?
  
  var isVisible = false {
    didSet{
      headerView?.descriptionSeperatorView?.isHidden = !isVisible
      headerView?.optionsLabel?.isHidden = !isVisible
      
      if isVisible {
        if optionCount > 0 {
          collectionView?.insertItems(at: Array(0..<optionCount).map({IndexPath(row: $0, section: 0)}))
        }
      } else {
        if let count = collectionView?.visibleCells.count, count > 0 {
          collectionView?.deleteItems(at: Array(0..<optionCount).map({IndexPath(row: $0, section: 0)}))
        }
      }
    }
  }
  
  var textViewDelegate: UITextViewDelegate { return self }
  var textFieldDelegate: UITextFieldDelegate { return self }
  
  var optionCellDatas = [OptionCellData?]()
  var optionCount = 0
  
  let topicCreateOptionCellTextFieldDelegateManager = TopicCreateOptionCellTextFieldDelegateManager()
  
  var descriptionAttributedString: NSAttributedString? {
    if let font = UIFont(name: "NanumSquareR", size: 16.0) {
      return .init( string: descriptionPlaceholderString,
                    attributes: [
                      .font: font,
                      .foregroundColor: descriptionPlaceholderTextColor
        ])
    }
    return nil
  }
  
  var descriptionPlaceholderString: String {
    return "자유롭게 작성해주세요."
  }
  
  var descriptionPlaceholderTextColor: UIColor {
    return .init(r: 154, g: 154, b: 154)
  }
  
  var descriptionTextColor: UIColor {
    return .init(r: 77, g: 77, b: 77)
  }
  
  @objc func handleButton(_ button: UIButton) {
    guard let buttonTag = TopicCreateButtonTag(rawValue: button.tag) else {return}
    switch buttonTag {
    case .back, .cancel:
      self.dismiss(animated: true, completion: nil)
    case .category:
      let vc = CategorySelectViewController()
      if  let topicCategory = topicCategory,
          let index = categories.index(where: {topicCategory.categorySN == $0.categorySN}) {
        vc.selectedIndex = index
      }
      vc.delegate = self
      present(vc, animated: true, transitioningDelegate: presentFadeInOutManager, completion: nil)
    case .optionAdd:
      optionCount += 1
      collectionView?.insertItems(at: [IndexPath(row: optionCount-1, section: 0)])
    case .addImage:
      let picker = UIImagePickerController()
      picker.delegate = self
      present(picker, animated: true, completion: nil)
    case .submit:
      let alertClosure = { (_ message: String,_ handler: ((UIAlertAction)->Void)? ) in
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "확인", style: .cancel, handler: handler))
        self.present(alert, animated: true, completion: nil)
      }
      
      guard let topicCategory = topicCategory else {
        alertClosure("카테고리를 선택해주세요.", nil)
        return
      }
      
      guard let title = (headerView != nil) ? headerView?.titleTextField?.text : self.topicTitle,
            title.count > 0 else {
        alertClosure("제목을 입력해주세요.") { _ in
          self.headerView?.titleTextField?.becomeFirstResponder()
        }
        return
      }
      
      guard title.count >= 5 else {
        alertClosure("제목은 5자 이상이여야 합니다.") { _ in
          self.headerView?.titleTextField?.becomeFirstResponder()
        }
        return
      }
      
      let description = (headerView != nil) ? headerView?.descriptionTextView?.text : self.topicDescription
      
      let isOnlyWriterCreateOption = footerView?.settingView?.isOnlyWriterCreateOption ?? false
      
      let isVotableCountPerUser = footerView?.settingView?.isVotableCount ?? false
      
      let topicWrite = TopicWrite.init(
        topicSN: nil,
        category: topicCategory,
        title: title,
        description: description ?? "",
        isOnlyWriterCreateOption: isOnlyWriterCreateOption,
        votableCountPerUser: (isVotableCountPerUser) ? 3 : 1)
      
      TopicService.create(topicWrite: topicWrite) {
        switch($0.result) {
          
        case .success(let sResult):
          if sResult.succ {
            guard let topicSN = sResult.topicSN else { return }
            
            let topicDetailClosure = {
              let vc = TopicDetailViewController()
              vc.topicSN = topicSN
              (self.presentingViewController as? UINavigationController)?.pushViewController(vc, animated: false)
              self.dismiss(animated: true, completion: nil)
            }
            
            if let collectionView = self.collectionView, self.optionCount > 0 {
              var optionCellDatas = self.optionCellDatas
              Array(0..<self.optionCount)
                .map({IndexPath(row: $0, section: 0)})
                .flatMap(collectionView.cellForItem)
                .flatMap({$0 as? TopicCreateOptionCell})
                .filter({$0.index >= 0})
                .forEach{ cell in
                  if optionCellDatas.count-1 < cell.index {
                    optionCellDatas += Array<OptionCellData?>(repeating: nil,
                      count: cell.index+1-optionCellDatas.count)
                  }
                  optionCellDatas[cell.index] = OptionCellData(
                    image: (cell.imageView?.tag != 0) ? cell.imageView?.image : nil,
                    text: cell.textField?.text)
                }
              
              //TODO
              var options = optionCellDatas
                .filter({$0 != nil})
                .map({$0!})
                .filter({$0.text != nil && $0.text!.count > 0})
                .map({ optionCellData in
                  return OptionWrite.init(topicSN: topicSN, optionSN: nil, title: optionCellData.text!, description: nil)
                })
              
              if options.count > 0 {
                
                var optionCreateResponseClosure: ((DataResponse<SResultOptionCreate>) -> Void)!
                optionCreateResponseClosure = {
                  switch($0.result) {
                    
                  case .success(let sResult):
                    if sResult.succ {
                      if options.count > 0 {
                        OptionService.create(
                          optionWrite: options.remove(at: 0),
                          completion: optionCreateResponseClosure)
                      } else {
                        topicDetailClosure()
                      }
                    } else if let msg = sResult.msg {
                      switch msg {
                      default:
                        break
                      }
                      topicDetailClosure()
                    }
                    break
                  case .failure(let error):
                    if let error = error as? SolutionProcessableProtocol {
                      error.handle(self)
                    }
                    topicDetailClosure()
                  }
                }
                
                OptionService.create(
                  optionWrite: options.remove(at: 0),
                  completion: optionCreateResponseClosure)
                
                return
              }
              
            }
            
            topicDetailClosure()
            
          } else if let msg = sResult.msg {
            switch msg {
            case "TitleExists":
              alertClosure("같은 제목을 가진 랭킹 주제가 존재합니다.") { _ in
                self.headerView?.titleTextField?.becomeFirstResponder()
              }
            default:
              break
            }
          }
          
        case .failure(let error):
          if let error = error as? SolutionProcessableProtocol {
            error.handle(self)
          }
        }
      }
    }
  }
  
  func resignSubViewsFirstResponder() {
    if let titleTextField = headerView?.titleTextField, titleTextField.isFirstResponder {
      titleTextField.resignFirstResponder()
    } else if let descriptionTextView = headerView?.descriptionTextView, descriptionTextView.isFirstResponder {
      descriptionTextView.resignFirstResponder()
    } else if let textField = topicCreateOptionCellTextFieldDelegateManager.textField, textField.isFirstResponder {
      textField.resignFirstResponder()
    }
  }
  
  @objc func handleView(_ sender: UIGestureRecognizer) {
    resignSubViewsFirstResponder()
  }
  
  lazy var presentFadeInOutManager: PresentFadeInOutManager = PresentFadeInOutManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }
  
  func initView(){
    //MARK: For iPhone X
    let topSpaceLayer = CALayer()
    topSpaceLayer.backgroundColor = UIColor.white.cgColor
    topSpaceLayer.frame = .init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 76.0/667.0)
    view.layer.addSublayer(topSpaceLayer)
    
    //MARK: CustomNaviBarView
    let customNaviBarView = UIView()
    view.addSubview(customNaviBarView)
    customNaviBarView.backgroundColor = .white
    customNaviBarView.isUserInteractionEnabled = true
    customNaviBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view)
      $0.height.equalTo(self.view.bounds.height * 76.0/667.0)
    }
    
    let backButton = UIButton()
    let padding = self.view.bounds.width * 10.0/375.0
    let backButtonImage = UIImage(named: "ic_keyboard_backspace")?.copy(with: .init(top: padding, left: padding, bottom: padding, right: padding), isTemplate: true)
    backButton.setImage(backButtonImage, for: .normal)
    backButton.imageView?.tintColor = UIColor(r: 255, g: 195, b: 75)
    customNaviBarView.addSubview(backButton)
    backButton.tag = TopicCreateButtonTag.back.rawValue
    backButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    backButton.snp.makeConstraints {
      $0.leading.equalTo(customNaviBarView).offset(self.view.bounds.width * 6.0/375.0)
      $0.bottom.equalTo(customNaviBarView)
      $0.width.equalTo(self.view.bounds.width * 44.0/375.0)
      $0.height.equalTo(backButton.snp.width)
    }
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont(name: "NanumSquareB", size: 16.0)
    titleLabel.textColor = UIColor(r: 255, g: 195, b: 75)
    titleLabel.text = "글쓰기"
    customNaviBarView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(backButton.snp.trailing).offset(self.view.bounds.width * 6.0/375.0)
      $0.bottom.equalTo(customNaviBarView).offset(-(self.view.bounds.height * 13.0/667.0))
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
    cancelButton.tag = TopicCreateButtonTag.cancel.rawValue
    cancelButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    cancelButton.snp.makeConstraints {
      $0.trailing.equalTo(customNaviBarView).offset(-(self.view.bounds.width * 3.0/375.0))
      $0.bottom.equalTo(customNaviBarView)
      $0.width.equalTo(self.view.bounds.width * 56.0/375.0)
      $0.height.equalTo(self.view.bounds.height * 44.0/667.0)
    }
    
    //MARK: View & CollectionView
    view.backgroundColor = .init(r: 246, g: 248, b: 250)
    
    view.addGestureRecognizer(UITapGestureRecognizer(
      target: self, action: #selector(handleView)))
    
    let flowLayout = UICollectionViewFlowLayout()
    self.flowLayout = flowLayout
    let collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: flowLayout)
    collectionView.backgroundColor = .init(r: 246, g: 248, b: 250)
    collectionView.alwaysBounceHorizontal = false
    collectionView.alwaysBounceVertical = true
    collectionView.showsVerticalScrollIndicator = false
    self.collectionView = collectionView
    view.insertSubview(collectionView, at: 0)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.snp.makeConstraints{
      $0.top.equalTo(customNaviBarView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self.view)
    }
    
    collectionView.register(TopicCreateOptionCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.register(TopicCreateHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    collectionView.register(TopicCreateFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
  }
  
  func checkHeader(title: String?, description: String?){
    let title = title ?? headerView?.titleTextField?.text
    /*let description = description ??
      ((headerView?.descriptionTextView?.textColor?.hashValue != descriptionPlaceholderTextColor.hashValue) ?headerView?.descriptionTextView?.text : nil)*/
    let isVisible = (topicCategory != nil && title != nil && /*description != nil &&*/
      title!.trimmingCharacters(in: .init(charactersIn: " \n")).count > 0) /*&&
      description!.trimmingCharacters(in: .init(charactersIn: " \n")).count > 0*/
    if self.isVisible != isVisible {
      self.isVisible = isVisible
      //if description != nil {
        flowLayout?.invalidateLayout()
      //}
    }
  }
  
}

extension TopicCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      if let imageAreaStackView = headerView?.imageAreaStackView {
        let imageView = UIImageView()
        imageView.image = image
        imageAreaStackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints{
          $0.width.equalTo(image.size.width * (view.bounds.height * 121.0 / 667.0) / image.size.height)
          $0.height.equalTo(imageAreaStackView)
        }
        if imageAreaStackView.arrangedSubviews.count == 1 {
          headerView?.constraintImagesAreaScrollView?.constraint.layoutConstraints.first?.constant =
            imageAreaStackView.bounds.height
          flowLayout?.invalidateLayout()
        }
      }
    }
    picker.dismiss(animated: true, completion: nil)
  }
}

/*extension TopicCreateViewController: PresentFadeInOutDelegate {
  func prepareFade(vc: UIViewController, fade: PresentationFade) {
    if fade == .out, let vc = vc as? CategorySelectViewController {
    }
  }
}*/

extension TopicCreateViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    resignSubViewsFirstResponder()
  }
}

extension TopicCreateViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (isVisible) ? optionCount : 0
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    if let cell = cell as? TopicCreateOptionCell {
      if  indexPath.row < optionCellDatas.count,
          let optionCellData = optionCellDatas[indexPath.row] {
        if let image = optionCellData.image {
          cell.imageView?.tag = 1
          cell.imageView?.image = image
        } else {
          cell.imageView?.tag = 0
        }
        cell.textField?.text = optionCellData.text
      }
      cell.index = indexPath.row
      cell.delegate = self
      cell.textField?.delegate = topicCreateOptionCellTextFieldDelegateManager
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
      if let headerView = headerView as? TopicCreateHeaderView {
        if self.headerView != headerView {
          headerView.categoryButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
          headerView.addImageButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
          headerView.descriptionTextView?.attributedText = descriptionAttributedString
          headerView.titleTextField?.delegate = self
          headerView.descriptionTextView?.delegate = self
          headerView.descriptionSeperatorView?.isHidden = !isVisible
          headerView.optionsLabel?.isHidden = !isVisible
          headerView.callback = self
          
          if let oldHeaderView = self.headerView {
            print("replace header")
            if let image = oldHeaderView.categoryButton?.backgroundImage(for: .normal) {
              headerView.categoryButton?.setBackgroundImage(image, for: .normal)
              if let attributedTitle = oldHeaderView.categoryButton?.attributedTitle(for: .normal) {
                headerView.categoryButton?.setAttributedTitle(attributedTitle, for: .normal)
              }
            }
            if let title = oldHeaderView.titleTextField?.text {
              headerView.titleTextField?.text = title
            }
            if let description = oldHeaderView.descriptionTextView?.text {
              headerView.descriptionTextView?.textColor = descriptionTextColor
              headerView.descriptionTextView?.text = description
            }
            headerView.isHidden = false
            oldHeaderView.isHidden = true
          }
          
          self.headerView = headerView
        }
      }
      return headerView
    case UICollectionElementKindSectionFooter:
      let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
      if let footerView = footerView as? TopicCreateFooterView {
        if self.footerView != footerView {
          footerView.optionAddButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
          footerView.submitButton?.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
          self.footerView = footerView
        }
      }
      
      footerView.isHidden = !isVisible
      
      return footerView
    default:
      return UICollectionReusableView()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let header = headerView ?? /*collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader).first ??*/
      collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: section)) ??
    collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: IndexPath(row: 0, section: section))
    let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    return .init(width: UIScreen.main.bounds.width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    let footer = footerView ?? /*collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).first ??*/
      collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: IndexPath(row: 0, section: section))
    let height = isVisible ? footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height : 0
    return .init(width: UIScreen.main.bounds.width, height: height)
  }
}

extension TopicCreateViewController: TopicCreateOptionCellDelegate {
  func cellDelegate(index: Int, image: UIImage?, text: String?) {
    if optionCellDatas.count-1 < index {
      optionCellDatas += Array<OptionCellData?>(repeating: nil, count: index+1-optionCellDatas.count)
    }
    optionCellDatas[index] = OptionCellData(image: image, text: text)
  }
  
  func present(vc: UIViewController) {
    present(vc, animated: true, completion: nil)
  }
}

extension TopicCreateViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return self.view.bounds.height * 10.0 / 667.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(
      width: self.view.bounds.width * 343.0 / 375.0,
      height: self.view.bounds.height * 72.0 / 667.0)
  }
}

extension TopicCreateViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    var text = textField.text
    if let text2 = text {
      if let range2 = Range<String.Index>(range, in: text2) {
        text?.replaceSubrange(range2, with: string)
        checkHeader(title: text!, description: nil)
      }
    }
    return true
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " \n")).count == 0 {
      textField.text = ""
    }
  }
}

extension TopicCreateViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor?.hashValue == descriptionPlaceholderTextColor.hashValue {
      textView.text = ""
      textView.textColor = descriptionTextColor
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.trimmingCharacters(in: CharacterSet(charactersIn: " \n")).count == 0 {
      textView.text = descriptionPlaceholderString
      textView.textColor = descriptionPlaceholderTextColor
    }
  }
  func textViewDidChange(_ textView: UITextView) {
    //checkHeader(title: nil, description: textView.text)
    flowLayout?.invalidateLayout()
  }
}

extension TopicCreateViewController: TopicCreateSettingViewDelegate {
  func topicCreateSettingViewDelegate(infoMesssage: String) {
    let alert = UIAlertController.init(title: nil, message: infoMesssage, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  func topicCreateSettingViewDelegate(buttonTag: TopicCreateSettingView.ButtonTag) {
    
  }
}

extension TopicCreateViewController: CategorySelectDelegate {
  func selectedCategory(category: Category?) {
    guard let category = category else {return}
    self.topicCategory = category
    checkHeader(title: nil, description: nil)
    if  let image = UIImage(named: "category_resizable_btn"),
      let font = UIFont(name: "NanumSquareB", size: 14.0) {
      headerView?.categoryButton?.setAttributedTitle(NSAttributedString(
        string: category.name,
        attributes: [
          .font: font,
          .foregroundColor: UIColor(r: 250, g: 84, b: 76)
        ]), for: .normal)
      headerView?.categoryButton?.setBackgroundImage(
        image.resizableImage(withCapInsets: .init(
          top: image.size.height/2,
          left: image.size.width/2,
          bottom: image.size.height/2,
          right: image.size.width/2), resizingMode: UIImageResizingMode.tile),
        for: .normal)
    }
  }
}

class TopicCreateOptionCellTextFieldDelegateManager: NSObject, UITextFieldDelegate {
  private(set) weak var textField: UITextField?
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.textField = textField
  }
}

protocol TopicCreateOptionCellDelegate {
  func cellDelegate(index: Int, image: UIImage?, text: String?)
  func present(vc: UIViewController)
}

class TopicCreateOptionCell: UICollectionViewCell {
  
  var delegate: TopicCreateOptionCellDelegate?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  var index: Int = 0
  private(set) weak var imageView: UIImageView?
  private(set) weak var textField: UITextField?
  
  override func prepareForReuse() {
    delegate?.cellDelegate(index: index, image: (imageView?.tag != 0) ? imageView?.image : nil, text: textField?.text)
    index = -1
    imageView?.tag = 0
    imageView?.image = UIImage(named: "image_icn")
    textField?.text = ""
  }
  
  func initView(){
    
    layer.backgroundColor = UIColor.white.cgColor
    layer.borderColor = UIColor(r: 192, g: 192, b: 192).cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 3.0
    
    let imageView = UIImageView()
    imageView.tag = 0
    imageView.image = UIImage(named: "image_icn")
    self.imageView = imageView
    self.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.leading.equalTo(self).offset(self.bounds.width * 5.0 / 343.0)
      $0.centerY.equalTo(self)
      $0.width.equalTo(self.bounds.width * 76.0 / 343.0)
      $0.height.equalTo(imageView.snp.width).multipliedBy(62.0/76.0)
    }
    
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageView)))
    
    let titleTextField = UITextField()
    titleTextField.font = UIFont(name: "NanumSquareR", size: 16.0)
    titleTextField.textColor = UIColor(r: 77, g: 77, b: 77)
    titleTextField.placeholder = "항목을 입력해주세요"
    titleTextField.clearButtonMode = .whileEditing
    self.textField = titleTextField
    self.addSubview(titleTextField)
    titleTextField.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing).offset(self.bounds.width * 14.0 / 343.0)
      $0.centerY.equalTo(self)
      $0.trailing.equalTo(self).offset(-(self.bounds.width * 14.0 / 343.0))///
    }
  }
}

extension TopicCreateOptionCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @objc func handleImageView(_ sender: UITapGestureRecognizer) {
    let picker = UIImagePickerController()
    picker.delegate = self
    delegate?.present(vc: picker)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView?.tag = 1
      imageView?.image = image
    }
    picker.dismiss(animated: true, completion: nil)
  }
}

protocol TopicCreateViewControllerCallback {
  var topicTitle: String? { get set }
  var topicDescription: String? { get set }
}

class TopicCreateHeaderView: UICollectionReusableView {
  var callback: TopicCreateViewControllerCallback?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  private(set) weak var categoryButton: UIButton?
  private(set) weak var addImageButton: UIButton?
  private(set) weak var imagesAreaScrollView: UIScrollView?
  private(set) weak var imageAreaStackView: UIStackView?
  private(set) weak var titleTextField: UITextField?
  private(set) weak var descriptionTextView: UITextView?
  private(set) weak var descriptionSeperatorView: UIView?
  private(set) weak var optionsLabel: UILabel?
  var constraintImagesAreaScrollView: ConstraintMakerEditable?
  //var imageAreaStackViewKVO: NSKeyValueObservation?
  
  deinit {
      callback?.topicTitle = titleTextField?.text
      callback?.topicDescription = descriptionTextView?.text
  }
  
  func initView(){
    //let isVisible = callback?.isVisible ?? false
    
    let rootBounds = UIScreen.main.bounds

    //MARK: CategoryButton
    let categoryButton = UIButton()
    categoryButton.setBackgroundImage(UIImage(named: "category_btn"), for: .normal)
    self.categoryButton = categoryButton
    self.addSubview(categoryButton)
    categoryButton.tag = TopicCreateButtonTag.category.rawValue
    categoryButton.snp.makeConstraints {
      $0.top.equalTo(self).offset(rootBounds.height * 24.0/667.0)
      $0.leading.equalTo(self).offset(rootBounds.width * 26.0/375.0)
      $0.width.equalTo(rootBounds.width * 126.0/375.0)
      $0.height.equalTo(rootBounds.height * 34.0/667.0)
    }
    
    let addImageButton = UIButton()
    addImageButton.setImage(UIImage(named: "image_plus_btn"), for: .normal)
    self.addImageButton = addImageButton
    self.addSubview(addImageButton)
    addImageButton.tag = TopicCreateButtonTag.addImage.rawValue
    addImageButton.snp.makeConstraints {
      $0.top.equalTo(categoryButton.snp.bottom)
        .offset(rootBounds.height * 16.0/667.0)
      $0.leading.equalTo(categoryButton)
      $0.width.equalTo(rootBounds.width * 102.0/375.0)
      $0.height.equalTo(rootBounds.height * 34.0/667.0)
    }
    
    let addImageLabel = UILabel()
    addImageLabel.text = "사진은 0~5장까지 추가 가능합니다."
    addImageLabel.font = UIFont(name: "NanumSquareR", size: 12.0)
    addImageLabel.textColor = UIColor(r: 154, g: 154, b: 154)
    //self.addImageLabel = addImageLabel
    self.addSubview(addImageLabel)
    addImageLabel.snp.makeConstraints {
      $0.leading.equalTo(addImageButton.snp.trailing)
        .offset(rootBounds.width * 10.0/375.0)
      $0.centerY.equalTo(addImageButton)
    }
    
    //MARK: ImagesAreaView
    let imagesAreaScrollView = UIScrollView()
    imagesAreaScrollView.showsHorizontalScrollIndicator = false
    imagesAreaScrollView.showsVerticalScrollIndicator = false
    imagesAreaScrollView.contentInset = .init(
      top: 0,
      left: rootBounds.width * 22.0/375.0,
      bottom: 0,
      right: rootBounds.width * 22.0/375.0)
    self.imagesAreaScrollView = imagesAreaScrollView
    self.addSubview(imagesAreaScrollView)
    imagesAreaScrollView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.top.equalTo(addImageLabel.snp.bottom)
        .offset(rootBounds.height * 23.0/667.0)
      constraintImagesAreaScrollView = $0.height.equalTo(0)
    }

    let imageAreaStackView = UIStackView()
    imageAreaStackView.axis = .horizontal
    imageAreaStackView.alignment = .fill
    imageAreaStackView.distribution = .fillProportionally
    imageAreaStackView.spacing = rootBounds.width * 8.0/375.0
    self.imageAreaStackView = imageAreaStackView
    imagesAreaScrollView.addSubview(imageAreaStackView)
    imageAreaStackView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(imagesAreaScrollView)
      $0.height.equalTo(rootBounds.height * 121.0/667.0)
    }
    
    /*imageAreaStackViewKVO = imageAreaStackView.observe(\UIStackView.subviews, changeHandler: {
      (stackView, _) -> Void in
      self.imagesAreaScrollView?.isHidden = stackView.subviews.count > 0
    })*/
    
    //MARK: Title & Description
    let titleTextField = UITextField()
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
    self.titleTextField = titleTextField
    self.addSubview(titleTextField)
    titleTextField.snp.makeConstraints {
      $0.top.equalTo(imagesAreaScrollView.snp.bottom)
        .offset(rootBounds.height * 23.0/667.0)
      $0.leading.equalTo(categoryButton)
      $0.width.equalTo(rootBounds.width * 323.0/375.0)
    }
    
    let titleSeperatorView = UIView()
    titleSeperatorView.backgroundColor = .init(r: 194, g: 194, b: 194)
    self.addSubview(titleSeperatorView)
    titleSeperatorView.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom)
        .offset(rootBounds.height * 6.0/667.0)
      $0.leading.equalTo(titleTextField)
      $0.trailing.equalTo(titleTextField)
      $0.height.equalTo(rootBounds.height * 2.0/667.0)
    }
    
    let descriptionTextView = UITextView()
    descriptionTextView.backgroundColor = .clear
    descriptionTextView.textContainer.lineFragmentPadding = 0
    /*descriptionTextView.textContainerInset = .init(
     top: 0, left: view.bounds.width * 26.0/375.0, bottom: 0, right: view.bounds.width * 26.0/375.0)*/
    descriptionTextView.allowsEditingTextAttributes = false
    self.descriptionTextView = descriptionTextView
    self.addSubview(descriptionTextView)
    descriptionTextView.isScrollEnabled = false
    descriptionTextView.snp.makeConstraints {
      $0.top.equalTo(titleSeperatorView.snp.bottom)
        .offset(rootBounds.height * 26.0/667.0)
      $0.leading.trailing.equalTo(titleTextField)
    }
    
    let descriptionSeperatorView = UIView()
    descriptionSeperatorView.backgroundColor = .init(r: 233, g: 233, b: 233)
    self.descriptionSeperatorView = descriptionSeperatorView
    self.addSubview(descriptionSeperatorView)
    descriptionSeperatorView.snp.makeConstraints {
      $0.top.equalTo(descriptionTextView.snp.bottom)
        .offset(rootBounds.height * 46.0/667.0)
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(rootBounds.height * 2.0/667.0)
    }
    
    let optionsLabel = UILabel()
    optionsLabel.text = "랭킹 항목 추가 / 사진 생략 가능"
    optionsLabel.font = UIFont(name: "NanumSquareB", size: 14.0)
    optionsLabel.textColor = UIColor(r: 112, g: 112, b: 112)
    self.optionsLabel = optionsLabel
    self.addSubview(optionsLabel)
    optionsLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionSeperatorView.snp.bottom)
        .offset(rootBounds.height * 24.0/667.0)
      $0.leading.equalTo(titleTextField)
      $0.height.equalTo(rootBounds.height * 16.0/667.0)
      $0.bottom.equalTo(self).offset(-(rootBounds.height * 10.0/667.0))
    }
  
  }
  
  /*@objc func observeValue(_ notification: Notification){
    guard let isVisible = notification.object as? Bool else {return}
    descriptionSeperatorView?.isHidden = !isVisible
    optionsLabel?.isHidden = !isVisible
  }*/
}

class TopicCreateFooterView: UICollectionReusableView {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  private(set) weak var optionAddButton: UIButton?
  private(set) weak var settingView: TopicCreateSettingView?
  private(set) weak var submitButton: UIButton?
  
  func initView(){
    let rootBounds = UIScreen.main.bounds
    
    let optionAddButton = UIButton()//(type: .custom)
    //optionAddButton.contentHorizontalAlignment = .left
    //if let font = UIFont(name: "NanumSquareR", size: 14.0) {
    //  optionAddButton.setAttributedTitle( NSAttributedString(string: "항목추가", attributes: [.font: font, .foregroundColor: UIColor(r: 112, g: 112, b: 112)]), for: .normal)
    //}
    //optionAddButton.titleEdgeInsets = .init(top: 0.0, left: rootBounds.width * 39.0 / 375.0, bottom: 0.0, right: 0.0)
    optionAddButton.backgroundColor = UIColor(r: 209, g: 209, b: 209)
    //optionAddButton.setBackgroundImage(UIColor(r: 209, g: 209, b: 209).image1x1, for: .normal)
    //optionAddButton.setBackgroundImage(UIColor(r: 219, g: 219, b: 219).image1x1, for: .selected)
    optionAddButton.layer.cornerRadius = 3.0
    
    
    
    let plusLayer = CAShapeLayer()
    let bezierPath = UIBezierPath()
    bezierPath.move(to: .init(x: rootBounds.width * 7.0 / 375.0, y: 0.0))
    bezierPath.addLine(to: .init(x: rootBounds.width * 7.0 / 375.0, y: rootBounds.height * 14.0 / 667.0))
    bezierPath.move(to: .init(x: 0.0, y: rootBounds.height * 7.0 / 667.0))
    bezierPath.addLine(to: .init(x: rootBounds.width * 14.0 / 375.0, y: rootBounds.height * 7.0 / 667.0))
    plusLayer.path = bezierPath.cgPath
    plusLayer.strokeColor = UIColor(r: 112, g: 112, b: 112).cgColor
    plusLayer.lineWidth = 2.0
    plusLayer.frame = .init(
      x: rootBounds.width * 16.0 / 375.0,
      y: rootBounds.height * 19.0 / 667.0,
      width: rootBounds.width * 14.0 / 375.0, height: rootBounds.height * 14.0 / 667.0)
    plusLayer.backgroundColor = UIColor.clear.cgColor
    optionAddButton.layer.addSublayer(plusLayer)
    
    let textLayer = CATextLayer()
    textLayer.frame = .init(
      x: rootBounds.width * 39.0 / 375.0,
      y: rootBounds.height * 18.0 / 667.0,
      width: rootBounds.width / 2.0,
      height: rootBounds.height * 16.0 / 667.0)
    textLayer.alignmentMode = kCAAlignmentLeft
    textLayer.string = "항목추가"
    textLayer.font = "NanumSquareR" as CFTypeRef
    textLayer.fontSize = 14.0
    textLayer.foregroundColor = UIColor(r: 112, g: 112, b: 112).cgColor
    textLayer.backgroundColor = UIColor.clear.cgColor
    optionAddButton.layer.addSublayer(textLayer)
    
    optionAddButton.tag = TopicCreateButtonTag.optionAdd.rawValue
    self.optionAddButton = optionAddButton
    self.addSubview(optionAddButton)
    optionAddButton.snp.makeConstraints {
      $0.top.equalTo(self).offset(rootBounds.height * 14.0 / 667.0)
      $0.centerX.equalTo(self)
      $0.width.equalTo(rootBounds.width * 317.0 / 375.0)
      $0.height.equalTo(rootBounds.height * 52.0 / 667.0)
    }
    
    let settingView = TopicCreateSettingView()
    self.settingView = settingView
    self.addSubview(settingView)
    settingView.snp.makeConstraints {
      $0.top.equalTo(optionAddButton.snp.bottom)
      $0.leading.trailing.equalTo(self)
    }
    
    let submitButton = UIButton()
    submitButton.setBackgroundImage(UIImage(named: "Wupload_bg_btn"), for: .normal)
    if let font = UIFont(name: "NanumSquareB", size: 18.0) {
      submitButton.setAttributedTitle(NSAttributedString(
        string: "완료", attributes: [.font: font, .foregroundColor: UIColor.white]), for: .normal)
    }
    self.submitButton = submitButton
    addSubview(submitButton)
    submitButton.tag = TopicCreateButtonTag.submit.rawValue
    //submitButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    submitButton.snp.makeConstraints {
      $0.top.equalTo(settingView.snp.bottom).offset(rootBounds.height * 26.0/667.0)
      $0.bottom.equalTo(self).offset(-(rootBounds.height * 51.0/667.0))
      $0.width.equalTo(rootBounds.width * 146.0/375.0)
      $0.height.equalTo(rootBounds.height * 42.0/667.0)
      $0.centerX.equalTo(self)
    }
  }
}

protocol TopicCreateSettingViewDelegate {
  func topicCreateSettingViewDelegate(infoMesssage: String)
  func topicCreateSettingViewDelegate(buttonTag: TopicCreateSettingView.ButtonTag)
}


class TopicCreateSettingView: UIView {
  var delegate: TopicCreateSettingViewDelegate?
  private weak var votableCountCheckButton: UIButton?
  private weak var onlyWriterCreateOptionCheckButton: UIButton?
  
  private(set) var isVotableCount: Bool = false {
    didSet { if oldValue != isVotableCount {
        changeImageCheckButton(button: votableCountCheckButton)
    }}
  }
  
  private(set) var isOnlyWriterCreateOption: Bool = false {
    didSet { if oldValue != isOnlyWriterCreateOption {
        changeImageCheckButton(button: onlyWriterCreateOptionCheckButton)
    }}
  }
  
  private func changeImageCheckButton(button: UIButton?) {
    if button == votableCountCheckButton {
      button?.setImage(imageCheckButton(isCheck: isVotableCount), for: .normal)
    }
    if button == onlyWriterCreateOptionCheckButton {
      button?.setImage(imageCheckButton(isCheck: isOnlyWriterCreateOption), for: .normal)
    }
  }
  
  private func imageCheckButton(isCheck: Bool) -> UIImage? {
    let padding = UIScreen.main.bounds.width * 20.0/375.0
    if let image = UIImage(named: ((isCheck) ? "Wcheck_btn_F" : "Wcheck_btn_N") ) {
      return image.copy(with: .init(top: padding, left: padding, bottom: padding, right: padding), isTemplate: false)
    }
    return nil
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  private func initView(){
    isUserInteractionEnabled = true
    let rootViewBounds = UIScreen.main.bounds
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont.init(name: "NanumSquareB", size: 14.0)
    titleLabel.textColor = UIColor.init(r: 112, g: 112, b: 112)
    titleLabel.text = "랭킹 설정"
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self).offset(rootViewBounds.height * 46.0/667.0)
      $0.leading.equalTo(self).offset(rootViewBounds.width * 24.0/375.0)
    }
    
    let seperatorView1 = UIView()
    addSubview(seperatorView1)
    seperatorView1.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(rootViewBounds.height * 10.0/667.0)
    }
    let votableCountLabel = UILabel()
    votableCountLabel.font = UIFont(name: "NanumSquareR", size: 14.0)
    votableCountLabel.textColor = UIColor.init(r: 112, g: 112, b: 112)
    votableCountLabel.text = "복수 선택 가능"
    let votableCountInfoButton = UIButton()
    votableCountInfoButton.tag = ButtonTag.votableCount.rawValue
    let votableCountCheckButton = UIButton()
    votableCountCheckButton.tag = ButtonTag.votableCount.rawValue
    self.votableCountCheckButton = votableCountCheckButton
    changeImageCheckButton(button: votableCountCheckButton)
    initSubView(rootViewBounds: rootViewBounds, seperatorView: seperatorView1, label: votableCountLabel, infoButton: votableCountInfoButton, chekcButton: votableCountCheckButton)
    
    let seperatorView2 = UIView()
    addSubview(seperatorView2)
    seperatorView2.snp.makeConstraints {
      $0.top.equalTo(votableCountLabel.snp.bottom).offset(rootViewBounds.height * 24.0/667.0)
    }
    let onlyWriterCreateOptionLabel = UILabel()
    onlyWriterCreateOptionLabel.font = UIFont(name: "NanumSquareR", size: 14.0)
    onlyWriterCreateOptionLabel.textColor = UIColor.init(r: 112, g: 112, b: 112)
    onlyWriterCreateOptionLabel.text = "랭킹 항목 추가 허용"
    let onlyWriterCreateOptionInfoButton = UIButton()
    onlyWriterCreateOptionInfoButton.tag = ButtonTag.onlyWriterCreateOption.rawValue
    let onlyWriterCreateOptionCheckButton = UIButton()
    onlyWriterCreateOptionCheckButton.tag = ButtonTag.onlyWriterCreateOption.rawValue
    self.onlyWriterCreateOptionCheckButton = onlyWriterCreateOptionCheckButton
    changeImageCheckButton(button: onlyWriterCreateOptionCheckButton)
    initSubView(rootViewBounds: rootViewBounds, seperatorView: seperatorView2, label: onlyWriterCreateOptionLabel, infoButton: onlyWriterCreateOptionInfoButton, chekcButton: onlyWriterCreateOptionCheckButton)
    
    onlyWriterCreateOptionLabel.snp.makeConstraints {
      $0.bottom.equalTo(self).offset(-(rootViewBounds.height * 24.0/667.0))
    }
  }
  
  private func initSubView(rootViewBounds: CGRect, seperatorView: UIView, label: UILabel, infoButton: UIButton, chekcButton:UIButton) {
    seperatorView.backgroundColor = .init(r: 194, g: 194, b: 194)
    seperatorView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(1.0)
    }
    addSubview(label)
    label.snp.makeConstraints {
      $0.top.equalTo(seperatorView.snp.bottom).offset(rootViewBounds.height * 24.0/667.0)
      $0.leading.equalTo(self).offset(rootViewBounds.width * 24.0/375.0)
    }
    var infoImage = UIImage(named: "help_icn")
    infoImage = infoImage?.copy(with: .init(top: 10, left: 10, bottom: 10, right: 10), isTemplate: false)
    infoButton.setImage(infoImage, for: .normal)
    addSubview(infoButton)
    infoButton.snp.makeConstraints {
      $0.leading.equalTo(label.snp.trailing)
      $0.width.equalTo((rootViewBounds.width * 36.0/375.0))
      $0.height.equalTo((rootViewBounds.width * 36.0/375.0))
      $0.centerY.equalTo(label)
    }
    infoButton.addTarget(self, action: #selector(handleButtonInfo), for: .touchUpInside)
    addSubview(chekcButton)
    chekcButton.snp.makeConstraints {
      $0.centerY.equalTo(infoButton)
      $0.width.equalTo((rootViewBounds.width * 56.0/375.0))
      $0.height.equalTo((rootViewBounds.width * 56.0/375.0))
      $0.trailing.equalTo(self).offset(-(rootViewBounds.width * 4.0/375.0))
    }
    chekcButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
  }
  
  @objc private func handleButtonInfo(_ button: UIButton) {
    guard let buttonTag = ButtonTag(rawValue: button.tag) else {return}
    var message: String
    switch buttonTag {
    case .votableCount:
      message = "투표하는 유저가 3개까지\n복수 선택을 할 수 있도록 합니다."
    case .onlyWriterCreateOption:
      message = "다른 유저가 랭킹 항목을\n추가하도록 허용합니다."
    }
    delegate?.topicCreateSettingViewDelegate(infoMesssage: message)
  }
  
  @objc func handleButton(_ button: UIButton) {
    guard let buttonTag = ButtonTag(rawValue: button.tag) else {return}
    switch buttonTag {
    case .votableCount:
      isVotableCount = !isVotableCount
    case .onlyWriterCreateOption:
      isOnlyWriterCreateOption = !isOnlyWriterCreateOption
    }
    delegate?.topicCreateSettingViewDelegate(buttonTag: buttonTag)
  }
  
  public enum ButtonTag: Int {
    case votableCount = 1
    case onlyWriterCreateOption = 2
  }
  
}
