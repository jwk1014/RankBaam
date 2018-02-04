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
  static func unLike(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) -> DataRequest {
    
    return Alamofire .request(TopicRouter.unlike(topicSN: topicSN))
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


