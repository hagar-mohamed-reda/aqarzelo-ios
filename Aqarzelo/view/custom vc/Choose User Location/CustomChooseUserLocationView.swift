//
//  CustomChooseUserLocationView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import GoogleMaps
class CustomChooseUserLocationView: CustomBaseView {
    
    lazy var infoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 3958"))
        i.isUserInteractionEnabled = true
        return i
    }()
    lazy var mapView:GMSMapView  = {
        let i = GMSMapView()
        i.padding = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        return i
    }()
    lazy var doneButton:UIButton = {
        let b = UIButton()
        b.setTitle("Done".localized, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .white
        b.backgroundColor = ColorConstant.mainBackgroundColor
        b.constrainHeight(constant: 50)
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    
    override func setupViews() {
        backgroundColor = .white
        
        addSubViews(views: mapView,infoImageView,doneButton)
        mapView.fillSuperview()
        
        infoImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        doneButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 16, left: 16, bottom: 32, right: 16))
    }
}
