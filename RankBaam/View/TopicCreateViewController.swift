//
//  TopicCreateViewController.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 29..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import Alamofire

class TopicCreateViewController: UIViewController {
    
    var delegate: TopicCreationCompletionDelegate?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isOptionCanReviseSwitch: UISwitch!
    @IBOutlet weak var numberOfvoterRightSegmentedControl: UISegmentedControl!
    @IBOutlet weak var topicDetailTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc func createButtonTapped(_ sender: UIButton){
        guard titleTextField.text != nil, !titleTextField.text!.isEmpty else { return }
        
        // TODO: FIXME
        
        // TODO: Optional 처리
        guard let detailDescription = topicDetailTextView.text else { return }
        
        TopicService.topicCreate(topic: Topic(
            title: titleTextField.text!,
            description: detailDescription,
            isOnlyWriterCreateOption: isOptionCanReviseSwitch.isOn,
            votableCountPerUser: numberOfvoterRightSegmentedControl.selectedSegmentIndex + 1)) {
            
            switch($0.result) {
                
            case .success(let sResult):
                if sResult.succ {
                    self.delegate?.TopicCreationCompleted()
                    self.dismiss(animated: true, completion: nil)
                } else if let msg = sResult.msg {
                    switch msg {
                    default:
                        break
                    }
                }
                
            case .failure(let error):
                if let error = error as? SolutionProcessableProtocol {
                    error.handle(self)
                } else {
                    
                }
                
            }
        }
        
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
