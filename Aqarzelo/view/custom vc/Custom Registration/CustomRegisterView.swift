//
//  CustomRegisterView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import AuthenticationServices
import MOLH

class CustomRegisterView: UIView {
    
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "1"))
        return i
    }()
    
    lazy var createLabel:UILabel = {
        let l = UILabel(text: "Create your \n account".localized, font: .systemFont(ofSize: 29), textColor: .white,textAlignment: .center,numberOfLines: 2)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    lazy var usernameTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.placeholder = "Username".localized
        t.title = "Username".localized
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.titleFormatter = { $0 }
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .red
        t.titleColor = .white
        t.tintColor = .white
        t.selectedTitleColor = .white
        return t
    }()
    lazy var phoneTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholder = "Phone".localized
        t.keyboardType = UIKeyboardType.numberPad
        t.title = "Phone".localized
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .red
        t.tintColor = .white
        t.titleColor = .white
        t.titleFormatter = { $0 }
        t.selectedTitleColor = .white
        return t
    }()
    lazy var emailTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.keyboardType = UIKeyboardType.emailAddress
        t.placeholder = "Email".localized
        t.titleFormatter = { $0 }
        t.title = "Email".localized
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .red
        t.tintColor = .white
        t.selectedTitleColor = .white
        t.titleColor = .white
        t.constrainHeight(constant: 50)
        return t
    }()
    lazy var passwordTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        //        t.placeholder = "password"
        t.isSecureTextEntry = true
        t.placeholder = "Enter your password".localized
        t.title = "Password".localized
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .red
        t.tintColor = .white
        t.selectedTitleColor = .white
        t.titleFormatter = { $0 }
        t.titleColor = .white
        passwordOldBTN.frame = CGRect(x: CGFloat(t.frame.size.width - 10), y: CGFloat(5), width: CGFloat(10), height: CGFloat(10))
        t.rightView =  passwordOldBTN
        t.rightViewMode = .always
        return t
    }()
    lazy var passwordOldBTN:UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(systemName: "eye.slash.fill") , for: .normal)
//        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        b.imageView?.contentMode = .scaleAspectFit
//        b.imageView?.clipsToBounds=true
        b.addTarget(self, action: #selector(handleASD), for: .touchUpInside)
        return b
    }()
    lazy var confirmPasswordTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.placeholder = "Confirm Password".localized
        t.title = "Confirm Password".localized
        t.isSecureTextEntry = true
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .red
        t.tintColor = .white
        t.selectedTitleColor = .white
        t.titleFormatter = { $0 }
        t.titleColor = .white
        passwordAAAOldBTN.frame = CGRect(x: CGFloat(t.frame.size.width - 10), y: CGFloat(5), width: CGFloat(10), height: CGFloat(10))
        //        button.addTarget(self, action: #selector(handleASDs), for: .touchUpInside)
        t.rightView =  passwordAAAOldBTN
        t.rightViewMode = .always
        return t
    }()
    lazy var passwordAAAOldBTN:UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(systemName: "eye.slash.fill") , for: .normal)

//        b.setImage(#imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysTemplate), for: .normal)
//        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        b.addTarget(self, action: #selector(handleASDs), for: .touchUpInside)
        return b
    }()
    lazy var orLabel = UILabel(text: "OR SIGN UP WITH".localized, font: .systemFont(ofSize: 16), textColor: .white,textAlignment: .center, numberOfLines: 1)
    lazy var facebookImageView:UIImageView = {
        let b = UIImageView(image: #imageLiteral(resourceName: "facebook (2)"))
        b.isUserInteractionEnabled = true
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    lazy var googleImagView:UIImageView = {
        let b = UIImageView(image: #imageLiteral(resourceName: "google-plus"))
        b.constrainWidth(constant: 44)
        b.constrainHeight(constant: 44)
        b.clipsToBounds = true
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isUserInteractionEnabled = true
        return b
    }()
    lazy var signUpButton:UIButton = {
        let b = UIButton()
        b.setTitle("SIGN Up".localized, for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = .white
        
//                b.backgroundColor =
        b.constrainHeight(constant: 50)
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2534725964, green: 0.8196641803, blue: 0.6812620759, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.isEnabled = false
        return b
    }()
    lazy var backImageView:UIImageView = {
        let i =  UIImageView(image:  MOLHLanguage.isRTLLanguage() ?  #imageLiteral(resourceName: "left-arrow") : #imageLiteral(resourceName: "back button-2"))
        i.isUserInteractionEnabled = true
        return i
    }()
//    @available(iOS 13.0, *)
    lazy var appleLogInButton : ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        //        button.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        return button
    }()
    let registerViewModel = RegisterViewModel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        [
            emailTextField,
            passwordTextField,
            confirmPasswordTextField,usernameTextField,
            phoneTextField
            ].forEach({$0.addTarget(self, action: #selector(textFieldDidChange(text:)), for: .editingChanged)})
        let mainStack = getStack(views: usernameTextField,phoneTextField,emailTextField,passwordTextField,confirmPasswordTextField, spacing: 16, distribution: .fillEqually, axis: .vertical)
        
        //        let buttonStack = getStack(views: facebookImageView,googleImagView, spacing: 8, distribution: .fillEqually, axis: .horizontal)
        let buttonStack:UIStackView
        if #available(iOS 13.0, *) {
            buttonStack = getStack(views: facebookImageView,googleImagView,appleLogInButton, spacing: 8, distribution: .fillEqually, axis: .horizontal)
        } else {
            // Fallback on earlier versions
            buttonStack = getStack(views: facebookImageView,googleImagView, spacing: 8, distribution: .fillEqually, axis: .horizontal)
        }
        addSubViews(views: mainImageView,backImageView,createLabel,mainStack,buttonStack,orLabel,signUpButton)
        
        NSLayoutConstraint.activate([
            createLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            
        ])
        
        mainImageView.fillSuperview()
        backImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 60, left: 16, bottom: 0, right: 0))
        createLabel.anchor(top: mainImageView.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 80, left: 0, bottom: 0, right: 0))
        
        mainStack.anchor(top: createLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 60, left: 32, bottom: 0, right: 32))
        
        signUpButton.anchor(top: mainStack.bottomAnchor, leading: leadingAnchor, bottom: orLabel.topAnchor, trailing: trailingAnchor,padding: .init(top: 24, left: 48, bottom: 24, right: 48))
//        signUpButton.anchor(top: nil, leading: leadingAnchor, bottom: orLabel.topAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 32, bottom: 24, right: 32))

        orLabel.anchor(top: buttonStack.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: -32, left: 0, bottom: 0, right: 0))
        buttonStack.anchor(top: signUpButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 24, left: 0, bottom: 40, right: 0))

//        buttonStack.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
    }
    
    
    @objc func handleASD(sender:UIButton)  {
        passwordTextField.isSecureTextEntry.toggle()
        let xx = passwordTextField.isSecureTextEntry == true ?
                          UIImage(systemName: "eye.slash.fill") :
                          UIImage(systemName: "eye.fill")
        sender.setImage(xx, for: .normal)
    }
    
    @objc func handleASDs(sender:UIButton)  {
        confirmPasswordTextField.isSecureTextEntry.toggle()
//        let xx = confirmPasswordTextField.isSecureTextEntry == true ? #imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "icons8-eye-64").withRenderingMode(.alwaysTemplate)
       let xx = confirmPasswordTextField.isSecureTextEntry == true ?
       UIImage(systemName: "eye.slash.fill") :
       UIImage(systemName: "eye.fill")
        sender.setImage(xx, for: .normal)
    }
    
    @objc func textFieldDidChange(text: UITextField)  {
        
        guard let texts = text.text else { return  }
        if let floatingLabelTextField = text as? SkyFloatingLabelTextField {
            if text == usernameTextField {
                if (texts.count < 3 ) {
                    floatingLabelTextField.errorMessage = "Invalid Username".localized
                    registerViewModel.usernasme = nil
                }
                else {
                    
                    registerViewModel.usernasme = texts
                    floatingLabelTextField.errorMessage = ""
                }
                
            }else if text == phoneTextField {
                if  !texts.isValidPhoneNumber {
                    floatingLabelTextField.errorMessage = "Phone must begin with 0 and 11 numbers".localized
                    registerViewModel.phone = nil
                }
                else {
                    registerViewModel.phone = texts
                    floatingLabelTextField.errorMessage = ""
                }
                
            } else if text == emailTextField {
                if !texts.isValidEmail {
                    floatingLabelTextField.errorMessage = "Invalid Email".localized
                    registerViewModel.email = nil
                }
                else {
                    registerViewModel.email = texts
                    floatingLabelTextField.errorMessage = ""
                }
                
            }else if text == passwordTextField {
                if(texts.count < 8 ) {
                    floatingLabelTextField.errorMessage = "Password must have 8 character".localized
                    registerViewModel.password = nil
                }
                else {
                    registerViewModel.password = texts
                    floatingLabelTextField.errorMessage = ""
                }
                
            }else {
                if text.text != passwordTextField.text {
                    floatingLabelTextField.errorMessage = "Passowrd should be same".localized
                    registerViewModel.confirmPassword = nil
                }
                else {
                    registerViewModel.confirmPassword = texts
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    
}
