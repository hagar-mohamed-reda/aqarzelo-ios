//
//  CustomForgetPasswordConfirmationView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import MOLH

class CustomForgetPasswordConfirmationView: CustomBaseView {
    
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "1"))
        return i
    }()
    lazy var createLabel:UILabel = {
        let l = UILabel(text: "Confirm  your Password".localized, font: .systemFont(ofSize: 29), textColor: .white,textAlignment: .center)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
   
    lazy var confirmButton:UIButton = {
        let b = UIButton()
        b.setTitle("Confirm".localized, for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = .white
        b.constrainHeight(constant: 50)
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2534725964, green: 0.8196641803, blue: 0.6812620759, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.isEnabled = false
        return b
    }()
    
    lazy var smsTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholder = "SMS code".localized
        t.title = "SMS code".localized
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        return t
    }()
    lazy var passwordTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        //        t.placeholder = "password"
        t.isSecureTextEntry = true
        t.placeholder = "enter your password".localized
        t.title = "Password".localized
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        passwordOldBTN.frame = CGRect(x: CGFloat(t.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        t.rightView =  passwordOldBTN
        t.rightViewMode = .always
        //        t.constrainHeight(constant: 44)
        return t
    }()
    lazy var passwordOldBTN:UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(#imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        b.addTarget(self, action: #selector(handleShowPassword), for: .touchUpInside)
        return b
    }()
    
    lazy var confirmPasswordTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.placeholder = "confirm password".localized
        t.title = "Confirm Password".localized
        t.isSecureTextEntry = true
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        passwordAAAOldBTN.frame = CGRect(x: CGFloat(t.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        t.rightView =  passwordAAAOldBTN
        t.rightViewMode = .always
        return t
    }()
    lazy var passwordAAAOldBTN:UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(#imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        b.addTarget(self, action: #selector(handleShowConfirmPassword), for: .touchUpInside)
        return b
    }()
    lazy var resendLabel = UILabel(text: "Don't receive an sms code ? ".localized, font: .systemFont(ofSize: 16), textColor: .white)
    lazy var resendSMSButton:UIButton = {
        let b = UIButton()
        b.setTitle("Resend".localized, for: .normal)
        b.setTitleColor(#colorLiteral(red: 0.7871699929, green: 0.09486690909, blue: 0, alpha: 1), for: .normal)
        b.constrainHeight(constant: 50)
        return b
    }()
    lazy var backImageView:UIImageView = {
        let i =  UIImageView(image:  MOLHLanguage.isRTLLanguage() ?  #imageLiteral(resourceName: "left-arrow") :  #imageLiteral(resourceName: "back button-2"))
        i.isUserInteractionEnabled = true
        return i
    }()
    
    let forgetPassConfirmViewModel = ForgetPassConfirmViewModel()
    var token:String!
    var phone:String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews()  {
        [
            passwordTextField, confirmPasswordTextField, smsTextField ].forEach({$0.addTarget(self, action: #selector(textFieldDidChange(text:)), for: .editingChanged)})
        
        let mainStack = getStack(views: smsTextField,passwordTextField,confirmPasswordTextField, spacing: 16, distribution: .fillEqually, axis: .vertical)
        let resendStack = getStack(views: resendLabel,resendSMSButton, spacing: 0, distribution: .fill, axis: .horizontal)
        
        addSubViews(views: mainImageView,backImageView,createLabel,mainStack,confirmButton,resendStack)
        
        NSLayoutConstraint.activate([
            createLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        mainImageView.fillSuperview()
        backImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 60, left: 16, bottom: 0, right: 0))
        createLabel.anchor(top: nil, leading: nil, bottom: mainStack.topAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 80, right: 0))
        mainStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        resendStack.anchor(top: mainStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 16, left: 16, bottom: 16, right: 0))
        confirmButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 32, right: 16))
    }
    
    @objc fileprivate func handleShowPassword(sender:UIButton)  {
        passwordTextField.isSecureTextEntry.toggle()
        let xx = passwordTextField.isSecureTextEntry == true ? #imageLiteral(resourceName: "visibility") : #imageLiteral(resourceName: "icons8-eye-64")
               sender.setImage(xx, for: .normal)
    }
    
    @objc fileprivate func handleShowConfirmPassword(sender:UIButton)  {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        let xx = passwordTextField.isSecureTextEntry == true ? #imageLiteral(resourceName: "visibility") : #imageLiteral(resourceName: "icons8-eye-64")
               sender.setImage(xx, for: .normal)
    }
    
    @objc func textFieldDidChange(text: UITextField)  {
        forgetPassConfirmViewModel.apiToken = token
        forgetPassConfirmViewModel.phone = phone
        guard let texts = text.text else { return  }
        if let floatingLabelTextField = text as? SkyFloatingLabelTextField {
            if text == smsTextField {
                if (texts.count < 0 ) {
                    floatingLabelTextField.errorMessage = "Invalid SMS Code".localized
                    forgetPassConfirmViewModel.smsCode = nil
                }
                else {
                    forgetPassConfirmViewModel.smsCode = texts
                    floatingLabelTextField.errorMessage = ""
                }
            }else if text == passwordTextField {
                if(texts.count < 8 ) {
                    floatingLabelTextField.errorMessage = "password must have 8 character"
                    forgetPassConfirmViewModel.password = nil
                }
                else {
                    forgetPassConfirmViewModel.password =   texts
                    floatingLabelTextField.errorMessage = ""
                }
                
            }else {
                if text.text != passwordTextField.text {
                    floatingLabelTextField.errorMessage = "Passowrd should be same"
                    forgetPassConfirmViewModel.confirmPassword = nil
                }
                else {
                    forgetPassConfirmViewModel.confirmPassword  = texts
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    
}
