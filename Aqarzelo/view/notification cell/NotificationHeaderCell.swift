//
//  NotificationHeaderCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Lottie

class NotificationHeaderCell: UICollectionReusableView {
    
    lazy var customEmptyNotifyOrFavoriteView:CustomEmptyNotifyOrFavoriteView = {
        let v = CustomEmptyNotifyOrFavoriteView()
        v.setupAnimation(name: "10002-empty-notification")
//        v.constrainHeight(constant: 300)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        stack(customEmptyNotifyOrFavoriteView)
    }
}
