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
import Photos

typealias ImageData = (image: UIImage, imageAsset: PHAsset)

class TopicCreateViewController: UIViewController, TopicCreateViewControllerCallback {
  enum ButtonTag: Int {
    case back = 1
    case cancel = 2
    case category = 3
    case addImage = 4
  }
  
  typealias OptionCellData = (imageData: ImageData?, text: String?)
  var topicSN: UInt? {
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
  
  var imageDatas = [ImageData]()
  var optionCellDatas = [OptionCellData?]()
  var optionCount = 0
  
  let topicCreateOptionCellTextFieldDelegateManager = TopicCreateOptionCellTextFieldDelegateManager()
  
  lazy var topicCreateNetworkModel = TopicCreateNetworkModel()
  
  @objc func handleButton(_ button: UIButton) {
    guard let buttonTag = ButtonTag(rawValue: button.tag) else {return}
    switch buttonTag {
    case .back, .cancel:
      self.dismiss(animated: true, completion: nil)
    case .category:
      let vc = CategorySelectViewController()
      vc.category = topicCategory
      vc.delegate = self
      present(vc, animated: true, transitioningDelegate: presentFadeInOutManager, completion: nil)
    case .addImage:
      requestPhotoLibraryAuthorization {
        //let picker = UIImagePickerController()
        //picker.delegate = self
        let picker = TopicCreatePhotoPickerViewController()
        let navi = UINavigationController.init(rootViewController: picker)
        if let headerView = self.headerView {
          picker.selectedPHAssetDataFromVC = headerView.imageDatas.map({$1})
        } else {
          picker.selectedPHAssetDataFromVC = self.imageDatas.map({$1})
        }
        picker.delegate = self
        self.present(navi, animated: true, completion: nil)
      }
    }
  }
  
  func requestPhotoLibraryAuthorization( status: PHAuthorizationStatus? = nil, requestAuth: Bool = true, closure: @escaping ()->Void ) {
    
    switch status ?? PHPhotoLibrary.authorizationStatus() {
      
    case .notDetermined:
      if requestAuth {
        PHPhotoLibrary.requestAuthorization{
          self.requestPhotoLibraryAuthorization(status: $0, requestAuth: false, closure: closure)
        }
      } else {
        assertionFailure("requestPhotoLibraryAuthorization requestAuth")
      }
      
    case .authorized:
      closure()
      
    case .denied:
      let alert = UIAlertController(title: nil, message: "사진 앨범에 접근하기 위해서 권한을 허용해주세요.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "설정", style: .default){ _ in
        if let settingUrl = URL(string: UIApplicationOpenSettingsURLString) {
          UIApplication.shared.open(settingUrl)
        }
      })
      alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
      
    case .restricted:
      let alert = UIAlertController(title: nil, message: "사진 앨범에 접근할 수 없습니다.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
      
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
    /*let topSpaceLayer = CALayer()
    topSpaceLayer.backgroundColor = UIColor.white.cgColor
    topSpaceLayer.frame = .init(x: 0, y: 0,
      width: view.bounds.width, height: height667(76.0))
    view.layer.addSublayer(topSpaceLayer)*/
    
    //MARK: CustomNaviBarView
    let customNaviBarView = UIView()
    view.addSubview(customNaviBarView)
    customNaviBarView.backgroundColor = .white
    customNaviBarView.isUserInteractionEnabled = true
    customNaviBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view)
      $0.height.equalTo(height667(76.0) - UIApplication.shared.statusBarFrame.height)
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
      if let url = info[UIImagePickerControllerReferenceURL] as? URL,
        let phAsset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject{
        headerView?.addImageInImageArea(imageData: ImageData(image: image, imageAsset: phAsset))
        headerView?.fitSizeImagesAreaScrollView()
        flowLayout?.invalidateLayout()
      }
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
        if let imageData = optionCellData.imageData {
          cell.imageView?.image = imageData.image
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
        } else {
          headerView.fitSizeImagesAreaScrollView()
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
  func selected(category: Category?) {
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
  /*func selectedCategory(category: Category?) {
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
  }*/
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
    
    let description = headerView?.descriptionString ?? self.topicDescription
    
    let isOnlyWriterCreateOption = footerView?.isOnlyWriterCreateOption ?? false
    
    let isVotableCountPerUser = footerView?.isVotableCount ?? false
    
    let topicWrite = TopicWrite.init(
      topicSN: nil,
      category: topicCategory,
      title: title,
      description: description ?? "",
      isOnlyWriterCreateOption: isOnlyWriterCreateOption,
      votableCountPerUser: (isVotableCountPerUser) ? 3 : 1)
    
    var optionDatas: [TopicCreateNetworkModel.OptionData] = []
    if let collectionView = self.collectionView, self.optionCount > 0 {
      let optionCount = self.optionCount
      var optionCellDatas = self.optionCellDatas
      if optionCellDatas.count < optionCount {
        optionCellDatas += Array<OptionCellData?>(
          repeating: nil, count: self.optionCount - self.optionCellDatas.count)
      }
      Array(0..<optionCount)
        .map({IndexPath(row: $0, section: 0)})
        .flatMap(collectionView.cellForItem)
        .flatMap({$0 as? TopicCreateOptionCell})
        .forEach{ cell in
          var imageData: ImageData?
          if let imageAsset = cell.imageAsset, let image = cell.imageView?.image {
            imageData = ImageData(image: image, imageAsset: imageAsset)
          } else {
            imageData = optionCellDatas[cell.index]?.imageData
          }
          optionCellDatas[cell.index] = OptionCellData(
            imageData: imageData,
            text: cell.textField?.text)
      }
      
      optionDatas = optionCellDatas
        .filter({$0 != nil})
        .map({$0!})
        .filter({$0.text != nil && $0.text!.count > 0})
        .map({ (imageData, text) -> TopicCreateNetworkModel.OptionData in
          return TopicCreateNetworkModel.OptionData(imageAsset: imageData?.imageAsset, text: text!)
        })
    }
    
    let isSucc = topicCreateNetworkModel.requestTopicCreate(
      topicWrite: topicWrite,
      topicImageAssets: (headerView?.imageDatas ?? imageDatas).map({$0.imageAsset}),
      optionDatas: optionDatas,
      presentClosure: {
        let vc = TopicDetailViewController()
        vc.topicSN = $0
        (self.presentingViewController as? UINavigationController)?.pushViewController(vc, animated: false)
        self.dismiss(animated: true, completion: nil)
      }, dismissClosure: {
        self.dismiss(animated: true, completion: nil)
    })
    
    if !isSucc { simpleAlert("이미 작업중입니다.", nil) }
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
  func cellDelegate(index: Int, imageData: ImageData?, text: String?) { //TODO
    if optionCellDatas.count-1 < index {
      optionCellDatas += Array<OptionCellData?>(repeating: nil, count: index+1-optionCellDatas.count)
    }
    optionCellDatas[index] = OptionCellData(imageData: imageData, text: text)
  }
  
  func present(vc: UIViewController) {
    if vc is UIImagePickerController {
      requestPhotoLibraryAuthorization {
        self.present(vc, animated: true, completion: nil)
      }
    } else {
      present(vc, animated: true, completion: nil)
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
  func cellDelegate(index: Int, imageData: ImageData?, text: String?)
  func present(vc: UIViewController)
}

//MARK: Cell
class TopicCreateOptionCell: UICollectionViewCell {
  var delegate: TopicCreateOptionCellDelegate?
  
  var index: Int = -1
  var imageAsset: PHAsset?
  private(set) weak var imageView: UIImageView?
  private(set) weak var textField: UITextField?
  
  override func prepareForReuse() {
    var imageData: ImageData?
    if let imageAsset = imageAsset, let image = imageView?.image {
      imageData = ImageData(image: image, imageAsset: imageAsset)
    }
    delegate?.cellDelegate(
      index: index,
      imageData: imageData,
      text: textField?.text)
    initData()
  }
  
  func initData() {
    index = -1
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
    self.delegate?.present(vc: picker)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      if let url = info[UIImagePickerControllerReferenceURL] as? URL,
        let phAsset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject{
        imageView?.tag = 1
        imageView?.image = image
        imageAsset = phAsset
      }
    }
    picker.dismiss(animated: true, completion: nil)
  }
}

protocol TopicCreateViewControllerCallback {
  var topicTitle: String? { get set }
  var topicDescription: String? { get set }
  var imageDatas: [ImageData] { get set }
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
  private var imagesAreaScrollViewHeightConstraint: NSLayoutConstraint?
  private(set) var imageDatas = [ImageData]()
  
  deinit {
      callback?.topicTitle = titleTextField?.text
      callback?.topicDescription = descriptionTextView?.text
      callback?.imageDatas = imageDatas
  }
  
  var isVisibleBottomArea: Bool = false {
    willSet{
      descriptionSeperatorView?.isHidden = !newValue
      optionsLabel?.isHidden = !newValue
    }
  }
  
  func fitSizeImagesAreaScrollView() {
    imagesAreaScrollViewHeightConstraint?.isActive = (imageDatas.count > 0)
  }
  
  func addImagesInImageArea(imageDatas: [ImageData]) {
    imageDatas.forEach(addImageInImageArea)
  }
  
  var tmpAssets: [PHAsset] = []
  
  func resetImagesInImageArea(phAssets: [PHAsset]) {
    guard phAssets.count > 0 else {return}
    clearImageInImageArea()
    tmpAssets = phAssets
    requestImage()
  }
  
  func requestImage() {
    let phAsset = tmpAssets.first!
    
    var ratio = Double(phAsset.pixelWidth) / Double(phAsset.pixelHeight)
    ratio = max(0.5, min(2.0, ratio))
    let h = Double(height667(121.0))
    
    PHImageManager.default().requestImage(for: phAsset, targetSize: CGSize(width: ratio * h, height: h), contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: patchImageResultHandler)
  }
  
  func patchImageResultHandler(image: UIImage?, info: [AnyHashable:Any]?){
    defer {
      if tmpAssets.count > 0 {
        requestImage()
      } else {
        fitSizeImagesAreaScrollView()
        callback?.invalidateLayoutCollectionView()
      }
    }
    guard let image = image, tmpAssets.count > 0 else {return}
    addImageInImageArea(imageData: ImageData(image: image, imageAsset: tmpAssets.remove(at: 0)))
  }
  
  //min max
  func addImageInImageArea(imageData: ImageData){
    guard let imageAreaStackView = imageAreaStackView else {return}
    
    let imageView = UIImageView()
    imageView.image = imageData.image
    imageAreaStackView.addArrangedSubview(imageView)
    imageView.layer.cornerRadius = 10.0
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFit
    var ratio = imageData.image.size.width / imageData.image.size.height
    ratio = max(0.5, min(2, ratio))
    imageView.snp.makeConstraints{
      $0.height.equalToSuperview()
      $0.width.equalTo(imageView.snp.height).multipliedBy(ratio)
    }
    imageView.isUserInteractionEnabled = true
    
    imageDatas.append(imageData)
    
    let button = UIButton(type: .custom)
    if let image = UIImage(named: "x_icn") {
      button.setImage(
        image.copy(
          with: .init(top: 6, left: 6, bottom: 6, right: 6),
          isTemplate: false),
        for: .normal)
    }
    imageView.addSubview(button)
    button.addTarget(self, action: #selector(removeImageInImageArea), for: .touchUpInside)
    button.snp.makeConstraints {
      $0.top.trailing.equalTo(imageView)
      $0.width.equalTo(width375(30.0))
      $0.height.equalTo(button.snp.width)
    }
  }
  
  func clearImageInImageArea(){
    guard let imageViews = imageAreaStackView?.arrangedSubviews.flatMap({ $0 as? UIImageView }),
      imageViews.count > 0 else { return }
    imageDatas.removeAll()
    for imageView in imageViews {
      imageView.removeFromSuperview()
    }
  }
  
  @objc func removeImageInImageArea(_ button: UIButton){
    guard let imageView = imageAreaStackView?.arrangedSubviews.filter({
      $0 == button.superview
    }).first as? UIImageView else {return}
    if let index = imageDatas.index(where: {$0.image == imageView.image}) {
      imageDatas.remove(at: index)
    }
    imageView.removeFromSuperview()
    if imageDatas.count == 0 {
      fitSizeImagesAreaScrollView()
      callback?.invalidateLayoutCollectionView()
    }
  }
  
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
  
  var descriptionString: String {
    if let descriptionTextView = descriptionTextView,
       descriptionTextView.textColor == descriptionPlaceholderTextColor{
      return descriptionTextView.text
    }
    return ""
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
    if let imageAreaStackView = imageAreaStackView {
      imageDatas = headerView.imageDatas
      for (index, arrangedSubview) in imageAreaStackView.arrangedSubviews.enumerated() {
        if index < imageDatas.count, let imageView = arrangedSubview as? UIImageView {
          imageView.image = imageDatas[index].image
        } else {
          arrangedSubview.removeFromSuperview()
        }
      }
      imagesAreaScrollViewHeightConstraint?.isActive = (imageDatas.count > 0)
    }
    if let title = headerView.titleTextField?.text {
      titleTextField?.text = title
    }
    let description = headerView.descriptionString
    descriptionTextView?.textColor = (description.count == 0) ?
      descriptionPlaceholderTextColor : descriptionTextColor
    descriptionTextView?.text = description
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
    self.addSubview(imagesAreaScrollView)
    imagesAreaScrollView.snp.makeConstraints {
      $0.leading.trailing.equalTo(self)
      $0.top.equalTo(addImageLabel.snp.bottom)
        .offset(height667(34.0))
      $0.height.equalTo(0).priority(ConstraintPriority.high)
    }
    imagesAreaScrollViewHeightConstraint = imagesAreaScrollView.heightAnchor.constraint(equalToConstant: height667(121.0))
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
      $0.top.leading.trailing.bottom.equalTo(imagesAreaScrollView)
      $0.height.equalToSuperview()
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
      //$0.height.equalTo(height667(20))
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
    titleLabel.font = UIFont(name: "NanumSquareB", size: 14.0)
    titleLabel.textColor = UIColor(r: 112, g: 112, b: 112)
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
    votableCountLabel.textColor = UIColor(r: 112, g: 112, b: 112)
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

class TopicCreateNetworkModel {
  typealias OptionData = (imageAsset: PHAsset?, text:String)
  private var loadingSemaphore = DispatchSemaphore(value: 1)
  private var isLoading: Bool = false
  private var topicSN: Int?
  private var topicImageAssets: [PHAsset]?
  private var optionDatas: [OptionData]?
  private var presentClosure: ((Int)->Void)?
  init() {}
  private func initValue(){
    isLoading = false
    topicSN = nil
    topicImageAssets = nil
    optionDatas = nil
    presentClosure = nil
  }
  
  private func presentTopicDetail() {
    guard let topicSN = topicSN else { debugPrint("topicSN is nil"); return }
    guard let presentClosure = presentClosure else { debugPrint("presentClosure is nil"); return }
    initValue()
    presentClosure(topicSN)
  }
  
  private func requestOptionCreate() {
    if  let topicSN = topicSN,
        let optionData = optionDatas?.first {
      let optionCreateClosure: (Data?) -> Void = { photoData in
        OptionService.create( optionWrite: OptionWrite(
            topicSN: topicSN,
            optionSN: nil,
            title: optionData.text,
            description: nil),
            photoData: photoData,
          completion: self.responseOptionCreate)
      }
      
      if let imageAsset = optionData.imageAsset {
        PHImageManager.default().requestImageData(
          for: imageAsset, options: nil) { (data,_,_,_) in
            optionCreateClosure(data)
        }
      } else {
        optionCreateClosure(nil)
      }
    } else {
      presentTopicDetail()
    }
  }
  
  private func responseOptionCreate(response: DataResponse<SResultOptionCreate>) {
    switch(response.result) {
    case .success(let sResult):
      if sResult.succ {
        guard let _ = sResult.optionSN,
              let _ = optionDatas?.removeFirst() else {
          presentTopicDetail(); return
        }
        
        requestOptionCreate()
      } else if let msg = sResult.msg {
        switch msg { default: break }
        presentTopicDetail()
      }
    case .failure(let _):
      presentTopicDetail()
    }
  }
  
  /*private func requestOptionPhotoCreate(optionSN: Int, imageAsset: PHAsset) {
    guard let topicSN = topicSN else { debugPrint("topicSN is nil"); return }
    PHImageManager.default().requestImageData(
      for: imageAsset, options: nil) { (data,_,_,_) in
        if let data = data {
        OptionService.photoCreate(
          topicSN: topicSN, optionSN: optionSN,
          photoData: data, completion: self.responseOptionPhotoCreate)
        } else {
          self.requestOptionCreate()
        }
    }
  }
  
  private func responseOptionPhotoCreate(response: DataResponse<SResult>) {
    switch(response.result) {
    case .success(let sResult):
      if sResult.succ {
        requestOptionCreate()
      } else if let msg = sResult.msg {
        switch msg { default: break }
        requestOptionCreate()
      }
    case .failure(let _):
      requestOptionCreate()
    }
  }*/
  
  func requestTopicCreate(
    topicWrite: TopicWrite, topicImageAssets: [PHAsset], optionDatas: [OptionData],
    presentClosure: @escaping ((Int)->Void),
    dismissClosure: @escaping (()->Void)) -> Bool {
    
    loadingSemaphore.wait()
    guard !isLoading else {
      loadingSemaphore.signal()
      return false
    }
    isLoading = true
    loadingSemaphore.signal()
    
    TopicService.create(topicWrite: topicWrite) {
      switch($0.result) {
      case .success(let sResult):
        if sResult.succ {
          guard let topicSN = sResult.topicSN else { self.initValue(); dismissClosure(); return }
          self.topicSN = topicSN
          self.optionDatas = optionDatas
          self.presentClosure = presentClosure
          self.topicImageAssets = topicImageAssets
          self.requestTopicPhotoCreate()
        } else if let msg = sResult.msg {
          switch msg { default: break }
          self.initValue(); dismissClosure(); return
        }
      case .failure(let _):
        self.initValue(); dismissClosure(); return
      }
    }
    
    return true
  }
  
  private func requestTopicPhotoCreate(){
    if  let topicSN = topicSN,
        let topicImageAsset = topicImageAssets?.first {
        topicImageAssets?.removeFirst()
        PHImageManager.default().requestImageData(
        for: topicImageAsset, options: nil) { (data,_,_,_) in
          if let data = data {
            TopicService.photoCreate(
              topicSN: topicSN, photoData: data,
              completion: self.responseTopicPhotoCreate)
          } else {
            self.requestOptionCreate()
          }
        }
    } else {
      self.requestOptionCreate()
    }
  }
  
  private func responseTopicPhotoCreate(response: DataResponse<SResult>) {
    switch(response.result) {
    case .success(let sResult):
      if sResult.succ {
        requestTopicPhotoCreate()
      } else if let msg = sResult.msg {
        switch msg { default: break }
        requestOptionCreate()
      }
    case .failure(let _):
      requestOptionCreate()
    }
  }
}

extension TopicCreateViewController: TopicCreatePhotoPickerViewControllerDelegate {
  func photoPickerView(action: TopicCreatePhotoPickerViewAction) {
    switch action {
    case .success(let phAssets):
      self.headerView?.resetImagesInImageArea(phAssets: phAssets)
      //self.headerView?.clearImageInImageArea()
      //patchImageInImageArea(phAssets: phAssets)
      break
    case .cancel:
      break
    }
  }
  
  /*func patchImageInImageArea(phAssets: [PHAsset]) {
    guard phAssets.count > 0 else {
      self.flowLayout?.invalidateLayout(); return
    }
    
    var tmpPhAssets = phAssets
    
    let phAsset = tmpPhAssets.remove(at: 0)
    var ratio = Double(phAsset.pixelWidth) / Double(phAsset.pixelHeight)
    ratio = max(0.5, min(2.0, ratio))
    let h = Double(height667(121.0))
    
    PHImageManager.default().requestImage(for: phAsset, targetSize: CGSize(width: ratio * h, height: h), contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: patchImageResultHandler)
    /*PHImageManager.default().requestImage(for: phAsset,
      targetSize: CGSize(width: ratio * h, height: h),
      contentMode: PHImageContentMode.aspectFit, options: nil ) { image, _ in
        if let image = image {
          self.headerView?.addImageInImageArea(imageData: ImageData(
              image: image, imageAsset: phAsset))
        }
        self.patchImageInImageArea(phAssets: tmpPhAssets)
    }*/
  }
  
  func patchImageResultHandler(image: UIImage?, info: [AnyHashable: Any]?){
    if let image = image {
      self.headerView?.addImageInImageArea(imageData: ImageData(
        image: image, imageAsset: phAsset))
    }
    self.patchImageInImageArea(phAssets: tmpPhAssets)
  }*/
}
