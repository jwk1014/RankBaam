import Alamofire

protocol TargetType {
  
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var header: HTTPHeaders { get }
  var parameters: Parameters { get }
}

extension TargetType {
  
  var baseURL: URL {
    return URL(string: "https://www.devwon.com/rankbaam")!
  }
  
  var header: HTTPHeaders {
    return ["Content-Type": "application/x-www-form-urlencoded"]
  }
  var parameters: Parameters {
    return [:]
  }
}
