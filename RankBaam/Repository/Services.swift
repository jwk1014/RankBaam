import Alamofire

struct UserService {
    
  static let EMAIL_DOMAINS = ["gmail.com", "naver.com", "daum.net",
                         "nate.com", "hotmail.com", "icloud.com",
                         "yahoo.co.jp", "hanmail.net", "me.com", "mac.com"]
  
  static func singin(
    signForm: SignForm,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    Alamofire
        .request(UserRouter.signin(signForm: signForm))
        .responseRankBaam(completion)
  }
  
  static func signup(
    signForm: SignForm,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
        .request(UserRouter.signup(signForm: signForm))
        .responseRankBaam(completion)
  }
}

struct TopicService {
  
  static func topicList(
    page: Int,
    count: Int?,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) {
    let pagingParam = PagingParam(page: page, count: count)
    
    Alamofire
        .request(TopicRouter.topicList(pagingParam: pagingParam))
        .responseRankBaam(completion)
    
  }
  
  static func topicRead(
    topicSN: Int,
    completion: @escaping (DataResponse<SResultTopicDetail>) -> Void
  ) {
    
    Alamofire
        .request(TopicRouter.topicRead(topicSN: topicSN))
        .responseRankBaam(completion)
  }
  
  static func topicCreate(
    topic: Topic,
    completion: @escaping (DataResponse<SResultTopicCreate>) -> Void
  ) {
    
    Alamofire
        .request(TopicRouter.topicCreate(topic: topic))
        .responseRankBaam(completion)
  }
  
  static func topicLike(
    topicSN: Int,
    isLike: Bool,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicLike(topicSN: topicSN, isLike: isLike))
      .responseRankBaam(completion)
  }
  
  static func topicUnLike(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicUnlike(topicSN: topicSN))
      .responseRankBaam(completion)
  }
  
  static func topicUpdate(
    topic: Topic,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicUpdate(topic: topic))
      .responseRankBaam(completion)
  }
  
  static func topicDelete(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicDelete(topicSN: topicSN))
      .responseRankBaam(completion)
  }
}

struct OptionService {
  
  static func optionList(
    topicSN: Int,
    pagingParam: PagingParam,
    completion: @escaping (DataResponse<SResultOptionList>) -> Void
  ) {
    
    Alamofire
      .request(OptionRouter.optionList(topicSN: topicSN, pagingParam: pagingParam))
      .responseRankBaam(completion)
  }
  
  static func optionCreate(
    topicSN: Int,
    optionParam: VoteOptionType,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(OptionRouter.optionCreate(topicSN: topicSN, optionParam: optionParam))
      .responseRankBaam(completion)
  }

}


