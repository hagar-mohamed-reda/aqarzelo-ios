//
//  CustomUpdateSserProfileView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Lottie
import MOLH

class CustomUpdateSserProfileView: CustomBaseView {
    
    
    lazy var okButton:UIButton = {
        let b = UIButton()
        b.setTitle("Ok".localized, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.backgroundColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1)
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handlesss), for: .touchUpInside)
        return b
    }()
    
    lazy var cancelButton:UIButton = {
        let b = UIButton()
        b.setTitle("Cancel".localized, for: .normal)
        b.setTitleColor(.black, for: .normal)
//        b.isSelected = true
        b.constrainHeight(constant: 50)
        //        b.constrainWidth(constant: 60)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderWidth = 4
           b.addTarget(self, action: #selector(handlesss), for: .touchUpInside)
        b.layer.borderColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.backgroundColor = .white
        b.clipsToBounds = true
        return b
    }()
    lazy var problemsView:AnimationView = {
        let i = AnimationView()
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    lazy var errorLabel = UILabel(text: "Warring".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var errorInfoLabel = UILabel(text: "Update Profile ?".localized, font: .systemFont(ofSize: 20), textColor: .black)
   
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
    
    func setupAnimation(name:String)  {
           problemsView.animation = Animation.named(name)
           problemsView.play()
           problemsView.loopMode = .loop
       }
    
    override func setupViews() {
        let buttonStack = getStack(views: cancelButton,okButton, spacing: 16, distribution: .fillEqually, axis: .horizontal)
        
        addSubViews(views: mainView,subView,buttonStack)
        mainView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        
        subView.addSubViews(views: errorLabel,errorInfoLabel)
        
        NSLayoutConstraint.activate([
                                     errorInfoLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
         subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        errorLabel.anchor(top:topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 16, left: 16, bottom: 0, right: 0))
       
        errorInfoLabel.anchor(top: subView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: -32, left: 0, bottom: 0, right: 0))
        
        
         buttonStack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: -16, right: 16))
//        buttonStack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: -35, right: 16))
    }
    
   @objc func handlesss()  {
        print(555555)
    }
}


