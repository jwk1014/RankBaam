//
//  ImageBindData.swift
//  RankBaam
//
//  Created by 김정원 on 2018. 3. 8..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos
import SDWebImage

class ImageBindData {
  var image: UIImage? {
    didSet{
      if let imageView = imageView, let image = image {
        imageView.image = image
      }
    }
  }
  var imageAsset: PHAsset?
  weak var imageView: UIImageView? {
    didSet{
      if let imageView = imageView, let image = image,
        imageView.image != image {
        imageView.image = image
      }
    }
  }
  
  init(imageAsset: PHAsset, image: UIImage) {
    self.imageAsset = imageAsset
    self.image = image
  }
  
  init(imageAsset: PHAsset, targetSize: CGSize) {
    self.imageAsset = imageAsset
    let xDistance = CGFloat(imageAsset.pixelWidth) - targetSize.width
    let yDistance = CGFloat(imageAsset.pixelHeight) - targetSize.height
    var resultTargetSize: CGSize
    switch max(xDistance, yDistance) {
    case xDistance:
      resultTargetSize = .init(width: targetSize.width,
                               height: CGFloat(Double(targetSize.height) *
                                Double(targetSize.width) / Double(imageAsset.pixelWidth)))
    case yDistance:
      resultTargetSize = .init( width: CGFloat(Double(targetSize.width) *
        Double(targetSize.height) / Double(imageAsset.pixelHeight)),
                                height: targetSize.height)
    default:
      resultTargetSize = targetSize
    }
    
    PHImageManager.default().requestImage(
      for: imageAsset,
      targetSize: resultTargetSize,
      contentMode: PHImageContentMode.aspectFit,
      options: nil) { image, _ in
        self.image = image
    }
  }
  
  init(url: URL) {
    SDWebImageManager.shared().imageDownloader?.downloadImage(
    with: url, options: SDWebImageDownloaderOptions.lowPriority, progress: nil) {
      (image, data, error, finished) in
      if let error = error { debugPrint(error); return }
      guard let image = image else { assertionFailure("image nil"); return }
      
      self.image = image
    }
  }
}
