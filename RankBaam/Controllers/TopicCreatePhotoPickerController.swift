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

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class TopicCreatePhotoPickerViewController: UIViewController {
    
    var topicCreatePhotoPickerCollectionView: UICollectionView =  {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        var topicCreatePhotoPickerCollectionView =
            UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return topicCreatePhotoPickerCollectionView
    }()
    
    var topicCreatePhotosPickerPHAssetBunchView: TopicCreatePHAssetBunchView = {
        let topicCreatePhotosPickerBunchView = TopicCreatePHAssetBunchView()
        return topicCreatePhotosPickerBunchView
    }()
    
    let fetchingQueue = DispatchQueue(label: "com.jaewook.RankBaamPhotoPicker")
    var photosCellPHAssetDatas: PHFetchResult<PHAsset>?
    var photosCellPHAssetCollections = [PHAssetCollection]()
    var phImageCachingManager = PHCachingImageManager()
    var selectedPhotoDatas = [(Int, PHAsset?)]()
    var selectedPHAssetDataFromVC = [PHAsset]()
    
    fileprivate let targetSize = CGSize(width: width375(125), height: width375(125))
    fileprivate var previousPreheatRect = CGRect.zero
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*PHPhotoLibrary.requestAuthorization { (status) in
            print(status)
        }
         
        phImgCachingManager.startCachingImages(for: <#T##[PHAsset]#>, targetSize: <#T##CGSize#>, contentMode: <#T##PHImageContentMode#>, options: <#T##PHImageRequestOptions?#>)*/
        
         let fetchCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        print("This is smart album : \(fetchCollection.count)")
        print("This is Localized Title : \(fetchCollection.firstObject?.localizedTitle)")
        
        let phlist = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        phlist.enumerateObjects { (phcollection, index, stop) in
            guard let collection = phcollection as? PHAssetCollection else { return }
            self.photosCellPHAssetCollections.append(collection)
        }
        print("This is collection Count : \(photosCellPHAssetCollections.count, phlist.count)")
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "취소", style: .plain, target: self, action: #selector(topicCreatePhotoPickerCancelButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "사진선택", style: .plain, target: self, action: #selector(topicCreatePhotoPickerSelectButtonTapped(_:)))
        let photoPickerTitleView = TopicCreatePhotoPickerTitleView(frame: CGRect(x: 0, y: 0, width: width375(250), height: (self.navigationController?.navigationBar.frame.height)!))
        //testView.backgroundColor = UIColor.black
        self.navigationItem.titleView = photoPickerTitleView
        
        viewInitConfigure()
        topicCreatePhotoPickerCollectionViewConfigure()
        fetchPHAssetData()
        topicCreatePhotosPickerPHAssetBunchViewConfigure()
    }
    
    fileprivate func viewInitConfigure() {
        self.view.addSubview(topicCreatePhotoPickerCollectionView)
        self.view.addSubview(topicCreatePhotosPickerPHAssetBunchView)
        topicCreatePhotoPickerCollectionView.snp.makeConstraints {
            $0.bottom.top.left.right.equalToSuperview()
        }
        topicCreatePhotosPickerPHAssetBunchView.snp.makeConstraints {
            let upperOffset = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height ?? 44)
            $0.top.equalTo(topicCreatePhotoPickerCollectionView.snp.top)
                .offset(upperOffset)
            print("This is NavigationBar Height : \(self.navigationController?.navigationBar.frame.height)")
            $0.bottom.left.right.equalToSuperview()
        }
    }
    
    fileprivate func fetchPHAssetData(){
        DispatchQueue.global().async {
            let phOption = PHFetchOptions()
            phOption.fetchLimit = 1000
            let creSortDescripter = NSSortDescriptor(key: "creationDate",
                                                     ascending: true)
            let modiSortDescripter = NSSortDescriptor(key: "modificationDate",
                                                      ascending: true)
            phOption.sortDescriptors = [ creSortDescripter, modiSortDescripter ]
            self.photosCellPHAssetDatas = PHAsset.fetchAssets(with: phOption)
            print("This is Photos datas : \(self.photosCellPHAssetDatas)")
            DispatchQueue.main.async {
                self.topicCreatePhotoPickerCollectionView.reloadData()
            }
        }
    }
    
    fileprivate func topicCreatePhotoPickerCollectionViewConfigure() {
        
        topicCreatePhotoPickerCollectionView.register(TopicCreatePhotosCell.self, forCellWithReuseIdentifier: "TopicCreatePhotosCell")
        topicCreatePhotoPickerCollectionView.dataSource = self
        topicCreatePhotoPickerCollectionView.delegate = self
        topicCreatePhotoPickerCollectionView.backgroundColor = UIColor.white
        
    }
    
    fileprivate func topicCreatePhotosPickerPHAssetBunchViewConfigure() {
        topicCreatePhotosPickerPHAssetBunchView.topicCreatePHAssetBunchViewTableView.delegate = self
        topicCreatePhotosPickerPHAssetBunchView.topicCreatePHAssetBunchViewTableView.dataSource = self
        
    }
    
    @objc fileprivate func topicCreatePhotoPickerCancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func topicCreatePhotoPickerSelectButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: FIXME
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
    fileprivate func updateCachedAssets() {
        guard isViewLoaded && view.window != nil else { return }
        let visibleRect = CGRect(origin: topicCreatePhotoPickerCollectionView.contentOffset, size: topicCreatePhotoPickerCollectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in topicCreatePhotoPickerCollectionView.indexPathsForElements(in: rect) }
        .map { indexPath in photosCellPHAssetDatas?.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in topicCreatePhotoPickerCollectionView.indexPathsForElements(in: rect) }
        .map { indexPath in photosCellPHAssetDatas?.object(at: indexPath.item) }
        phImageCachingManager.startCachingImages(for: addedAssets as! [PHAsset],
                                        targetSize: targetSize, contentMode: .aspectFill, options: nil)
        phImageCachingManager.stopCachingImages(for: removedAssets as! [PHAsset],
                                       targetSize: targetSize, contentMode: .aspectFill, options: nil)
        previousPreheatRect = preheatRect
    }
}

extension TopicCreatePhotoPickerViewController: UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let topicCreatePhotoscell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCreatePhotosCell", for: indexPath) as! TopicCreatePhotosCell
        let phiRequestOption = PHImageRequestOptions()
        
        fetchingQueue.async { [weak self] in
            
            guard let `self` = self else { return }
            guard let data = self.photosCellPHAssetDatas?.object(at: indexPath.item) else { return }
            
            self.phImageCachingManager.requestImage(for: data, targetSize: self.targetSize, contentMode: .aspectFit, options: phiRequestOption, resultHandler: { (image, _) in
                DispatchQueue.main.async {
                    topicCreatePhotoscell.topicCreatePhotosCellImageView.image = image
                }
            })
        }
        return topicCreatePhotoscell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let willDisplayCell = cell as! TopicCreatePhotosCell
        print("앞으로 나올 path : \(indexPath.item)")
        if let phassetData = photosCellPHAssetDatas?.object(at: indexPath.item),
            !selectedPHAssetDataFromVC.isEmpty,
            let index = selectedPHAssetDataFromVC.index(where: { asset -> Bool in
                return phassetData == asset
            }) {
            selectedPHAssetDataFromVC.remove(at: index)
            selectedPhotoDatas.append((indexPath.item, phassetData))
            willDisplayCell.isSelectedPhoto = true
        }
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
            if let _ = selectedcell.topicCreatePhotosCellImageView.image {
                guard let phassetData = self.photosCellPHAssetDatas?.object(at: indexPath.item) else { return }
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

extension TopicCreatePhotoPickerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         updateCachedAssets()
    }
}


class TopicCreatePhotoPickerTitleView: UIView {
    
    var topicCreatePhotoPickerStackView: UIStackView = {
        let topicCreatePhotoPickerStackView = UIStackView()
        topicCreatePhotoPickerStackView.axis = .vertical
        return topicCreatePhotoPickerStackView
    }()
    
    var topicCreatePhotoPickerInnerStackView: UIStackView = {
        let topicCreatePhotoPickerInnerStackView = UIStackView()
        topicCreatePhotoPickerInnerStackView.axis = .horizontal
        return topicCreatePhotoPickerInnerStackView
    }()
    
    var topicCreatePhotoPickerTitleLabel: UILabel = {
        let topicCreatePhotoPickerTitleLabel = UILabel()
        return topicCreatePhotoPickerTitleLabel
    }()
    
    var topicCreatePhotoPickerCoachLabel: UILabel = {
        let topicCreatePhotoPickerCoachLabel = UILabel()
        return topicCreatePhotoPickerCoachLabel
    }()
    
    var topicCreatePhotoPickerBottomArrowImageView: UIImageView = {
        let topicCreatePhotoPickerBottomArrowImageView = UIImageView()
        return topicCreatePhotoPickerBottomArrowImageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitConfigure()
    }
    convenience init(frame: CGRect, title: String, coachComment: String) {
        self.init(frame: frame)
        viewInitConfigure(title, coachComment)
        
    }
    
    fileprivate func viewInitConfigure(_ title: String? = nil, _ coachComment: String? = nil) {
        self.addSubview(topicCreatePhotoPickerStackView)
        topicCreatePhotoPickerStackView.addArrangedSubview(topicCreatePhotoPickerTitleLabel)
        topicCreatePhotoPickerStackView.addArrangedSubview(topicCreatePhotoPickerInnerStackView)
        topicCreatePhotoPickerInnerStackView.addArrangedSubview(topicCreatePhotoPickerCoachLabel)
        topicCreatePhotoPickerInnerStackView.addArrangedSubview(topicCreatePhotoPickerBottomArrowImageView)
        
        topicCreatePhotoPickerStackView.distribution = .equalSpacing
        topicCreatePhotoPickerStackView.spacing = 2
        topicCreatePhotoPickerTitleLabel.text = title ?? "카메라 롤"
        topicCreatePhotoPickerTitleLabel.textAlignment = .center
        topicCreatePhotoPickerTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        topicCreatePhotoPickerCoachLabel.text = coachComment ?? "변경하려면 여기를 누르세요"
        topicCreatePhotoPickerCoachLabel.textAlignment = .center
        topicCreatePhotoPickerCoachLabel.font = UIFont.systemFont(ofSize: 12)
        topicCreatePhotoPickerBottomArrowImageView.image = UIImage(named: "ic_arrow_drop_down")
        topicCreatePhotoPickerStackView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension TopicCreatePhotoPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let phassetBunchTableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicCreatePHAssetBunchViewCell.self) , for: indexPath) as! TopicCreatePHAssetBunchViewCell
        return phassetBunchTableCell
    }
}

extension TopicCreatePhotoPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}




