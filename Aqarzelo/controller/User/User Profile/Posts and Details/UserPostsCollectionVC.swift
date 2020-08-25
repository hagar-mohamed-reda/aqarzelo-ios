//
//  UserPostsCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

protocol UserPostsCollectionVCProtocol {
    func handleTakePost(post:AqarModel,index:Int)
}

class UserPostsCollectionVC:   UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.black
        return refreshControl
        
    }()
    
    var handleRefreshCollection:(()->Void)?
    
    
    fileprivate let cellId = "cellId"
    var postsArray:[AqarModel] = [ ]
    var delgate: UserPostsCollectionVCProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        statusBarBackgroundColor()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.noDataFound(postsArray.count, text: "No Data Added Yet".localized)
        return postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserPostsCell
        let post = postsArray[indexPath.item]
        
        cell.post = post
        cell.index = indexPath.item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2 * 16 - 8) / 2
        //        let width = (view.frame.width - 3 *  8 ) / 2
        
        return .init(width: width, height: width)//180)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    ////        return 8
    //    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index   = indexPath.item
        let post = postsArray[indexPath.item]
        self.delgate?.handleTakePost(post: post,index: index)
    }
    
    //MARK:-User methods
    
    fileprivate func setupCollections() {
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator=false
        collectionView.register(UserPostsCell.self, forCellWithReuseIdentifier: cellId)
        //        collectionView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        //        collectionView.alwaysBounceHorizontal=true
        collectionView.refreshControl = refreshControl
    }
    
    @objc func didPullToRefresh()  {
        handleRefreshCollection?()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
