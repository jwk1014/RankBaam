import Foundation
import Alamofire

struct DataEmptyError: Error, CustomStringConvertible {
  
  let description: String
  
  init() {
    self.description = "DataEmptyError"
  }
}

struct MappingError: Error, CustomStringConvertible {
    
    let description: String
    
    init(from: Any, to: Any.Type) {
        self.description = "Failed to mapping \(from) to \(to)"
    }
}

protocol SolutionProcessableProtocol {
  func handle(_ vc: UIViewController)
}

struct TimeOutError: Error, CustomStringConvertible, SolutionProcessableProtocol {
    
    let description: String
    
    init() {
        self.description = "TimeOutError"
    }
    
  func handle(_ vc: UIViewController){
        let alert = UIAlertController(title: nil, message: "네트워크 상태를 확인해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}

struct NeedLoginError<T: Decodable>: Error, CustomStringConvertible, SolutionProcessableProtocol {
  
  let description: String
  
  init() {
    self.description = "NeedLoginError"
  }
  
  var urlRequest: URLRequest?
  var completionHandler: ((DataResponse<T>)->Void)?
  
  func handle(_ vc: UIViewController){
    DispatchQueue.main.async {
      let alert = SignInViewController()
      alert.loginCompleteClosure = {
        if let urlRequest = self.urlRequest, let completionHandler = self.completionHandler {
          let _ = Alamofire.request(urlRequest).responseRankBaam(completionHandler)
        }
      }
      vc.present(alert, animated: true, completion: nil)
    }
  }
}
