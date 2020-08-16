//
//  CustomConfirmationView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class CustomConfirmationView: UIView {
    
    lazy var informationLabel = UILabel(text: "Confirmation".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var detailInformationLabel = UILabel(text: "The post was created successfully".localized, font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    lazy var okImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "buttons-1"))
        i.clipsToBounds = true
        i.isUserInteractionEnabled = true
        return i
    }()
    
    var handleLoginState:(()->Void)?
    var handleSignupState:(()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        clipsToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .white
        let ss = hstack(UIView(),okImageView)
        
        stack(informationLabel,detailInformationLabel,ss).withMargins(.init(top: 16, left: 16, bottom: 16, right: 16))
    }
}
