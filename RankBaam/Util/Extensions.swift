//
//  Extensions.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 1. 6..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Alamofire

func width375(_ width: CGFloat) -> CGFloat {
  return UIScreen.main.bounds.width * width / 375.0
}

func height667(_ height: CGFloat, forX: CGFloat? = nil) -> CGFloat {
  let screenHeight = UIScreen.main.bounds.height
  if screenHeight == 812.0, let forX = forX { //if X
    return forX
  }
  return screenHeight * height / 667.0
}

extension String {
    func isMatch(regex: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: regex, options: [])
        return regex?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: utf16.count)) != nil
    }
    
    func tempDateFommatConverter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy H:mm:ss a"
        guard let result = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: result)
    }
}

extension UIViewController {
  func present(_ vc: UIViewController, animated: Bool, transitioningDelegate: UIViewControllerTransitioningDelegate, completion: (() -> Void)?){
    vc.transitioningDelegate = transitioningDelegate
    vc.modalPresentationStyle = .custom
    present(vc, animated: animated, completion: completion)
  }
}

extension UITextField {
    var isEmpty: Bool {
        return text == nil || text!.isEmpty
    }
}

extension UIAlertController {
    static func alert( target: UIViewController, msg: String, actionClosure: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "확인", style: .cancel, handler: actionClosure))
        target.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
  convenience init(hex: String) {
      let scanner = Scanner(string: hex.trimmingCharacters(in: [" "]))
    
      if( hex.hasPrefix("#") ) {
          scanner.scanLocation = 1
      }
    
      var argbValue: UInt64 = 0
    
      scanner.scanHexInt64(&argbValue)
    
      let hexCount = scanner.string.count - scanner.scanLocation
    
      let a = (hexCount > 2 * 3) ? ((argbValue >> 8 * 3) & 0xff) : 0xff
      let r = (hexCount > 2 * 2) ? ((argbValue >> 8 * 2) & 0xff) : 0x00
      let g = (hexCount > 2 * 1) ? ((argbValue >> 8 * 1) & 0xff) : 0x00
      let b = argbValue & 0xff
    
      self.init(
          red:    CGFloat(r) / 0xff,
          green:  CGFloat(g) / 0xff,
          blue:   CGFloat(b) / 0xff,
          alpha:  CGFloat(a) / 0xff
      )
  }
  convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
    self.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
  }
}

extension Dictionary where Key == String, Value == Any {
    init(optionalItems: Dictionary<Key,Any?>) {
        self.init(minimumCapacity: optionalItems.capacity)
        for (key, value) in optionalItems where value != nil{
            self[key] = value!
        }
    }
}

extension DataResponse {
    func create<T>(_ result: Result<T>) -> DataResponse<T> {
        return DataResponse<T>(
            request: self.request,
            response: self.response,
            data: self.data,
            result: result,
            timeline: self.timeline
        )
    }
}

extension DataRequest {
    
    func debug<T: Decodable>(response: DataResponse<Data>, type: T.Type){
        
        #if DEBUG
            
            var log: String = "\n===== \((response.request?.url?.absoluteString)!) =====\n\n"
            
            if let error = response.error {
                log += "[ERROR]\n\(error.localizedDescription)\n\n"
            } else {
                
                if  let headerFields = response.response?.allHeaderFields as? [String: String],
                    let url = response.request?.url {
                    
                    if let dateString = headerFields["Date"] {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss z"
                        if let date = dateFormatter.date(from: dateString) {
                            log += "[DATE]\n\(date)\n\n"
                        }
                    }
                    
                    if headerFields.count > 0 {
                        log += "[HEADERS]\n"
                        for (key, value) in headerFields {
                            log += "\(key) : \(value)\n"
                        }
                        log += "\n"
                    }
                    
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                    if cookies.count > 0 {
                        log += "[COOKIES]\n"
                        for cookie in cookies {
                            log += "\(cookie.name) : \(cookie.value) \n"
                        }
                        log += "\n"
                    }
                }
                
                log += "[RESPONSE DATA]\n"
                if let data = response.data{
                    
                    if let str = String(data: data, encoding: .utf8) {
                        log += "\(str)\n\n"
                    } else {
                        log += "to String fail\n\n"
                    }
                    
                    do{
                        let _ = try JSONDecoder().decode(type, from: data)
                    } catch let error as DecodingError {
                        log += "decode fail\n"
                        switch error {
                        case .dataCorrupted(let context):
                            print("dataCorrupted")
                            print(context.debugDescription)
                        case .keyNotFound(let type, let context):
                            print("keyNotFound (type: \(type)")
                            print(context.codingPath.enumerated()
                                .filter({$0.offset % 2 == 0})
                                .reduce(""){$0+$1.element.stringValue+" "})
                            print(context.debugDescription)
                        case .typeMismatch(let type, let context):
                            print("typeMismatch (type: \(type)")
                            print(context.codingPath.enumerated()
                                .filter({$0.offset % 2 == 0})
                                .reduce(""){$0+$1.element.stringValue+" "})
                            print(context.debugDescription)
                        case .valueNotFound(let type, let context):
                            print("valueNotFound (type: \(type)")
                            print(context.codingPath.enumerated()
                                .filter({$0.offset % 2 == 0})
                                .reduce(""){$0+$1.element.stringValue+" "})
                            print(context.debugDescription)
                        }
                    } catch _ { }
                    
                } else {
                    log += "nil\n\n"
                }
            }
            
            log += "=================================================\n\n"
            print(log)
            
        #endif
    }
    
    func responseRankBaam<T: Decodable>(
        _ completionHandler: @escaping (DataResponse<T>)->Void ) -> DataRequest {
        return responseData { response in
            
            self.debug(response: response, type: T.self)
            
            if let error = response.error {
                
                completionHandler(response.create(.failure(error)))
    
            } else {
                
                guard let data = response.data else {
                    completionHandler(response.create(.failure(DataEmptyError())))
                    return
                }
                
                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    completionHandler(response.create(.failure(MappingError(from: data, to: T.self))))
                    return
                }
                
                completionHandler(response.create(.success(decodedData)))
                
            }
        }
    }
}

/*
 var errorClosure: ((UIViewController)->Void)? = nil
 if let error = error as? URLError {
 switch error.code {
 case URLError.timedOut:
 //와이파이 또는 통신사인터넷 등 인터넷이 아에 안됨
 //서버다운
 break
 case URLError.cannotFindHost:
 //와이파이 연결했지만 와이파이가 인터넷이 안되는 와이파이
 break
 default:
 break
 }
 errorHandler(error, errorClosure)
 }*/
