//
//  TopicCreatePhotoPickerController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 2. 9..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit
import Photos
import SnapKit
import MobileCoreServices

class TopicCreatePhotoPickerViewController: UIViewController {
    
    var topicCreatePhotoPickerCollectionView: UICollectionView =  {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        var topicCreatePhotoPickerCollectionView =
            UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return topicCreatePhotoPickerCollectionView
    }()
    let phImageManager = PHImageManager()
    let fetchingQueue = DispatchQueue(label: "com.jaewook.RankBaamPhotoPicker")
    var photosCellPHAssetDatas: PHFetchResult<PHAsset>?
    var phImgCachingManager = PHCachingImageManager()
    var selectedPhotoDatas = [(Int, PHAsset?)]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            print(status)
        }
        let data = UserDefaults.standard.object(forKey: "data") as! PHAsset
        selectedPhotoDatas += [(1, data)]
        
        fetchPHAssetData()
        topicCreatePhotoPickerCollectionViewConfigure()
        /*phImgCachingManager.startCachingImages(for: <#T##[PHAsset]#>, targetSize: <#T##CGSize#>, contentMode: <#T##PHImageContentMode#>, options: <#T##PHImageRequestOptions?#>)*/
    }
    
    fileprivate func fetchPHAssetData(){
        
        let phOption = PHFetchOptions()
        phOption.fetchLimit = 1000
        let creSortDescripter = NSSortDescriptor(key: "creationDate",
                                                 ascending: true)
        let modiSortDescripter = NSSortDescriptor(key: "modificationDate",
                                                  ascending: true)
        phOption.sortDescriptors = [ creSortDescripter, modiSortDescripter ]
        let cachingData = PHAsset.fetchAssets(with: phOption)
        let phiOp = PHImageRequestOptions()
        cachingData.enumerateObjects { (phasset, _, _) in
            self.phImgCachingManager.stopCachingImages(for: [phasset], targetSize: CGSize.init(width: 125, height: 125), contentMode: .aspectFit, options: phiOp)
        }
        photosCellPHAssetDatas = PHAsset.fetchAssets(with: phOption)
        print("This is Photos datas : \(photosCellPHAssetDatas)")
    }
    
    fileprivate func topicCreatePhotoPickerCollectionViewConfigure() {
        self.view.addSubview(topicCreatePhotoPickerCollectionView)
        topicCreatePhotoPickerCollectionView.snp.makeConstraints {
            $0.bottom.top.left.right.equalToSuperview()
        }
        topicCreatePhotoPickerCollectionView.register(TopicCreatePhotosCell.self, forCellWithReuseIdentifier: "TopicCreatePhotosCell")
        topicCreatePhotoPickerCollectionView.dataSource = self
        topicCreatePhotoPickerCollectionView.delegate = self
        topicCreatePhotoPickerCollectionView.backgroundColor = UIColor.rankbaamOrange
        
    }
}

extension TopicCreatePhotoPickerViewController: UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topicCreatePhotoscell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCreatePhotosCell", for: indexPath) as! TopicCreatePhotosCell
        let targetSize = CGSize(width: 125, height: 125)
        let phiRequestOption = PHImageRequestOptions()
        
        fetchingQueue.async { [weak self] in
            
            guard let `self` = self else { return }
            guard let data = self.photosCellPHAssetDatas?.object(at: indexPath.item) else { return }
            
            self.phImgCachingManager.requestImage(for: data, targetSize: targetSize, contentMode: .aspectFit, options: phiRequestOption, resultHandler: { (image, _) in
                DispatchQueue.main.async {
                    topicCreatePhotoscell.topicCreatePhotosCellImageView.image = image
                }
            })
        }
        return topicCreatePhotoscell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let willDisplayCell = cell as! TopicCreatePhotosCell
        print("앞으로 나올 path 다 \(indexPath.item)")
        if selectedPhotoDatas.contains(where: { $0.0 == indexPath.item }) {
            willDisplayCell.isSelectedPhoto = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 6) / 4
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosCellPHAssetDatas?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedcell = collectionView.cellForItem(at: indexPath) as! TopicCreatePhotosCell
        
        print("\(indexPath.item)")
        
        if !selectedcell.isSelectedPhoto {
            selectedcell.isSelectedPhoto = true
            if let selectedImage = selectedcell.topicCreatePhotosCellImageView.image {
                guard let phassetData = self.photosCellPHAssetDatas?.object(at: indexPath.item) else { return }
                UserDefaults.standard.set(phassetData, forKey: "data")
                selectedPhotoDatas.append((indexPath.item, phassetData))
            }
        } else {
            selectedcell.isSelectedPhoto = false
            if let selectedDataIndex = selectedPhotoDatas.index(where: { (index, _) -> Bool in
                return index == indexPath.item
            }){
                selectedPhotoDatas.remove(at: selectedDataIndex)
            }
            
        }
    }
}

extension TopicCreatePhotoPickerViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            // print(idx.item)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            print(idx.item)
            
        }
    }
    
}
