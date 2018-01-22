//
//  Models.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 21..
//  Copyright © 2017년 김정원. All rights reserved.
//

import Foundation


struct Topic: Codable{
    var topicSN: Int?
    var writerSN: Int?
    var isMine: Bool?
    var user: User?
    var title: String
    var photos: [Photo]?
    var description: String?
    var createDate: String
    var updateDate: String?
    var likeCount: Int
    var isOnlyWriterCreateOption: Bool
    var votableCountPerUser: Int
    
    init(topicSN: Int = 0, writer: User? = nil, title: String, photos: [Photo] = [], description: String, createDate: String = "", updateDate: String = "", likeCount: Int = 0, isOnlyWriterCreateOption: Bool, votableCountPerUser: Int) {
        self.topicSN = topicSN
        self.user = writer
        self.title = title
        self.photos = photos
        self.description = description
        self.createDate = createDate
        self.updateDate = updateDate
        self.likeCount = likeCount
        self.isOnlyWriterCreateOption = isOnlyWriterCreateOption
        self.votableCountPerUser = votableCountPerUser
    }
}

struct Photo: Codable {
    var order: Int
    var url: String
    
}


struct Option: Codable{
    var topicSN: Int
    var optionSN: Int?
    var writerSN: Int?
    var user: User?
    var title: String
    var photos: [String]
    var description: String?
    var createDate: String?
    var updateDate: String?
    var voteCount: Int?
    var supportPositiveCount: Int?
    var supportNegativeCount: Int?
    
    init(topicSN: Int, optionSN: Int? = nil, user: User? = nil, title: String, photos: [String] = [], description: String? = nil, createDate: String? = nil, updateDate: String? = nil, voteCount: Int? = nil, supportPositiveCount: Int? = nil, supportNegativeCount: Int? = nil){
        self.topicSN = topicSN
        self.optionSN = optionSN
        self.user = user
        self.title = title
        self.photos = photos
        self.description = description
        self.createDate = createDate
        self.updateDate = updateDate
        self.voteCount = voteCount
        self.supportPositiveCount = supportPositiveCount
        self.supportNegativeCount = supportNegativeCount
    }
}

enum SupportType: Int, Codable {
    case positive = 1
    case negative = 2
}

struct OptionCommentSupport: Codable {
    var optionCommentSupportSN: String
    var topicSN: Int
    var optionSN: Int
    var writer: User
    var supportType: SupportType // 1 = positive 2 = negative
    var comment: String
    var createDate: Date
    var updateDate: Date
    // likeCount
}

struct User: Codable{
    var userSN: Int
    var photoUrl: String?
    var nickname: String
}
