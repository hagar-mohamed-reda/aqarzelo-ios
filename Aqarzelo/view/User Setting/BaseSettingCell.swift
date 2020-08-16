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
    
//    lazy var mainView:UIView = {
//       let v = UIView()
//    v.constrainWidth(constant: 42)
//        v.constrainHeight(constant: 42)
//        v.layer.cornerRadius = 21
//        v.addSubview(logoImageView)
//        return v
//    }()
    lazy var logoImageView:UIImageView = {
       let i = UIImageView( )
//        i.constrainWidth(constant: 20)
//        i.constrainHeight(constant: 20)
//        i.layer.cornerRadius = 10
//        i.contentMode = .scaleAspectFit
        i.constrainWidth(constant: 42)
        i.constrainHeight(constant: 42)

        i.clipsToBounds = true
        return i
    }()
    
    lazy var nameLabel = UILabel(text: "sss", font: .systemFont(ofSize: 16), textColor: .black)
    
    override func setupViews() {
        accessoryType = .disclosureIndicator
        backgroundColor = .white
        nameLabel.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        hstack(logoImageView,nameLabel,spacing: 16,alignment:.center).withMargins(.init(top: 8, left: 32, bottom: 8, right: 0))
//        logoImageView.centerInSuperview()
    }
}
