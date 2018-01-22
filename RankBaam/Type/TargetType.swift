import Alamofire

protocol TargetType: URLRequestConvertible {
  
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: HTTPHeaders? { get }
  var parameters: Parameters? { get }
}

extension TargetType {
  
  var baseURL: URL {
    return URL(string: "https://www.devwon.com/rankbaam")!
  }
  
  var headers: HTTPHeaders? {
    return nil
    //return ["Content-Type": "application/x-www-form-urlencoded"]
  }
    
  var parameters: Parameters? {
    return nil
    //return [:]
  }
    
  func asURLRequest() throws -> URLRequest {
        
    let originalRequest = try URLRequest(
        url: self.baseURL.appendingPathComponent(self.path),
        method: self.method,
        headers: self.headers)
    
    return try URLEncoding.default.encode(originalRequest, with: parameters)
        
  }
}
