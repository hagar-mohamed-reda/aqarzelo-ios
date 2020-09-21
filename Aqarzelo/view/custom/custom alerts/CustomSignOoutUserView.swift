//
//  CustomSignOoutUserView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Lottie
import MOLH

class CustomSignOoutUserView: CustomBaseView {
    
    lazy var informationLabel = UILabel(text: "Warring".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var detailInformationLabel = UILabel(text: "Are You Sure You Want To Log Out?".localized, font: .systemFont(ofSize: 16), textColor: .black)
    
    lazy var okButton = createButtons(title: "Ok".localized, bgColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), bColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), tColor: .white, selector: #selector(handleLogin))
    lazy var cancelButton = createButtons(title: "Cancel".localized, bgColor: .white, bColor: #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1), tColor: .black, selector: #selector(handleSignup))
    
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
    lazy var problemsView:AnimationView = {
        let i = AnimationView()
        i.contentMode = .scaleAspectFit
        return i
    }()
    var handleLoginState:(()->Void)?
    var handleSignupState:(()->Void)?
    
    
    func setupAnimation(name:String)  {
        problemsView.animation = Animation.named(name)
        problemsView.play()
        problemsView.loopMode = .loop
    }
    
    override func setupViews()  {
        backgroundColor = .clear
        
        let buttonStack = getStack(views: okButton,cancelButton, spacing: 16, distribution: .fillEqually, axis: .horizontal)
        //         addSubViews(views: mainView,loginButton,signUpButton)
        addSubViews(views: mainView,subView,buttonStack)
        mainView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        subView.addSubViews(views: informationLabel,detailInformationLabel,problemsView)
        
        NSLayoutConstraint.activate([
            problemsView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            problemsView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            detailInformationLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ])
        
        subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        informationLabel.anchor(top:topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        
        detailInformationLabel.anchor(top: subView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: -16, left: 0, bottom: 0, right: 0))
        problemsView.anchor(top:nil, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        buttonStack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: -16, right: 16))
    }
    
    func createButtons(title:String,bgColor:UIColor,bColor:UIColor,tColor:UIColor,selector:Selector) -> UIButton {
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
        bt.addTarget(self, action: selector, for: .touchUpInside)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }
    
    @objc func handleLogin()  {
        handleLoginState?()
    }
    
    @objc func handleSignup()  {
        handleLoginState?()
    }
}


