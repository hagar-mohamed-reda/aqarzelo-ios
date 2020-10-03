//
//  CustomErrorViews.swift
//  Aqarzelo
//
//  Created by Hossam on 9/20/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import Lottie
import MOLH

class CustomErrorView: CustomBaseView {
    
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
        b.constrainWidth(constant: 100)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        //        b.addTarget(self, action: #selector(handless), for: .touchUpInside)
        return b
    }()
    
    lazy var errorLabel = UILabel(text: "Error".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var errorInfoLabel = UILabel(text: "You Can't Chat With Yourself".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .center,numberOfLines: 0)
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
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
        
        
       addSubViews(views: mainView,subView,okButton)
       mainView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
       subView.addSubViews(views: problemsView,errorLabel,errorInfoLabel)
       
       
       NSLayoutConstraint.activate([
//           errorInfoLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
           okButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
           ])
       
       subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
       problemsView.centerInSuperview(size: .init(width: 80, height: 80))
       errorLabel.anchor(top:topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
       
       errorInfoLabel.anchor(top: subView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: -24, left: 0, bottom: 0, right: 0))
       
       
       okButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: -16, right: 16))
    }
    
}
