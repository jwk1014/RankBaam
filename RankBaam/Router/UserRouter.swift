import Alamofire


/// 유저와 관련된 서비스 (로그인, 회원가입 등)을 위한 URLRequest를 만들어주는 라우터
enum UserRouter {
  case signin(type: SignType, email: String?, identification: String, fcmToken: String?)
  case signup(email: String, identification: String)
  case getNickname
  case setNickname(nickname: String)
  case preNickname
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
    case .preNickname:
      return "/user/me/nickname/pre"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .getNickname,
         .preNickname:
      return .get
    case .signin,
         .signup,
         .setNickname:
      return .post
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .signin(type, email, identification, fcmToken):
      return .init(optionalItems: [
        "type": type.rawValue,
        "email": email,
        "identification": identification,
        "fcmToken": fcmToken
      ])
    case let .signup(email, identification):
      return .init(optionalItems: [
        "email": email,
        "identification": identification
      ])
    case let .setNickname(nickname):
      return ["nickname": nickname]
    case .getNickname,
         .preNickname:
      return nil
    }
  }
}



