//
//  CustomResetPasswordView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Lottie
import MOLH

class CustomResetPasswordView: CustomBaseView {
    
    lazy var problemsView:AnimationView = {
        let i = AnimationView()
        i.contentMode = .scaleAspectFit
        i.constrainWidth(constant: 80)
        i.constrainHeight(constant: 80)
        return i
    }()
    
    lazy var okButton:UIButton = {
        let b = UIButton()
        b.setTitle("OK".localized, for: .normal)
        b.backgroundColor = .green
        b.setTitleColor(.white, for: .normal)
        b.constrainHeight(constant: 40)
        b.constrainWidth(constant: 60)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    
    lazy var errorLabel = UILabel(text: "Success".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var errorInfoLabel = UILabel(text: "You Have Reset Your Password".localized, font: .systemFont(ofSize: 20), textColor: .black)
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    let subView:UIView = {
        let v =  UIView(backgroundColor: .white)
        //        v.layer.cornerRadius = 16
        //        v.clipsToBounds = true
        return v
    }()
    
    func setupAnimation(name:String)  {
           problemsView.animation = Animation.named(name)
           problemsView.play()
           problemsView.loopMode = .loop
       }
    
    override func setupViews() {
        
        addSubViews(views: mainView,okButton)
        mainView.fillSuperview(padding: .init(top: 0, left: 0, bottom: -20, right: 0))
        mainView.addSubViews(views: subView)
        
        subView.addSubViews(views: problemsView,errorLabel,errorInfoLabel)
        
        NSLayoutConstraint.activate([okButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
                                     problemsView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
                                     problemsView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                                     errorInfoLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
        subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        problemsView.anchor(top:nil, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        errorLabel.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 8, left: 16, bottom: 0, right: 0))
        errorInfoLabel.anchor(top: problemsView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        okButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: -35, right: 0))
    }
}



