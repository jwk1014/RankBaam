//
//  ViewController.swift
//  0116#RankBaamMainCollectionProto
//
//  Created by 황재욱 on 2018. 1. 17..
//  Copyright © 2018년 황재욱. All rights reserved.
//

import UIKit

class TabMainViewController: UIViewController {

    
    @IBOutlet weak var mainAllRankCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "MainAllRankCell", bundle: nil)
        mainAllRankCollectionView.register(cellNib, forCellWithReuseIdentifier: ConstantsNames.TabMainViewControllerNames.MAINALLRANKCELL)
        let upperTabber = MainAllRankTopTabbar(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 35))
        self.view.addSubview(upperTabber)
        upperTabber.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            upperTabber.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        upperTabber.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        upperTabber.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        upperTabber.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
//        navigationController?.hidesBarsOnSwipe = true
//        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 195/255, blue: 75/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor(red: 255/255, green: 195/255, blue: 75/255, alpha: 1)
        ]
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        mainAllRankCollectionView.backgroundColor = UIColor(red: 246/255, green: 248/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor.white
        mainAllRankCollectionView.contentInset = UIEdgeInsets(top: 21, left: 0, bottom: 0, right: 0)
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        
//        navigationController?.hidesBarsOnSwipe = true
//        navigationController?.hidesBarsOnTap = true
        
        
    }

}


extension TabMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mainAllRankCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantsNames.TabMainViewControllerNames.MAINALLRANKCELL, for: indexPath) as! MainAllRankCell
        
        return mainAllRankCell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 327, height: 128)
    }
    
    
    
    
}

