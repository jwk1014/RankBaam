//
//  TopicEditCollectionViewManager.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 8..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos
/*
protocol TopicEditCollectionViewDataSource: class {
  var dataManager: TopicEditDataManager { get }
  var isSubmittable: Bool { get }
}

protocol TopicEditCollectionViewManagerDelegate {
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
  func presentFade(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (()->Void)?)
}

protocol TopicEditPhotoLibraryAuthDelegate: class {
  func requestPhotoLibraryAuthorization(
    status: PHAuthorizationStatus?, requestAuth: Bool, closure: @escaping ()->Void )
}

class TopicEditCollectionViewManager: NSObject {
  let CellInfo = (type: TopicEditOptionCell.self, identifier: "cell")
  
  private weak var collectionView: UICollectionView!
  //private weak var collectionViewLayout: StaticHeaderFooterFlowLayout!
  
  var firstResponder: UIResponder? {
    /*if let responder = topView?.firstResponder, responder.isFirstResponder {
      return responder
    } else */if let responder = optionCellFirstResponder, responder.isFirstResponder {
      return responder
    }
    return nil
  }
  
  func scrollForFirstResponder() {
    /*if let responder = topView?.firstResponder, responder.isFirstResponder {
      if let view = responder as? UIView {
        let rect = view.convert(view.bounds, to: collectionView)
        collectionView?.scrollRectToVisible(rect, animated: true)
      }
    } else */if let responder = optionCellFirstResponder, responder.isFirstResponder {
      if let view = (responder as? UIView)?.superview {
        let rect = view.convert(view.bounds, to: collectionView)
        collectionView?.scrollRectToVisible(rect, animated: true)
      }
    }
  }
  
  private weak var optionCellFirstResponder: UIResponder?
  
  func register(collectionView: UICollectionView){/*, dataSource: TopicEditCollectionViewDataSource) {*/
    //self.dataSource = dataSource
    self.collectionView = collectionView
    //self.collectionViewLayout = collectionView.collectionViewLayout as! StaticHeaderFooterFlowLayout
    collectionView.register(CellInfo.type, forCellWithReuseIdentifier: CellInfo.identifier)
  }
}

/*extension TopicEditCollectionViewManager {
  func setVisibleCellAndBottomView(isVisible: Bool) {
    topView?.isVisibleButtomArea = isVisible
    self.collectionView?.performBatchUpdates({
      let numberOfSections = collectionView.numberOfSections
      if isVisible {
        if numberOfSections < sectionCount {
          collectionView.insertSections(IndexSet(integersIn: numberOfSections..<sectionCount))
        }
        let count = self.dataSource.dataManager.options.count
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
}*/

extension TopicEditCollectionViewManager: TopicEditDataDelegate {
  func updatedValue(category: Category?) {
    topView?.setValue(categoryName: category?.name)
  }
  func updatedValue(title: String?) {}
  
  private func performBatchUpdatesCell(closure: (UICollectionView) -> Void){
    collectionView.performBatchUpdates({
      if self.dataSource.isSubmittable { closure(collectionView) }
      else { self.removeAllCell(collectionView: collectionView) }
    }, completion: nil)
  }
  private func removeAllCell(collectionView: UICollectionView){
    let cellCount = collectionView.numberOfItems(inSection: self.cell.section)
    if cellCount > 0 {
      collectionView.deleteItems(at: Array(0..<cellCount)
        .map({IndexPath(row: $0, section: self.cell.section)}))
    }
  }
  func addedOption(index: Int) {
    performBatchUpdatesCell{
      $0.insertItems(at: [IndexPath(row: index, section: self.cell.section)])
    }
  }
  func addedOptions(startIndex: Int, count: Int) {
    performBatchUpdatesCell{
      $0.insertItems(at: Array(startIndex..<(startIndex+count))
        .map({IndexPath(row: $0, section: self.cell.section)}))
    }
  }
  func removedOption(oldIndex: Int) {
    performBatchUpdatesCell {
      $0.deleteItems(at: [IndexPath(row: oldIndex, section: self.cell.section)])
    }
  }
}

extension TopicEditCollectionViewManager: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataSource.isSubmittable ? sectionCount : 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == cell.section && dataSource.isSubmittable {
      return dataSource.dataManager.options.count
    }
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: self.cell.identifier, for: indexPath)
    
    if let cell = cell as? TopicEditOptionCell {
      cell.row = indexPath.row
      cell.delegate = self
      if dataSource.dataManager.options.count > indexPath.row {
        cell.textField?.text = dataSource.dataManager.options[indexPath.row].text
        cell.initImage()
        if let imageView = cell.imageView {
          dataSource.dataManager.options[indexPath.row].imageData?.imageView = imageView
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
            topView.delegate = self
            topView.setValue(title: dataSource.dataManager.title ?? "")
            topView.setValue(description: dataSource.dataManager.topicDescription ?? "")
          }
          return view
        }()
        
        return view
      } else if indexPath.section == bottom.section && dataSource.isSubmittable {
        let view: UICollectionReusableView = {
          () -> UICollectionReusableView in
          let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: self.bottom.identifier, for: indexPath)
          
          if let bottomView = view as? TopicEditBottomView {
            bottomView.isVotableCount = self.dataSource.dataManager.isVotableCount ?? false
            bottomView.isOnlyWriterCreateOption = self.dataSource.dataManager.isOnlyWriterCreateOption ?? false
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
    } else if section == bottom.section && dataSource.isSubmittable {
      let bottomView = self.bottomView ?? TopicEditBottomView()
      return bottomView.systemLayoutSizeFitting(.init(width: collectionView.bounds.width, height: 0))
    }
    return .zero
  }
}

extension TopicEditCollectionViewManager: TopicEditTopViewDelegate {
  func topViewHandleTapCategory() {
    let categorySelectVC = CategorySelectViewController
      .createForCategory(selectedCategory: dataSource.dataManager.category)
    categorySelectVC.delegate = self
    delegate?.presentFade(categorySelectVC, animated: true, completion: nil)
  }
  
  func topViewHandleTapAddImage() {
    delegate?.requestPhotoLibraryAuthorization(
    status: nil, requestAuth: true) {
      let picker = TopicCreatePhotoPickerViewController()
      let navi = UINavigationController(rootViewController: picker)
      picker.selectedPHAssetDataFromVC = self.dataSource.dataManager.imageDatas.flatMap({$0.imageAsset}) ?? [PHAsset]()
      picker.delegate = self
      self.delegate?.present(navi, animated: true, completion: nil)
    }
  }
  
  func topViewValueUpdate(title: String) {
    dataSource.dataManager.setValue(title: title)
  }
  
  func topViewValueUpdate(description: String) {
    dataSource.dataManager.topicDescription = description
    invalidateTopView()
  }
  
  func topViewValueRemove(index: Int) {
    dataSource.dataManager.removeImageData(index: index)
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
    if topView?.isNeedFrameHeightUpdate ?? false {
      collectionViewLayout.invalidateLayout()
    }
  }
}

extension TopicEditCollectionViewManager: CategorySelectDelegate {
  func submitted(category: Category?) {
    dataSource.dataManager.category = category
  }
  func closed(category: Category?) {}
}

extension TopicEditCollectionViewManager: TopicCreatePhotoPickerViewControllerDelegate{
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
      dataSource.dataManager.setValue(imageDatas: imageBindDatas)
      topView.resetImages(imageBindDatas: imageBindDatas)
      let count = imageBindDatas.count
      topView.isVisibleImageArea = count > 0
      let beforeIsVisibleAddButton = topView.isVisibleAddButton
      topView.isVisibleAddButton = count < 5
      
      if beforeIsVisibleAddButton != topView.isVisibleAddButton ||
         topView.isNeedFrameHeightUpdate {
         collectionViewLayout?.invalidateLayout()
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
    dataSource.dataManager.updateOptionImage(
      index: row, imageData: ImageBindData(imageAsset: phAsset, image: image))
  }
  func optionCellValueUpdate(row: Int, title: String?) {
    dataSource.dataManager.updateOption(index: row, title: title)
  }
  func optionCellDelete(row: Int) {
    dataSource.dataManager.removeOption(index: row)
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
    dataSource.dataManager.append(option:
      TopicEditDataManager.OptionCellData(imageData: nil, text: nil, optionSN: nil))
  }
  func bottomViewHandleTapInfo(type: TopicEditBottomCheckType) {
    /*var msg: String
    switch type {
    case .votableCount:
      msg = "투표하는 유저가 3개까지\n복수 선택을 할 수 있도록 합니다."
    case .onlyWriterCreateOption:
      msg = "다른 유저가 랭킹 항목을\n추가하도록 허용합니다."
    }
    let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
    delegate?.present(alert, animated: true, completion: nil)*/
  }
  func bottomViewHandleTapCheck(type: TopicEditBottomCheckType, isChecked: Bool) {
    /*switch type {
    case .votableCount:
      delegate?.dataManager.isVotableCount = isChecked
    case .onlyWriterCreateOption:
      delegate?.dataManager.isOnlyWriterCreateOption = isChecked
    }*/
  }
}

extension TopicEditCollectionViewManager {
  
  func setValue(topic: Topic) {
    topView?.setValue(title: topic.title)
    topView?.setValue(description: topic.description)
    
  }
}*/
