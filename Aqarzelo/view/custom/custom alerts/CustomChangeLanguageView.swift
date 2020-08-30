//
//  CustomChangeLanguageView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class CustomChangeLanguageView: CustomBaseView {
    
    
    lazy var englishButton = createButtons(title: "English".localized, bgColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), bColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), tColor: .white)
    lazy var arabicButton = createButtons(title: "عربي".localized, bgColor: .white, bColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), tColor: .black)
    
    
    lazy var errorLabel = UILabel(text: "Language".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var errorInfoLabel = UILabel(text: "Change Your Current Language".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left,numberOfLines: 2)
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .black)
        v.constrainHeight(constant: 1)
        return v
    }()
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .lightGray)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.gray.cgColor
        return v
    }()
    lazy var subView:UIView = {
        let v =  UIView(backgroundColor: .lightGray)
        return v
    }()
    
    override func setupViews() {
        //        layer.cornerRadius = 16
        //        clipsToBounds = true
        let buttonStack = getStack(views: englishButton,arabicButton, spacing: 16, distribution: .fillEqually, axis: .horizontal)
        
        addSubViews(views: mainView,subView,buttonStack)
        mainView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        subView.addSubViews(views: seperatorView,errorLabel,errorInfoLabel)
        
        NSLayoutConstraint.activate([errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
                                     errorInfoLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
        //        subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 30, right: 0))
        
        subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        errorLabel.anchor(top:topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        seperatorView.anchor(top: errorLabel.bottomAnchor, leading: subView.leadingAnchor, bottom: nil, trailing: subView.trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        errorInfoLabel.anchor(top: seperatorView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
        //        buttonStack.anchor(top: nil, leading: subView.leadingAnchor, bottom: subView.bottomAnchor, trailing: subView.trailingAnchor,padding: .init(top: 0, left: 16, bottom: -40, right: 16))
        
        buttonStack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: -16, right: 16))
    }
    
    func createButtons(title:String,bgColor:UIColor,bColor:UIColor,tColor:UIColor) -> UIButton {
        let bt  = UIButton()
        bt.constrainHeight(constant: 40)
        //        bt.constrainWidth(constant: 120)
        bt.layer.cornerRadius = 16
        bt.clipsToBounds = true
        bt.setTitle(title, for: .normal)
        bt.backgroundColor = bgColor
        bt.layer.borderWidth = 2
        bt.layer.borderColor = bColor.cgColor
        bt.setTitleColor(tColor, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }
}
