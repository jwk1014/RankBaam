//
//  DataManager.swift
//  RankBaamProtoType
//
//  Created by 황재욱 on 2018. 1. 1..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import Foundation


class DataManager {
    
    static var shared: DataManager = DataManager()
    
    var topicData = [Topic]()
    
    private init(){
        
        loadTopicData(page: 1)
    }
    
    func loadTopicData(page: Int) {
        AlamofireManager.request(
            .TopicList(pagingParam: PagingParam(page: page, count: nil))
            ).responseRankBaam { (error, errorClosure, result: SResultTopicList?, date) in
                print("에러 : \(String(describing: error?.localizedDescription)), 결과 : \(String(describing: result))")
                if let result = result {
                    if result.succ {
                        guard let topics = result.topics else {return}
                        self.topicData = topics
                    }
                }
        }
        
    }
    
}
