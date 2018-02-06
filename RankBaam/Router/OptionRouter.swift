import Alamofire


enum OptionRouter {
  case list(topicSN: Int, page: Int, count: Int?)
  case read(topicSN: Int, optionSN: Int)
  case create(option: OptionWrite)
  case photoCreate(topicSN: Int, optionSN: Int)
  case updatePre(topicSN: Int, optionSN: Int)
  case update(option: OptionWrite)
  case delete(topicSN: Int, optionSN: Int)
  case vote(topicSN: Int, optionSN: Int, isVoted: Bool)
  case votes(topicSN: Int, optionSNs: [Int]) //override
}

// MARK: TargetType

extension OptionRouter: TargetType {
  
  var path: String {
    switch self {
    case let .list(topicSN, page, _):
      return "/topic/\(topicSN)/option/list/\(page)"
    case let .read(topicSN, optionSN):
      return "/topic/\(topicSN)/option/\(optionSN)"
    case let .create(option):
      return "/topic/\(option.topicSN)/option/create"
    case let .photoCreate(topicSN, optionSN):
      return "/topic/\(topicSN)/option/\(optionSN)/photo/create"
    case let .updatePre(topicSN, optionSN):
      return "/topic/\(topicSN)/option/\(optionSN)/update/pre"
    case let .update(option):
      guard let optionSN = option.optionSN else {return ""}
      return "/topic/\(option.topicSN)/option/\(optionSN)/update"
    case let .delete(topicSN, optionSN):
      return "/topic/\(topicSN)/option/\(optionSN)/delete"
    case let .vote(topicSN, optionSN, _):
      return "/topic/\(topicSN)/option/\(optionSN)/vote"
    case let .votes(topicSN, _):
      return "/topic/\(topicSN)/votes"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .list,
         .read,
         .updatePre:
      return .get
    case .create,
         .photoCreate,
         .update,
         .delete,
         .vote,
         .votes:
      return .post
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .list(_, _, count):
      return .init(optionalItems: [
        "count": count
      ])
    case let .create(option),
         let .update(option):
      return .init(optionalItems: [
        "title" : option.title,
        "description" : option.description
      ])
    case let .vote(_, _, isVoted):
      return ["isVoted": isVoted]
    case let.votes(_, optionSNs):
      let strOptionSNs = "\(optionSNs)"
      let strStartIndex = strOptionSNs.index(strOptionSNs.startIndex, offsetBy: 1)
      let strEndIndex = strOptionSNs.index(strOptionSNs.endIndex, offsetBy: -1)
      return [
        "optionSNs": String(strOptionSNs[strStartIndex..<strEndIndex])
      ]
    case .photoCreate,
         .read,
         .updatePre,
         .delete:
      return nil
    }
  }
  
}
