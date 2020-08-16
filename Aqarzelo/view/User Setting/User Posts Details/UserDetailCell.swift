//
//  UserDetailCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class UserDetailCell: BaseCollectionCell {
    
    var contact:DetailContactModel?  {
        didSet {
            guard let contact = contact else { return }

            userContactImageView.image = contact.image
            userContactLabel.text = contact.contact
            userContactImageView.isHidden = contact.contact == "" ? true : false
            userContactLabel.isHidden = contact.contact == "" ? true : false
        }
    }
    
    
    lazy var userContactImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "jackFinniganRriAi0NhcbcUnsplash"))
        i.constrainWidth(constant: 40)
        i.constrainHeight(constant: 40)
        i.clipsToBounds = true
        return i
    }()
    lazy var userContactLabel = UILabel(text: "profile Picture", font: .systemFont(ofSize: 18), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    
    override func setupViews() {
        hstack(userContactImageView,userContactLabel,spacing:16,alignment:.center).withMargins(.init(top: 0, left: 8, bottom: 0, right: 8))
    }
}
