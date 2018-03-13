//
//  PageManager.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 7..
//  Copyright © 2018년 김정원. All rights reserved.
//

import Foundation

class PageManager {
  private(set) var page: Int = 1
  private(set) var more: Bool = false
  private(set) var isLoading: Bool = false
  private var isLoadingSemaphore = DispatchSemaphore(value: 1)
  func initPage(){
    page = 1
    more = false
  }
  func increasePage(){
    page += 1
  }
  func noMore(){
    more = false
  }
  func beginLoading() -> Bool {
    if !more { return false }
    isLoadingSemaphore.wait()
    if !isLoading {
      isLoading = true
      isLoadingSemaphore.signal()
      return true
    } else {
      isLoadingSemaphore.signal()
      return false
    }
  }
  func endLoading() {
    isLoading = false
  }
}
