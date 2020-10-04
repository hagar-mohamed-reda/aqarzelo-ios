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
        let i = UIView(backgroundColor: .green)
        i.constrainWidth(constant: 42)
        i.layer.cornerRadius = 21
        i.clipsToBounds = true
        i.constrainHeight(constant: 42)
        i.addSubview(shareImageView)
        shareImageView.centerInSuperview()
        return i
    }()
    lazy var shareImageView:UIImageView = {
       let i = UIImageView(image: UIImage(named: "share"))
        i.contentMode = .scaleAspectFit
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
