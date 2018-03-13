//
//  TopicEditPresenter.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 12..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos

protocol TopicEditPresenterDelegate: PhotoLibraryAuthManagerDelegate {
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
  func presentFade(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (()->Void)?)
  func pushViewController(_ viewController: UIViewController, animated: Bool)
  func dismiss(animated: Bool, completion: (() -> Void)?)
  func changeValue(isSubmittable: Bool)
}

class TopicEditPresenter {
  var isSubmittable: Bool = false
  var cellSection: Int = 0
  private(set) var dataManager = TopicEditDataManager()
  private(set) var networkManager = TopicEditNetworkManager()
  private(set) var pageManager = PageManager()
  weak var collectionView: UICollectionView!
  weak var topView: TopicEditTopView? {
    didSet {
      if let topView = topView {
        topView.delegate = self
      }
    }
  }
  weak var bottomView: TopicEditBottomView? {
    didSet {
      if let bottomView = bottomView {
        bottomView.delegate = self
      }
    }
  }
  weak var delegate: TopicEditPresenterDelegate?
  
  init() {
    dataManager.delegate = self
    networkManager.delegate = self
  }
  
  var submittableSemaphore = DispatchSemaphore(value: 1)
  func updateSubmittable(isSubmittable: Bool) {
    if self.isSubmittable != isSubmittable {
      submittableSemaphore.wait()
      self.isSubmittable = isSubmittable
      delegate?.changeValue(isSubmittable: isSubmittable)
      bottomView?.isHidden = !isSubmittable
      collectionView.reloadData()
      submittableSemaphore.signal()
    }
  }
}

extension TopicEditPresenter: TopicEditDataDelegate {
  func updatedValue(category: Category?) {
    topView?.setValue(categoryName: category?.name)
    updateSubmittable(isSubmittable: (category != nil && !dataManager.isEmptyTitle))
  }
  func updatedValue(title: String?) {
    updateSubmittable(isSubmittable: (dataManager.category != nil && !dataManager.isEmptyTitle))
  }
  
  private func performBatchUpdatesCell(closure: (UICollectionView) -> Void){
    collectionView.performBatchUpdates({
      if self.isSubmittable { closure(collectionView) }
      else { self.removeAllCell(collectionView: collectionView) }
    }, completion: nil)
  }
  private func removeAllCell(collectionView: UICollectionView){
    let cellCount = collectionView.numberOfItems(inSection: self.cellSection)
    if cellCount > 0 {
      collectionView.deleteItems(at: Array(0..<cellCount)
        .map({IndexPath(row: $0, section: self.cellSection)}))
    }
  }
  func addedOption(index: Int) {
    performBatchUpdatesCell{
      $0.insertItems(at: [IndexPath(row: index, section: self.cellSection)])
    }
  }
  func addedOptions(startIndex: Int, count: Int) {
    performBatchUpdatesCell{
      $0.insertItems(at: Array(startIndex..<(startIndex+count))
        .map({IndexPath(row: $0, section: self.cellSection)}))
    }
  }
  func removedOption(oldIndex: Int) {
    performBatchUpdatesCell {
      $0.deleteItems(at: [IndexPath(row: oldIndex, section: self.cellSection)])
    }
  }
}

extension TopicEditPresenter: CategorySelectDelegate {
  func submitted(category: Category?) {
    dataManager.category = category
  }
  func closed(category: Category?) {}
}

extension TopicEditPresenter: TopicEditTopViewDelegate {
  func topViewHandleTapCategory() {
    let categorySelectVC = CategorySelectViewController
      .createForCategory(selectedCategory: dataManager.category)
    categorySelectVC.delegate = self
    delegate?.presentFade(categorySelectVC, animated: true, completion: nil)
  }
  
  func topViewHandleTapAddImage() {
    requestPhotoLibraryAuthorization( status: nil, requestAuth: true) {
      let picker = TopicCreatePhotoPickerViewController()
      picker.limitNumberOfPhotoSelection = 5
      let navi = UINavigationController(rootViewController: picker)
      picker.selectedPHAssetDataFromVC = self.dataManager.imageDatas.flatMap({$0.imageAsset})
      picker.delegate = self
      self.delegate?.present(navi, animated: true, completion: nil)
    }
  }
  
  func topViewValueUpdate(title: String) {
    dataManager.setValue(title: title)
  }
  
  func topViewValueUpdate(description: String) {
    dataManager.topicDescription = description
    invalidateTopView()
  }
  
  func topViewValueRemove(index: Int) {
    dataManager.removeImageData(index: index)
    let count = topView?.countImageViews
    if count == 0 {
      topView?.isVisibleImageArea = false
      invalidateTopView()
    } else if count == 5 - 1 {
      topView?.isVisibleAddButton = true
      invalidateTopView()
    }
  }
  
  func invalidateTopView(){
    if topView?.updateFrameHeight() ?? false {
      collectionView?.collectionViewLayout.invalidateLayout()
    }
  }
}

extension TopicEditPresenter: TopicEditOptionCellDelegate {
  func optionCellPresentPhotoSelectView(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
    /////TODO
  }
  func optionCellSelectedPhoto(row: Int, image: UIImage, phAsset: PHAsset) {
    dataManager.updateOptionImage(index: row, imageData: ImageBindData(
      imageAsset: phAsset, image: image))
  }
  func optionCellValueUpdate(row: Int, title: String?) {
    dataManager.updateOption(index: row, title: title)
  }
  func optionCellDelete(row: Int) {
    dataManager.removeOption(index: row)
  }
  func optionCellIsBecameFirstResponder(responder: UIResponder, isFirstResponder: Bool) {
    ////TODO
  }
}

extension TopicEditPresenter: TopicEditBottomViewDelegate {
  func bottomViewHandleTapOptionAdd() {
    dataManager.append(option: TopicEditDataManager.OptionCellData(
      optionSN: nil, text: nil, imageData: nil))
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
      let _ = dataManager.setValue(isVotableCount: isChecked)
    case .onlyWriterCreateOption:
      let _ = dataManager.setValue(isOnlyWriterCreateOption: isChecked)
    }
  }
}

extension TopicEditPresenter: TopicCreatePhotoPickerViewControllerDelegate {
  func photoPickerView(action: TopicCreatePhotoPickerViewAction) {
    switch action {
    case .success(let phAssets):
      guard let topView = topView else { return }
      var imageBindDatas = [ImageBindData]()
      for phAsset in phAssets {
        var ratio = Double(phAsset.pixelWidth) / Double(phAsset.pixelHeight)
        ratio = max(0.5, min(2.0, ratio))
        let h = Double(height667(170.0)) ////TODO FIX
        
        let imageData = ImageBindData(imageAsset: phAsset,
                                      targetSize: CGSize(width: ratio * h, height: h))
        imageBindDatas.append(imageData)
      }
      dataManager.setValue(imageDatas: imageBindDatas)
      topView.resetImages(imageBindDatas: imageBindDatas)
      let count = imageBindDatas.count
      var needUpdate = false
      if topView.isVisibleImageArea != (count > 0) {
        topView.isVisibleImageArea = (count > 0)
        needUpdate = true
      }
      if topView.isVisibleAddButton != (count < 5) {
        topView.isVisibleAddButton = (count < 5)
        needUpdate = true
      }
      if needUpdate {
        collectionView?.collectionViewLayout.invalidateLayout()
      }
    case .cancel:
      break
    }
  }
}

extension TopicEditPresenter {
  func requestPhotoLibraryAuthorization( status: PHAuthorizationStatus? = nil, requestAuth: Bool = true, closure: @escaping ()->Void ) {
    let status = PHPhotoLibrary.authorizationStatus()
    if status == .authorized {
      closure()
    } else if let delegate = delegate {
      PhotoLibraryAuthManager(delegate: delegate).requestPhotoLibraryAuthorization(
        status: status, requestAuth: true, closure: closure)
    }
  }
}

extension TopicEditPresenter {
  private func simpleAlert(_ message: String,_ handler: ((UIAlertAction)->Void)? ) {
    let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
    alert.addAction(.init(title: "확인", style: .cancel, handler: handler))
    delegate?.present(alert, animated: true, completion: nil)
  }
  func submit(editType: TopicEditViewController.EditType){
    guard let topicCategory = dataManager.category else {
      simpleAlert("카테고리를 선택해주세요.", nil); return
    }
    
    guard let title = dataManager.title, title.count > 0 else {
      simpleAlert("제목을 입력해주세요.") { _ in
        /////TODO
        //self.headerView?.titleTextField?.becomeFirstResponder()
      }; return
    }
    
    guard title.count >= 5 else {
      simpleAlert("제목은 5자 이상이여야 합니다.") { _ in
        /////TODO
        //self.headerView?.titleTextField?.becomeFirstResponder()
      }; return
    }
    
    let topicWrite = TopicWrite( topicSN: dataManager.topicSN,
                                 category: topicCategory,
                                 title: title,
                                 description: dataManager.topicDescription ?? "",
                                 isOnlyWriterCreateOption: dataManager.isOnlyWriterCreateOption,
                                 votableCountPerUser: (dataManager.isVotableCount) ? 3 : 1) ////TODO FIX
    
    let optionDatas: [TopicEditNetworkManager.OptionData] = dataManager.options
      .flatMap({
        if let text = $0.text, text.count > 0 {
          return TopicEditNetworkManager.OptionData(imageAsset: $0.imageData?.imageAsset, text: text)
        }
        return nil
      })
    
    var isSucc = false
    switch editType {
    case .create:
      isSucc = networkManager.requestTopicCreate(
        topicWrite: topicWrite,
        topicImageAssets: dataManager.imageDatas.flatMap({$0.imageAsset}),
        optionDatas: optionDatas)
    case .modify:
      break ////TODO
    }
    
    if !isSucc { simpleAlert("이미 작업중입니다.", nil) }
  }
}

extension TopicEditPresenter: TopicEditNetworkManagerDelegate {
  func loaded(topic: Topic) {
    dataManager.setValue(category: topic.category, title: topic.title, topicDescription: topic.description, isVotableCount: !(topic.votableCountPerUser == 1), isOnlyWriterCreateOption: topic.isOnlyWriterCreateOption)
    topView?.setValue(title: topic.title)
    topView?.setValue(description: topic.description)
    
    let _ = networkManager.requestOptionList(topicSN: topic.topicSN, page: pageManager.page)
  }
  func loaded(page: Int, options: [Option]?) {
    if let options = options {
      dataManager.append(options: options.map({
        var imageData: ImageBindData? = nil
        if let photo = $0.photos.first, let url = URL(string: photo.realUrl) {
          imageData = ImageBindData(url: url)
        }
        return (imageData: imageData, text: $0.title, optionSN: $0.optionSN)
      }))
      pageManager.increasePage()
    } else {
      pageManager.noMore()
    }
    pageManager.endLoading()
  }
  func submitted(topicSN: Int?) {
    if let topicSN = topicSN {
      let vc = TopicDetailViewController()
      vc.topicSN = topicSN
      delegate?.pushViewController(vc, animated: true)
      delegate?.dismiss(animated: true, completion: nil)
    } else {
      assertionFailure("topic create fail")
    }
  }
}
