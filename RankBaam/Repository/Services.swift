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
  
  static func categoryList(
    completion: @escaping (DataResponse<SResultCategoryList>) -> Void
  ) {
    Alamofire .request(TopicRouter.categoryList)
              .responseRankBaam(completion)
  }
  
  static func list(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) {
    Alamofire .request(TopicRouter.list(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  static func weekList(
    page: Int, count: Int? = nil, categorySN: Int? = nil,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) {
    Alamofire .request(TopicRouter.weekList(page: page, count: count, categorySN: categorySN))
              .responseRankBaam(completion)
  }
  
  static func likeList(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
    ) {
    Alamofire .request(TopicRouter.likeList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  static func myList(
    page: Int, count: Int? = nil, categorySN: Int? = nil, order: OrderType,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
    ) {
    Alamofire .request(TopicRouter.myList(page: page, count: count, categorySN: categorySN, order: order))
              .responseRankBaam(completion)
  }
  
  static func read(
    topicSN: Int,
    completion: @escaping (DataResponse<SResultTopicDetail>) -> Void
  ) {
    Alamofire .request(TopicRouter.read(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
  static func create(
    topicWrite: TopicWrite,
    completion: @escaping (DataResponse<SResultTopicCreate>) -> Void
  ) {
    Alamofire .request(TopicRouter.create(topic: topicWrite))
              .responseRankBaam(completion)
  }
  
  static func like(
    topicSN: Int, isLike: Bool,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.like(topicSN: topicSN, isLike: isLike))
              .responseRankBaam(completion)
  }
  
  static func unLike(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire .request(TopicRouter.unlike(topicSN: topicSN))
              .responseRankBaam(completion)
  }
  
  // TODO completion
  static func updatePre(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.updatePre(topicSN: topicSN))
      .responseRankBaam(completion)
  }
  
  static func update(
    topicWrite: TopicWrite,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.update(topic: topicWrite))
              .responseRankBaam(completion)
  }
  
  static func delete(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(TopicRouter.delete(topicSN: topicSN))
              .responseRankBaam(completion)
  }
}

struct OptionService {
  
  static func list(
    topicSN: Int, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionList>) -> Void
  ) {
    Alamofire .request(OptionRouter.list(topicSN: topicSN, page: page, count: count))
              .responseRankBaam(completion)
  }
  
  static func read(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResultOptionDetail>) -> Void
  ) {
    Alamofire .request(OptionRouter.read(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
  static func create(
    optionWrite: OptionWrite,
    completion: @escaping (DataResponse<SResultOptionCreate>) -> Void
  ) {
    Alamofire .request(OptionRouter.create(option: optionWrite))
              .responseRankBaam(completion)
  }
  
  // TODO completion
  static func updatePre(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionRouter.updatePre(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
  
  static func update(
    optionWrite: OptionWrite,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionRouter.update(option: optionWrite))
              .responseRankBaam(completion)
  }
  
  static func delete(
    topicSN: Int, optionSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionRouter.delete(topicSN: topicSN, optionSN: optionSN))
              .responseRankBaam(completion)
  }
}

struct OptionCommentService {
  
  static func list(
    topicSN: Int, optionSN: Int, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionCommentList>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.list(topicSN: topicSN, optionSN: optionSN, page: page, count: count))
              .responseRankBaam(completion)
  }
  
  static func list(
    optionCommentSN: String, page: Int, count: Int? = nil,
    completion: @escaping (DataResponse<SResultOptionSubCommentList>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.subList(pOptionCommentSN: optionCommentSN, page: page, count: count))
              .responseRankBaam(completion)
  }
  
  static func create(
    topicSN: Int, optionSN: Int, supportType: SupportType, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.create(topicSN: topicSN, optionSN: optionSN, supportType: supportType, description: description))
              .responseRankBaam(completion)
  }
  
  static func create(
    optionCommentSN: String, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.subCreate(optionCommentSN: optionCommentSN, description: description))
              .responseRankBaam(completion)
  }
  
  static func update(
    optionCommentSN: String, supportType: SupportType? = nil, description: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.update(optionCommentSN: optionCommentSN, supportType: supportType, description: description))
              .responseRankBaam(completion)
  }
  
  static func delete(
    optionCommentSN: String,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire .request(OptionCommentRouter.delete(optionCommentSN: optionCommentSN))
              .responseRankBaam(completion)
  }
  
}


