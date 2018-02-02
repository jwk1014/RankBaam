//
//  Models.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 21..
//  Copyright © 2017년 김정원. All rights reserved.
//

import Foundation

struct Category: Codable {
    var categorySN: Int
    var name: String
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
    var updateDate: String?
    var isMine: Bool
    var isLike: Bool
    var likeCount: Int
    var voteCount: Int
    var votedOptions: [Int]?
    var rankOptions: [Option]?
    
    mutating func sortPhotos(){
        photos.sort{
            switch($0.order, $1.order) {
            case (photoMain, _):
                return true
                //case (_, photoMain):
            //  return false
            case let (order1, order2):
                return order1 < order2
            default:
                return false
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

struct Option: Decodable {
    var topicSN: Int
    var optionSN: Int
    var writer: User
    var title: String
    var description: String?
    var photos: [Photo]
    var createDate: String
    var updateDate: String?
    var isMine: Bool
    var voteCount: Int
    var commentPositiveCount: Int
    var commentNegativeCount: Int
    
}

enum SupportType: Int, Codable, CustomStringConvertible {
    case positive = 1
    case negative = 2
    var description: String {
      return "\(rawValue)"
    }
}

struct OptionComment: Decodable {
    var optionCommentSN: String
    var topicSN: Int
    var optionSN: Int
    var writer: User
    var description: String
    var isMine: Bool
    var supportType: SupportType // 1 = positive 2 = negative
    var createDate: String
    var updateDate: String?
}

struct OptionSubComment: Decodable {
  var optionCommentSN: String
  var pOptionCommentSN: String
  var writer: User
  var description: String
  var isMine: Bool
  var createDate: String
  var updateDate: String?
}

struct User: Codable{
    var userSN: Int
    var photoUrl: String?
    var nickname: String
}
