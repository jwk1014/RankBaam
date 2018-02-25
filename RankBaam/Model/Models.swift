//
//  Models.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 21..
//  Copyright © 2017년 김정원. All rights reserved.
//

import Foundation

struct Category: Equatable, Codable {
    var categorySN: Int
    var name: String
    static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.categorySN == rhs.categorySN
    }
}

struct Photo: Codable {
    var order: Int
    var url: String
    var realUrl: String {
        return "http://www.devwon.com/rankbaam/photo\(url)"
    }
}

struct TopicWrite: Encodable {
    var topicSN: Int?
    var category: Category
    var title: String
    var description: String
    var isOnlyWriterCreateOption: Bool?
    var votableCountPerUser: Int?
}

struct Topic: Decodable {
    var topicSN: Int
    var category: Category
    var writer: User
    var title: String
    var description: String
    var isOnlyWriterCreateOption: Bool
    var votableCountPerUser: Int
    var photoMain: Int
    var photos: [Photo]
    var createDate: String
    var timeDistance: UInt
    var updateDate: String?
    var isMine: Bool
    var isLike: Bool
    var likeCount: Int
    var voteCount: Int
    var weekVoteCount: UInt?
    var votedOptions: [Int]?
    var rankOptions: [OptionSimple]?
    
    mutating func sortPhotos(){
        photos.sort{
            switch($0.order, $1.order) {
            case (photoMain, _):
                return true
            case let (order1, order2):
                return order1 < order2
            }
        }
    }
}

struct OptionWrite: Encodable {
    var topicSN: Int
    var optionSN: Int?
    var title: String
    var description: String?
}

struct OptionSimple: Decodable {
  var topicSN: Int
  var optionSN: Int
  var title: String
  var voteCount: UInt
}

struct Option: Decodable {
    var topicSN: Int
    var optionSN: Int
    var writer: User
    var title: String
    var description: String?
    var photos: [Photo]
    var createDate: String
    var timeDistance: UInt
    var updateDate: String?
    var isMine: Bool
    var voteCount: Int
    var commentPositiveCount: Int
    var commentNegativeCount: Int
}

enum SupportType: UInt8, Codable, CustomStringConvertible {
    case positive = 1
    case negative = 2
    var description: String {
      return "\(rawValue)"
    }
}

struct OptionComment: Decodable {
    var optionCommentSN: String
    var topicSN: UInt
    var optionSN: Int
    var writer: User
    var description: String
    var isMine: Bool
    var supportType: SupportType // 1 = positive 2 = negative
    var createDate: String
    var timeDistance: UInt
    var updateDate: String?
  
    var subCommentCount: UInt
    var subComments: [OptionSubComment]?
}

struct OptionSubComment: Equatable, Decodable {
  var optionCommentSN: String
  var pOptionCommentSN: String
  var writer: User
  var description: String
  var isMine: Bool
  var createDate: String
  var timeDistance: UInt
  var updateDate: String?
  
  static func ==(lhs: OptionSubComment, rhs: OptionSubComment) -> Bool {
    return lhs.optionCommentSN == rhs.optionCommentSN
  }
}

struct Vote: Decodable {
  var optionSN: Int
  var count: Int
  var isVoted: Bool
}

struct User: Codable{
    var userSN: Int
    var photoUrl: String?
    var nickname: String
}
