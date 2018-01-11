import Foundation

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
        let alert = UIAlertController()
        vc.present(alert, animated: true, completion: nil)
    }
    
}
