//
//  TopicReadViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit

class TopicDetailViewController: UIViewController {
    var topicSN: Int!
    var topic: Topic?
    
    var optionDatas: [Option] = []
    
    @IBOutlet weak var optionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionTableView.dataSource = self
        optionTableView.delegate = self
        
        optionTableView.register(UINib.init(nibName: "TopicOptionCell", bundle: nil), forCellReuseIdentifier: NamesWithTableView.TOPICDETAILCELL)
        optionTableView.register(UINib.init(nibName: "TopicDetailHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: NamesWithTableView.TOPICDETAILHEADER)
        
        
        
        AlamofireManager.request(
            .OptionList(topicSN: self.topicSN, pagingParam: PagingParam(page: 1)))
            .responseRankBaam { (error, errorClosure, result: SResultOptionList?, date) in
            
                print("에러 : \(String(describing: error?.localizedDescription)), 결과 : \(String(describing: result))")
        }
        
    }
    
    @IBAction func deleteTopicButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController.init(title: nil, message: "삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "확인", style: .default) { _ in
            AlamofireManager.request(
                .TopicDelete(topicSN: self.topicSN))
                .responseRankBaam { (error, errorClosure, result: SResult?, date) in
                if let result = result {
                    if result.succ {
                        UIAlertController.alert(target: self, msg: "삭제되었습니다.") { _ in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        })
        present(alert, animated: true, completion: nil)
    }
}

extension TopicDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topicDetailCell = tableView.dequeueReusableCell(withIdentifier: NamesWithTableView.TOPICDETAILCELL, for: indexPath) as! TopicOptionCell
        return topicDetailCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let topicDetailHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: NamesWithTableView.TOPICDETAILHEADER) as! TopicDetailHeader
        
        AlamofireManager.request(
            .TopicRead(topicSN: self.topicSN))
            .responseRankBaam { (error, errorClosure, result: SResultTopicDetail?, date) in
                
                print("에러 : \(String(describing: error?.localizedDescription)), 결과 : \(String(describing: result))")
                if let result = result {
                    if result.succ {
                        guard let topic = result.topic else {return}
                        print("### 토픽 디테일 부분 ### : \(String(describing: topic.topicSN))")
                        DispatchQueue.main.async {
                            topicDetailHeader.titleLabel.text = topic.title
                            topicDetailHeader.descriptionLabel.text = topic.description ?? ""
                            topicDetailHeader.likeCountButton.titleLabel?.text = "\(topic.likeCount ?? 0)"
                        }
                    }
                }
                
        }
        topicDetailHeader.delegate = self
        
        return topicDetailHeader
    }
}

extension TopicDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

protocol TopicDetailHeaderDelegate{
    func likeButtonTapped()
}

extension TopicDetailViewController: TopicDetailHeaderDelegate {
    func likeButtonTapped() {
        AlamofireManager.request(
            .TopicLike(topicSN: topicSN, isLike: true))
            .responseRankBaam { (error, errorClosure, result: SResult?, date) in
                
                print("에러 : \(String(describing: error?.localizedDescription)), 결과 : \(String(describing: result))")
                
        }
    }
}
