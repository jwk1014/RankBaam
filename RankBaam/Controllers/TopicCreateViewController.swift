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
//import Photos

class TopicCreateViewController: UIViewController, TopicCreateViewControllerCallback {
  enum ButtonTag: Int {
    case back = 1
    case cancel = 2
    case category = 3
    case addImage = 4
  }
  
  typealias OptionCellData = (image: UIImage?, imageUrl: URL?, text: String?)
  var topicSN: Int? {
    willSet{
      if let _ = newValue {
        isVisible = true
      }
    }
  }
  var topicCategory: Category?
  var topicTitle: String?
  var topicDescription: String?
  
  weak var flowLayout: UICollectionViewFlowLayout?
  weak var collectionView: UICollectionView?
  
  weak var headerView: TopicCreateHeaderView?
  weak var footerView: TopicCreateFooterView?
  
  var isVisible = false {
    didSet{
      headerView?.isVisibleBottomArea = isVisible
      
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
  var textFieldDelegate: UITextFieldDelegate { return self }
  
  var optionCellDatas = [OptionCellData?]()
  var optionCount = 0
  
  let topicCreateOptionCellTextFieldDelegateManager = TopicCreateOptionCellTextFieldDelegateManager()
  
  @objc func handleButton(_ button: UIButton) {
    guard let buttonTag = ButtonTag(rawValue: button.tag) else {return}
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
    case .addImage:
      let picker = UIImagePickerController()
      picker.delegate = self
      present(picker, animated: true, completion: nil)
    }
  }
  
  @objc func resignSubViewsFirstResponder() {
    if let titleTextField = headerView?.titleTextField, titleTextField.isFirstResponder {
      titleTextField.resignFirstResponder()
    } else if let descriptionTextView = headerView?.descriptionTextView, descriptionTextView.isFirstResponder {
      descriptionTextView.resignFirstResponder()
    } else if let textField = topicCreateOptionCellTextFieldDelegateManager.textField, textField.isFirstResponder {
      textField.resignFirstResponder()
    }
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
    topSpaceLayer.frame = .init(x: 0, y: 0,
      width: view.bounds.width, height: height667(76.0))
    view.layer.addSublayer(topSpaceLayer)
    
    //MARK: CustomNaviBarView
    let customNaviBarView = UIView()
    view.addSubview(customNaviBarView)
    customNaviBarView.backgroundColor = .white
    customNaviBarView.isUserInteractionEnabled = true
    customNaviBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view)
      $0.height.equalTo(height667(76.0))
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
    backButton.tag = ButtonTag.back.rawValue
    backButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    backButton.snp.makeConstraints {
      $0.leading.equalTo(customNaviBarView).offset(width375(6.0))
      $0.bottom.equalTo(customNaviBarView)
      $0.width.equalTo(width375(44.0))
      $0.height.equalTo(backButton.snp.width)
    }
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont(name: "NanumSquareB", size: 16.0)
    titleLabel.textColor = UIColor(r: 255, g: 195, b: 75)
    titleLabel.text = "글쓰기"
    customNaviBarView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(backButton.snp.trailing).offset(width375(6.0))
      $0.bottom.equalTo(customNaviBarView).offset(-height667(13.0))
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
    cancelButton.tag = ButtonTag.cancel.rawValue
    cancelButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    cancelButton.snp.makeConstraints {
      $0.trailing.equalTo(customNaviBarView).offset(-width375(3.0))
      $0.bottom.equalTo(customNaviBarView)
      $0.width.equalTo(width375(56.0))
      $0.height.equalTo(height667(44.0))
    }
    
    //MARK: View & CollectionView
    view.backgroundColor = .init(r: 246, g: 248, b: 250)
    
    view.addGestureRecognizer(UITapGestureRecognizer(
      target: self, action: #selector(resignSubViewsFirstResponder)))
    
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
    collectionView.register(TopicCreateHeaderView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
      withReuseIdentifier: "header")
    collectionView.register(TopicCreateFooterView.self,
      forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
      withReuseIdentifier: "footer")
  }
  
  func invalidateLayoutCollectionView() {
    flowLayout?.invalidateLayout()
  }
  
  func checkHeader(title: String?, description: String?){
    let title = title ?? headerView?.titleTextField?.text
    let isVisible = (topicCategory != nil && title != nil &&
      title!.trimmingCharacters(in: .init(charactersIn: " \n")).count > 0)
    guard self.isVisible != isVisible else { return }
    self.isVisible = isVisible
    flowLayout?.invalidateLayout()
  }
  
}

extension TopicCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      headerView?.addImageInImageArea(image: image)
      flowLayout?.invalidateLayout()
    }
    picker.dismiss(animated: true, completion: nil)
  }
}

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
        /*if  let url = optionCellData.imageUrl,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
          cell.imageView?.tag = 1
          cell.imageView?.image = image
          cell.imageUrl = optionCellData.imageUrl
        }*/
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
          headerView.descriptionTextView?.attributedText = headerView.descriptionAttributedString
          headerView.titleTextField?.delegate = self
          headerView.isVisibleBottomArea = isVisible
          headerView.callback = self
          
          if let oldHeaderView = self.headerView {
            print("replace header")
            headerView.copyValue(headerView: oldHeaderView)
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
          footerView.delegate = self
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
    let height = heightCollectionViewSupplementaryView(
      defaultView: headerView,
      type: TopicCreateHeaderView.self
    )
    return .init(width: UIScreen.main.bounds.width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    let height = isVisible ? heightCollectionViewSupplementaryView(
      defaultView: footerView,
      type: TopicCreateFooterView.self
    ) : 0
    return .init(width: UIScreen.main.bounds.width, height: height)
  }
  
  func heightCollectionViewSupplementaryView<T: UICollectionReusableView>(defaultView: UICollectionReusableView?, type: T.Type) -> CGFloat {
    guard [TopicCreateHeaderView.self, TopicCreateFooterView.self].contains(where: {$0 == type}),
          let collectionView = collectionView else {return 0}
    let view = defaultView ?? /*collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).first ??*/
      collectionView.dequeueReusableSupplementaryView(
        ofKind: (type == TopicCreateHeaderView.self) ?
          UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter,
        withReuseIdentifier: (type == TopicCreateHeaderView.self) ?
          "header" : "footer",
        for: IndexPath(row: 0, section: 0))
    return view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
  }
}

extension TopicCreateViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return height667(10.0)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize( width: width375(343.0), height: height667(72.0))
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
          right: image.size.width/2), resizingMode: .tile),
        for: .normal)
    }
  }
}

extension TopicCreateViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      var text2 = text
      if let range2 = Range<String.Index>(range, in: text2) {
        text2.replaceSubrange(range2, with: string)
        checkHeader(title: text2, description: nil)
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

extension TopicCreateViewController: TopicCreateFooterViewDelegate {
  private func simpleAlert(_ message: String,_ handler: ((UIAlertAction)->Void)? ) {
    let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .cancel, handler: handler))
    self.present(alert, animated: true, completion: nil)
  }
  @objc func footerView(optionAddButton: UIButton) {
    optionCount += 1
    collectionView?.insertItems(at: [IndexPath(row: optionCount-1, section: 0)])
  }
  @objc func footerView(submitButton: UIButton) {
    guard let topicCategory = topicCategory else {
      simpleAlert("카테고리를 선택해주세요.", nil); return
    }
    
    guard let title = (headerView != nil) ? headerView?.titleTextField?.text : self.topicTitle,
          title.count > 0 else {
        simpleAlert("제목을 입력해주세요.") { _ in
          self.headerView?.titleTextField?.becomeFirstResponder()
        }; return
    }
    
    guard title.count >= 5 else {
      simpleAlert("제목은 5자 이상이여야 합니다.") { _ in
        self.headerView?.titleTextField?.becomeFirstResponder()
      }; return
    }
    
    let description = (headerView != nil) ? headerView?.descriptionTextView?.text : self.topicDescription
    
    let isOnlyWriterCreateOption = footerView?.isOnlyWriterCreateOption ?? false
    
    let isVotableCountPerUser = footerView?.isVotableCount ?? false
    
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
                  image: (cell.imageView?.tag != 0) ? cell.imageView?.image : nil, //TODO
                  imageUrl: (cell.imageView?.tag != 0) ? cell.imageUrl : nil,
                  text: cell.textField?.text)
            }
            
            optionCellDatas = optionCellDatas
              .filter({$0 != nil})
              .map({$0!})
              .filter({$0.text != nil && $0.text!.count > 0})
            
            if optionCellDatas.count > 0 {
              
              var optionCreateResponseClosure: ((DataResponse<SResultOptionCreate>) -> Void)!
              var optionPhotoCreateResponseClosure: ((DataResponse<SResult>) -> Void)!
              
              optionCreateResponseClosure = {
                switch($0.result) {
                  
                case .success(let sResult):
                  if sResult.succ {
                    guard let optionCellData = optionCellDatas.remove(at: 0) else {
                      topicDetailClosure()
                      return
                    }
                    /*if  let imageUrl = optionCellData.imageUrl,
                     let optionSN = sResult.optionSN {
                     OptionService.photoCreate(
                     topicSN: topicSN,
                     optionSN: optionSN,
                     photoUrl: imageUrl,
                     completion: optionPhotoCreateResponseClosure)
                     } else */if optionCellDatas.count > 0,
                      let title = optionCellDatas[0]?.text {
                      OptionService.create(
                        optionWrite: OptionWrite(
                          topicSN: topicSN,
                          optionSN: nil,
                          title: title,
                          description: nil),
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
              
              optionPhotoCreateResponseClosure = {
                switch($0.result) {
                  
                case .success(let sResult):
                  if sResult.succ {
                    if let optionCellData = optionCellDatas[0] {
                      OptionService.create(
                        optionWrite: OptionWrite(
                          topicSN: topicSN,
                          optionSN: nil,
                          title: optionCellData.text!,
                          description: nil),
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
              
              if let title = optionCellDatas[0]?.text {
                OptionService.create(
                  optionWrite: OptionWrite(
                    topicSN: topicSN,
                    optionSN: nil,
                    title: title,
                    description: nil),
                  completion: optionCreateResponseClosure)
              }
              
              return
            }
            
          }
          
          topicDetailClosure()
          
        } else if let msg = sResult.msg {
          switch msg {
          case "TitleExists":
            self.simpleAlert("같은 제목을 가진 랭킹 주제가 존재합니다.") { _ in
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
  func footerView(infoButtonTag: Int) {
    guard let buttonTag = TopicCreateFooterView.ButtonTag(rawValue: infoButtonTag) else {return}
    var message: String
    switch buttonTag {
    case .votableCount:
      message = "투표하는 유저가 3개까지\n복수 선택을 할 수 있도록 합니다."
    case .onlyWriterCreateOption:
      message = "다른 유저가 랭킹 항목을\n추가하도록 허용합니다."
    }
    simpleAlert(message, nil)
  }
}

extension TopicCreateViewController: TopicCreateOptionCellDelegate {
  func cellDelegate(index: Int, image: UIImage?, imageUrl: URL?, text: String?) { //TODO
    if optionCellDatas.count-1 < index {
      optionCellDatas += Array<OptionCellData?>(repeating: nil, count: index+1-optionCellDatas.count)
    }
    optionCellDatas[index] = OptionCellData(image: image, imageUrl: imageUrl, text: text)
  }
  
  func present(vc: UIViewController) {
    present(vc, animated: true, completion: nil)
  }
}

class TopicCreateOptionCellTextFieldDelegateManager: NSObject, UITextFieldDelegate {
  private(set) weak var textField: UITextField?
  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.textField = textField
  }
}

protocol TopicCreateOptionCellDelegate {
  func cellDelegate(index: Int, image: UIImage?, imageUrl: URL?, text: String?)
  func present(vc: UIViewController)
}

//MARK: Cell
class TopicCreateOptionCell: UICollectionViewCell {
  var delegate: TopicCreateOptionCellDelegate?
  
  var index: Int = -1
  var imageUrl: URL?
  private(set) weak var imageView: UIImageView?
  private(set) weak var textField: UITextField?
  
  override func prepareForReuse() {
    delegate?.cellDelegate(
      index: index,
      image: (imageView?.tag != 0) ? imageView?.image : nil,
      imageUrl: (imageView?.tag != 0) ? imageUrl : nil,
      text: textField?.text)
    initData()
  }
  
  func initData() {
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
    self.imageView = imageView
    addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.leading.equalTo(self).offset(width375(5.0))
      $0.centerY.equalTo(self)
      $0.width.equalTo(width375(76.0))
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
    addSubview(titleTextField)
    titleTextField.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing).offset(width375(14.0))
      $0.centerY.equalTo(self)
      $0.trailing.equalTo(self).offset(-width375(14.0))///
    }
    
    initData()
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
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
    //imageUrl = info[UIImagePickerControllerMediaURL] as? URL
    
    picker.dismiss(animated: true, completion: nil)
  }
}

protocol TopicCreateViewControllerCallback {
  var topicTitle: String? { get set }
  var topicDescription: String? { get set }
  func invalidateLayoutCollectionView()
}

//MARK: HeaderView
class TopicCreateHeaderView: UICollectionReusableView {
  var callback: TopicCreateViewControllerCallback?
  
  private(set) weak var categoryButton: UIButton?
  private(set) weak var addImageButton: UIButton?
  private weak var imagesAreaScrollView: UIScrollView?
  private weak var imageAreaStackView: UIStackView?
  private(set) weak var titleTextField: UITextField?
  private(set) weak var descriptionTextView: UITextView?
  private weak var descriptionSeperatorView: UIView?
  private weak var optionsLabel: UILabel?
  private var constraintImagesAreaScrollView: ConstraintMakerEditable?
  
  deinit {
      callback?.topicTitle = titleTextField?.text
      callback?.topicDescription = descriptionTextView?.text
  }
  
  var isVisibleBottomArea: Bool = false {
    willSet{
      descriptionSeperatorView?.isHidden = !newValue
      optionsLabel?.isHidden = !newValue
    }
  }
  
  //min max
  func addImageInImageArea(image: UIImage){
    guard let imageAreaStackView = imageAreaStackView else {return}
    let imageView = UIImageView()
    imageView.image = image
    imageAreaStackView.addArrangedSubview(imageView)
    imageView.layer.cornerRadius = 10.0
    imageView.clipsToBounds = true
    imageView.snp.makeConstraints{
      $0.width.equalTo(image.size.width * height667(121.0) / image.size.height)
      $0.height.equalTo(imageAreaStackView)
    }
    if imageAreaStackView.arrangedSubviews.count == 1 {
      constraintImagesAreaScrollView?.constraint.layoutConstraints.first?.constant =
        imageAreaStackView.bounds.height
    }
    
    let button = UIButton(type: .custom)
    if let image = UIImage(named: "x_icn") {
      button.setImage(
        image.copy(
          with: .init(top: 6, left: 6, bottom: 6, right: 6),
          isTemplate: false),
        for: .normal)
    }
    imageView.addSubview(button)
    button.snp.makeConstraints {
      $0.top.trailing.equalTo(imageView)
      $0.width.equalTo(width375(16.0))
      $0.height.equalTo(button.snp.width)
    }
  }
  
  //save image url array & deinit
  //func removeImageInImageArea(image: UIImage){}
  
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
  
  private var descriptionPlaceholderString: String {
    return "자유롭게 작성해주세요."
  }
  
  private var descriptionPlaceholderTextColor: UIColor {
    return .init(r: 154, g: 154, b: 154)
  }
  
  var descriptionTextColor: UIColor {
    return .init(r: 77, g: 77, b: 77)
  }
  
  func copyValue(headerView: TopicCreateHeaderView) {
    if let image = headerView.categoryButton?.backgroundImage(for: .normal) {
      categoryButton?.setBackgroundImage(image, for: .normal)
      if let attributedTitle = headerView.categoryButton?.attributedTitle(for: .normal) {
        categoryButton?.setAttributedTitle(attributedTitle, for: .normal)
      }
    }
    if let title = headerView.titleTextField?.text {
      titleTextField?.text = title
    }
    if let description = headerView.descriptionTextView?.text {
      descriptionTextView?.textColor = descriptionTextColor
      descriptionTextView?.text = description
    }
  }
  
  func initView(){
    let categoryButton = UIButton()
    categoryButton.setBackgroundImage(UIImage(named: "category_btn"), for: .normal)
    self.categoryButton = categoryButton
    self.addSubview(categoryButton)
    categoryButton.tag = TopicCreateViewController.ButtonTag.category.rawValue
    categoryButton.snp.makeConstraints {
      $0.top.equalTo(self).offset(height667(24.0))
      $0.leading.equalTo(self).offset(width375(26.0))
      $0.width.equalTo(width375(126.0))
      $0.height.equalTo(height667(34.0))
    }
    
    let addImageButton = UIButton()
    addImageButton.setImage(UIImage(named: "image_plus_btn"), for: .normal)
    self.addImageButton = addImageButton
    self.addSubview(addImageButton)
    addImageButton.tag = TopicCreateViewController.ButtonTag.addImage.rawValue
    addImageButton.snp.makeConstraints {
      $0.top.equalTo(categoryButton.snp.bottom)
        .offset(height667(16.0))
      $0.leading.equalTo(categoryButton)
      $0.width.equalTo(width375(102.0))
      $0.height.equalTo(height667(34.0))
    }
    
    let addImageLabel = UILabel()
    addImageLabel.text = "사진은 0~5장까지 추가 가능합니다."
    addImageLabel.font = UIFont(name: "NanumSquareR", size: 12.0)
    addImageLabel.textColor = UIColor(r: 154, g: 154, b: 154)
    self.addSubview(addImageLabel)
    addImageLabel.snp.makeConstraints {
      $0.leading.equalTo(addImageButton.snp.trailing)
        .offset(width375(10.0))
      $0.centerY.equalTo(addImageButton)
    }
    
    let imagesAreaScrollView = UIScrollView()
    imagesAreaScrollView.showsHorizontalScrollIndicator = false
    imagesAreaScrollView.showsVerticalScrollIndicator = false
    imagesAreaScrollView.contentInset = .init(
      top: 0, left: width375(22.0),
      bottom: 0, right: width375(22.0))
    self.imagesAreaScrollView = imagesAreaScrollView
    addSubview(imagesAreaScrollView)
    imagesAreaScrollView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.top.equalTo(addImageLabel.snp.bottom)
        .offset(height667(23.0))
      constraintImagesAreaScrollView = $0.height.equalTo(0)
    }

    let imageAreaStackView = UIStackView()
    imageAreaStackView.axis = .horizontal
    imageAreaStackView.alignment = .fill
    imageAreaStackView.distribution = .fillProportionally
    imageAreaStackView.spacing = width375(8.0)
    self.imageAreaStackView = imageAreaStackView
    imagesAreaScrollView.addSubview(imageAreaStackView)
    imageAreaStackView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalTo(imagesAreaScrollView)
      $0.height.equalTo(height667(121.0))
    }
    
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
    self.descriptionTextView = descriptionTextView
    self.addSubview(descriptionTextView)
    descriptionTextView.snp.makeConstraints {
      $0.top.equalTo(titleSeperatorView.snp.bottom)
        .offset(height667(26.0))
      $0.leading.trailing.equalTo(titleTextField)
    }
    
    let descriptionSeperatorView = UIView()
    descriptionSeperatorView.backgroundColor = .init(r: 233, g: 233, b: 233)
    self.descriptionSeperatorView = descriptionSeperatorView
    addSubview(descriptionSeperatorView)
    descriptionSeperatorView.snp.makeConstraints {
      $0.top.equalTo(descriptionTextView.snp.bottom)
        .offset(height667(46.0))
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(height667(2.0))
    }
    
    let optionsLabel = UILabel()
    optionsLabel.text = "랭킹 항목 추가 / 사진 생략 가능"
    optionsLabel.font = UIFont(name: "NanumSquareB", size: 14.0)
    optionsLabel.textColor = UIColor(r: 112, g: 112, b: 112)
    self.optionsLabel = optionsLabel
    addSubview(optionsLabel)
    optionsLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionSeperatorView.snp.bottom)
        .offset(height667(24.0))
      $0.leading.equalTo(titleTextField)
      $0.height.equalTo(height667(16.0))
      $0.bottom.equalTo(self).offset(-height667(10.0))
    }
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}

extension TopicCreateHeaderView: UITextViewDelegate {
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
    callback?.invalidateLayoutCollectionView()
  }
}

@objc protocol TopicCreateFooterViewDelegate {
  func footerView(optionAddButton: UIButton)
  func footerView(submitButton: UIButton)
  func footerView(infoButtonTag: Int)
}

//MARK: FooterView
class TopicCreateFooterView: UICollectionReusableView {
  var delegate: TopicCreateFooterViewDelegate? {
    willSet{
      if let delegate = delegate {
        optionAddButton?.removeTarget(delegate,
          action: #selector(delegate.footerView(optionAddButton:)),
          for: .touchUpInside)
        submitButton?.removeTarget(delegate,
          action: #selector(delegate.footerView(submitButton:)),
          for: .touchUpInside)
      }
      if let newValue = newValue {
        optionAddButton?.addTarget(newValue,
          action: #selector(newValue.footerView(optionAddButton:)),
          for: .touchUpInside)
        submitButton?.addTarget(newValue,
          action: #selector(newValue.footerView(submitButton:)),
          for: .touchUpInside)
      }
      /*if let btn1 = optionAddButton, let btn2 = submitButton, let newValue = newValue {
        for (btn, selector) in [(btn1, #selector(newValue.footerView(optionAddButton:))),
                                (btn2, #selector(newValue.footerView(submitButton:)))] {
          for (f, target) in [(btn.removeTarget, delegate), (btn.addTarget, newValue)] where target != nil {
            f(target, selector, .touchUpInside)
          }
        }
      }*/
    }
  }
  
  private(set) var isVotableCount: Bool = false {
    didSet { if oldValue != isVotableCount {
      votableCountCheckButton?.setImage(
        imageCheckButton(isCheck: isVotableCount), for: .normal)
    }}
  }
  private(set) var isOnlyWriterCreateOption: Bool = false {
    didSet { if oldValue != isOnlyWriterCreateOption {
      onlyWriterCreateOptionCheckButton?.setImage(
        imageCheckButton(isCheck: isOnlyWriterCreateOption), for: .normal)
    }}
  }
  
  public enum ButtonTag: Int {
    case votableCount
    case onlyWriterCreateOption
  }
  
  private weak var optionAddButton: UIButton?
  private weak var votableCountCheckButton: UIButton?
  private weak var onlyWriterCreateOptionCheckButton: UIButton?
  private weak var submitButton: UIButton?
  
  private func imageCheckButton(isCheck: Bool) -> UIImage? {
    guard let image = UIImage(named: ((isCheck) ? "Wcheck_btn_F" : "Wcheck_btn_N") ) else { return nil }
    let padding = width375(20.0)
    return image.copy(with: .init(top: padding, left: padding, bottom: padding, right: padding), isTemplate: false)
  }
  
  @objc private func handleInfoButton(_ button: UIButton) {
    delegate?.footerView(infoButtonTag: button.tag)
  }
  
  @objc private func handleButton(_ button: UIButton) {
    guard let buttonTag = ButtonTag(rawValue: button.tag) else {return}
    switch buttonTag {
    case .votableCount: isVotableCount = !isVotableCount
    case .onlyWriterCreateOption: isOnlyWriterCreateOption = !isOnlyWriterCreateOption
    }
  }
  
  private func initView(){
    let optionAddButton = UIButton()
    optionAddButton.backgroundColor = UIColor(r: 209, g: 209, b: 209)
    optionAddButton.layer.cornerRadius = 3.0
    
    let plusLayer = CAShapeLayer()
    let bezierPath = UIBezierPath()
    bezierPath.move(to: .init(x: width375(7.0), y: 0.0))
    bezierPath.addLine(to: .init(x: width375(7.0), y: height667(14.0)))
    bezierPath.move(to: .init(x: 0.0, y: height667(7.0)))
    bezierPath.addLine(to: .init(x: width375(14.0), y: height667(7.0)))
    plusLayer.path = bezierPath.cgPath
    plusLayer.strokeColor = UIColor(r: 112, g: 112, b: 112).cgColor
    plusLayer.lineWidth = 2.0
    plusLayer.frame = .init( x: width375(16.0), y: height667(19.0),
      width: width375(14.0), height: height667(14.0))
    plusLayer.backgroundColor = UIColor.clear.cgColor
    optionAddButton.layer.addSublayer(plusLayer)
    
    let textLayer = CATextLayer()
    textLayer.frame = .init( x: width375(39.0), y: height667(18.0),
      width: width375(170.0), height: height667(16.0))
    textLayer.alignmentMode = kCAAlignmentLeft
    textLayer.string = "항목추가"
    textLayer.font = "NanumSquareR" as CFTypeRef
    textLayer.fontSize = 14.0
    textLayer.foregroundColor = UIColor(r: 112, g: 112, b: 112).cgColor
    textLayer.backgroundColor = UIColor.clear.cgColor
    optionAddButton.layer.addSublayer(textLayer)
    
    self.optionAddButton = optionAddButton
    addSubview(optionAddButton)
    optionAddButton.snp.makeConstraints {
      $0.top.equalTo(self).offset(height667(14.0))
      $0.centerX.equalTo(self)
      $0.width.equalTo(width375(317.0))
      $0.height.equalTo(height667(52.0))
    }
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont.init(name: "NanumSquareB", size: 14.0)
    titleLabel.textColor = UIColor.init(r: 112, g: 112, b: 112)
    titleLabel.text = "랭킹 설정"
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(optionAddButton.snp.bottom).offset(height667(46.0))
      $0.leading.equalTo(self).offset(width375(24.0))
    }
    
    let seperatorView1 = UIView()
    addSubview(seperatorView1)
    seperatorView1.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(height667(10.0))
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
    votableCountCheckButton.setImage(
      imageCheckButton(isCheck: isVotableCount), for: .normal)
    initSubView( seperatorView: seperatorView1, label: votableCountLabel,
      infoButton: votableCountInfoButton, checkButton: votableCountCheckButton)
    
    let seperatorView2 = UIView()
    addSubview(seperatorView2)
    seperatorView2.snp.makeConstraints {
      $0.top.equalTo(votableCountLabel.snp.bottom).offset(height667(24.0))
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
    onlyWriterCreateOptionCheckButton.setImage(
      imageCheckButton(isCheck: isOnlyWriterCreateOption), for: .normal)
    initSubView( seperatorView: seperatorView2, label: onlyWriterCreateOptionLabel,
      infoButton: onlyWriterCreateOptionInfoButton, checkButton: onlyWriterCreateOptionCheckButton)
    
    let submitButton = UIButton()
    submitButton.setBackgroundImage(UIImage(named: "Wupload_bg_btn"), for: .normal)
    if let font = UIFont(name: "NanumSquareB", size: 18.0) {
      submitButton.setAttributedTitle(NSAttributedString(
        string: "완료", attributes: [.font: font, .foregroundColor: UIColor.white]), for: .normal)
    }
    self.submitButton = submitButton
    addSubview(submitButton)
    submitButton.snp.makeConstraints {
      $0.top.equalTo(onlyWriterCreateOptionLabel.snp.bottom).offset(height667(50.0))
      $0.bottom.equalTo(self).offset(-height667(51.0))
      $0.width.equalTo(width375(146.0))
      $0.height.equalTo(height667(42.0))
      $0.centerX.equalTo(self)
    }
  }
  
  private func initSubView(seperatorView: UIView, label: UILabel, infoButton: UIButton, checkButton:UIButton) {
    seperatorView.backgroundColor = .init(r: 194, g: 194, b: 194)
    seperatorView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.height.equalTo(1.0)
    }
    
    addSubview(label)
    label.snp.makeConstraints {
      $0.top.equalTo(seperatorView.snp.bottom).offset(height667(24.0))
      $0.leading.equalTo(self).offset(width375(24.0))
    }
    
    if let infoImage = UIImage(named: "help_icn") {
      infoButton.setImage(
        infoImage.copy(
          with: .init(top: 10, left: 10, bottom: 10, right: 10),
          isTemplate: false),
        for: .normal)
    }
    addSubview(infoButton)
    infoButton.snp.makeConstraints {
      $0.leading.equalTo(label.snp.trailing)
      $0.width.equalTo(width375(36.0))
      $0.height.equalTo(infoButton.snp.width)
      $0.centerY.equalTo(label)
    }
    infoButton.addTarget(self, action: #selector(handleInfoButton), for: .touchUpInside)
    
    addSubview(checkButton)
    checkButton.snp.makeConstraints {
      $0.centerY.equalTo(infoButton)
      $0.width.equalTo(width375(56.0))
      $0.height.equalTo(checkButton.snp.width)
      $0.trailing.equalTo(self).offset(-width375(4.0))
    }
    checkButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}

extension UIView {
  func addSubViewSnp(_ view: UIView, closure: (ConstraintMaker) -> Void) {
    self.addSubview(view)
    view.snp.makeConstraints(closure)
  }
}
