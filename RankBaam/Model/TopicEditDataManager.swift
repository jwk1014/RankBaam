//
//  TopicEditDataManager.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 8..
//  Copyright © 2018년 김정원. All rights reserved.
//

import Foundation

protocol TopicEditDataDelegate: class {
  func updatedValue(category: Category?)
  func updatedValue(title: String?)
  func addedOption(index: Int)
  func addedOptions(startIndex: Int, count: Int)
  func removedOption(oldIndex: Int)
}

class TopicEditDataManager {
  typealias OptionCellData = (optionSN: Int?, text: String?, imageData: ImageBindData?)
  weak var delegate: TopicEditDataDelegate?
  
  private let imageMaxCount: Int = 5
  private let titleMinLength: Int = 5
  
  var topicSN: Int? = nil
  var category: Category? = nil {
    didSet {
      if category != oldValue {
        delegate?.updatedValue(category: category)
      }
    }
  }
  private(set) var imageDatas: [ImageBindData] = []
  var isUpdatableTitle: Bool  = true
  private(set) var title: String? = nil
  var topicDescription: String? = nil
  
  private(set) var options: [OptionCellData] = []
  private var optionsSemaphore = DispatchSemaphore(value: 1)
  
  private(set) var isVotableCount: Bool = false
  var isUpdatableVotableCount: Bool  = true
  private(set) var isOnlyWriterCreateOption: Bool = false
  var isUpdatableOnlyWriterCreateOption: Bool  = true
  
  func setValue(imageDatas: [ImageBindData]) {
    self.imageDatas = imageDatas
  }
  
  @discardableResult
  func removeImageData(index: Int) -> ImageBindData {
    return imageDatas.remove(at: index)
  }
  
  func append(option: OptionCellData) {
    optionsSemaphore.wait()
    options.append(option)
    delegate?.addedOption(index: options.count - 1)
    optionsSemaphore.signal()
  }
  
  func append(options: [OptionCellData]) {
    optionsSemaphore.wait()
    self.options += options
    let count = options.count
    delegate?.addedOptions(
      startIndex: self.options.count - count, count: count)
    optionsSemaphore.signal()
  }
  
  func updateOptionImage(index: Int, imageData: ImageBindData?) {
    optionsSemaphore.wait()
    guard options.count > index else { optionsSemaphore.signal(); return }
    imageData?.imageView = options[index].imageData?.imageView
    options[index].imageData = imageData
    optionsSemaphore.signal()
  }
  
  func updateOption(index: Int, title: String?) {
    optionsSemaphore.wait()
    guard options.count > index else { optionsSemaphore.signal(); return }
    options[index].text = title
    optionsSemaphore.signal()
  }
  
  func removeOption(index: Int) {
    optionsSemaphore.wait()
    guard options.count > index else { optionsSemaphore.signal(); return }
    let _ = options.remove(at: index)
    delegate?.removedOption(oldIndex: index)
    optionsSemaphore.signal()
  }
  
  func setValue(category: Category, title: String,  topicDescription: String?,
                isVotableCount: Bool, isOnlyWriterCreateOption: Bool) {
    self.category = category
    self.title = title
    self.topicDescription = topicDescription
    self.isVotableCount = isVotableCount
    self.isOnlyWriterCreateOption = isOnlyWriterCreateOption
  }
  
  @discardableResult
  func setValue(title: String) -> Bool {
    guard self.title != title else { return false }
    self.title = title
    delegate?.updatedValue(title: title)
    return true
  }
  
  var isEmptyTitle: Bool {
    return (title?.count ?? 0) == 0
  }
  
  func setValue(isVotableCount: Bool) -> Bool {
    guard self.isVotableCount != isVotableCount else { return false }
    self.isVotableCount = isVotableCount
    return true
  }
  
  func setValue(isOnlyWriterCreateOption: Bool) -> Bool {
    guard self.isOnlyWriterCreateOption != isOnlyWriterCreateOption else { return false }
    self.isOnlyWriterCreateOption = isOnlyWriterCreateOption
    return true
  }
}
