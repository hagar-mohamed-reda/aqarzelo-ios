//
//  UserPostsDetailsCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class UserPostsDetailsCollectionVC: BaseCollectionVC {
    
    lazy var refreshControl:UIRefreshControl = {
              let refreshControl = UIRefreshControl()
              refreshControl.backgroundColor = UIColor.white
              refreshControl.tintColor = UIColor.black
              return refreshControl
              
          }()
    
    fileprivate let cellId = "cellId"
    lazy var contactsArray:[DetailContactModel] = [
        DetailContactModel(image: #imageLiteral(resourceName: "Group 3923-9"), contact: self.currentUser?.email ?? "" ),
        //    .init(image: #imageLiteral(resourceName: "Group 3927-3"), contact: "0109 552 5115 "),
        .init(image: #imageLiteral(resourceName: "Group 3923"), contact: self.currentUser?.phone ?? ""  ),
        .init(image: #imageLiteral(resourceName: "Group 3926-3"), contact: self.currentUser?.facebook ?? ""),
        .init(image: #imageLiteral(resourceName: "Group 3925-3"), contact: self.currentUser?.address ?? ""),
        .init(image: #imageLiteral(resourceName: "Group 3924-4"), contact: self.currentUser?.website ?? "")
    ]
    
    var currentUser: UserModel?
    var handleRefreshCollection:(()->Void)?

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.noDataFound(contactsArray.count, text: "No Data Added Yet".localized)

        return contactsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserDetailCell
        let contact = contactsArray[indexPath.item]
        
        cell.contact = contact
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return .init(width: view.frame.width, height: 60)
    }
    
    //MARK:-User methods
    
    override func setupCollection() {
        collectionView.showsVerticalScrollIndicator=false

        collectionView.backgroundColor = .white
        collectionView.register(UserDetailCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 8)
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
//           collectionView.alwaysBounceHorizontal=true
                  collectionView.refreshControl = refreshControl
       }
    
       @objc func didPullToRefresh()  {
              handleRefreshCollection?()
          }
    
}
