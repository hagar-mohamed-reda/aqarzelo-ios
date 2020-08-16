//
//  CustomLocationView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import GoogleMaps

class CustomLocationView:  CustomBaseView{
    
    fileprivate let cellId = "cellId"
    var handleBackAction:((UIViewController)->Void)?
    
    lazy var closeImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "×-2"))
        i.clipsToBounds = true
        i.constrainWidth(constant: 40)
        i.isUserInteractionEnabled = true
        return i
    }()
    
    lazy var userImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "facebook (2)").withRenderingMode(.alwaysTemplate))
        i.clipsToBounds = true
        i.isUserInteractionEnabled = true
        return i
    }()
    
    lazy var mapView:GMSMapView  = {
        let i = GMSMapView()
        i.isUserInteractionEnabled=true
        i.isMyLocationEnabled=true
//        i.layer.cornerRadius = 16
//        i.clipsToBounds = true
//        i.padding = UIEdgeInsets(top: 0, left: 0, bottom:100, right: 0)
        
        return i
    }()
    lazy var subView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.4169815183, green: 0.83258003, blue: 0.6895253658, alpha: 1))
        v.constrainHeight(constant: 100)
        v.isHide(true)
        return v
    }()
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(LocationCollectionCell.self, forCellWithReuseIdentifier: cellId)
        c.constrainHeight(constant: 220)
        c.backgroundColor = .clear
        return c
    }()
    
    override func layoutSubviews() {
        subView.addGradientBackground(firstColor: #colorLiteral(red: 0.4169815183, green: 0.83258003, blue: 0.6895253658, alpha: 1), secondColor: #colorLiteral(red: 0.4569166303, green: 0.8946051002, blue: 0.7911534905, alpha: 1))
    }
    
    override func setupViews() {
        layer.cornerRadius = 24
        clipsToBounds = true

        addSubViews(views: mapView,subView,collectionView)
        
        mapView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        collectionView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: -16, bottom: 0, right: -16))//24
        subView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: -16, bottom: 24, right: -16))
    }
}
