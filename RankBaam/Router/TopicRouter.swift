import Alamofire


enum TopicRouter {
  case categoryList
  case list(page: Int, count: Int?, categorySN: Int?, order: OrderType?)
  case weekList(page: Int, count: Int?, categorySN: Int?)
  case likeList(page: Int, count: Int?, categorySN: Int?, order: OrderType?)
  case myList(page: Int, count: Int?, categorySN: Int?, order: OrderType?)
  case create(topic: TopicWrite)
  //case photoCreate(topicSN: Int)
  //case photoDelete(topicSN: Int, order: Int)
  case read(topicSN: Int)
  case like(topicSN: Int, isLike: Bool)
  case unlike(topicSN: Int)
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
    case let .read(topicSN):
      return "/topic/\(topicSN)"
    case let .like(topicSN, _):
      return "/topic/\(topicSN)/like"
    case let .unlike(topicSN):
      return "/topic/\(topicSN)/unlike"
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
         .like,
         .unlike,
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
      return ["isLike" : isLike]
    case .categoryList,
         .read,
         .unlike,
         .updatePre,
         .delete:
      return nil
    }
  }

}
