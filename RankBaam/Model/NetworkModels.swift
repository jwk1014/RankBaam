//
//  NetworkModels.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 21..
//  Copyright © 2017년 김정원. All rights reserved.
//

import Foundation
//22일 1시

enum SignType: Int, Codable, CustomStringConvertible {
  case email = 1
  case facebook = 2
  case google = 3
  case kakao = 4
  var description: String {
    return "\(rawValue)"
  }
}

enum OrderType: Int, Encodable, CustomStringConvertible {
  case new = 1
  case best = 2
  case vote = 3
  var description: String {
    return "\(self.rawValue)"
  }
  var name: String {
    switch self {
    case .new: return "최신순"
    case .best: return "인기순"
    case .vote: return "투표순"
    }
  }
}

struct SResult: Decodable{
    var succ: Bool
    var msg: String?
}

struct SResultNickname: Decodable {
  var succ: Bool
  var msg: String?
  var nickname: String?
}

struct SResultCategoryList: Decodable {
  var succ: Bool
  var msg: String?
  var categories: [Category]?
}

struct SResultTopicList: Decodable{
    var succ: Bool
    var msg: String?
    var topics: [Topic]?
}

struct SResultTopicRankList: Decodable{
  var succ: Bool
  var msg: String?
  var topics: [Topic]?
}

struct SResultTopicDetail: Decodable{
    var succ: Bool
    var msg: String?
    var topic: Topic?
}

struct SResultTopicCreate: Decodable {
    var succ: Bool
    var msg: String?
    var topicSN: Int?
}

struct SResultVote: Decodable {
    var succ: Bool
    var msg: String?
    var vote: Vote?
}

struct SResultOptionList: Decodable{
    var succ: Bool
    var msg: String?
    var options: [Option]?
}

struct SResultOptionDetail: Decodable{
  var succ: Bool
  var msg: String?
  var option: Option?
}

struct SResultOptionCreate: Decodable {
  var succ: Bool
  var msg: String?
  var topicSN: Int?
  var optionSN: Int?
}

struct SResultOptionCommentList: Decodable {
  var succ: Bool
  var msg: String?
  var optionComments: [OptionComment]?
}

struct SResultOptionSubCommentList: Decodable {
  var succ: Bool
  var msg: String?
  var optionSubComments: [OptionSubComment]?
}

/*
struct PagingParam {
  var page: Int
  var count: Int?
  init(page: Int, count: Int?) {
    self.page = page
    self.count = count
  }
  init(page: Int) {
    self.init(page: page, count: nil)
  }
}*/

/*
struct SResultTopicDetail: Decodable{
  
  enum CodingKeys: String, CodingKey {
    case succ
    case msg
    case topic
  }
   
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let succ = try container.decode(Bool.self, forKey: .succ)
    self.succ = succ
    let msg = try? container.decode(String.self, forKey: .msg)
    if msg == nil {
      let msgInt = try? container.decode(Int.self, forKey: .msg)
      self.msgInt = msgInt
    } else {
      self.msg = msg
    }
    let topic = try? container.decode(Topic.self, forKey: .topic)
    self.topic = topic
  }
}*/
