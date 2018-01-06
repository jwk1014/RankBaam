//
//  AlamofireManager.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 21..
//  Copyright © 2017년 김정원. All rights reserved.
//

import Foundation
import Alamofire

let EMAIL_DOMAINS = ["gmail.com", "naver.com", "daum.net",
                            "nate.com", "hotmail.com", "icloud.com",
                            "yahoo.co.jp", "hanmail.net", "me.com", "mac.com"]

enum Urls {
    static let BASE_URL = "https://www.devwon.com/rankbaam"
    
    case SignUp(signForm: SignForm)
    case SignIn(signForm: SignForm)
    case SignOut
    case GetNickname
    case SetNickname(nickname: String)
    case TopicList(pagingParam: PagingParam)
    case TopicCreate(topic: Topic)
    case TopicRead(topicSN: Int)
    case TopicLike(topicSN: Int, isLike: Bool)
    case TopicUnlike(topicSN: Int)
    case TopicUpdate(topic: Topic)
    case TopicDelete(topicSN: Int)
    case OptionList(topicSN: Int, pagingParam: PagingParam)
    case OptoinCreate(topicSN: Int, optionParam: VoteOptionType)
    
    var info: (subUrl: String, method: HTTPMethod) {
        switch self {
        case .SignUp:
            return ( "/sign/up", .post )
        case .SignIn:
            return ( "/sign/in", .post )
        case .SignOut:
            return ( "/sign/out", .post )
        case .GetNickname:
            return ( "/user/me/nickname", .get )
        case .SetNickname:
            return ( "/user/me/nickname", .post )
        case .TopicList(let pagingParam):
            return ( "/topic/list/\(pagingParam.page)", .get )
        case .TopicCreate:
            return ( "/topic/create", .post )
        case .TopicRead(let topicSN):
            return ("/topic/\(topicSN)", .get)
        case .TopicLike(let topicSN, _):
            return ("/topic/\(topicSN)/like",.post)
        case .TopicUnlike(let topicSN):
            return ("/topic/\(topicSN)/unlike", .post)
        case .TopicUpdate(let topic):
            guard let topicSN = topic.topicSN else { return ("", .post)}
            return ("/topic/\(topicSN)/update", .post)
        case .TopicDelete(let topicSN):
            return ("/topic/\(topicSN)/delete", .post)
        case .OptionList(let topicSN, let pagingParam):
            return ("/topic/\(topicSN)/option/list/\(pagingParam.page)", .get)
        case .OptoinCreate(let topicSN, _):
            return ("/topic/\(topicSN)/option/create", .post)
        }
        
        
    }
    
    var param: Parameters? {
        switch self {
        case .SignUp(let signForm):
            return .init(optionalItems: ["email": signForm.email, "identification": signForm.identification])
        case .SignIn(let signForm):
            return .init(optionalItems: ["type": signForm.type.rawValue, "email": signForm.email, "identification": signForm.identification])
        case .SignOut:
            return nil
        case .GetNickname:
            return nil
        case .SetNickname(let nickname):
            return ["nickname": nickname]
        case .TopicList:
            return nil
        case .TopicCreate(let topic):
            return .init(optionalItems: [
                "title": topic.title,
                "description": topic.description,
                "isOnlyWriterCreateOption": topic.isOnlyWriterCreateOption,
                "votableCountPerUser": topic.votableCountPerUser
            ])
        case .TopicRead(_):
            return nil
        case .TopicLike(_, let isLike):
            return [
                "isLike" : "\(isLike)"
            ]
        case .TopicUnlike(_):
            return nil
        case .TopicUpdate(let topic):
            return .init(optionalItems: [
//                "title" : "\(topic.title)",
                "description": topic.description
            ])
        case .TopicDelete(_):
            return nil
        case .OptionList:
            return [
                "count" : 20
            ]
        case .OptoinCreate(_, let voteOption ):
            return .init(optionalItems: [
                "title" : voteOption.title,
                "description" : voteOption.description
            ])
        }
    }
    
}

class AlamofireManager {
    static func request(_ url: Urls) -> DataRequest {
        print("\(Urls.BASE_URL)\(url.info.subUrl)")
        print("파라미터 : \(String(describing: url.param))")
        return Alamofire.request(
            "\(Urls.BASE_URL)\(url.info.subUrl)",
            method: url.info.method,
            parameters: url.param,
            headers: ["Content-Type":"application/x-www-form-urlencoded"])
    }
}

extension DataRequest {
    
    func responseRankBaam<T: Decodable>( completionHandler: @escaping ((Error?, ((UIViewController)->Void)?, T?, Date?)->Void) ){
        
        responseData { response in
            
            if let error = response.error {
                
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
                }
                
                print("responseRankBaam Error : \(error.localizedDescription)")
                completionHandler(error, errorClosure, nil, nil)
            } else {
                var date: Date? = nil
                
                if  let headerFields = response.response?.allHeaderFields as? [String: String],
                    let url = response.request?.url {
                    
                    if let dateString = headerFields["Date"] {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss z"
                        date = dateFormatter.date(from: dateString)
                    }
                    
                    #if DEBUG
                        print("[HEADERS]")
                        for (key, value) in headerFields {
                            print("\(key) : \(value)")
                        }
                        print("=========")
                        
                        print("[COOKIES]")
                        for cookie in HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url) {
                            print(cookie)
                        }
                        print("=========")
                    #endif
                }
                
                if let data = response.data{
                    
                    
                    let testData = try? JSONDecoder().decode(T.self, from: data)
                    print("###########테스트 데이터 : \(String(describing: testData))")
                    
                    
                    completionHandler(nil, nil, try? JSONDecoder().decode(T.self, from: data), date)
                }
                
                #if DEBUG
                    if  let data = response.data,
                        let str = String(data: data, encoding: .utf8) {
                            print(str)
                            print(str)
                        }
                #endif
            }
        }
    }
}





