//
//  TopicEditNetworkManager.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 8..
//  Copyright © 2018년 김정원. All rights reserved.
//

import Foundation
import Alamofire
import Photos

protocol TopicEditNetworkManagerDelegate: class {
  func loaded(topic: Topic)
  func loaded(page: Int, options: [Option]?)
  func submitted(topicSN: Int?)
}

class TopicEditNetworkManager {
  typealias OptionData = (imageAsset: PHAsset?, text:String)
  weak var delegate: TopicEditNetworkManagerDelegate?
  
  private var loadingSemaphore = DispatchSemaphore(value: 1)
  private var isLoading: Bool = false
  private var topicSN: Int?
  private var topicImageAssets: [PHAsset] = []
  private var optionDatas: [OptionData] = []
  private var page: Int = 0
  
  private func initValue(){
    isLoading = false
    topicSN = nil
    topicImageAssets = []
    optionDatas = []
  }
  
  private func submitted() {
    let topicSN = self.topicSN
    initValue()
    delegate?.submitted(topicSN: topicSN)
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
      submitted()
    }
  }
  
  private func responseOptionCreate(response: DataResponse<SResultOptionCreate>) {
    switch(response.result) {
    case .success(let sResult):
      if sResult.succ {
        guard let optionSN = sResult.optionSN else { submitted(); return }
        let previousOptionData = optionDatas.removeFirst()
        
        if let imageAsset = previousOptionData.imageAsset {
          requestOptionPhotoCreate(optionSN: optionSN, imageAsset: imageAsset)
        } else {
          requestOptionCreate()
        }
      } else if let msg = sResult.msg {
        switch msg { default: break }
        submitted()
      }
    case .failure(let _):
      submitted()
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
    topicWrite: TopicWrite, topicImageAssets: [PHAsset], optionDatas: [OptionData]
    ) -> Bool {
    
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
          guard let topicSN = sResult.topicSN else { self.delegate?.submitted(topicSN: nil); return }
          self.topicSN = topicSN
          self.optionDatas = optionDatas
          self.topicImageAssets = topicImageAssets
          self.requestTopicPhotoCreate()
        } else if let msg = sResult.msg {
          switch msg { default: break }
          self.delegate?.submitted(topicSN: nil); return
        }
      case .failure(let _):
        self.delegate?.submitted(topicSN: nil); return
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

extension TopicEditNetworkManager {
  func requestTopicRead(topicSN: Int) {
    TopicService.read(topicSN: topicSN, completion: responseTopicRead)
  }
  private func responseTopicRead(response: DataResponse<SResultTopicDetail>) {
    switch(response.result) {
    case .success(let sResult):
      if sResult.succ {
        if let topic = sResult.topic {
          delegate?.loaded(topic: topic)
        } else {
          assertionFailure("server error")
        }
      } else if let msg = sResult.msg {
        switch msg { default: break }
        debugPrint(msg)
      } else {
        assertionFailure("server error")
      }
    case .failure(let error):
      debugPrint(error)
    }
  }
  
  func requestOptionList(topicSN: Int, page: Int) -> Bool {
    loadingSemaphore.wait()
    guard !isLoading else {
      loadingSemaphore.signal()
      return false
    }
    isLoading = true
    loadingSemaphore.signal()
    
    self.page = page
    OptionService.list(topicSN: topicSN, page: page, completion: responseOptionList)
    
    return true
  }
  
  private func responseOptionList(response: DataResponse<SResultOptionList>) {
    switch(response.result) {
    case .success(let sResult):
      if sResult.succ {
        if let options = sResult.options {
          delegate?.loaded(page: page, options: options)
        } else {
          assertionFailure("server error")
        }
      } else if let msg = sResult.msg {
        switch msg {
        case "Overflow":
          delegate?.loaded(page: page, options: nil)
        default: break
        }
        debugPrint(msg)
      } else {
        assertionFailure("server error")
      }
    case .failure(let error):
      debugPrint(error)
    }
  }
}
