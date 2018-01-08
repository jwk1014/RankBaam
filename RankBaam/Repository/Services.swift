import Alamofire

struct UserService {
  
  static func singin(
    signForm: SignForm,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {

    Alamofire
      .request(UserRouter.signin(signForm: signForm))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.flatMapResult { json -> Result<SResult> in
          do {
            let sResult = try JSONDecoder().decode(SResult.self, from: json)
            return .success(sResult)
          } catch {
            return .failure(MappingError(from: json, to: SResult.self))
          }
        }
        completion(newResponse)
      }
    
  }
  
  static func signup(
    signForm: SignForm,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(UserRouter.signup(signForm: signForm))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.flatMapResult { json -> Result<SResult> in
          do {
            let sResult = try JSONDecoder().decode(SResult.self, from: json)
            return .success(sResult)
          } catch {
            return .failure(MappingError(from: json, to: SResult.self))
          }
        }
        completion(newResponse)
      }
  }
}

struct TopicService {
  
  static func topicList(
    page: Int,
    count: Int?,
    completion: @escaping (DataResponse<SResultTopicList>) -> Void
  ) {
    let pagingParam = PagingParam(page: page, count: count)
    
    Alamofire
      .request(TopicRouter.topicList(pagingParam: pagingParam))
      .validate(statusCode: 200..<400)
      .responseData { response in
        
        let newResponse = response.flatMapResult { json -> Result<SResultTopicList> in
          do {
            let result = try JSONDecoder().decode(SResultTopicList.self, from: json)
            return .success(result)
          } catch {
            return .failure(MappingError(from: json, to: SResultTopicList.self))
          }
        }
        completion(newResponse)
      }
    
  }
  
  static func topicRead(
    topicSN: Int,
    completion: @escaping (DataResponse<SResultTopicDetail>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicRead(topicSN: topicSN))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.flatMapResult { json -> Result<SResultTopicDetail> in
          do {
            let sResult = try JSONDecoder().decode(SResultTopicDetail.self, from: json)
            return .success(sResult)
          } catch {
            return .failure(MappingError(from: json, to: SResultTopicDetail.self))
          }
        }
        completion(newResponse)
      }
  }
  
  static func topicCreate(
    topic: Topic,
    completion: @escaping (DataResponse<SResultTopicCreate>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicCreate(topic: topic))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.flatMapResult { json -> Result<SResultTopicCreate> in
          do {
            let sResult = try JSONDecoder().decode(SResultTopicCreate.self, from: json)
            return .success(sResult)
          } catch {
            return .failure(MappingError(from: json, to: SResultTopicCreate.self))
          }
        }
        completion(newResponse)
      }
  }
  
  static func topicLike(
    topicSN: Int,
    isLike: Bool,
    completion: @escaping (DataResponse<Void>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicLike(topicSN: topicSN, isLike: isLike))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.mapResult { json -> Void in
          return Void()
        }
        completion(newResponse)
      }
  }
  
  static func topicUnLike(
    topicSN: Int,
    completion: @escaping (DataResponse<Void>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicUnlike(topicSN: topicSN))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.mapResult { json -> Void in
          return Void()
        }
        completion(newResponse)
      }
  }
  
  static func topicUpdate(
    topic: Topic,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicUpdate(topic: topic))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.flatMapResult { json -> Result<SResult> in
          do {
            let sResult = try JSONDecoder().decode(SResult.self, from: json)
            return .success(sResult)
          } catch {
            return .failure(error)
          }
        }
        completion(newResponse)
      }
  }
  
  static func topicDelete(
    topicSN: Int,
    completion: @escaping (DataResponse<SResult>) -> Void
  ) {
    
    Alamofire
      .request(TopicRouter.topicDelete(topicSN: topicSN))
      .validate(statusCode: 200..<400)
      .responseData { response in
        let newResponse = response.flatMapResult { json -> Result<SResult> in
          do {
            let sResult = try JSONDecoder().decode(SResult.self, from: json)
            return .success(sResult)
          } catch {
            return .failure(error)
          }
        }
        completion(newResponse)
      }
  }
}

struct OptionService {
  
  static func optionList(
    topicSN: Int,
    pagingParam: PagingParam,
    completion: @escaping (DataResponse<SResultOptionList>) -> Void
  ) {
    
    Alamofire
      .request(OptionRouter.optionList(topicSN: topicSN, pagingParam: pagingParam))
      .responseData { response in
        let newResponse = response.flatMapResult { json -> Result<SResultOptionList> in
          do {
            let sResult = try JSONDecoder().decode(SResultOptionList.self, from: json)
            return .success(sResult)
          } catch {
            return .failure(error)
          }
        }
        completion(newResponse)
      }
  }
  
  static func optionCreate(
    topicSN: Int,
    optionParam: VoteOptionType,
    completion: @escaping (DataResponse<Void>) -> Void
  ) {
    
    // FIXME: Option처리 다시하기
    Alamofire
      .request(OptionRouter.optionCreate(topicSN: topicSN, optionParam: optionParam))
      .responseData { response in
        let newResponse = response.mapResult { json -> Void in
          return Void()
        }
        completion(newResponse)
      }
  }
  
}


