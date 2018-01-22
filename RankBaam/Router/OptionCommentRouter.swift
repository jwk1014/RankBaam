import Alamofire

enum OptionCommentRouter {
  case list(topicSN: Int, optionSN:Int, page: Int, count: Int?)
  case subList(pOptionCommentSN: String, page: Int, count: Int?)
  case create(topicSN: Int, optionSN: Int, supportType: SupportType, description: String)
  case subCreate(optionCommentSN: String, description: String)
  case update(optionCommentSN: String, supportType: SupportType?, description: String)
  case delete(optionCommentSN: String)
}

// MARK: TargetType

extension OptionCommentRouter: TargetType {
  
  var path: String {
    switch self {
    case let .list(topicSN, optionSN, page, _):
      return "/topic/\(topicSN)/option/\(optionSN)/comment/list/\(page)"
    case let .subList(pOptionCommentSN, page, _):
      return "/topic/option/comment/\(pOptionCommentSN)/list/\(page)"
    case let .create(topicSN, optionSN, _, _):
      return "/topic/\(topicSN)/option/\(optionSN)/comment/create"
    case let .subCreate(optionCommentSN, _):
      return "/topic/option/comment/\(optionCommentSN)/create"
    case let .update(optionCommentSN, _, _):
      return "/topic/option/comment/\(optionCommentSN)/update"
    case let .delete(optionCommentSN):
      return "/topic/option/comment/\(optionCommentSN)/delete"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .list,
         .subList:
      return .get
    case .create,
         .subCreate,
         .update,
         .delete:
      return .post
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .list(_, _, _, count),
         let .subList(_, _, count):
      return .init(optionalItems: [
        "count": count
      ])
    case let .create(_, _, supportType, description):
      return [
        "supportType": supportType,
        "description" : description
      ]
    case let .subCreate(_, description):
      return ["description": description]
    case let .update(_, supportType, description):
      return .init(optionalItems: [
        "supportType": supportType,
        "description" : description
      ])
    case .delete:
      return nil
    }
  }
  
}
