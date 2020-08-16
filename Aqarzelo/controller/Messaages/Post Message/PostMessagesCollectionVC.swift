//
//  PostMessagesCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD


class PostMessagesCollectionVC: BaseCollectionVC {
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.black
        return refreshControl
        
    }()
    
    fileprivate let cellId = "cellId"
    var messagesArray = [GetPostModel]()
    
    fileprivate let post_Id:Int!
    init(postId:Int) {
        self.post_Id = postId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userDefaults.bool(forKey: UserDefaultsConstants.isMessagedCahced)   {
            guard let message = cacheMessagessssUserCodabe.storedValue else { return  }
            messagesArray = message
        }else {
            loadMessages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostMessagesCell
        let message = messagesArray[indexPath.item]
        
        cell.message = message
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedCellSize = PostMessagesCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 10000))
        estimatedCellSize.textMessageLabel.text = messagesArray[indexPath.item].comment
        estimatedCellSize.layoutIfNeeded()
        
        let estimatedHeight = estimatedCellSize.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        
        return .init(width: view.frame.width, height: estimatedHeight.height + 60)
    }
    
    //MARK:-User methods
    
    fileprivate func loadMessages()  {
        //        messagesArray.removeAll()
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding....".localized)
        PostServices.shared.getPostReviews(post_id: post_Id) { (base, err) in
            if let error = err {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                //                 UIApplication.shared.endIgnoringInteractionEvents()
            }
            guard let base = base?.data else {return}
            self.messagesArray = base
            self.reloadDatas()
        }
        
    }
    
    func loadNewerMessages()  {
        messagesArray.removeAll()
        PostServices.shared.getPostReviews(post_id: post_Id) { (base, err) in
            if let error = err {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.activeViewsIfNoData()
                //                 UIApplication.shared.endIgnoringInteractionEvents()
            }
            guard let base = base?.data else {return}
            self.messagesArray = base
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func reloadDatas()  {
        
        
        messagesArray = messagesArray.sorted(by: {$0.createdAt > $1.createdAt})
        userDefaults.set(true, forKey: UserDefaultsConstants.isMessagedCahced)
        userDefaults.synchronize()
        cacheMessagessssUserCodabe.save(messagesArray)
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.collectionView.refreshControl?.beginRefreshing()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            
        }
    }
    
    
    override func setupCollection() {
        collectionView.backgroundColor = .white
        collectionView.register(PostMessagesCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsVerticalScrollIndicator=false
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.alwaysBounceVertical=true
        collectionView.refreshControl = refreshControl
    }
    
    @objc func didPullToRefresh()  {
        loadMessages()
    }
    
}
