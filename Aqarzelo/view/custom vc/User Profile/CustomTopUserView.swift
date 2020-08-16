//
//  CustomTopUserView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class CustomTopUserView: CustomBaseView {
    
    
    var handleEditProfiles:(()->Void)?
    
    lazy var userImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 3931-1"))
             i.constrainWidth(constant: 80)
        i.constrainHeight(constant: 80)
        i.layer.cornerRadius = 40
        i.clipsToBounds = true
        return i
    }()
    lazy var userNameLabel = UILabel(text: "LOGIN".localized, font: .systemFont(ofSize: 16), textColor: .black)
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.8730823398, green: 0.8732082844, blue: 0.873054862, alpha: 1))
        v.constrainHeight(constant: 1)
        return v
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditProfile)))
        addSubview(seperatorView)
       
            userNameLabel.textAlignment = MOLHLanguage.isRTLLanguage() ?  .right : .left
            
     
        hstack(userImageView,userNameLabel,spacing: 16,alignment:.center).withMargins(.init(top: 8, left: 32, bottom: 8, right: 0))
       
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 24, bottom: 0, right: 0))
    }
    
  @objc  func handleEditProfile()  {
     handleEditProfiles?()
    }
}
