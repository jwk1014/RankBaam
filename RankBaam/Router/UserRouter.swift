import Alamofire


/// 유저와 관련된 서비스 (로그인, 회원가입 등)을 위한 URLRequest를 만들어주는 라우터
enum UserRouter {
  case signIn(type: SignType, email: String?, identification: String, fcmToken: String?)
  case signUp(email: String, identification: String, nickname: String)
  case signOut
  case getNickname
  case setNickname(nickname: String)
  case preNickname
}

// MARK: TargetType
extension UserRouter: TargetType {
  
  var path: String {
    switch self {
    case .signIn:
      return "/sign/in"
    case .signUp:
      return "/sign/up"
    case .signOut:
      return "/sign/out"
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
    case .signIn,
         .signUp,
         .signOut,
         .setNickname:
      return .post
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .signIn(type, email, identification, fcmToken):
      return .init(optionalItems: [
        "type": type.rawValue,
        "email": email,
        "identification": identification,
        "fcmToken": fcmToken
      ])
    case let .signUp(email, identification, nickname):
      return .init(optionalItems: [
        "email": email,
        "identification": identification,
        "nickname": nickname
      ])
    case let .setNickname(nickname):
      return ["nickname": nickname]
    case .signOut,
         .getNickname,
         .preNickname:
      return nil
    }
  }
}



