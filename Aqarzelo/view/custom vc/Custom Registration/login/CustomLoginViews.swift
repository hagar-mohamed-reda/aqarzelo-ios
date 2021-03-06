////
////  CustomLoginViews.swift
////  Aqarzelo
////
////  Created by Hossam on 9/7/20.
////  Copyright © 2020 Hossam. All rights reserved.
////
//
//import UIKit
//import MOLH
//import AuthenticationServices
//
//class CustomLoginViews: UIView {
//    
//    lazy var mainImageView:UIImageView = {
//        let i = UIImageView(image: #imageLiteral(resourceName: "1"))
//        return i
//    }()
//    lazy var backImageView:UIImageView = {
//        let i =  UIImageView(image:  MOLHLanguage.isRTLLanguage() ?  #imageLiteral(resourceName: "left-arrow") : #imageLiteral(resourceName: "back button-2"))
//        i.isUserInteractionEnabled = true
//        return i
//    }()
//    
//    lazy var loginLabel:UILabel = {
//        let l = UILabel(text: "Login".localized, font: .systemFont(ofSize: 29), textColor: .white)
//        l.translatesAutoresizingMaskIntoConstraints = false
//        return l
//    }()
//    lazy var emailTextField:FloatingLabeledTextFields = {
//        let v = FloatingLabeledTextFields(padding: 16)
//        v.constrainHeight(constant: 60)
//        v.layer.borderColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1).cgColor
//        v.texst="enter your email or telephone".localized
//        return v
//    }()
//    lazy var passwordTextField:FloatingLabeledTextFields = {
//        let v = FloatingLabeledTextFields(padding: 16)
//        v.layer.borderColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1).cgColor
//        v.texst="enter your password".localized
//        passwordOldBTN.frame = CGRect(x: CGFloat(v.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
//        v.rightView =  passwordOldBTN
//        v.rightViewMode = .always
//        return v
//    }()
//    lazy var passwordOldBTN:UIButton = {
//        let b = UIButton(type: .custom)
//        
//        b.setImage(#imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal), for: .normal)
//        b.imageView?.contentMode = .scaleAspectFit
//        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        b.addTarget(self, action: #selector(handleASD), for: .touchUpInside)
//        return b
//    }()
//    lazy var forgetPasswordButton:UIButton = {
//        let b = UIButton()
//        b.setTitle("Forget Password ?".localized, for: .normal)
//        b.setTitleColor(.white, for: .normal)
//        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        b.backgroundColor = .clear
//        b.constrainWidth(constant: 150)
//        return b
//        
//    }()
//    lazy var loginButton:UIButton = {
//        let b =  UIButton()
//        b.setTitle("LOGIN".localized, for: .normal)
//        b.setTitleColor(.black, for: .normal)
//        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        b.backgroundColor = .white// #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1)
//        b.constrainHeight(constant: 50)
//        b.layer.borderWidth = 4
//        b.layer.borderColor = #colorLiteral(red: 0.2534725964, green: 0.8196641803, blue: 0.6812620759, alpha: 1).cgColor
//        b.layer.cornerRadius = 16
//        b.clipsToBounds = true
//        b.isEnabled = false
//        return b
//    }()
//    lazy var orLabel = UILabel(text: "OR LOGIN WITH".localized, font: .systemFont(ofSize: 12), textColor: .white,textAlignment: .center, numberOfLines: 1)
//    lazy var facebookImageView:UIImageView = {
//        let b = UIImageView(image: #imageLiteral(resourceName: "facebook (2)"))
//        b.isUserInteractionEnabled = true
//        b.translatesAutoresizingMaskIntoConstraints = false
//        return b
//    }()
//    lazy var googleImagView:UIImageView = {
//        let b = UIImageView(image: #imageLiteral(resourceName: "google-plus"))
//        b.constrainWidth(constant: 44)
//        b.constrainHeight(constant: 44)
//        b.clipsToBounds = true
//        b.translatesAutoresizingMaskIntoConstraints = false
//        b.isUserInteractionEnabled = true
//        return b
//    }()
//    
//    lazy var createAccountLabel = UILabel(text: "Don't have an account ? ".localized, font: .systemFont(ofSize: 16), textColor: .white)
//    lazy var createAccountButton:UIButton = {
//        let b = UIButton()
//        b.setTitle("Sign up".localized, for: .normal)
//        b.setTitleColor(#colorLiteral(red: 0.7871699929, green: 0.09486690909, blue: 0, alpha: 1), for: .normal)
//        b.constrainHeight(constant: 50)
//        return b
//    }()
//    @available(iOS 13.0, *)
//    lazy var appleLogInButton : ASAuthorizationAppleIDButton = {
//        let button = ASAuthorizationAppleIDButton()
//        //        button.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
//        return button
//    }()
//    
//    let loginViewModel = LoginViewModel ()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupViews()  {
//        [ emailTextField, passwordTextField  ].forEach({$0.addTarget(self, action: #selector(textFieldDidChange(text:)), for: .editingChanged)})
//        [emailTextField,passwordTextField].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
//        
//        let forgetStack = MOLHLanguage.isRTLLanguage() ? getStack(views: forgetPasswordButton,UIView(), spacing: 8, distribution: .fill, axis: .horizontal) :  getStack(views: UIView(),forgetPasswordButton, spacing: 8, distribution: .fill, axis: .horizontal)
//        let buttonStack:UIStackView
//        if #available(iOS 13.0, *) {
//            buttonStack = getStack(views: facebookImageView,googleImagView,appleLogInButton, spacing: 8, distribution: .fillEqually, axis: .horizontal)
//        } else {
//            // Fallback on earlier versions
//            buttonStack = getStack(views: facebookImageView,googleImagView, spacing: 8, distribution: .fillEqually, axis: .horizontal)
//        }
//        let createStack = getStack(views: createAccountLabel,createAccountButton, spacing: 0, distribution: .fill, axis: .horizontal)
//        let subStack = getStack(views: emailTextField,passwordTextField,forgetStack, spacing: 24, distribution: .fillEqually, axis: .vertical)
//        
//        addSubViews(views: mainImageView,backImageView,loginLabel,subStack,loginButton,orLabel,buttonStack,createStack)
//        NSLayoutConstraint.activate([
//            loginLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            //
//            subStack.centerXAnchor.constraint(equalTo: centerXAnchor),
//            subStack.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -40),
//            buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
//            createStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
//            
//        ])
//        
//        mainImageView.fillSuperview()
//        backImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 60, left: 16, bottom: 0, right: 0))
//        loginLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 80, left: 0, bottom: 0, right: 0))
//        
//        
//        subStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 32, bottom: 0, right: 32))
//        loginButton.anchor(top: subStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 24, left: 16, bottom: 0, right: 16))
//        orLabel.anchor(top: loginButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
//        buttonStack.anchor(top: orLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
//        createStack.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 16, right: 0))
//        
//    }
//    
//    @objc func textFieldDidChange(text: UITextField)  {
//        
//        guard let texts = text.text else { return  }
//            if text == emailTextField {
//                let xx = !texts.isValidEmail && !texts.isValidPhoneNumber
//                emailTextField.putErrorMessage(err: xx, errMess: "Invalid Email or Phone".localized, truMess: "your email or telephone")
//                loginViewModel.email = xx ?  texts : nil
//
//            }else {
//                let x = (texts.count < 8 )
//                passwordTextField.putErrorMessage(err: x, errMess: "password must have 8 character".localized, truMess: "Password".localized)
//                loginViewModel.password = x ?  texts : nil
//
//        }
//        
//    }
//    
//    
//    
//    @objc func handleASD(sender:UIButton)  {
//        passwordTextField.isSecureTextEntry.toggle()
//        let xx = passwordTextField.isSecureTextEntry == true ? #imageLiteral(resourceName: "visibility") : #imageLiteral(resourceName: "icons8-eye-64")
//        sender.setImage(xx, for: .normal)
//    }
//    
//    
//}
