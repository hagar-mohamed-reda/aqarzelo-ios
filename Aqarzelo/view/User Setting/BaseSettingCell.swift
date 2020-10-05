//
//  BaseSettingCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class BaseSettingCell: BaseTableViewCell {
    
    lazy var logoImageView:UIImageView = {
       let i = UIImageView( )
        i.constrainWidth(constant: 42)
        i.constrainHeight(constant: 42)
//        i.isHide(true)
        i.clipsToBounds = true
        return i
    }()
    lazy var logo22ImageView:UIView = {
        let i = UIView(backgroundColor: #colorLiteral(red: 0.3691211641, green: 0.6540648937, blue: 0.02052302659, alpha: 1))
        i.constrainWidth(constant: 42)
        i.layer.cornerRadius = 21
        i.clipsToBounds = true
        i.constrainHeight(constant: 42)
        i.addSubViews(views: whiteView,shareImageView)
        shareImageView.centerInSuperview()
        whiteView.centerInSuperview()
        return i
    }()
   
    lazy var whiteView:UIView = {
        let i = UIView(backgroundColor: .white)
        i.constrainWidth(constant: 22)
        i.layer.cornerRadius = 11
        i.clipsToBounds = true
        i.constrainHeight(constant: 22)
        i.isHide(false)
        return i
    }()
    lazy var shareImageView:UIImageView = {
       let i = UIImageView(image: UIImage(named: "share"))
        i.contentMode = .scaleAspectFit
//        i.isHide(true)
        return i
    }()
    
    lazy var nameLabel = UILabel(text: "sss", font: .systemFont(ofSize: 16), textColor: .black)
    
    override func setupViews() {
        accessoryType = .disclosureIndicator
        backgroundColor = .white
        nameLabel.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        hstack(logo22ImageView,logoImageView,nameLabel,spacing: 16,alignment:.center).withMargins(.init(top: 8, left: 32, bottom: 8, right: 0))
//        logoImageView.centerInSuperview()
    }
}
