//
//  TopicEditOptionCell.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 2. 26..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos

protocol TopicEditOptionCellDelegate: class {
  func optionCellPresentPhotoSelectView(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate)
  func optionCellSelectedPhoto(row: Int, image: UIImage, phAsset: PHAsset)
  func optionCellValueUpdate(row: Int, title: String?)
  func optionCellDelete(row: Int)
  func optionCellIsBecameFirstResponder(responder: UIResponder, isFirstResponder: Bool)
}

class TopicEditOptionCell: UICollectionViewCell {
  weak var delegate: TopicEditOptionCellDelegate?
  
  var row: Int = -1
  private(set) weak var imageView: UIImageView?
  private(set) weak var textField: UITextField?
  
  static var imageViewSize: CGSize {
    return .init(width: width375(76.0), height: width375(62.0))
    //height에 세로인데도 width375기준으로 한것은 "디바이스 세로"가 아닌 "이미지뷰 가로에 대한 비율"로 가기 위해서
  }
  
  func initImage() {
    imageView?.image = UIImage(named: "image_icn")
  }
  
  private func initView(){
    layer.backgroundColor = UIColor.white.cgColor
    layer.borderColor = UIColor(r: 192, g: 192, b: 192).cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 3.0
    
    let imageView = UIImageView()
    self.imageView = imageView
    initImage()
    self.addSubview(imageView)
    let imageViewSize = TopicEditOptionCell.imageViewSize
    imageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(width375(5.0))
      $0.centerY.equalToSuperview()
      $0.width.equalTo(imageViewSize.width)
      $0.height.equalTo(imageViewSize.height)
    }
    
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageView)))
    
    let titleTextField = UITextField()
    titleTextField.font = UIFont(name: "NanumSquareR", size: 16.0)
    titleTextField.textColor = UIColor(r: 77, g: 77, b: 77)
    titleTextField.placeholder = "항목을 입력해주세요"
    titleTextField.clearButtonMode = .whileEditing
    titleTextField.autocapitalizationType = .none
    titleTextField.autocorrectionType = .no
    let inputAccessoryView = UIButton(frame: .init(x: 0, y: 0, width: 0, height: 30.0))
    inputAccessoryView.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: width375(8.0))
    inputAccessoryView.contentHorizontalAlignment = .right
    inputAccessoryView.backgroundColor = UIColor(r: 255, g: 195, b: 75)
    if let font = UIFont(name: "NanumSquareR", size: 14.0) {
      inputAccessoryView.setAttributedTitle(NSAttributedString(
        string: "키보드 닫기",
        attributes: [
          .font: font,
          .foregroundColor: UIColor(r: 77, g: 77, b: 77)
        ]), for: .normal)
    }
    inputAccessoryView.addTarget(self, action: #selector(handleTapKeyboardCloseButton), for: .touchUpInside)
    titleTextField.inputAccessoryView = inputAccessoryView
    titleTextField.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
    titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    titleTextField.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
    self.textField = titleTextField
    self.addSubview(titleTextField)
    titleTextField.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalTo(imageView.snp.trailing).offset(width375(14.0))
      $0.trailing.equalToSuperview().offset(-width375(50.0))
    }
    
    let removeButton = UIButton()
    removeButton.setImage(UIImage(named: "group3")?.copy(with: .init(top: 9.0, left: 9.0, bottom: 9.0, right: 9.0), isTemplate: false), for: .normal)
    removeButton.addTarget(self, action: #selector(handleTapRemoveButton), for: .touchUpInside)
    self.addSubview(removeButton)
    removeButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.width.equalTo(width375(18.0 + 18.0))
      $0.height.equalTo(removeButton.snp.width)
    }
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder); initView() }
  override init(frame: CGRect) { super.init(frame: frame); initView() }
}

extension TopicEditOptionCell {
  @objc func handleTapRemoveButton(_ button: UIButton){
    delegate?.optionCellDelete(row: row)
  }
}

extension TopicEditOptionCell {
  @objc func handleTapKeyboardCloseButton(_ button: UIButton) {
    if textField?.isFirstResponder ?? false {
      textField?.resignFirstResponder()
    }
  }
  
  @objc func textFieldDidBegin(_ textField: UITextField) {
    delegate?.optionCellIsBecameFirstResponder(responder: textField, isFirstResponder: true)
  }
  
  @objc func textFieldDidEnd(_ textField: UITextField) {
    delegate?.optionCellIsBecameFirstResponder(responder: textField, isFirstResponder: false)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    delegate?.optionCellValueUpdate(row: row, title: textField.text)
  }
}

extension TopicEditOptionCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @objc func handleImageView(_ sender: UITapGestureRecognizer) {
    let picker = UIImagePickerController()
    picker.delegate = self
    delegate?.optionCellPresentPhotoSelectView(delegate: self)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      if let url = info[UIImagePickerControllerReferenceURL] as? URL,
        let phAsset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil).firstObject{
        self.delegate?.optionCellSelectedPhoto(row: row, image: image, phAsset: phAsset)
        imageView?.image = image
      }
    }
    picker.dismiss(animated: true, completion: nil)
  }
}
