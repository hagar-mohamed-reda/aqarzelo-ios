//
//  CustomMustLogInView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Lottie
import MOLH

class CustomMustLogInView: CustomBaseView {
  
    lazy var okButton = createButtons(title: "Ok".localized, bgColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), bColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), tColor: .white)
    lazy var cancelButton = createButtons(title: "Cancel".localized, bgColor: .white, bColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), tColor: .black)
        
    
    
    lazy var problemsView:AnimationView = {
        let i = AnimationView()
        i.contentMode = .scaleAspectFit
        return i
    }()
    lazy var errorLabel = UILabel(text: "Information".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var errorInfoLabel = UILabel(text: "You Must Log In First".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: .center)
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .lightGray)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        v.layer.borderWidth = 0
        v.layer.borderColor = UIColor.gray.cgColor
        return v
    }()
    lazy var subView:UIView = {
           let v =  UIView(backgroundColor: .clear)
           v.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
                  v.layer.cornerRadius = 8
                  v.clipsToBounds = true
           return v
       }()
    
    func setupAnimation(name:String)  {
           problemsView.animation = Animation.named(name)
           problemsView.play()
           problemsView.loopMode = .loop
       }
    
    override func setupViews() {
        errorInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        let buttonStack = getStack(views: cancelButton,okButton, spacing: 16, distribution: .fillEqually, axis: .horizontal)
        

        addSubViews(views: mainView,subView,buttonStack)
        mainView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        subView.addSubViews(views: problemsView,errorLabel,errorInfoLabel)
        
        subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        problemsView.centerInSuperview(size: .init(width: 120, height: 80))
//        problemsView.anchor(top:nil, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        errorLabel.anchor(top: subView.topAnchor, leading: subView.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 16, bottom: 0, right: 0))
        errorInfoLabel.anchor(top: problemsView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
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
