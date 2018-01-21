import Alamofire

struct UserService {
    
  static let EMAIL_DOMAINS = ["gmail.com", "naver.com", "daum.net",
                         "nate.com", "hotmail.com", "icloud.com",
                         "yahoo.co.jp", "hanmail.net", "me.com", "mac.com"]
  
  static func singin(
    signData: SignData, fcmToken: String? = nil,
    completion: @escaping (DataResponse<SResult>) -> Void
    ) {
    singin(type: signData.type, email: signData.email, identification: signData.identification, fcmToken: fcmToken, completion: completion)
  }
  
  static func singin(
    type: SignType, email: String? = nil, identification: String, fcmToken: String? = nil,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(UserRouter.signin(type: type, email: email, identification: identification, fcmToken: fcmToken))
              .responseRankBaam(completion)
  }
  
  static func signup(
    email: String, identification: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(UserRouter.signup(email: email, identification: identification))
              .responseRankBaam(completion)
  }
}

struct TopicService {
  
  static func list(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  static func weekList(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicWeekList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  static func likeList(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
    ) {
    Alamofire .request(TopicRouter.topicLikeList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  static func myList(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
    ) {
    Alamofire .request(TopicRouter.topicMyList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  static func read(
    topicSN: Int,
    completion: @escaping (DataResponse<SResultTopicDetail>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicRead(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
  static func create(
    topicWrite: TopicWrite,
    completion: @escaping (DataResponse<SResultTopicCreate>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicCreate(topic: topicWrite))
              .responseRankBaam(completion)
  }
  
  static func like(
    topicSN: Int, isLike: Bool,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicLike(topicSN: topicSN, isLike: isLike))
              .responseRankBaam(completion)
  }
  
  static func unLike(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire .request(TopicRouter.topicUnlike(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
  // TODO completion
  static func updatePre(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicUpdatePre(topicSN: topicSN))
      .responseRankBaam(completion)
  }
  
  static func update(
    topicWrite: TopicWrite,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicUpdate(topic: topicWrite))
              .responseRankBaam(completion)
  }
  
  static func delete(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.topicDelete(topicSN: topicSN))
              .responseRankBaam(completion)
  }
}

struct OptionService {
  
  static func list(
    topicSN: Int, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionList>) -> Void
  ) {
    Alamofire .request(OptionRouter.optionList(topicSN: topicSN, page: page, count: count))
              .responseRankBaam(completion)
  }
  
  static func read(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResultOptionDetail>) -> Void
  ) {
    Alamofire .request(OptionRouter.optionRead(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
  static func create(
    optionWrite: OptionWrite,
    completion: @escaping (DataResponse<SResultOptionCreate>) -> Void
  ) {
    Alamofire .request(OptionRouter.optionCreate(option: optionWrite))
              .responseRankBaam(completion)
  }
  
  // TODO completion
  static func updatePre(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionRouter.optionUpdatePre(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
  static func update(
    optionWrite: OptionWrite,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionRouter.optionUpdate(option: optionWrite))
              .responseRankBaam(completion)
  }
  
  static func delete(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionRouter.optionDelete(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
}

struct OptionCommentService {
  
  static func list(
    topicSN: Int, optionSN: Int, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionCommentList>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.optionCommentList(topicSN: topicSN, optionSN: optionSN, page: page, count: count))
              .responseRankBaam(completion)
  }
  
  static func list(
    optionCommentSN: String, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionSubCommentList>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.optionSubCommentList(pOptionCommentSN: optionCommentSN, page: page, count: count))
              .responseRankBaam(completion)
  }
  
  static func create(
    topicSN: Int, optionSN: Int, supportType: SupportType, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.optionCommentCreate(topicSN: topicSN, optionSN: optionSN, supportType: supportType, description: description))
              .responseRankBaam(completion)
  }
  
  static func create(
    optionCommentSN: String, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.optionSubCommentCreate(optionCommentSN: optionCommentSN, description: description))
              .responseRankBaam(completion)
  }
  
  static func update(
    optionCommentSN: String, supportType: SupportType? = nil, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.optionCommentUpdate(optionCommentSN: optionCommentSN, supportType: supportType, description: description))
              .responseRankBaam(completion)
  }
  
  static func delete(
    optionCommentSN: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.optionCommentDelete(optionCommentSN: optionCommentSN))
              .responseRankBaam(completion)
  }
  
}


