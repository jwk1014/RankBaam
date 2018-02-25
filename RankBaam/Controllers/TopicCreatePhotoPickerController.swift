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
    var phImageManager = PHImageManager()
    var selectedPhotoDatas = [(Int, PHAsset?)]()
    var selectedPHAssetDataFromVC = [PHAsset]()
    var topicCreatePhotoPickerTitleView: TopicCreatePhotoPickerTitleView?
    var isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    fileprivate let targetSize = CGSize(width: width375(125), height: width375(125))
    fileprivate var previousPreheatRect = CGRect.zero
    lazy var topicCreatePhotosPickerPHAssetBunchViewTableViewHeightClosure: (Double)->CGFloat = { ratio in
        let superView = self.topicCreatePhotosPickerPHAssetBunchView
        let tableView = self.topicCreatePhotosPickerPHAssetBunchView.topicCreatePHAssetBunchViewTableView
        superView.superview?.layoutIfNeeded()
        superView.layoutIfNeeded()
        tableView.layoutIfNeeded()
        let height = CGFloat(self.tableView(tableView, numberOfRowsInSection: 0)) *
            self.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        return CGFloat( Double(min( height, superView.bounds.height - tableView.frame.origin.y )) * ratio )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInitConfigure()
        fetchPHAssetCollections()
        topicCreateNavigationBarConfigure()
        topicCreatePhotoPickerCollectionViewConfigure()
        fetchPHAssetData()
        topicCreatePhotosPickerPHAssetBunchViewConfigure()
        
        topicCreatePhotosPickerPHAssetBunchView
            .topicCreatePHAssetBunchViewTableViewHeightConstraint?.constant = 0
        topicCreatePhotosPickerPHAssetBunchView.isHidden = true
    }
    
    fileprivate func viewInitConfigure() {
        
        
        self.view.addSubview(topicCreatePhotoPickerCollectionView)
        self.view.addSubview(topicCreatePhotosPickerPHAssetBunchView)
        topicCreatePhotoPickerCollectionView.snp.makeConstraints {
            guard let navigationBar = navigationController?.navigationBar else { return }
            $0.top.equalTo(navigationBar.frame.origin.y + navigationBar.bounds.height)
            $0.bottom.left.right.equalToSuperview()
        }
        topicCreatePhotosPickerPHAssetBunchView.snp.makeConstraints {
            $0.top.bottom.left.right.equalTo(topicCreatePhotoPickerCollectionView)
        }
    }
    
    fileprivate func topicCreateNavigationBarConfigure() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "취소", style: .plain, target: self, action: #selector(topicCreatePhotoPickerCancelButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "사진선택", style: .plain, target: self, action: #selector(topicCreatePhotoPickerSelectButtonTapped(_:)))
        topicCreatePhotoPickerTitleView = TopicCreatePhotoPickerTitleView(frame: CGRect(x: 0, y: 0, width: width375(250), height: (self.navigationController?.navigationBar.frame.height)!))
        self.navigationItem.titleView = topicCreatePhotoPickerTitleView
        topicCreatePhotoPickerTitleView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoPickerTitleViewTapped))
        topicCreatePhotoPickerTitleView?.addGestureRecognizer(tapGesture)
    }
    
    @objc func photoPickerTitleViewTapped() {
        
        self.topicCreatePhotosPickerPHAssetBunchView
            .topicCreatePHAssetBunchViewTableViewHeightConstraint?.constant =
            !self.topicCreatePhotosPickerPHAssetBunchView.isHidden ? 0 :
            self.topicCreatePhotosPickerPHAssetBunchViewTableViewHeightClosure(1.0)
        
        self.topicCreatePhotosPickerPHAssetBunchView.isHidden = !self.topicCreatePhotosPickerPHAssetBunchView.isHidden
        
        UIView.animate(withDuration: 0.3) {
            
            self.topicCreatePhotosPickerPHAssetBunchView
                .topicCreatePHAssetBunchViewTableViewHeightConstraint?.constant = self.topicCreatePhotosPickerPHAssetBunchView.isHidden ? 0 :
                self.topicCreatePhotosPickerPHAssetBunchViewTableViewHeightClosure(1.0)
            
            self.topicCreatePhotosPickerPHAssetBunchView.layoutIfNeeded()
        }
    }
    
    fileprivate func fetchPHAssetData(with assetCollection: PHAssetCollection? = nil){
        DispatchQueue.global().async {
            let phOption = PHFetchOptions()
            phOption.fetchLimit = Int.max
            let creSortDescripter = NSSortDescriptor(key: "creationDate",
                                                     ascending: false)
            let modiSortDescripter = NSSortDescriptor(key: "modificationDate",
                                                      ascending: false)
            phOption.sortDescriptors = [ creSortDescripter, modiSortDescripter ]
            if let collection = assetCollection {
                self.photosCellPHAssetDatas = PHAsset.fetchAssets(in: collection, options: phOption)
                DispatchQueue.main.async {
                    self.topicCreatePhotoPickerCollectionView.reloadData()
                }
            } else {
                self.photosCellPHAssetDatas = PHAsset.fetchAssets(with: phOption)
                DispatchQueue.main.async {
                    self.topicCreatePhotoPickerCollectionView.reloadData()
                }
            }
            
        }
    }
    
    fileprivate func fetchPHAssetCollections() {
        let fetchCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        guard let collectionTest = fetchCollection.firstObject else { return }
        photosCellPHAssetCollections.append(collectionTest)
        
        
        let phlist = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        phlist.enumerateObjects { (phcollection, index, stop) in
            guard let collection = phcollection as? PHAssetCollection else { return }
            self.photosCellPHAssetCollections.append(collection)
        }
        topicCreatePhotosPickerPHAssetBunchView.topicCreatePHAssetBunchViewTableView.reloadData()
    }
    
    fileprivate func topicCreatePhotoPickerCollectionViewConfigure() {
        
        topicCreatePhotoPickerCollectionView.register(TopicCreatePhotosCell.self, forCellWithReuseIdentifier: "TopicCreatePhotosCell")
        topicCreatePhotoPickerCollectionView.register(TopicCreateCameraCell.self, forCellWithReuseIdentifier: String(describing: TopicCreateCameraCell.self))
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
        var totalSelectedPhassetDatas = [PHAsset]()
        if !selectedPHAssetDataFromVC.isEmpty {
            totalSelectedPhassetDatas = selectedPHAssetDataFromVC
        }
        totalSelectedPhassetDatas += selectedPhotoDatas.reduce([PHAsset?]()) { total , item in total + [item.1] }.flatMap{ $0! }
        
        print("This is count of result : \(totalSelectedPhassetDatas.count)")
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
        .map { indexPath in
            photosCellPHAssetDatas?.object(at: indexPath.item == 0 ? indexPath.item : indexPath.item - 1) }
        let removedAssets = removedRects
            .flatMap { rect in topicCreatePhotoPickerCollectionView.indexPathsForElements(in: rect) }
        .map { indexPath in
            photosCellPHAssetDatas?.object(at: indexPath.item == 0 ? indexPath.item : indexPath.item - 1) }
        phImageCachingManager.startCachingImages(for: addedAssets as! [PHAsset],
                                        targetSize: targetSize, contentMode: .aspectFill, options: nil)
        phImageCachingManager.stopCachingImages(for: removedAssets as! [PHAsset],
                                       targetSize: targetSize, contentMode: .aspectFill, options: nil)
        previousPreheatRect = preheatRect
    }
    
    func phassetCollectionSelected(selectedIndex: Int) {
        
    }
}

extension TopicCreatePhotoPickerViewController: UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let topicCreateCameraCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TopicCreateCameraCell.self), for: indexPath)
            return topicCreateCameraCell
        } else {
            let topicCreatePhotosCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCreatePhotosCell", for: indexPath) as! TopicCreatePhotosCell
            let phiRequestOption = PHImageRequestOptions()
            
            fetchingQueue.async {/* [weak self] in*/
                
               // guard let `self` = self else { return }
                guard let data = self.photosCellPHAssetDatas?.object(at: (indexPath.item - 1)) else { return }
                
                self.phImageCachingManager.requestImage(for: data, targetSize: self.targetSize, contentMode: .aspectFit, options: phiRequestOption, resultHandler: { (image, _) in
                    DispatchQueue.main.async {
                        topicCreatePhotosCell.topicCreatePhotosCellImageView.image = image
                    }
                })
            } 
            return topicCreatePhotosCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            // TODO:
        } else {
            guard let willDisplayCell = cell as? TopicCreatePhotosCell else { return }
            print("앞으로 나올 path : \(indexPath.item)")
            if let phassetData = photosCellPHAssetDatas?.object(at: indexPath.item - 1) {
                    if !selectedPHAssetDataFromVC.isEmpty,
                        let index = selectedPHAssetDataFromVC.index(where: { asset -> Bool in
                        return phassetData == asset
                        }) {
                        selectedPHAssetDataFromVC.remove(at: index)
                        selectedPhotoDatas.append((indexPath.item, phassetData))
                        willDisplayCell.isSelectedPhoto = true
                    } else  {
                        if selectedPhotoDatas.contains(where: { $0.0 == indexPath.item && $0.1 == phassetData }) {
                            willDisplayCell.isSelectedPhoto = true
                        }
                    }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 6) / 4
        return CGSize(width: width, height: width)
    }
    
    /*func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cameraHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: TopicCreateCameraCell.self), for: indexPath)
            return cameraHeaderView
        case UICollectionElementKindSectionFooter:
            return UICollectionReusableView()
        default:
            fatalError()
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = (self.view.frame.width - 6) / 4
        return CGSize(width: width, height: width)
    }*/
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (photosCellPHAssetDatas?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedcell = collectionView.cellForItem(at: indexPath)
        
        if let _ = selectedcell as? TopicCreateCameraCell {
            if !isCameraAvailable {
                let alertCon = UIAlertController(title: "카메라 사용 오류", message: "카메라 기능이 없는 모바일 기기입니다", preferredStyle: UIAlertControllerStyle.alert)
                alertCon.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alertCon, animated: true)
            } else {
                let topicCreateCustomCameraViewController = TopicCreateCustomCameraViewController()
                self.present(topicCreateCustomCameraViewController, animated: true)
            }
        } else if let photosCell = selectedcell as? TopicCreatePhotosCell,
            let phassetData = self.photosCellPHAssetDatas?.object(at: indexPath.item - 1) {
            if !photosCell.isSelectedPhoto {
                photosCell.isSelectedPhoto = true
                if let _ = photosCell.topicCreatePhotosCellImageView.image {
                    selectedPhotoDatas.append((indexPath.item, phassetData))
                }
            } else {
                photosCell.isSelectedPhoto = false
                if let selectedDataIndex = selectedPhotoDatas.index(where: { $0.0 == indexPath.item && $0.1 == phassetData}){
                    selectedPhotoDatas.remove(at: selectedDataIndex)
                }
            }
        }
    }
}

/*extension TopicCreatePhotoPickerViewController: UICollectionViewDataSourcePrefetching {
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
}*/

extension TopicCreatePhotoPickerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            updateCachedAssets()
        }
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
        topicCreatePhotoPickerTitleLabel.text = title ?? "Camera Roll"
        topicCreatePhotoPickerTitleLabel.textAlignment = .center
        topicCreatePhotoPickerTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        topicCreatePhotoPickerCoachLabel.text = coachComment ?? "변경하려면 여기를 누르세요"
        topicCreatePhotoPickerCoachLabel.textAlignment = .left
        topicCreatePhotoPickerCoachLabel.font = UIFont.systemFont(ofSize: 12)
        topicCreatePhotoPickerBottomArrowImageView.image = UIImage(named: "ic_arrow_drop_down")
        topicCreatePhotoPickerBottomArrowImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        topicCreatePhotoPickerStackView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
    }
}

extension TopicCreatePhotoPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosCellPHAssetCollections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let phassetBunchTableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TopicCreatePHAssetBunchViewCell.self) , for: indexPath) as! TopicCreatePHAssetBunchViewCell
        let phassetCollection = photosCellPHAssetCollections[indexPath.row]
        phassetBunchTableCell.bunchViewPhotosCountLabel.text =
            "\(PHAsset.fetchAssets(in: phassetCollection, options: PHFetchOptions()).count)"
        phassetBunchTableCell.bunchViewTitleLabel.text = phassetCollection.localizedTitle!
        
        if let phasset = PHAsset.fetchAssets(in: phassetCollection, options: nil).firstObject {
            phImageManager.requestImage(for: phasset, targetSize: CGSize.init(width: 50, height: 50), contentMode: PHImageContentMode.aspectFit, options: nil) { (image, _) in
                DispatchQueue.main.async {
                    phassetBunchTableCell.bunchViewThumbnailImageView.image = image
                }
            }
        }
        return phassetBunchTableCell
    }
}




extension TopicCreatePhotoPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height667(75)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.topicCreatePhotosPickerPHAssetBunchView.isHidden = true
        }
        let phassetCollection = photosCellPHAssetCollections[indexPath.row]
        self.topicCreatePhotoPickerTitleView?.topicCreatePhotoPickerTitleLabel.text =
            phassetCollection.localizedTitle
        fetchPHAssetData(with: phassetCollection)
    }
}


/*if PHPhotoLibrary.authorizationStatus() == .notDetermined {
 PHPhotoLibrary.requestAuthorization({ status in
 if status == .authorized {
 
 } else {
 
 }
 })
 } else {
 
 }*/

