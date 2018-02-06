import Alamofire


enum TopicRouter {
  case categoryList
  case list(page: Int, count: Int?, categorySN: Int?, order: OrderType?)
  case weekList(page: Int, count: Int?, categorySN: Int?)
  case likeList(page: Int, count: Int?, categorySN: Int?, order: OrderType?)
  case myList(page: Int, count: Int?, categorySN: Int?, order: OrderType?)
  case create(topic: TopicWrite)
  case photoCreate(topicSN: Int)
  case read(topicSN: Int)
  case like(topicSN: Int, isLiked: Bool)
  case likes(topicSNs: [Int], isLiked: Bool)
  case unlike(topicSN: Int)
  case unlikes(topicSNs: [Int])
  case updatePre(topicSN: Int)
  case update(topic: TopicWrite)
  case delete(topicSN: Int)
}

// MARK: TargetType

extension TopicRouter: TargetType {
  
  var path: String {
    switch self {
    case .categoryList:
      return "/topic/category/list"
    case let .list(page, _, _, _):
      return "/topic/list/\(page)"
    case let .weekList(page, _, _):
      return "/topic/week/list/\(page)"
    case let .likeList(page, _, _, _):
      return "/topic/like/list/\(page)"
    case let .myList(page, _, _, _):
      return "/topic/my/list/\(page)"
    case .create:
      return "/topic/create"
    case let .photoCreate(topicSN):
      return "/topic/\(topicSN)/photo/create"
    case let .read(topicSN):
      return "/topic/\(topicSN)"
    case let .like(topicSN, _):
      return "/topic/\(topicSN)/like"
    case .likes:
      return "/topic/likes"
    case let .unlike(topicSN):
      return "/topic/\(topicSN)/unlike"
    case .unlikes:
      return "/topic/unlikes"
    case let .updatePre(topicSN):
      return "/topic/\(topicSN)/update/pre"
    case let .update(topic):
      guard let topicSN = topic.topicSN else {return ""}
      return "/topic/\(topicSN)/update"
    case let .delete(topicSN):
      return "/topic/\(topicSN)/delete"
    }
  }
  
  var method: HTTPMethod {
    
    switch self {
    case .categoryList,
         .list,
         .weekList,
         .likeList,
         .myList,
         .read,
         .updatePre:
      return .get
    case .create,
         .photoCreate,
         .like,
         .likes,
         .unlike,
         .unlikes,
         .update,
         .delete:
      return .post
    }
  }
  
  var parameters: Parameters? {
    switch self {
    case let .list(_, count, categorySN, order),
         let .likeList(_, count, categorySN, order),
         let .myList(_, count, categorySN, order):
      return .init(optionalItems: [
        "count": count,
        "categorySN": categorySN,
        "order": order
      ])
    case let .weekList(_, count, categorySN):
      return .init(optionalItems: [
        "count": count,
        "categorySN": categorySN
      ])
    case let .create(topic),
         let .update(topic):
      return .init(optionalItems: [
        "category.categorySN": topic.category.categorySN,
        "title": topic.title,
        "description": topic.description,
        "isOnlyWriterCreateOption": topic.isOnlyWriterCreateOption,
        "votableCountPerUser": topic.votableCountPerUser
      ])
    case let .like(_, isLike):
      return ["isLiked" : isLike]
    case let .likes(topicSNs, isLike):
      let strTopicSNs = "\(topicSNs)"
      let strStartIndex = strTopicSNs.index(strTopicSNs.startIndex, offsetBy: 1)
      let strEndIndex = strTopicSNs.index(strTopicSNs.endIndex, offsetBy: -1)
      return [
        "topicSNs": String(strTopicSNs[strStartIndex..<strEndIndex]),
        "isLiked": isLike
      ]
    case let .unlikes(topicSNs):
      let strTopicSNs = "\(topicSNs)"
      let strStartIndex = strTopicSNs.index(strTopicSNs.startIndex, offsetBy: 1)
      let strEndIndex = strTopicSNs.index(strTopicSNs.endIndex, offsetBy: -1)
      return [
        "topicSNs": String(strTopicSNs[strStartIndex..<strEndIndex])
      ]
    case .categoryList,
         .photoCreate,
         .read,
         .unlike,
         .updatePre,
         .delete:
      return nil
    }
  }

}
