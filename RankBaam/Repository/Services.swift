import Alamofire

struct UserService {
    
  static let EMAIL_DOMAINS = ["gmail.com", "naver.com", "daum.net",
                         "nate.com", "hotmail.com", "icloud.com",
                         "yahoo.co.jp", "hanmail.net", "me.com", "mac.com"]
  
  @discardableResult
  static func singin(
    signData: SignData, fcmToken: String? = nil,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) -> DataRequest {
    return singin(type: signData.type, email: signData.email, identification: signData.identification, fcmToken: fcmToken, completion: completion)
  }
  
  @discardableResult
  static func singin(
    type: SignType, email: String? = nil, identification: String, fcmToken: String? = nil,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(UserRouter.signin(type: type, email: email, identification: identification, fcmToken: fcmToken))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func signup(
    email: String, identification: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(UserRouter.signup(email: email, identification: identification))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func signout(
    completion: @escaping (DataResponse<SResult>) -> Void
    ) -> DataRequest {
    return Alamofire.request(UserRouter.signout).responseRankBaam(completion)
  }
  
  static func signout() {
    Alamofire.request(UserRouter.signout).response{ _ in }
  }
  
  @discardableResult
  static func getNickname(
    completion: @escaping (DataResponse<SResultNickname>) -> Void
    ) -> DataRequest {
    return Alamofire.request(UserRouter.getNickname).responseRankBaam(completion)
  }
  
  @discardableResult
  static func setNickname(
    nickname: String,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) -> DataRequest {
    return Alamofire.request(UserRouter.setNickname(nickname: nickname))
      .responseRankBaam(completion)
  }
  
  @discardableResult
  static func preNickname(
    completion: @escaping (DataResponse<SResultNickname>) -> Void
    ) -> DataRequest {
    return Alamofire.request(UserRouter.preNickname).responseRankBaam(completion)
  }
  
}

struct TopicService {
  
  @discardableResult
  static func categoryList(
    completion: @escaping (DataResponse<SResultCategoryList>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.categoryList)
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func list(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.list(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func weekList(
    page: Int, count: Int? = nil, categorySN: Int? = nil,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.weekList(page: page, count: count, categorySN: categorySN))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func likeList(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
    ) -> DataRequest {
    return Alamofire .request(TopicRouter.likeList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func myList(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
    ) -> DataRequest {
    return Alamofire .request(TopicRouter.myList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func read(
    topicSN: Int,
    completion: @escaping (DataResponse<SResultTopicDetail>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.read(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func create(
    topicWrite: TopicWrite,
    completion: @escaping (DataResponse<SResultTopicCreate>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.create(topic: topicWrite))
              .responseRankBaam(completion)
  }
  
  /* 시뮬레이터에서만 정상동작
  static func photoCreate(
    topicSN: Int,
    photoUrl: URL,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) {
    let requestUrl = TopicRouter.photoCreate(topicSN: topicSN).url
    Alamofire.upload(
      multipartFormData: { $0.append(photoUrl, withName: "photo") },
      to: requestUrl,
      encodingCompletion: {
        switch $0 {
        case .success(let upload, _, _):
          let _ = upload.responseRankBaam(completion)
        case .failure(let encodingError):
          let error = DataResponse<SResult>(
            request: nil, response: nil, data: nil,
            result: Result<SResult>.failure(encodingError))
          DataRequest.debugMultipartEncodingFailure(requestUrl: requestUrl, result: $0)
          completion(error)
        }
    })
  }*/
  
  static func photoCreate(
    topicSN: Int,
    photoData: Data,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) {
    let requestUrl = TopicRouter.photoCreate(topicSN: topicSN).url
    Alamofire.upload(
      multipartFormData: {
        if let mimeType = $0.getImageMimeType(data: photoData) {
          $0.append(photoData, withName: "photo", fileName: "photo", mimeType: mimeType)
        }
    },
      to: requestUrl,
      encodingCompletion: {
        switch $0 {
        case .success(let upload, _, _):
          let _ = upload.responseRankBaam(completion)
        case .failure(let encodingError):
          let error = DataResponse<SResult>(
            request: nil, response: nil, data: nil,
            result: Result<SResult>.failure(encodingError))
          DataRequest.debugMultipartEncodingFailure(requestUrl: requestUrl, result: $0)
          completion(error)
        }
    })
  }
  
  @discardableResult
  static func like(
    topicSN: Int, isLiked: Bool,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.like(topicSN: topicSN, isLiked: isLiked))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func likes(
    topicSNs: [Int], isLiked: Bool,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) -> DataRequest {
    return Alamofire .request(TopicRouter.likes(topicSNs: topicSNs, isLiked: isLiked))
      .responseRankBaam(completion)
  }
  
  @discardableResult
  static func unlike(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    
    return Alamofire .request(TopicRouter.unlike(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func unlikes(
    topicSNs: [Int],
    completion: @escaping (DataResponse<SResult>) -> Void
    ) -> DataRequest {
    return Alamofire .request(TopicRouter.unlikes(topicSNs: topicSNs))
      .responseRankBaam(completion)
  }
  
  @discardableResult
  // TODO completion
  static func updatePre(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.updatePre(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func update(
    topicWrite: TopicWrite,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.update(topic: topicWrite))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func delete(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(TopicRouter.delete(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
}

struct OptionService {
  
  @discardableResult
  static func list(
    topicSN: Int, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionList>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionRouter.list(topicSN: topicSN, page: page, count: count))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func read(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResultOptionDetail>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionRouter.read(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func create(
    optionWrite: OptionWrite,
    completion: @escaping (DataResponse<SResultOptionCreate>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionRouter.create(option: optionWrite))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func create(
    optionWrite: OptionWrite,
    photoData: Data?,
    completion: @escaping (DataResponse<SResultOptionCreate>) -> Void
    ) -> DataRequest? {
    if let photoData = photoData {
      let request = OptionRouter.create(option: optionWrite)
      Alamofire.upload(
        multipartFormData: {
          if let mimeType = $0.getImageMimeType(data: photoData) {
            $0.append(photoData, withName: "photo", fileName: "photo", mimeType: mimeType)
          }
          if let parameters = request.parameters {
            for (key, value) in parameters {
              if let data = "\(value)".data(using: .utf8) {
                $0.append(data, withName: key)
              }
            }
          }
      },
        to: request.url,
        encodingCompletion: {
          switch $0 {
          case .success(let upload, _, _):
            let _ = upload.responseRankBaam(completion)
          case .failure(let encodingError):
            let error = DataResponse<SResultOptionCreate>(
              request: nil, response: nil, data: nil,
              result: Result<SResultOptionCreate>.failure(encodingError))
            DataRequest.debugMultipartEncodingFailure(requestUrl: request.url, result: $0)
            completion(error)
          }
      })
      return nil
    } else {
      return self.create(optionWrite: optionWrite, completion: completion)
    }
  }
  
  static func photoCreate(
    topicSN: Int,
    optionSN: Int,
    photoData: Data,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) {
    let requestUrl = OptionRouter.photoCreate(topicSN: topicSN, optionSN: optionSN).url
    Alamofire.upload(
      multipartFormData: {
        if let mimeType = $0.getImageMimeType(data: photoData) {
          $0.append(photoData, withName: "photo", fileName: "photo", mimeType: mimeType)
        }
      },
      to: requestUrl,
      encodingCompletion: {
        switch $0 {
        case .success(let upload, _, _):
          let _ = upload.responseRankBaam(completion)
        case .failure(let encodingError):
          let error = DataResponse<SResult>(
            request: nil, response: nil, data: nil,
            result: Result<SResult>.failure(encodingError))
          DataRequest.debugMultipartEncodingFailure(requestUrl: requestUrl, result: $0)
          completion(error)
        }
    })
  }
  
  /* 시뮬레이터에서만 정상동작
   static func photoCreate(
    topicSN: Int,
    optionSN: Int,
    photoUrl: URL,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) {
    let requestUrl = OptionRouter.photoCreate(topicSN: topicSN, optionSN: optionSN).url
    Alamofire.upload(
      multipartFormData: { $0.append(photoUrl, withName: "photo") },
      to: requestUrl,
      encodingCompletion: {
        switch $0 {
        case .success(let upload, _, _):
          let _ = upload.responseRankBaam(completion)
        case .failure(let encodingError):
          let error = DataResponse<SResult>(
            request: nil, response: nil, data: nil,
            result: Result<SResult>.failure(encodingError))
          DataRequest.debugMultipartEncodingFailure(requestUrl: requestUrl, result: $0)
          completion(error)
        }
    })
  }*/
  
  @discardableResult
  // TODO completion
  static func updatePre(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionRouter.updatePre(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func update(
    optionWrite: OptionWrite,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionRouter.update(option: optionWrite))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func delete(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionRouter.delete(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func vote(
    topicSN: Int, optionSN: Int, isVoted: Bool,
    completion: @escaping (DataResponse<SResultVote>) -> Void
    ) -> DataRequest {
    return Alamofire .request(OptionRouter.vote(topicSN: topicSN, optionSN: optionSN, isVoted: isVoted))
      .responseRankBaam(completion)
  }
  
  @discardableResult
  static func vote(
    topicSN: Int, optionSNs: [Int],
    completion: @escaping (DataResponse<SResult>) -> Void
    ) -> DataRequest {
    return Alamofire .request(OptionRouter.votes(topicSN: topicSN, optionSNs: optionSNs))
      .responseRankBaam(completion)
  }
}

struct OptionCommentService {
  
  @discardableResult
  static func list(
    topicSN: Int, optionSN: Int, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionCommentList>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionCommentRouter.list(topicSN: topicSN, optionSN: optionSN, page: page, count: count))
        .responseRankBaam(completion)
  }
  
  @discardableResult
  static func list(
    optionCommentSN: String, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionSubCommentList>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionCommentRouter.subList(pOptionCommentSN: optionCommentSN, page: page, count: count))
        .responseRankBaam(completion)
  }
  
  @discardableResult
  static func create(
    topicSN: Int, optionSN: Int, supportType: SupportType, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionCommentRouter.create(topicSN: topicSN, optionSN: optionSN, supportType: supportType, description: description))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func create(
    optionCommentSN: String, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionCommentRouter.subCreate(optionCommentSN: optionCommentSN, description: description))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func update(
    optionCommentSN: String, supportType: SupportType? = nil, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionCommentRouter.update(optionCommentSN: optionCommentSN, supportType: supportType, description: description))
              .responseRankBaam(completion)
  }
  
  @discardableResult
  static func delete(
    optionCommentSN: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    return Alamofire .request(OptionCommentRouter.delete(optionCommentSN: optionCommentSN))
              .responseRankBaam(completion)
  }
  
}


