//
//  OptionDetailViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 6..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

fileprivate extension UILabel {
  static func createForSystemLayoutSizeFitting(
    font: UIFont?, numberOfLines: Int, width: CGFloat? = nil) -> UILabel {
    let label = UILabel()
    label.numberOfLines = numberOfLines
    label.font = font
    if let width = width {
      label.snp.makeConstraints {
        $0.width.equalTo(width)
      }
    }
    return label
  }
}

class OptionDetailViewController: UIViewController {
  private enum Kind{
    case topHeader, header, indicatorHeader, cell, footer
    var string: String {
      switch self {
      case .topHeader: return "topHeader"
      case .header: return "header"
      case .indicatorHeader: return "indicatorHeader"
      case .cell: return "cell"
      case .footer: return "footer"
      }
    }
  }
  var dataManager: OptionDetailDataManager!
  var networkManager: OptionDetailNetworkManager!
  
  weak var collectionView: UICollectionView?
  weak var flowLayout: UICollectionViewFlowLayout?
  
  let referenceSizeHeaderDescriptionLabel: UILabel =
    UILabel.createForSystemLayoutSizeFitting(
      font: UIFont(name: "NanumSquareR", size: 14.0),
      numberOfLines: 0, width: width375(250.0))
  
  let referenceSizeCellDescriptionLabel: UILabel =
    UILabel.createForSystemLayoutSizeFitting(
      font: UIFont(name: "NanumSquareR", size: 14.0),
      numberOfLines: 0, width: width375(303.0))
  
  weak var upButton: UIButton?
  weak var supportBarView: OptionDetailSupportVersusGaugeBarView?
  weak var topHeaderSupportBarView: UIView?
  weak var topHeaderTextView: UIView?
  var topHeaderTextViewConvertFrame: CGRect?
  
  var isOpenCloseProcessing: Bool = false
  let openCloseCheckSemaphore = DispatchSemaphore(value: 1)
  
  static func create(topicSN: Int, optionSN: Int) -> OptionDetailViewController {
    let vc = OptionDetailViewController()
    vc.dataManager = OptionDetailDataManager(topicSN: topicSN, optionSN: optionSN)
    vc.networkManager = OptionDetailNetworkManager(optionDetailNetworkDataManager: vc.dataManager)
    return vc
  }

  override func viewDidLoad() {
      super.viewDidLoad()
      initView()
      NotificationCenter.default.addObserver(self,
         selector: #selector(keyboardWillShow(_:)),
         name: .UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self,
         selector: #selector(keyboardWillHide(_:)),
         name: .UIKeyboardWillHide, object: nil)
      collectionView?.refreshControl?.beginRefreshing()
      refreshData()
  }
  
  @objc func keyboardWillShow(_ noti: Notification){
    guard let collectionView = collectionView,
          let keyboardFrameHeight = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.height else {return}
    
    collectionView.contentInset = .init(top: 0, left: 0,
      bottom: keyboardFrameHeight, right: 0)
    
    if topHeaderTextView?.isFirstResponder ?? false {
      guard let topHeaderTextViewConvertFrame = topHeaderTextViewConvertFrame else { return }
      var point = CGPoint(x: 0, y: topHeaderTextViewConvertFrame.origin.y)
      point.y += topHeaderTextViewConvertFrame.height
      point.y -= collectionView.bounds.height - keyboardFrameHeight - 20 /////////
      collectionView.setContentOffset(point, animated: true)
      //collectionView.scrollRectToVisible(topHeaderTextViewConvertFrame, animated: true)
    }
    //// TODO 대댓글 입력
  }
  
  @objc func keyboardWillHide(_ noti: Notification){
    collectionView?.contentInset = .zero
  }
  
  @objc func handleTapCell(_ sender: UITapGestureRecognizer) {
    if let textView = topHeaderTextView, textView.isFirstResponder {
      textView.resignFirstResponder()
    }
  }
  
  @objc func handleBackButton(_ button: UIButton) {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func handleUpButton(_ button: UIButton) {
    collectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
  }
  
  @objc func handleRefreshCollectionView(_ refreshControl: UIRefreshControl) {
    refreshData()
  }
  
  func refreshData() {
    networkManager.requestRefresh(senderClosure: (
      s: { (optionComments: [OptionComment]) in
        guard let collectionView = self.collectionView else {return}
        let originSectionCount = collectionView.numberOfSections
        self.dataManager.clear()
        let _ = self.dataManager.addComments(comments: optionComments)
        let newSectionCount = self.dataManager.optionDetailSectionCount()
        let compareSectionCount = newSectionCount - originSectionCount
        self.collectionView?.performBatchUpdates({
          if compareSectionCount > 0 {
              collectionView.insertSections(IndexSet(integersIn: originSectionCount..<newSectionCount))
          } else if compareSectionCount < 0 {
              collectionView.deleteSections(IndexSet(integersIn: newSectionCount..<originSectionCount))
          }
        }, completion: { completion in
          if completion {
            let reloadSections = IndexSet(integersIn:
              0..<self.dataManager.optionDetailSectionCount())
            self.collectionView?.reloadSections(reloadSections)
            self.collectionView?.refreshControl?.endRefreshing()
          }
        })
      },
      f: {
        switch $0 {
          case .loading: break
          case .overflow:
            self.dataManager.more = false
            self.collectionView?.performBatchUpdates({
              if let numberOfSections = self.collectionView?.numberOfSections {
                if numberOfSections > 1 {
                self.collectionView?.deleteSections(IndexSet(integersIn: 1..<numberOfSections))
                } else if numberOfSections == 0 {
                  self.collectionView?.insertSections(IndexSet(integer: 0))
                }
              }
            }, completion: { completion in
              if completion {
                self.collectionView?.reloadSections(IndexSet(integer: 0))
                self.collectionView?.refreshControl?.endRefreshing()
              }
            })
          case .`else`( _): break
          case .error( _): break
        }
        self.collectionView?.refreshControl?.endRefreshing()
      },
      c: nil))
  }
  
  func initView(){
    let customNaviBarView = UIView()
    view.addSubview(customNaviBarView)
    customNaviBarView.backgroundColor = .white
    customNaviBarView.isUserInteractionEnabled = true
    customNaviBarView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(self.view)
      $0.height.equalTo(height667(56.0) + UIApplication.shared.statusBarFrame.height)
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
      $0.leading.equalTo(customNaviBarView).offset(width375(6.0))
      $0.bottom.equalTo(customNaviBarView)
      $0.width.equalTo(width375(44.0))
      $0.height.equalTo(backButton.snp.width)
    }
    
    let titleLabel = UILabel()
    titleLabel.font = UIFont(name: "NanumSquareB", size: 16.0)
    titleLabel.textColor = UIColor(r: 255, g: 195, b: 75)
    titleLabel.text = "댓글"
    customNaviBarView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(backButton.snp.trailing).offset(width375(6.0))
      $0.bottom.equalTo(customNaviBarView).offset(-height667(13.0))
    }
    
    let upButton = UIButton(type: .custom)
    upButton.setImage(UIImage(named: "up_btn"), for: .normal)
    upButton.addTarget(self, action: #selector(handleUpButton), for: .touchUpInside)
    self.upButton = upButton
    view.addSubview(upButton)
    upButton.snp.makeConstraints {
      $0.bottom.equalTo(view).offset(-height667(22.0))
      $0.trailing.equalTo(view).offset(-height667(22.0))
      $0.width.equalTo(width375(46.0))
      $0.height.equalTo(upButton.snp.width)
    }
    
    let supportBarView = OptionDetailSupportVersusGaugeBarView()
    supportBarView.isHidden = true
    self.supportBarView = supportBarView
    view.addSubview(supportBarView)
    supportBarView.snp.makeConstraints {
      $0.top.equalTo(customNaviBarView.snp.bottom)
      $0.leading.trailing.equalTo(self.view)
    }
    
    let flowLayout = UICollectionViewFlowLayout()
    self.flowLayout = flowLayout
    let collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: flowLayout)
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.rankbaamOrange
    refreshControl.addTarget(self, action: #selector(handleRefreshCollectionView), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    collectionView.contentOffset = .init(x:0, y:-refreshControl.frame.height)
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
      $0.leading.trailing.bottom.equalTo(view)
    }
    collectionView.register(OptionDetailTopHeaderCell.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: Kind.topHeader.string)
    collectionView.register(OptionDetailHeaderCell.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: Kind.header.string)
    collectionView.register(OptionDetailActivityIndicatorCell.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                            withReuseIdentifier: Kind.indicatorHeader.string)
    collectionView.register(OptionDetailCell.self, forCellWithReuseIdentifier: Kind.cell.string)
    collectionView.register(OptionDetailFooterCell.self,
                            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
                            withReuseIdentifier: Kind.footer.string)
  }

}

//MARK: extension CollectionViewDataSource
extension OptionDetailViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataManager.optionDetailSectionCount()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard section >= dataManager.firstSectionIndex,
          let data = dataManager.optionDetailHeaderData(section: section)
      else{ return 0 }
    return (data.isOpen) ? data.subComments?.count ?? 0 : 0
  }
  
  @discardableResult
  private func collectionView(_ collectionView: UICollectionView, indexPath: IndexPath,
                      kind: Kind, cell: UICollectionViewCell ) -> Bool {
    switch kind {
    case .topHeader:
      guard let topHeaderCell = cell as? OptionDetailTopHeaderCell,
            let option = dataManager.option else {return false}
      //if topHeaderCell.delegate == nil {
        topHeaderCell.delegate = self
        if let photo = option.photos.first {
          topHeaderCell.setPhoto(url: photo.realUrl)
        }
        topHeaderTextView = topHeaderCell.commentDescriptionTextView
        topHeaderCell.contentView.layoutIfNeeded()
        topHeaderTextViewConvertFrame = topHeaderCell.commentDescriptionTextViewConvertFrame
        topHeaderCell.descriptionText = option.title
        topHeaderCell.commentCount = option.commentPositiveCount + option.commentNegativeCount
        if let headerSupportBarView = topHeaderCell.supportBarView {
          headerSupportBarView.blueValue = option.commentPositiveCount
          headerSupportBarView.redValue = option.commentNegativeCount
          self.supportBarView?.blueValue = option.commentPositiveCount
          self.supportBarView?.redValue = option.commentNegativeCount
          topHeaderSupportBarView = headerSupportBarView
        }
        //TODO
      //}
    case .header:
      guard let headerCell = cell as? OptionDetailHeaderCell else {return false}
      headerCell.dataSource = dataManager
      headerCell.delegate = self
      headerCell.section = indexPath.section
    case .indicatorHeader:
      guard let indicatorCell = cell as? OptionDetailActivityIndicatorCell else {return false}
      indicatorCell.isAnimating = dataManager.isVisibleMoreIndicator
    case .cell:
      guard let cell = cell as? OptionDetailCell else {return false}
      cell.dataSource = dataManager
      cell.dataIndex = (section: indexPath.section, row: indexPath.row)
    case .footer:
      if !(dataManager.optionDetailHeaderData(indexPath: indexPath)?.isOpen ?? false) {
        return false
      }
      guard let footerCell = cell as? OptionDetailFooterCell else {return false}
      footerCell.delegate = self
      footerCell.section = indexPath.section
      footerCell.isButtonHidden = false
      if let data = dataManager.optionDetailHeaderData(indexPath: indexPath) {
        footerCell.fitView(data: data)
      }
    }
    if (cell.gestureRecognizers?.count ?? 0) == 0 {
      cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapCell)))
    }
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    self.collectionView(collectionView, indexPath: indexPath, kind: .cell, cell: cell)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionElementKindSectionHeader:
      let dataRange = dataManager.optionDetailSectionDataRange()
      let optionKind: Kind =
        (indexPath.section < dataRange.lowerBound) ? .topHeader :
        (dataRange.contains(indexPath.section)) ? .header :
          .indicatorHeader
      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind, withReuseIdentifier: optionKind.string, for: indexPath)
      if let headerCell = headerView as? UICollectionViewCell {
        self.collectionView(collectionView, indexPath: indexPath, kind: optionKind, cell: headerCell)
      }
      return headerView
    case UICollectionElementKindSectionFooter:
      let footerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind, withReuseIdentifier: Kind.footer.string, for: indexPath)
      if let footerCell = footerView as? UICollectionViewCell {
        if !self.collectionView(collectionView, indexPath: indexPath, kind: .footer, cell: footerCell) {
          return UICollectionReusableView()
        }
      }
      return footerView
    default:
      return UICollectionReusableView()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let dataRange = dataManager.optionDetailSectionDataRange()
    let optionKind: Kind =
      (section < dataRange.lowerBound) ? .topHeader :
      (dataRange.contains(section)) ? .header :
      .indicatorHeader
    switch optionKind {
    case .topHeader:
      return .init(width: width375(375.0), height: height667(455.0))
    case .header:
      referenceSizeHeaderDescriptionLabel.text = dataManager.optionDetailHeaderData(section: section)?.description
      let height = height667(52.0) + referenceSizeHeaderDescriptionLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
      return .init(width: width375(375.0), height: height)
    case .indicatorHeader:
      return .init( width: width375(375.0), height: 50.0)
    default:
      return .zero
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    /*let indexPath = IndexPath(row: 0, section: section)
    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
    if let footerCell = footerView as? UICollectionViewCell {
      if !self.collectionView(collectionView, indexPath: indexPath, kind: .footer, cell: footerCell) {
        return .zero
      }
    }*/
    //let height = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    //return .init(width: UIScreen.main.bounds.width, height: height)
    if section < dataManager.firstSectionIndex { return .zero }
    if let data = dataManager.optionDetailHeaderData(section: section), data.isOpen {
      return .init(width: view.bounds.width, height: data.more ? height667(154.0) : height667(118.0))
    }
    return .zero
  }
}

protocol OptionDetailNetworkDataManager {
  var topicSN: Int {get}
  var optionSN: Int {get}
  var page: Int {get}
  var option: Option? {get set}
}

//MARK: - NetworkManager
class OptionDetailNetworkManager {
  typealias FailureClosure = ((Failure) -> Void)
  typealias CompleteClosure = (() -> Void)
  
  var dataManager: OptionDetailNetworkDataManager?
  
  private(set) var isLoading: Bool = false
  let loadingSemaphore = DispatchSemaphore(value: 1)
  
  public enum Failure{
    case loading
    case overflow
    case `else`(String)
    case error(Error)
  }
  
  init(optionDetailNetworkDataManager: OptionDetailNetworkDataManager? = nil){
    self.dataManager = optionDetailNetworkDataManager
  }
  
  func checkLoadable() -> Bool {
    loadingSemaphore.wait()
    guard !isLoading else { loadingSemaphore.signal(); return false }
    isLoading = true
    loadingSemaphore.signal()
    return true
  }
  
  func requestRefresh(senderClosure: CommentsListSenderClosure){
    guard let topicSN = dataManager?.topicSN, let optionSN = dataManager?.optionSN
          else { return }
    guard checkLoadable() else { senderClosure.f?(Failure.loading); return }
    let request = OptionService.read( topicSN: topicSN, optionSN: optionSN) {
      self.responseRead(response: $0, sender: senderClosure)
    }
    debugPrint(request.request?.urlRequest)
  }
  
  typealias CommentsListSenderClosure = (s:
    ([OptionComment])->Void, f: FailureClosure?, c: CompleteClosure?)
  func requestCommentsList(senderClosure: CommentsListSenderClosure){
    guard let topicSN = dataManager?.topicSN, let optionSN = dataManager?.optionSN,
          let page = dataManager?.page else { return }
    guard checkLoadable() else { senderClosure.f?(Failure.loading); return }
    OptionCommentService.list( topicSN: topicSN, optionSN: optionSN, page: page) {
      self.responseCommentsList(response: $0, sender: senderClosure)
    }
  }
  
  typealias SubCommentsListSenderClosure = (s:
    ([OptionSubComment])->Void, f: FailureClosure?, c: CompleteClosure?)
  func requestSubCommentsList(
    optionCommentData: OptionCommentData,
    senderClosure: SubCommentsListSenderClosure){
    guard checkLoadable() else { senderClosure.f?(Failure.loading); return }
    OptionCommentService.list(
      optionCommentSN: optionCommentData.optionCommentSN,
      page: optionCommentData.page) {
        self.responseSubCommentsList(response: $0, sender: senderClosure)
    }
  }
  
  private func responseRead(
    response: DataResponse<SResultOptionDetail>, sender: CommentsListSenderClosure) {
    switch response.result {
    case .success(let result):
      if result.succ {
        self.dataManager?.option = result.option
        if  let topicSN = dataManager?.topicSN, let optionSN = dataManager?.optionSN {
          OptionCommentService.list( topicSN: topicSN, optionSN: optionSN, page: 1) {
              self.responseCommentsList(response: $0, sender: sender)
          }
          return
        }
      } else {
        switch result.msg {
        default:
          if let msg = result.msg {
            debugPrint(msg)
            sender.f?(Failure.`else`(msg))
          }
        }
      }
    case .failure(let error):
      debugPrint(error)
      sender.f?(Failure.error(error))
    }
    isLoading = false
    sender.c?()
  }
  
  
  private func responseCommentsList(response: DataResponse<SResultOptionCommentList>, sender: CommentsListSenderClosure){
    switch response.result {
    case .success(let result):
      if result.succ {
        if let optionComments = result.optionComments {
          /*let originCount = self.optionDetailDataManager.comments.count
          let newCount = optionComments.count
          self.optionDetailDataManager.addComments(comments: optionComments)
          IndexSet(integersIn: originCount+1..<originCount+1+newCount)*/
          sender.s( optionComments )
        } else {
          assertionFailure("responseCommentsList result.optionComments nil")
        }
      } else if let msg = result.msg {
        switch msg {
        case "Overflow":
          //self.optionDetailDataManager.more = false
          sender.f?(Failure.overflow)
        default:
          if let msg = result.msg {
            debugPrint(msg)
            sender.f?(Failure.`else`(msg))
          }
        }
      }
    case .failure(let error):
      debugPrint(error)
      sender.f?(Failure.error(error))
    }
    self.isLoading = false
    sender.c?()
  }
  
  private func responseSubCommentsList(response: DataResponse<SResultOptionSubCommentList>, sender: SubCommentsListSenderClosure){
    switch response.result {
    case .success(let result):
      if result.succ {
        if let optionSubComments = result.optionSubComments {
          sender.s( optionSubComments )
        } else {
          assertionFailure("responseSubCommentsList result.optionSubComments nil")
        }
      } else if let msg = result.msg {
        switch msg {
        case "Overflow":
          //self.optionDetailData.more = false
          sender.f?(Failure.overflow)
        default:
          if let msg = result.msg {
            debugPrint(msg)
            sender.f?(Failure.`else`(msg))
          }
        }
      }
    case .failure(let error):
      debugPrint(error)
      sender.f?(Failure.error(error))
    }
    self.isLoading = false
    sender.c?()
  }
  
}

protocol OptionDetailDataCollectionViewDataSource: class {
  func optionDetailSectionCount() -> Int
  func optionDetailSectionDataRange() -> ClosedRange<Int>
  func optionDetailSectionMoreLoadRange() -> ClosedRange<Int>?
  func optionDetailSectionDataIndex(indexPath: IndexPath) -> Int?
  func optionDetailSectionDataIndex(section: Int) -> Int?
  func optionDetailHeaderData(indexPath: IndexPath) -> OptionCommentData?
  func optionDetailHeaderData(section: Int) -> OptionCommentData?
  func optionDetailCellCount(indexPath: IndexPath) -> Int
  func optionDetailCellCount(section: Int) -> Int
  func optionDetailCellData(indexPath: IndexPath) -> OptionSubComment
  func optionDetailCellData(section: Int, row: Int) -> OptionSubComment
}

extension OptionDetailDataCollectionViewDataSource {
  func optionDetailSectionDataIndex(indexPath: IndexPath) -> Int? {
    return self.optionDetailSectionDataIndex(section: indexPath.section)
  }
  func optionDetailHeaderData(indexPath: IndexPath) -> OptionCommentData? {
    return self.optionDetailHeaderData(section: indexPath.section)
  }
  func optionDetailCellCount(indexPath: IndexPath) -> Int {
    return self.optionDetailCellCount(section: indexPath.section)
  }
  func optionDetailCellData(indexPath: IndexPath) -> OptionSubComment {
    return self.optionDetailCellData(section: indexPath.section, row: indexPath.row)
  }
}

//MARK: - class OptionCommentData
class OptionCommentData: Equatable, Hashable {
  let optionCommentSN: String
  let writer: User
  var description: String
  var supportType: SupportType // 1 = positive 2 = negative
  let createDate: String
  var timeDistance: UInt
  var updateDate: String?
  
  let isMine: Bool
  
  var subCommentCount: UInt
  var subComments: [OptionSubComment]?
  
  var isOpen: Bool {
    didSet {
      if !isOpen {
        more = true //////TODO
      }
    }
  }
  var more: Bool
  var page: Int
  
  static func ==(lhs: OptionCommentData, rhs: OptionCommentData) -> Bool {
    return lhs.optionCommentSN == rhs.optionCommentSN
  }
  
  var hashValue: Int {
    return optionCommentSN.hashValue
  }
  
  init( optionCommentSN: String,
        writer: User,
        description: String,
        supportType: SupportType,
        createDate: String,
        timeDistance: UInt,
        updateDate: String?,
        isMine: Bool,
        subCommentCount: UInt,
        isOpen: Bool = false,
        more: Bool = true,
        page: Int = 1) {
    self.optionCommentSN = optionCommentSN
    self.writer = writer
    self.description = description
    self.supportType = supportType
    self.createDate = createDate
    self.timeDistance = timeDistance
    self.updateDate = updateDate
    self.isMine = isMine
    self.subCommentCount = subCommentCount
    self.isOpen = isOpen
    self.more = more
    self.page = page
  }
}

//MARK: - DataManager
class OptionDetailDataManager: OptionDetailNetworkDataManager {
  let firstSectionIndex = 1
  private(set) var topicSN: Int
  private(set) var optionSN: Int
  var option: Option?
  private(set) var comments: Array<OptionCommentData> = []
  private(set) var page: Int = 1
  var more: Bool = true
  private var commentsSemaphore = DispatchSemaphore(value: 1)
  var isVisibleMoreIndicator: Bool {
    return (comments.count > 0 && more)
  }
  var visibleMoreIndicatorCount: Int {
    return isVisibleMoreIndicator ? 1 : 0
  }
  let thresholdMoreLoadSectionCount = 3
  let thresholdMoreLoadRowCount = 3
  
  init(topicSN: Int, optionSN: Int){
    self.topicSN = topicSN
    self.optionSN = optionSN
  }
  
  func clear(){
    commentsSemaphore.wait()
    comments.removeAll()
    commentsSemaphore.signal()
    page = 1
    more = true
  }
  
  func insertComments(comments: [OptionComment], at: Int) {
    commentsSemaphore.wait()
    if comments.count > 0 {
      let newComments = comments.map({
        return OptionCommentData.init(
          optionCommentSN: $0.optionCommentSN, writer: $0.writer,
          description: $0.description, supportType: $0.supportType,
          createDate: $0.createDate, timeDistance: $0.timeDistance,
          updateDate: $0.updateDate, isMine: $0.isMine,
          subCommentCount: $0.subCommentCount)
      })
      self.comments.insert(contentsOf: newComments, at: at)
    }
    commentsSemaphore.signal()
  }
  
  func addComments(comments: [OptionComment]) -> (startIndex: Int, addCount: Int, reloadIndexes: [Int])? { ////TODO
    commentsSemaphore.wait()
    var result: (startIndex: Int, addCount: Int, reloadIndexes: [Int])? = nil
    if !comments.isEmpty {
      
      let startIndex = self.comments.count
      var comments = comments
      
      let reloadIndexes: [Int] = self.comments.enumerated().flatMap({ offset, commentData -> Int? in
        if let commentIndex = comments.index(where: {$0.optionCommentSN == commentData.optionCommentSN}) {
          let comment = comments.remove(at: commentIndex)
          commentData.supportType = comment.supportType
          commentData.updateDate = comment.updateDate
          commentData.subCommentCount = comment.subCommentCount
          commentData.description = comment.description
          return offset
        }
        return nil
      }).sorted()
      
      self.comments += comments.map({ comment in
        return OptionCommentData.init(
          optionCommentSN: comment.optionCommentSN, writer: comment.writer,
          description: comment.description, supportType: comment.supportType,
          createDate: comment.createDate, timeDistance: comment.timeDistance,
          updateDate: comment.updateDate, isMine: comment.isMine,
          subCommentCount: comment.subCommentCount)
      })
      
      page += 1
      
      result = ( startIndex, comments.count, reloadIndexes )
    } else {
      more = false
    }
    commentsSemaphore.signal()
    return result
  }
  
  @discardableResult
  func addSubComments(
    optionCommentSN: String,
    newSubComments: [OptionSubComment],
    toFront: Bool = false) ->
    (startIndex: Int, addCount: Int, reloadIndexes: [Int])? {
    guard let comment = self.comments.first(where: { $0.optionCommentSN == optionCommentSN }) else { return nil }
    commentsSemaphore.wait()
    var result: (startIndex: Int, addCount: Int, reloadIndexes: [Int])? = nil
    if !newSubComments.isEmpty {
      
      var newSubComments = newSubComments
      
      if comment.subComments == nil {
        comment.subComments = newSubComments
        result = (0, newSubComments.count, [])
      } else {
        let reloadIndexes: [Int] = comment.subComments?.enumerated().flatMap({ offset, subComment -> Int? in
          if let newSubCommentIndex = newSubComments.index(where: {$0.optionCommentSN == subComment.optionCommentSN}) {
            comment.subComments?[offset] = newSubComments.remove(at: newSubCommentIndex)
            return offset
          }
          return nil
        }).sorted() ?? []
        
        var startIndex: Int
        if toFront {
          startIndex = 0
          comment.subComments?.insert(contentsOf: newSubComments, at: startIndex)
        } else {
          startIndex = comment.subComments?.count ?? 0
          comment.subComments?.append(contentsOf: newSubComments)
        }
        
        comment.subComments?.append(contentsOf: newSubComments)
        result = (startIndex, newSubComments.count, reloadIndexes)
      }
      
      comment.page += 1
      
    } else {
      comment.more = false
    }
    commentsSemaphore.signal()
    return result
  }
}

//MARK: - extension DataCollectionViewDataSource
extension OptionDetailDataManager: OptionDetailDataCollectionViewDataSource {
  func optionDetailSectionCount() -> Int {
    return comments.count == 0 ? (more ? 0 : 1) : comments.count + firstSectionIndex + (more ? 1 : 0)
  }
  func optionDetailSectionDataRange() -> ClosedRange<Int> {
    return (firstSectionIndex)...(firstSectionIndex+(comments.count > 0 ? comments.count - 1 : 0))
  }
  func optionDetailSectionMoreLoadRange() -> ClosedRange<Int>? {
    if isVisibleMoreIndicator {
      let endIndex = firstSectionIndex+(comments.count > 0 ? comments.count - 1 : 0)
      return (endIndex-thresholdMoreLoadSectionCount)...endIndex
    }
    return nil
  }
  func optionDetailSectionDataIndex(section: Int) -> Int? {
    let index = section - firstSectionIndex
    return (index < comments.count) ? index : nil
  }
  func optionDetailHeaderData(section: Int) -> OptionCommentData? {
    if let index = self.optionDetailSectionDataIndex(section: section) {
      return comments[index]
    }
    return nil
  }
  func optionDetailCellCount(section: Int) -> Int {
    return self.optionDetailHeaderData(section: section)?.subComments?.count ?? 0
  }
  func optionDetailCellData(section: Int, row: Int) -> OptionSubComment {
    guard let subComment = self.optionDetailHeaderData(section: section)?.subComments?[row]
      else { fatalError("""
        section: \(section), row: \(row) / subComments.count: \
        \(self.optionDetailHeaderData(section: section)?.subComments?.count ?? 0)
        """) }
    return subComment
  }
}

//MARK: - extension CollectionViewDelegate
extension OptionDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    if dataManager.more, elementKind == UICollectionElementKindSectionHeader,
      dataManager.optionDetailSectionMoreLoadRange()?.contains(indexPath.section) ?? false {
      networkManager.requestCommentsList(senderClosure: (
        s: { (optionComments: [OptionComment]) in
          guard let collectionView = self.collectionView, optionComments.count > 0 else {return}
          let firstIndex = self.dataManager.firstSectionIndex
          if let addedInfoData = self.dataManager.addComments(comments: optionComments) {
            collectionView.performBatchUpdates({
              if addedInfoData.addCount > 0 {
                let startSection = addedInfoData.startIndex+firstIndex
                let insertRange = startSection..<startSection+addedInfoData.addCount
                collectionView.insertSections(IndexSet(integersIn: insertRange))
              }
            }, completion: { complete in
              if complete, addedInfoData.reloadIndexes.count > 0 {
                for reloadIndex in addedInfoData.reloadIndexes {
                  collectionView.reloadSections(IndexSet(integer: reloadIndex+firstIndex))
                }
              }
            })
          }
      },
        f: {
          switch $0 {
          case .loading: break
          case .overflow:
            self.dataManager.more = false
            let moreSection = self.dataManager.optionDetailSectionDataRange().upperBound + 1
            if (self.collectionView?.numberOfSections ?? 0) > moreSection {
              self.collectionView?.deleteSections(IndexSet(integer: moreSection))
            }
          case .`else`( _): break
          case .error( _): break
          }
      },
        c: nil))
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
    if indexPath.section > dataManager.optionDetailSectionDataRange().upperBound,
       let cell = view as? OptionDetailActivityIndicatorCell {
       cell.isAnimating = false
    }
  }
}


//MARK: - extension ScrollViewDelegate
extension OptionDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let isUpButtonHidden = scrollView.contentOffset.y <
        (topHeaderTextViewConvertFrame?.origin.y ?? 474.0) +
        (topHeaderTextViewConvertFrame?.height ?? 126.0)
    if upButton?.isHidden != isUpButtonHidden {
      upButton?.isHidden = isUpButtonHidden
      if !isUpButtonHidden, let textView = topHeaderTextView, textView.isFirstResponder {
        textView.resignFirstResponder()
      }
    }
    if let y = topHeaderSupportBarView?.frame.origin.y {
      let isSupportBarViewHidden = scrollView.contentOffset.y < y
      if supportBarView?.isHidden != isSupportBarViewHidden {
        supportBarView?.isHidden = isSupportBarViewHidden
      }
    }
  }
  /*func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if let textView = topHeaderTextView, textView.isFirstResponder {
      textView.resignFirstResponder()
    }
  }*/
}


//MARK: - extension CollectionViewDelegateFlowLayout
extension OptionDetailViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    referenceSizeCellDescriptionLabel.text =
      dataManager.optionDetailCellData(indexPath: indexPath).description
    let height = height667(56.0) + referenceSizeCellDescriptionLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
    return .init( width: view.bounds.width, height: height)
  }
}

//MARK: - extension TopHeaderCellDelegate
extension OptionDetailViewController: OptionDetailTopHeaderCellDelegate {
  func submitCommentDescriptionTextView(text: String, supportType: OptionDetailTopHeaderCell.SupportType, clearTextClosure: @escaping ()->Void) {
    let alertClosure: (String, ((UIAlertAction) -> Void)?) -> UIAlertController =
    { message, buttonHandler in
      let alert = UIAlertController(
        title: nil, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: buttonHandler))
      return alert
    }
    var optionSupportType: SupportType
    switch supportType {
    case .none:
      let alert = alertClosure("공감 또는 비공감 아이콘을\n선택해주세요.", nil)
      present(alert, animated: true, completion: nil)
      return
    case .positive:
      optionSupportType = .positive
    case .negative:
      optionSupportType = .negative
    }
    if text.count < 5 {
      let alert = alertClosure("5글자 이상 입력해주세요.", { _ in
        self.topHeaderTextView?.becomeFirstResponder()
      })
      present(alert, animated: true, completion: nil)
      return
    }
    OptionCommentService.create(
      topicSN: dataManager.topicSN,
      optionSN: dataManager.optionSN,
      supportType: optionSupportType,
      description: text) {
      switch $0.result {
      case .success(let result):
        if result.succ {
          //TODO fix start
          OptionCommentService.list(
            topicSN: self.dataManager.topicSN,
            optionSN: self.dataManager.optionSN,
            page: 1) {
            switch $0.result {
            case .success(let result):
              if result.succ, let optionComments = result.optionComments {
                let newOptionComments = optionComments.filter({ optionComment in
                  return !self.dataManager.comments.contains(where: {return $0.optionCommentSN == optionComment.optionCommentSN})
                })
                if newOptionComments.count > 0 { // TODO reload도 하고 & 15개넘어서 새로운거 있는 것도 고려
                  self.dataManager.insertComments(comments: newOptionComments, at: 0)
                  let firstIndex = self.dataManager.firstSectionIndex
                  self.collectionView?.performBatchUpdates({
                    self.collectionView?.insertSections(IndexSet(integersIn: firstIndex..<newOptionComments.count+firstIndex))
                  }, completion: nil)
                }
              }
            default: break
            }
            
          }
          //TODO fix end
          clearTextClosure()
        } else {
          switch result.msg {
          default:
            if let msg = result.msg {
              debugPrint(msg)
            }
          }
        }
      case .failure(let error):
        debugPrint(error)
      }
    }
  }
}

//MARK: - extension HeaderCellDelegate
//댓글 0이지만 답글 달아야할때는?
extension OptionDetailViewController: OptionDetailHeaderCellDelegate {
  func headerCell(section: Int) {
    openCloseCheckSemaphore.wait()
    guard !isOpenCloseProcessing else { return }
    isOpenCloseProcessing = true
    openCloseCheckSemaphore.signal()
    
    guard let commentData = dataManager.optionDetailHeaderData(section: section)
      else { isOpenCloseProcessing = false; return }
    
    let updateClosure: ()->Void = {
      self.collectionView?.performBatchUpdates({
        if let count = commentData.subComments?.count, count > 0 {
          let indexPaths = Array(0..<count).map({IndexPath(row: $0, section: section)})
          if commentData.isOpen {
            self.collectionView?.insertItems(at: indexPaths)
          } else {
            self.collectionView?.deleteItems(at: indexPaths)
          }
        }
      }, completion: { completion in
        if completion {
          self.collectionView?.reloadSections(IndexSet(integer: section))
          self.isOpenCloseProcessing = false
        }
      })
    }
    
    commentData.isOpen = !commentData.isOpen
    
    if commentData.isOpen == false {
      self.collectionView?
        .visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter)
        .flatMap({ return $0 as? OptionDetailFooterCell })
        .filter({ return $0.section == section })
        .first?.isButtonHidden = true
    } else {
      let needInitialLoading = commentData.more && (commentData.subComments?.count ?? 0) == 0
      if needInitialLoading {
        networkManager.requestSubCommentsList(
          optionCommentData: commentData,
          senderClosure: (
          s: { (optionSubComments: [OptionSubComment]) in
            self.dataManager.addSubComments(
              optionCommentSN: commentData.optionCommentSN, newSubComments: optionSubComments)
            updateClosure()
          },
          f: {
            switch $0 {
            case .loading: break
            case .overflow:
              commentData.more = false
              self.collectionView?.reloadSections(IndexSet(integer: section))
            case .`else`( _): break
            case .error( _): break
            }
            self.isOpenCloseProcessing = false
          },
          c: nil
        ))
        return
      }
    }
    
    updateClosure()
  }
}

//MARK: - extension FooterCellDelegateasd
extension OptionDetailViewController: OptionDetailFooterCellDelegate {
  
  
  func footerCell(section: Int, text: String?, clearClosure: @escaping () -> Void) {
    guard let commentData = dataManager.optionDetailHeaderData(section: section) else { debugPrint("footer subComment create fail / section : \(section) / cv sections : \(self.collectionView?.numberOfSections ?? 0) / dm comments count : \(dataManager.comments.count)"); return }
    
    guard let text = text, text.count > 5 else {
      let alert = UIAlertController(title: nil, message: "5글자 이상 입력해주세요.", preferredStyle: .alert)
      alert.addAction(.init(title: "확인", style: .cancel, handler: nil))
      present(alert, animated: true, completion: nil)
      return
    }
    
    OptionCommentService.create(
      optionCommentSN: commentData.optionCommentSN, description: text) {
        switch $0.result {
        case .success(let result):
          if result.succ {
            clearClosure()
            commentData.more = true
            OptionCommentService.list(
              optionCommentSN: commentData.optionCommentSN, page: 1 ) {
              switch $0.result {
                case .success(let result):
                  if result.succ {
                    if let subComments = result.optionSubComments, subComments.count > 0 {
                      let addedInfo = self.dataManager.addSubComments(
                        optionCommentSN: commentData.optionCommentSN,
                        newSubComments: subComments, toFront: true)
                      if let addedInfoData = addedInfo {
                        guard let collectionView = self.collectionView, subComments.count > 0 else {return}
                        self.collectionView?.performBatchUpdates({
                          if addedInfoData.addCount > 0 {
                            let indexPaths = Array(addedInfoData.startIndex..<addedInfoData.startIndex+addedInfoData.addCount)
                              .map({IndexPath(row: $0, section: section)})
                            collectionView.insertItems(at: indexPaths)
                          }
                        }, completion: { complete in
                          if complete {
                            if addedInfoData.reloadIndexes.count > 0 {
                              let indexPaths = addedInfoData.reloadIndexes.map({IndexPath(row: $0, section: section)})
                              collectionView.reloadItems(at: indexPaths)
                            }
                          }
                        })
                      }
                    }
                  } else {
                    switch result.msg {
                    default:
                      debugPrint(result.msg ?? "")
                    }
                }
              case .failure(let error):
                debugPrint(error)
              }
            }
          } else {
            switch result.msg {
            default:
              debugPrint(result.msg ?? "")
            }
          }
        case .failure(let error):
          debugPrint(error)
        }
    }
    
  }
  func footerCell(section: Int, action: OptionDetailFooterCell.Action) {
    guard let commentData = dataManager.optionDetailHeaderData(section: section)
      else { isOpenCloseProcessing = false; return }
    
    switch action {
    case .more(let moreClosure):
      
      if commentData.more {
        networkManager.requestSubCommentsList( optionCommentData: commentData, senderClosure: (
          s: { (optionSubComments: [OptionSubComment]) in
            guard let collectionView = self.collectionView, optionSubComments.count > 0 else {return}
            if let addedInfoData = self.dataManager.addSubComments(
              optionCommentSN: commentData.optionCommentSN, newSubComments: optionSubComments) {
              collectionView.performBatchUpdates({
                if addedInfoData.addCount > 0 {
                  let indexPaths = Array(addedInfoData.startIndex..<addedInfoData.startIndex+addedInfoData.addCount)
                    .map({IndexPath(row: $0, section: section)})
                  collectionView.insertItems(at: indexPaths)
                }
              }, completion: { complete in
                if complete {
                  if addedInfoData.reloadIndexes.count > 0 {
                    let indexPaths = addedInfoData.reloadIndexes.map({IndexPath(row: $0, section: section)})
                    collectionView.reloadItems(at: indexPaths)
                    moreClosure(true)
                  }
                }
              })
            }
          },
            f: {
              switch $0 {
              case .loading: break
              case .overflow:
                commentData.more = false
                moreClosure(false)
                self.collectionView?.reloadSections(IndexSet(integer: section))
              case .`else`( _): break
              case .error( _): break
              }
              self.isOpenCloseProcessing = false
          },
            c: nil
          ))
      }
      
    case .hide:
      openCloseCheckSemaphore.wait()
      guard !isOpenCloseProcessing else { return }
      isOpenCloseProcessing = true
      openCloseCheckSemaphore.signal()
      
      commentData.isOpen = false
      
      self.collectionView?
        .visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter)
        .flatMap({ return $0 as? OptionDetailFooterCell })
        .filter({ return $0.section == section })
        .first?.isButtonHidden = true
      self.collectionView?.performBatchUpdates({
        if let count = commentData.subComments?.count, count > 0 {
          let indexPaths = Array(0..<count).map({IndexPath(row: $0, section: section)})
          self.collectionView?.deleteItems(at: indexPaths)
        }
      }, completion: { completion in
        if completion {
          self.collectionView?.reloadSections(IndexSet(integer: section))
          self.isOpenCloseProcessing = false
        }
      })
    }
  }
}

class OptionDetailActivityIndicatorCell: UICollectionViewCell {
  var isAnimating: Bool {
    get { return activityIndicateorView?.isAnimating ?? false }
    set {
      if newValue != activityIndicateorView?.isAnimating {
        activityIndicateorView?.isHidden = !newValue
        if newValue {
          activityIndicateorView?.startAnimating()
        }
        else {
          activityIndicateorView?.stopAnimating()
        }
      }
    }
  }
  weak var activityIndicateorView: UIActivityIndicatorView?
  private func initView() {
    let activityIndicateorView = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    activityIndicateorView.color = UIColor.rankbaamOrange
    self.activityIndicateorView = activityIndicateorView
    contentView.addSubview(activityIndicateorView)
    activityIndicateorView.snp.makeConstraints {
      $0.center.equalTo(contentView)
      $0.width.height.equalTo(50.0)
    }
  }
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}
