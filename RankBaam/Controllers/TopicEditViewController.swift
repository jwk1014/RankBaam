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

class ImageData: Equatable {
  var image: UIImage?
  var targetSize: CGSize
  var imageAsset: PHAsset
  
  init(imageAsset: PHAsset, targetSize: CGSize? =  nil) {
    self.imageAsset = imageAsset
    self.targetSize = targetSize ?? CGSize(
      width: imageAsset.pixelWidth, height: imageAsset.pixelHeight)
  }
  
  static func ==(lhs: ImageData, rhs: ImageData) -> Bool {
    return lhs.imageAsset == rhs.imageAsset
  }
}

protocol TopicEditDataProtocol {
  typealias OptionCellData = (imageData: ImageData?, text: String?)
  var delegate: TopicEditDataDelegate? { get set }
  
  var imageMaxCount: Int            { get }
  var titleMinLength: Int           { get }
  
  var category: Category?           { get set }
  var title: String?                { get set }
  var topicDescription: String?     { get set }
  var imageDatas: [ImageData]       { get set }
  var optionDatas: [OptionCellData] { get }
  var isVotableCount: Bool          { get set }
  var isOnlyWriterCreateOption: Bool  { get set }
  
  var isEnoughData: Bool            { get }
  
  func appendOptionData(optionData: OptionCellData)
  func updateOptionImageData(index: Int, imageData: ImageData?)
  func updateOptionTitle(index: Int, title: String?)
  func removeOptionData(index: Int)
}

protocol TopicEditDataDelegate: class {
  func updatedValue(category: Category?)
  func updatedState(isEnoughData: Bool)
  func addedOptionData(index: Int)
  func removedOptionData(oldIndex: Int)
}

protocol TopicEditDataSubmitDelegate: class {
  func updatedState(isEnoughData: Bool)
}

protocol TopicEditPhotoLibraryAuthDelegate: class {
  func requestPhotoLibraryAuthorization(
    status: PHAuthorizationStatus?, requestAuth: Bool, closure: @escaping ()->Void )
}

class TopicEditDataManager: TopicEditDataProtocol {
  weak var delegate: TopicEditDataDelegate?
  weak var submitDelegate: TopicEditDataSubmitDelegate?
  
  let imageMaxCount: Int = 5
  let titleMinLength: Int = 5
  
  var category: Category? = nil {
    didSet {
      if category != oldValue {
        delegate?.updatedValue(category: category)
        if checkEnoughData(category: oldValue, title: title) !=
          checkEnoughData(category: category, title: title) {
          delegate?.updatedState(isEnoughData: isEnoughData)
          submitDelegate?.updatedState(isEnoughData: isEnoughData)
        }
      }
    }
  }
  var title: String? = nil {
    didSet {
      if checkEnoughData(category: category, title: oldValue) !=
         checkEnoughData(category: category, title: title) {
        delegate?.updatedState(isEnoughData: isEnoughData)
        submitDelegate?.updatedState(isEnoughData: isEnoughData)
      }
    }
  }
  var topicDescription: String? = nil
  var imageDatas: [ImageData] = []
  var optionDatas: [OptionCellData] = []
  var optionDatasSemaphore = DispatchSemaphore(value: 1)
  var isVotableCount: Bool = false
  var isOnlyWriterCreateOption: Bool = false
  
  var isEnoughData: Bool {
    return checkEnoughData(category: category, title: title)
  }
  
  private func checkEnoughData(category: Category?, title: String?) -> Bool {
    return category != nil && !(title?.isEmpty ?? true)
  }
  
  func appendOptionData(optionData: OptionCellData) {
    optionDatasSemaphore.wait()
    optionDatas.append(optionData)
    delegate?.addedOptionData(index: optionDatas.count - 1)
    optionDatasSemaphore.signal()
  }
  
  func updateOptionImageData(index: Int, imageData: ImageData?) {
    optionDatasSemaphore.wait()
    guard optionDatas.count > index else { optionDatasSemaphore.signal(); return }
    optionDatas[index].imageData = imageData
    optionDatasSemaphore.signal()
  }
  
  func updateOptionTitle(index: Int, title: String?) {
    optionDatasSemaphore.wait()
    guard optionDatas.count > index else { optionDatasSemaphore.signal(); return }
    optionDatas[index].text = title
    optionDatasSemaphore.signal()
  }
  
  func removeOptionData(index: Int) {
    optionDatasSemaphore.wait()
    guard optionDatas.count > index else { optionDatasSemaphore.signal(); return }
    let _ = optionDatas.remove(at: index)
    delegate?.removedOptionData(oldIndex: index)
    optionDatasSemaphore.signal()
  }
  
}

protocol TopicEditCollectionViewManagerDelegate {
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
  func presentFade(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (()->Void)?)
}

class TopicEditCollectionViewManager: NSObject {
  typealias TopView = TopicEditTopView
  typealias BottomView = TopicEditBottomView
  
  private let sectionCount = 3
  private let top = (type: TopView.self, section: 0, identifier: "top")
  private let cell = (type: TopicEditOptionCell.self, section: 1, identifier: "cell")
  private let bottom = (type: BottomView.self, section: 2, identifier: "bottom")
  
  var delegate: (TopicEditCollectionViewManagerDelegate & TopicEditPhotoLibraryAuthDelegate)?
  var dataManager: TopicEditDataProtocol? {
    didSet { dataManager?.delegate = self }
  }
  
  private var topView: TopView?
  private var bottomView: BottomView?
  private weak var collectionView: UICollectionView?
  private weak var collectionViewLayout: UICollectionViewLayout?
  
  var firstResponder: UIResponder? {
    if let responder = topView?.firstResponder, responder.isFirstResponder {
      return responder
    } else if let responder = optionCellFirstResponder, responder.isFirstResponder {
      return responder
    }
    return nil
  }
  
  func collectionViewScrollForFirstResponder() {
    if let responder = topView?.firstResponder, responder.isFirstResponder {
      if let view = responder as? UIView {
        let rect = view.convert(view.bounds, to: collectionView)
        collectionView?.scrollRectToVisible(rect, animated: true)
      }
    } else if let responder = optionCellFirstResponder, responder.isFirstResponder {
      if let view = (responder as? UIView)?.superview {
        let rect = view.convert(view.bounds, to: collectionView)
        collectionView?.scrollRectToVisible(rect, animated: true)
      }
    }
  }
  
  private weak var optionCellFirstResponder: UIResponder?
  
  func register(collectionView: UICollectionView) {
    self.collectionView = collectionView
    self.collectionViewLayout = collectionView.collectionViewLayout
    collectionView.register(cell.type, forCellWithReuseIdentifier: cell.identifier)
    collectionView.register(top.type, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: top.identifier)
    collectionView.register(bottom.type, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: bottom.identifier)
  }
}

extension TopicEditCollectionViewManager: TopicEditDataDelegate {
  func updatedState(isEnoughData: Bool) {
    topView?.isVisibleButtomArea = isEnoughData
    self.collectionView?.performBatchUpdates({
      guard let collectionView = self.collectionView, let dataManager = self.dataManager else {return}
      let numberOfSections = collectionView.numberOfSections
      if isEnoughData {
        if numberOfSections < sectionCount {
          collectionView.insertSections(IndexSet(integersIn: numberOfSections..<sectionCount))
        }
        let count = dataManager.optionDatas.count
        if count > 0 {
          collectionView.insertItems(at: Array(0..<count)
            .map({IndexPath(row: $0, section: self.cell.section)}))
        }
      } else {
        if numberOfSections > 1 {
          collectionView.deleteSections(IndexSet(integersIn: 1..<numberOfSections))
        }
        self.removeAllCell(collectionView: collectionView)
      }
    }, completion: nil)
  }
  func updatedValue(category: Category?) {
    topView?.setCategoryButtonImage(category: category)
  }
  private func removeAllCell(collectionView: UICollectionView){
    let cellCount = collectionView.numberOfItems(inSection: self.cell.section)
    if cellCount > 0 {
      collectionView.deleteItems(at: Array(0..<cellCount)
        .map({IndexPath(row: $0, section: self.cell.section)}))
    }
  }
  func addedOptionData(index: Int) {
    guard let collectionView = collectionView, let dataManager = dataManager else {return}
    collectionView.performBatchUpdates({
      if dataManager.isEnoughData {
        collectionView.insertItems(at:
          [IndexPath(row: index, section: self.cell.section)])
      } else {
        self.removeAllCell(collectionView: collectionView)
      }
    }, completion: nil)
  }
  func removedOptionData(oldIndex: Int) {
    guard let collectionView = collectionView, let dataManager = dataManager else {return}
    collectionView.performBatchUpdates({
      if dataManager.isEnoughData {
        collectionView.deleteItems(at:
          [IndexPath(row: oldIndex, section: self.cell.section)])
      } else {
        self.removeAllCell(collectionView: collectionView)
      }
    }, completion: nil)
  }
}

extension TopicEditCollectionViewManager: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return (dataManager?.isEnoughData ?? false) ? sectionCount : 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == cell.section && (dataManager?.isEnoughData ?? false) {
      return dataManager?.optionDatas.count ?? 0
    }
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: self.cell.identifier, for: indexPath)
    
    if let cell = cell as? TopicEditOptionCell {
      cell.row = indexPath.row
      cell.delegate = self
      if let dataManager = dataManager, dataManager.optionDatas.count > indexPath.row {
        cell.textField?.text = dataManager.optionDatas[indexPath.row].text
        if let image = dataManager.optionDatas[indexPath.row].imageData?.image {
          cell.imageView?.image = image
        } else {
          cell.initImage()
        }
      } else {
        cell.initImage()
      }
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      if indexPath.section == top.section {
        let view: UICollectionReusableView = self.topView ?? {
          () -> UICollectionReusableView in
          let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: self.top.identifier, for: indexPath)
          if let topView = view as? TopicEditTopView {
            self.topView = topView
            topView.imageMaxCount = self.dataManager?.imageMaxCount ?? Int.max
            topView.delegate = self
          }
          return view
        }()
        
        return view
      } else if indexPath.section == bottom.section && (dataManager?.isEnoughData ?? false) {
        let view: UICollectionReusableView = {
          () -> UICollectionReusableView in
          let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: self.bottom.identifier, for: indexPath)
          
          if let bottomView = view as? TopicEditBottomView {
            bottomView.isVotableCount = self.dataManager?.isVotableCount ?? false
            bottomView.isOnlyWriterCreateOption = self.dataManager?.isOnlyWriterCreateOption ?? false
            bottomView.delegate = self
            self.bottomView = bottomView
          }
          return view
        }()
        
        return view
      }
    //case UICollectionElementKindSectionFooter:
    default: break
    }
    return UICollectionReusableView()
  }
}

extension TopicEditCollectionViewManager: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: width375(343.0), height: height667(72.0))
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == top.section {
      let topView = self.topView ?? TopicEditTopView()
      return CGSize(width: collectionView.bounds.width, height: topView.realHeight)
    } else if section == bottom.section && (dataManager?.isEnoughData ?? false) {
      let bottomView = self.bottomView ?? TopicEditBottomView()
      return bottomView.systemLayoutSizeFitting(.init(width: collectionView.bounds.width, height: 0))
    }
    return .zero
  }
}

extension TopicEditCollectionViewManager: TopicEditTopViewDelegate {
  func topViewHandleTapCategory() {
    let categorySelectVC = CategorySelectViewController()
    categorySelectVC.delegate = self
    //categorySelectVC.modalPresentationStyle = .overFullScreen
    //delegate?.present(categorySelectVC, animated: true, completion: nil)
    delegate?.presentFade(categorySelectVC, animated: true, completion: nil)
  }
  
  func topViewHandleTapAddImage() {
    delegate?.requestPhotoLibraryAuthorization(
      status: nil, requestAuth: true) {
        let picker = TopicCreatePhotoPickerViewController()
        let navi = UINavigationController(rootViewController: picker)
        picker.selectedPHAssetDataFromVC = self.dataManager?.imageDatas.map({$0.imageAsset}) ?? [PHAsset]()
        picker.delegate = self
        self.delegate?.present(navi, animated: true, completion: nil)
    }
  }
  
  func topViewValueUpdate(title: String) {
    dataManager?.title = title
  }
  
  func topViewValueUpdate(description: String) {
    dataManager?.topicDescription = description
    invalidateTopView()
  }
  
  func topViewValueRemove(image: UIImage) {
    dataManager?.imageDatas.enumerated()
      .filter({ $0.element.image == image })
      .forEach({ self.dataManager?.imageDatas.remove(at: $0.offset) })
  }
  
  func invalidateTopView(){
    if topView?.isNeedFrameHeightUpdate ?? false {
      collectionViewLayout?.invalidateLayout()
    }
  }
}

extension TopicEditCollectionViewManager: CategorySelectDelegate {
  func selected(category: Category?) {
    dataManager?.category = category
  }
}

extension TopicEditCollectionViewManager: TopicCreatePhotoPickerViewControllerDelegate{
  func photoPickerView(action: TopicCreatePhotoPickerViewAction) {
    switch action {
    case .success(let phAssets):
      if let topView = topView {
        
        topView.clearImageInImageArea()
        dataManager?.imageDatas.removeAll()
        
        for (index, phAsset) in phAssets.enumerated() {
          var ratio = Double(phAsset.pixelWidth) / Double(phAsset.pixelHeight)
          ratio = max(0.5, min(2.0, ratio))
          let h = Double(height667(170.0))
          
          let imageData = ImageData(imageAsset: phAsset, targetSize: CGSize(width: ratio * h, height: h))
          dataManager?.imageDatas.append(imageData)
          topView.setImageInImageArea(index: index, imageData: imageData)
        }
        
        let changedConstraint = topView.checkViewRelativeImage()
        topView.layoutIfNeeded()
        
        if changedConstraint || topView.isNeedFrameHeightUpdate {
          collectionViewLayout?.invalidateLayout()
        }
      }
    case .cancel:
      break
    }
  }
}

extension TopicEditCollectionViewManager: TopicEditOptionCellDelegate {
  func optionCellPresentPhotoSelectView(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    let picker = UIImagePickerController()
    picker.delegate = delegate
    self.delegate?.requestPhotoLibraryAuthorization(
      status: nil, requestAuth: true) {
        self.delegate?.present(picker, animated: true, completion: nil)
    }
  }
  func optionCellSelectedPhoto(row: Int, image: UIImage, phAsset: PHAsset) {
    let imageData = ImageData(imageAsset: phAsset)
    imageData.image = image
    dataManager?.updateOptionImageData(index: row, imageData: imageData)
  }
  func optionCellValueUpdate(row: Int, title: String?) {
    dataManager?.updateOptionTitle(index: row, title: title)
  }
  func optionCellDelete(row: Int) {
    dataManager?.removeOptionData(index: row)
  }
  func optionCellIsBecameFirstResponder(responder: UIResponder, isFirstResponder: Bool) {
    if isFirstResponder {
      optionCellFirstResponder = responder
    } else if optionCellFirstResponder == responder {
      optionCellFirstResponder = nil
    }
  }
}

extension TopicEditCollectionViewManager: TopicEditBottomViewDelegate {
  func bottomViewHandleTapOptionAdd() {
    dataManager?.appendOptionData(optionData:
      TopicEditDataProtocol.OptionCellData(imageData: nil, text: nil))
  }
  func bottomViewHandleTapInfo(type: TopicEditBottomCheckType) {
    var msg: String
    switch type {
    case .votableCount:
      msg = "투표하는 유저가 3개까지\n복수 선택을 할 수 있도록 합니다."
    case .onlyWriterCreateOption:
      msg = "다른 유저가 랭킹 항목을\n추가하도록 허용합니다."
    }
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
    delegate?.present(alert, animated: true, completion: nil)
  }
  func bottomViewHandleTapCheck(type: TopicEditBottomCheckType, isChecked: Bool) {
    switch type {
    case .votableCount:
      dataManager?.isVotableCount = isChecked
    case .onlyWriterCreateOption:
      dataManager?.isOnlyWriterCreateOption = isChecked
    }
  }
}

class TopicEditViewController: UIViewController {
  
  weak var collectionView: UICollectionView?
  weak var submitButton: UIButton?
  
  var dataManager = TopicEditDataManager()
  var collectionViewManager = TopicEditCollectionViewManager()
  var networkManager = TopicEditNetworkManager()
  
  var presentFadeInOutManager = PresentFadeInOutManager()
  
  @objc func handleBackButton(_ button: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataManager.submitDelegate = self
    collectionViewManager.delegate = self
    collectionViewManager.dataManager = dataManager
    initView()
    registEvent()
  }
  
  func initView(){
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
    titleLabel.text = "글쓰기"
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
    
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = .zero
    let collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: layout)
    
    collectionView.backgroundColor = .init(r: 246, g: 248, b: 250)
    collectionView.alwaysBounceHorizontal = false
    collectionView.alwaysBounceVertical = true
    collectionView.showsVerticalScrollIndicator = false
    
    collectionView.dataSource = collectionViewManager
    collectionView.delegate = collectionViewManager
    collectionViewManager.register(collectionView: collectionView)
    
    self.collectionView = collectionView
    self.view.insertSubview(collectionView, at: 0)
    collectionView.snp.makeConstraints{
      $0.top.equalTo(customNaviBarView.snp.bottom)
      $0.leading.trailing.bottom.equalTo(self.view)
    }
    
    let submitButton = UIButton()
    submitButton.backgroundColor = UIColor(r: 112, g: 112, b: 112)
    if let font = UIFont(name: "NanumSquareB", size: 16.0) {
      submitButton.setAttributedTitle(NSAttributedString(
        string: "글 등록하기",
        attributes: [
          .font: font,
          .foregroundColor: UIColor(r: 77, g: 77, b: 77)
        ]), for: .normal)
    }
    submitButton.addTarget(self, action: #selector(handleTapSubmitButton), for: .touchUpInside)
    self.submitButton = submitButton
    self.view.addSubview(submitButton)
    submitButton.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(height667(56.0))
    }
    
    submitButton.isEnabled = false
  }
  
}

extension TopicEditViewController: TopicEditPhotoLibraryAuthDelegate {
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
}

extension TopicEditViewController: TopicEditDataSubmitDelegate {
  func updatedState(isEnoughData: Bool) {
    submitButton?.isEnabled = isEnoughData
    submitButton?.backgroundColor =
      isEnoughData ? UIColor(r: 255, g: 195, b: 75) : UIColor(r: 112, g: 112, b: 112)
  }
  
  private func simpleAlert(_ message: String,_ handler: ((UIAlertAction)->Void)? ) {
    let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .cancel, handler: handler))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func handleTapSubmitButton(_ button: UIButton) {
    
    guard let topicCategory = dataManager.category else {
      simpleAlert("카테고리를 선택해주세요.", nil); return
    }
    
    guard let title = dataManager.title, title.count > 0 else {
        simpleAlert("제목을 입력해주세요.") { _ in
          //self.headerView?.titleTextField?.becomeFirstResponder()
        }; return
    }
    
    guard title.count >= 5 else {
      simpleAlert("제목은 5자 이상이여야 합니다.") { _ in
        //self.headerView?.titleTextField?.becomeFirstResponder()
      }; return
    }
    
    let topicWrite = TopicWrite( topicSN: nil,
      category: topicCategory,
      title: title,
      description: dataManager.topicDescription ?? "",
      isOnlyWriterCreateOption: dataManager.isOnlyWriterCreateOption,
      votableCountPerUser: (dataManager.isVotableCount) ? 3 : 1)
    
    let optionDatas: [TopicEditNetworkManager.OptionData] = dataManager.optionDatas
      .flatMap({
        if let text = $0.text, text.count > 0 {
          return TopicEditNetworkManager.OptionData(imageAsset: $0.imageData?.imageAsset, text: text)
        }
        return nil
      })
    
    
    let isSucc = networkManager.requestTopicCreate(
      topicWrite: topicWrite,
      topicImageAssets: dataManager.imageDatas.map({$0.imageAsset}),
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
}

extension TopicEditViewController {
  func registEvent(){
    view.addGestureRecognizer(UITapGestureRecognizer(
     target: self, action: #selector(resignSubViewsFirstResponder)))
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(_:)),
                                           name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(_:)),
                                           name: .UIKeyboardWillHide, object: nil)
  }
  
  @objc func resignSubViewsFirstResponder(_ sender: UITapGestureRecognizer) {
    if let responder = collectionViewManager.firstResponder {
      responder.resignFirstResponder()
    }
  }
  
  @objc func keyboardWillShow(_ noti: Notification){
    guard let collectionView = collectionView,
      let keyboardFrameHeight = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height else {return}
    
    collectionView.contentInset = .init(top: 0, left: 0,
                                        bottom: keyboardFrameHeight, right: 0)
    
    collectionViewManager.collectionViewScrollForFirstResponder()
  }
  
  @objc func keyboardWillHide(_ noti: Notification){
    collectionView?.contentInset = .zero
  }
}

extension TopicEditViewController: TopicEditCollectionViewManagerDelegate {
  func presentFade(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (()->Void)?) {
    viewControllerToPresent.transitioningDelegate = presentFadeInOutManager
    viewControllerToPresent.modalPresentationStyle = .custom
    present(viewControllerToPresent, animated: animated, completion: completion)
  }
}


class TopicEditNetworkManager {
  typealias OptionData = (imageAsset: PHAsset?, text:String)
  
  public enum FieldCheckType {
    
  }
  
  private var loadingSemaphore = DispatchSemaphore(value: 1)
  private var isLoading: Bool = false
  private var topicSN: Int?
  private var topicImageAssets: [PHAsset] = []
  private var optionDatas: [OptionData] = []
  private var presentClosure: ((Int)->Void)?
  init() {}
  private func initValue(){
    isLoading = false
    topicSN = nil
    topicImageAssets = []
    optionDatas = []
    presentClosure = nil
  }
  
  private func presentTopicDetail() {
    guard let topicSN = topicSN else { debugPrint("topicSN is nil"); return }
    guard let presentClosure = presentClosure else { debugPrint("presentClosure is nil"); return }
    initValue()
    presentClosure(topicSN)
  }
  
  private func requestOptionCreate() {
    if let topicSN = topicSN,
       let optionData = optionDatas.first {
      OptionService.create( optionWrite: OptionWrite(
        topicSN: topicSN,
        optionSN: nil,
        title: optionData.text,
        description: nil),
                            completion: responseOptionCreate)
    } else {
      presentTopicDetail()
    }
  }
  
  private func responseOptionCreate(response: DataResponse<SResultOptionCreate>) {
    switch(response.result) {
    case .success(let sResult):
      if sResult.succ {
        guard let optionSN = sResult.optionSN else {
            presentTopicDetail(); return
        }
        let previousOptionData = optionDatas.removeFirst()
        
        if let imageAsset = previousOptionData.imageAsset {
          requestOptionPhotoCreate(optionSN: optionSN, imageAsset: imageAsset)
        } else {
          requestOptionCreate()
        }
      } else if let msg = sResult.msg {
        switch msg { default: break }
        presentTopicDetail()
      }
    case .failure(let _):
      presentTopicDetail()
    }
  }
  
  private func requestOptionPhotoCreate(optionSN: Int, imageAsset: PHAsset) {
    guard let topicSN = topicSN else { debugPrint("topicSN is nil"); return }
    PHImageManager.default().requestImageData(
    for: imageAsset, options: nil) { (data,_,_,_) in
      if let data = data {
        OptionService.photoCreate(topicSN: topicSN, optionSN: optionSN,
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
  }
  
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
    if let topicSN = topicSN,
       !topicImageAssets.isEmpty {
      let topicImageAsset = topicImageAssets.removeFirst()
      PHImageManager.default().requestImageData(
      for: topicImageAsset, options: nil) { (data,_,_,info) in
        if let data = data {
          TopicService.photoCreate(topicSN: topicSN, photoData: data,
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
