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
    var photos: [Photo]
    var createDate: String
    var updateDate: String?
    var isMine: Bool
    var isLike: Bool
    var likeCount: Int
    var voteCount: Int
    var votedOptions: [Int]?
    var rankOptions: [Option]?
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
    var supportPositiveCount: Int
    var supportNegativeCount: Int
}

enum SupportType: Int, Codable {
    case positive = 1
    case negative = 2
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
