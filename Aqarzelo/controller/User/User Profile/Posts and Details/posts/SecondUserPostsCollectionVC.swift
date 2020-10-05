//
//  SecondUserPostsCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 10/5/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import MOLH
import SVProgressHUD

class SecondUserPostsCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.black
        return refreshControl
        
    }()
    
    var user:UserModel?  {
        didSet{
            guard let user=user else{return}
        }
    }
    
    fileprivate let cellId = "cellId"
    var postsArray:[AqarModel] = [ ]
    var delgate: UserPostsCollectionVCProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2015180886, green: 0.811791122, blue: 0.7185178995, alpha: 1)
        setupCollections()
        setupNavigation()
        statusBarBackgroundColor()
        handleRefreshCollection()
        
        statusBarBackgroundColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
            user=cacheCurrentUserCodabe.storedValue
        }
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
    
    fileprivate func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.title = "My Post".localized
    }
    
    fileprivate func setupCollections() {
        
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
        collectionView.clipsToBounds = true
        collectionView.showsVerticalScrollIndicator=false
        
        
        collectionView.register(UserPostsCell.self, forCellWithReuseIdentifier: cellId)
        //        collectionView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        //        collectionView.alwaysBounceHorizontal=true
        collectionView.refreshControl = refreshControl
    }
    
    func handleRefreshCollection()  {
        
        
        guard let user = user else { return  }
        
        var group3: [AqarModel]?
        
        //        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        //        guard let api_Key = user.apiToken
        progressHudProperties()
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            //            UserServices.shared.getUserData(apiKey: self.user.apiToken) {[unowned self] (base, err) in
            //                if let error = err {
            //                    SVProgressHUD.showError(withStatus: error.localizedDescription)
            //                    self.activeViewsIfNoData();return
            //                }
            //                guard let users = base?.data else{SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ?  base?.messageAr : base?.messageEn ); return}
            //
            //                self.putUserData(users:users)
            //                semaphore.signal()
            //            }
            //            semaphore.wait()
            
            UserServices.shared.getUserPosts(apiKeys: user.apiToken, completon: { (base, err) in
                if let error = err {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                group3 = base?.data ?? []
                semaphore.signal()
            })
            semaphore.wait()
            
            semaphore.signal()
            self.reloadMainData(group3: group3)
            semaphore.wait()
            
        }
    }
    
    func reloadMainData(group3:[AqarModel]?)  {
        self.postsArray.removeAll()
        
        DispatchQueue.main.async {
            //                self.user =
            
            SVProgressHUD.dismiss()
            //            UIApplication.shared.endIgnoringInteractionEvents()
            self.postsArray = group3 ?? []
            
            self.refreshControl.beginRefreshing()
            self.refreshControl.endRefreshing()
            
            
            self.collectionView.reloadData()
        }
        
    }
    
    
    @objc fileprivate func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didPullToRefresh()  {
        handleRefreshCollection()
    }
    
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
