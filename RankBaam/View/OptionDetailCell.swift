//
//  OptionDetailCell.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 24..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

class OptionDetailCell: UICollectionViewCell {
  weak var dataSource: OptionDetailDataCollectionViewDataSource?
  var dataIndex: (section: Int, row: Int)? {
    willSet {
      if  let (section, row) = newValue,
        let subComment = dataSource?.optionDetailCellData(section: section, row: row) {
        descriptionLabel?.text = subComment.description
        nicknameLabel?.text = subComment.writer.nickname
        switch subComment.timeDistance {
        case ..<1000:
          timeLabel?.text = "방금전"
        case 1000..<60*1000:
          let seconds = Int(subComment.timeDistance / 1000)
          timeLabel?.text = "\(seconds)초전"
        case 60*1000..<3600*1000:
          let minutes = Int(subComment.timeDistance / (60*1000))
          timeLabel?.text = "\(minutes)분전"
        case 3600*1000..<24*3600*1000:
          let hours = Int(subComment.timeDistance / (60*60*1000))
          timeLabel?.text = "\(hours)시간전"
        case (24*3600*1000)..<(7*24*3600*1000):
          let days = Int(subComment.timeDistance / (24*60*60*1000))
          timeLabel?.text = "\(days)일전"
        default:
          let dateStringFormatter = DateFormatter()
          dateStringFormatter.dateFormat = "MMM d, yyyy hh:mm:ss a"
          if let date = dateStringFormatter.date(from: subComment.createDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm월 dd일 HH:mm"
            timeLabel?.text = dateFormatter.string(from: date)
          }
        }
      }
    }
  }
  private weak var descriptionLabel: UILabel?
  private weak var nicknameLabel: UILabel?
  private weak var timeLabel: UILabel?
  
  func initView() {
    contentView.backgroundColor = UIColor(r: 247, g: 247, b: 247)
    
    let lineLayer = CAShapeLayer()
    let lineLength = width375(12.0)
    let bezierPath = UIBezierPath()
    bezierPath.move(to: .zero)
    bezierPath.addLine(to: .init(x: 0, y: lineLength))
    bezierPath.addLine(to: .init(x: lineLength, y: lineLength))
    lineLayer.path = bezierPath.cgPath
    lineLayer.fillColor = UIColor.clear.cgColor
    lineLayer.strokeColor = UIColor(r: 151, g: 151, b: 151).cgColor
    lineLayer.lineWidth = 1.0
    lineLayer.backgroundColor = UIColor.clear.cgColor
    lineLayer.frame = CGRect(x: width375(30.0), y: height667(7.0),
                             width: lineLength, height: lineLength)
    contentView.layer.addSublayer(lineLayer)
    
    let descriptionLabel = UILabel()
    descriptionLabel.font = UIFont(name: "NanumSquareR", size: 14.0)
    descriptionLabel.textColor = UIColor(r: 77, g: 77, b: 77)
    self.descriptionLabel = descriptionLabel
    contentView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(height667(14.0))
      $0.leading.equalTo(contentView).offset(width375(52.0))
      $0.trailing.equalTo(contentView).offset(width375(20.0))
    }
    
    let starImageView = UIImageView()
    starImageView.image = UIImage(named: "starImg")
    contentView.addSubview(starImageView)
    starImageView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(height667(14.0))
      $0.leading.equalTo(descriptionLabel)
      $0.bottom.equalTo(contentView).offset(-(height667(14.0)))
    }
    
    let nicknameLabel = UILabel()
    nicknameLabel.textColor = UIColor(r: 191, g: 191, b: 191)
    nicknameLabel.font = UIFont(name: "NanumSquareB", size: 12.0)
    self.nicknameLabel = nicknameLabel
    contentView.addSubview(nicknameLabel)
    nicknameLabel.snp.makeConstraints {
      $0.centerY.equalTo(starImageView)
      $0.leading.equalTo(starImageView.snp.trailing).offset(width375(4.0))
    }
    
    let vSeperatorView = UIView()
    vSeperatorView.backgroundColor = UIColor(r: 231, g: 231, b: 231)
    contentView.addSubview(vSeperatorView)
    vSeperatorView.snp.makeConstraints {
      $0.top.bottom.equalTo(starImageView)
      $0.leading.equalTo(nicknameLabel.snp.trailing).offset(width375(16.0))
      $0.width.equalTo(width375(2.0))
    }
    
    let timeLabel = UILabel()
    timeLabel.textColor = UIColor(r: 191, g: 191, b: 191)
    timeLabel.font = UIFont(name: "NanumSquareB", size: 12.0)
    self.timeLabel = timeLabel
    contentView.addSubview(timeLabel)
    timeLabel.snp.makeConstraints {
      $0.centerY.equalTo(starImageView)
      $0.leading.equalTo(vSeperatorView.snp.trailing).offset(width375(16.0))
    }
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}
