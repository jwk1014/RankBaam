import Alamofire


enum OptionRouter {
  case optionList(topicSN: Int, pagingParam: PagingParam)
  case optionCreate(topicSN: Int, optionParam: VoteOptionType)
}

// MARK: TargetType

extension OptionRouter: TargetType {
  
  var path: String {
    switch self {
    case let .optionList(topicSN, pagingParam):
      return "/topic/\(topicSN)/option/list/\(pagingParam.page)"
    case .optionCreate(let topicSN, _):
      return "/topic/\(topicSN)/option/create"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .optionList:
      return .get
    case .optionCreate:
      return .post
    }
  }
  
  var parameters: Parameters {
    switch self {
    case .optionList:
      return ["count" : 20]
    case .optionCreate(_, let voteOption ):
      return .init(optionalItems: [
        "title" : voteOption.title,
        "description" : voteOption.description
      ])
    }
  }
  
}


// MARK: URLRequestConvertible

extension OptionRouter: URLRequestConvertible {
  
  func asURLRequest() throws -> URLRequest {
    
    let url = self.baseURL
    
    var urlRequest = try URLRequest(
      url: url.appendingPathComponent(self.path),
      method: self.method,
      headers: self.header
    )
    
    switch self {
    case .optionList:
      urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: self.parameters)
    case .optionCreate:
      urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
    }
    
    return urlRequest
  }
}
