//
//  CustomAddPostListOfPhotoEditingView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CustomAddPostListOfPhotoEditingView: CustomBaseView {
    
    
    var photosArray = [PhotoModel]()
    
    
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    lazy var collectionView:UICollectionView = {
        let c = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        c.backgroundColor = .white
        c.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        //        c.delegate = self
        //        c.dataSource = self
        c.register(ListOfPhotoMaseterCell.self, forCellWithReuseIdentifier:  cellMasterId )
                c.register(ListOfFhotoCell.self, forCellWithReuseIdentifier: cellId)
        c.register(ListOfPhotoFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellFooterId)
        return c
    }()
    
    lazy var nextButton:UIButton = {
        let b = UIButton()
        b.setTitle("Next".localized, for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = .white
        
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.3588023782, green: 0.7468322515, blue: 0.7661533952, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.isEnabled = true
        b.constrainHeight(constant: 50)
        //        b.isEnabled = false
        return b
    }()
    
    let cellId = "cellId"
        let cellMasterId = "cellMasterId"
    let cellFooterId = "cellFooterId"
    
    override func setupViews() {
        
        addSubViews(views: mainView,collectionView,nextButton)
        mainView.fillSuperview()
        collectionView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nextButton.topAnchor, trailing: trailingAnchor,padding: .init(top: 16, left: 0, bottom: 16, right: 0))
        nextButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 32, right: 16))
    }
}

