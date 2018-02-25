//
//  OptionDetailHeaderCell.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 19..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

protocol OptionDetailHeaderCellDelegate: class {
  func headerCell(section: Int)//, isOpen: Bool)
}

//MARK: - HeaderCell
class OptionDetailHeaderCell: UICollectionViewCell {
  weak var dataSource: OptionDetailDataCollectionViewDataSource?
  weak var delegate: OptionDetailHeaderCellDelegate?
  var section: Int? {
    willSet {
      if let section = newValue, let commentData = dataSource?.optionDetailHeaderData(section: section) {
        changeSupportImage(supportType: commentData.supportType)
        descriptionLabel?.text = commentData.description
        nicknameLabel?.text = commentData.writer.nickname
        subCommentTextLayer?.string = "답글 \(commentData.subCommentCount)"
        switch commentData.timeDistance {
        case 0..<1000:
          timeLabel?.text = "방금전"
        case 1000..<60*1000:
          let seconds = Int(commentData.timeDistance / 1000)
          timeLabel?.text = "\(seconds)초전"
        case 60*1000..<3600*1000:
          let minutes = Int(commentData.timeDistance / (60*1000))
          timeLabel?.text = "\(minutes)분전"
        case 3600*1000..<24*3600*1000:
          let hours = Int(commentData.timeDistance / (60*60*1000))
          timeLabel?.text = "\(hours)시간전"
        case (24*3600*1000)..<(7*24*3600*1000):
          let days = Int(commentData.timeDistance / (24*60*60*1000))
          timeLabel?.text = "\(days)일전"
        default:
          let dateStringFormatter = DateFormatter()
          dateStringFormatter.dateFormat = "MMM d, yyyy hh:mm:ss a"
          if let date = dateStringFormatter.date(from: commentData.createDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 d일 a hh:mm"
            dateFormatter.locale = Locale.current
            timeLabel?.text = dateFormatter.string(from: date)
          }
        }
      }
    }
  }
  //private(set) var isOpen = false
  private weak var supportTypeImageView: UIImageView?
  private weak var descriptionLabel: UILabel?
  private weak var nicknameLabel: UILabel?
  private weak var timeLabel : UILabel?
  //private weak var moreButton: UIButton?
  //private weak var subCommentsView: UIView?
  private weak var subCommentTextLayer: CATextLayer?
  
  func changeSupportImage(supportType: SupportType) {
    supportTypeImageView?.image = UIImage(named:
      (supportType == .positive) ? "good_icn" : "bad_icn")
  }
  
  func initView() {
    contentView.backgroundColor = UIColor.white
    
    let supportTypeImageView = UIImageView()
    self.supportTypeImageView = supportTypeImageView
    contentView.addSubview(supportTypeImageView)
    supportTypeImageView.snp.makeConstraints{
      $0.leading.equalTo(contentView).offset(width375(16.0))
      $0.centerY.equalTo(contentView)
      $0.width.equalTo(width375(28.0))
      $0.height.equalTo(supportTypeImageView.snp.width)
    }
    
    let descriptionLabel = UILabel()
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = UIColor(r: 77, g: 77, b: 77)
    descriptionLabel.font = UIFont(name: "NanumSquareR", size: 14.0)
    self.descriptionLabel = descriptionLabel
    contentView.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(contentView).offset(height667(11.0))
      $0.leading.equalTo(supportTypeImageView.snp.trailing).offset(width375(16.0))
      $0.width.equalTo(width375(250.0))
    }
    
    let starImageView = UIImageView()
    starImageView.image = UIImage(named: "starImg")
    contentView.addSubview(starImageView)
    starImageView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(height667(13.0))
      $0.leading.equalTo(descriptionLabel)
      $0.bottom.equalTo(contentView).offset(-(height667(15.0)))
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
    
    let moreButton = UIButton()
    moreButton.imageEdgeInsets = .init(top: 6, left: 10, bottom: 6, right: 10)
    moreButton.setImage(UIImage(named: "more_h_icn"), for: .normal)
    contentView.addSubview(moreButton)
    moreButton.snp.makeConstraints {
      $0.top.trailing.equalTo(contentView)
      $0.width.equalTo(width375(44.0))
      $0.height.equalTo(height667(30.0))
    }
    
    let subCommentsView = UIView()
    
    let subLayerFrame = CGRect( x: width375(10.0), y: height667(10.0),
                                width: width375(45.0), height: height667(18.0))
    
    let bgLayer = CALayer()
    bgLayer.backgroundColor = UIColor(r: 247, g: 247, b: 247).cgColor
    bgLayer.borderColor = UIColor(r: 213, g: 213, b: 213).cgColor
    bgLayer.borderWidth = 1.0
    bgLayer.frame = subLayerFrame
    subCommentsView.layer.addSublayer(bgLayer)
    
    let textLayer = CATextLayer()
    textLayer.frame = subLayerFrame
    let fontSize: CGFloat = 10.0
    textLayer.frame.origin.y += (subLayerFrame.height - fontSize)/2.0 - fontSize/10.0
    textLayer.alignmentMode = kCAAlignmentCenter
    
    textLayer.font = "NanumSquareR" as CFTypeRef
    textLayer.fontSize = fontSize
    textLayer.foregroundColor = UIColor(r: 81, g: 81, b: 81).cgColor
    textLayer.backgroundColor = UIColor.clear.cgColor
    self.subCommentTextLayer = textLayer
    subCommentsView.layer.addSublayer(textLayer)
    
    subCommentsView.addGestureRecognizer(
      UITapGestureRecognizer(target: self, action: #selector(handleTapSubCommentsView)))
    contentView.addSubview(subCommentsView)
    subCommentsView.snp.makeConstraints {
      $0.trailing.bottom.equalTo(contentView)
      $0.width.equalTo(height667(65.0))
      $0.height.equalTo(height667(38.0))
      $0.leading.equalTo(descriptionLabel.snp.trailing)
    }
  }
  
  @objc func handleTapSubCommentsView(_ sender: UITapGestureRecognizer) {
    guard let section = section else {return}
    delegate?.headerCell(section: section)
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}
