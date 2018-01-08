import Alamofire


enum TopicRouter {
  case topicList(pagingParam: PagingParam)
  case topicCreate(topic: Topic)
  case topicRead(topicSN: Int)
  case topicLike(topicSN: Int, isLike: Bool)
  case topicUnlike(topicSN: Int)
  case topicUpdate(topic: Topic)
  case topicDelete(topicSN: Int)
}

// MARK: TargetType

extension TopicRouter: TargetType {
  
  var path: String {
    switch self {
    case .topicList(let param):
      return "/topic/list/\(param.page)"
    case .topicCreate:
      return "/topic/create"
    case .topicRead(let topicSN):
      return "/topic/\(topicSN)"
    case .topicLike(let topicSN):
      return "/topic/\(topicSN.topicSN)/like"
    case .topicUnlike(let topicSN):
      return "/topic/\(topicSN)/unlike"
    case .topicUpdate(let topic):
      guard let topicSN = topic.topicSN else { return "" }
      return "/topic/\(topicSN)/update"
    case .topicDelete(let topicSN):
      return "/topic/\(topicSN)/delete"
    }
  }
  
  var method: HTTPMethod {
    
    switch self {
    case .topicCreate,
         .topicLike,
         .topicUnlike,
         .topicUpdate,
         .topicDelete:
      return .post
    case .topicList,
         .topicRead:
      return .get
    }
  }
  
  var parameters: Parameters {
    switch self {
    case .topicList:
      return [:]
    case .topicCreate(let topic):
      return .init(optionalItems: [
        "title": topic.title,
        "description": topic.description,
        "isOnlyWriterCreateOption": topic.isOnlyWriterCreateOption,
        "votableCountPerUser": topic.votableCountPerUser
      ])
    case .topicRead, .topicUnlike, .topicDelete:
      return [:]
    case .topicLike(_, let isLike):
      return ["isLike" : "\(isLike)"]
    case .topicUpdate(let topic):
      return .init(optionalItems: ["description": topic.description])
    }
  }

}


// MARK: URLRequestConvertible

extension TopicRouter: URLRequestConvertible {

  func asURLRequest() throws -> URLRequest {
    let url = self.baseURL
    
    var urlRequest = try URLRequest(
      url: url.appendingPathComponent(self.path),
      method: self.method,
      headers: self.header
    )
    
    switch self {
    case .topicCreate,
         .topicLike,
         .topicUnlike,
         .topicUpdate,
         .topicDelete:
      urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: self.parameters)
    case .topicList,
         .topicRead:
      urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
    }
    
    return urlRequest
  }
}
