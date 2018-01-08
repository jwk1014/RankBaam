import Alamofire


/// 유저와 관련된 서비스 (로그인, 회원가입 등)을 위한 URLRequest를 만들어주는 라우터
enum UserRouter {
  
  case signin(signForm: SignForm)
  case signup(signForm: SignForm)
  case getNickname
  case setNickname(nickname: String)
}


// MARK: TargetType

extension UserRouter: TargetType {
  
  var path: String {
    switch self {
    case .signin:
      return "/sign/in"
    case .signup:
      return "/sign/up"
    case .getNickname, .setNickname:
      return "/user/me/nickname"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .signin, .signup, .setNickname:
      return .post
    case .getNickname:
      return .get
    }
  }
  
  var parameters: Parameters {
    switch self {
    case .signin(let form):
      return .init(optionalItems: ["type": form.type.rawValue,
                                   "email": form.email,
                                   "identification": form.identification])
    case .signup(let form):
      return .init(optionalItems: ["email": form.email,
                                   "identification": form.identification])
    case let .setNickname(nickname):
      return ["nickname": nickname]
    case .getNickname:
      return [:]
    }
  }
}

// MARK: URLRequestConvertible

extension UserRouter: URLRequestConvertible {
  
  func asURLRequest() throws -> URLRequest {
    let url = self.baseURL
    
    var urlRequest = try URLRequest(
      url: url.appendingPathComponent(self.path),
      method: self.method,
      headers: self.header
    )
    
    switch self {
    case .signin ,.signup, .setNickname:
      urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: self.parameters)
    case .getNickname:
      urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
    }
    
    return urlRequest
  }
}



