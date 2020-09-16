//
//  CustomChangePasswordView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import MOLH

class CustomChangePasswordView: CustomBaseView {
    
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    lazy var oldPasswordTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.isSecureTextEntry = true
        t.placeholder = "Old Passowrd".localized
        t.title = "Old Passowrd".localized
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .black
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .white
        t.tintColor = .white
        t.selectedTitleColor = .white
        t.constrainHeight(constant: 50)
        passwordOldBTN.frame = CGRect(x: CGFloat(t.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(10))
        t.rightView =  passwordOldBTN
        t.rightViewMode = .always
        return t
    }()
    lazy var passwordOldBTN:UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(#imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        b.addTarget(self, action: #selector(handleASD), for: .touchUpInside)
        return b
    }()
    lazy var newPasswordTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.isSecureTextEntry = true
        t.placeholder = "enter your New password".localized
        t.title = "New Password".localized
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .black
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .white
        t.tintColor = .white
        t.selectedTitleColor = .white
        passwordBTN.frame = CGRect(x: CGFloat(t.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(10))
        t.rightView =  passwordBTN
        t.rightViewMode = .always
        return t
    }()
    lazy var passwordBTN:UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(#imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        b.addTarget(self, action: #selector(handleASDa), for: .touchUpInside)
        
        return b
    }()
    lazy var passwordCOBTN:UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(#imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageEdgeInsets = MOLHLanguage.isRTLLanguage() ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -16) : UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        b.addTarget(self, action: #selector(handleASDss), for: .touchUpInside)
        
        return b
    }()
    lazy var confirmNewPasswordTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.placeholder = "Confirm New Password".localized
        t.title = "Confirm New Password".localized
        t.isSecureTextEntry = true
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholderColor = .black
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
        t.errorColor = .white
        t.tintColor = .white
        t.selectedTitleColor = .white
        passwordCOBTN.frame = CGRect(x: CGFloat(t.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(10))
        t.rightView =  passwordCOBTN
        t.rightViewMode = .always
        return t
    }()
    
    lazy var submitButton:UIButton = {
        let b = UIButton()
        b.setTitle("Submit".localized, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        b.constrainHeight(constant: 50)
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.1709282994, green: 0.6409345269, blue: 0.664721489, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.isEnabled = false
        return b
    }()
    var api_token = ""
    
    let changePpasswordViewModel = ChangePpasswordViewModel()
    
    
    override func setupViews()  {
        
        [ newPasswordTextField,oldPasswordTextField,confirmNewPasswordTextField].forEach({$0.addTarget(self, action: #selector(textFieldDidChange(text:)), for: .editingChanged)})
        let mainStack = getStack(views: oldPasswordTextField,newPasswordTextField,confirmNewPasswordTextField, spacing: 16, distribution: .fillEqually, axis: .vertical)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubViews(views: mainView,mainStack,submitButton)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        mainView.fillSuperview()
        
        mainStack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        submitButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 40, right: 16))
    }
    
    
    
    
    
    
    
    
    @objc  func handleASD(sender:UIButton)  {
        oldPasswordTextField.isSecureTextEntry.toggle()
        let xx = oldPasswordTextField.isSecureTextEntry == true ? #imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "icons8-eye-64").withRenderingMode(.alwaysOriginal)
        sender.setImage(xx, for: .normal)
    }
    
    @objc  func handleASDa(sender:UIButton)  {
        newPasswordTextField.isSecureTextEntry.toggle()
        let xx = newPasswordTextField.isSecureTextEntry == true ? #imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "icons8-eye-64").withRenderingMode(.alwaysOriginal)
        sender.setImage(xx, for: .normal)
    }
    
    @objc  func handleASDss(sender:UIButton)  {
        confirmNewPasswordTextField.isSecureTextEntry.toggle()
        let xx = confirmNewPasswordTextField.isSecureTextEntry == true ? #imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "icons8-eye-64").withRenderingMode(.alwaysOriginal)
        sender.setImage(xx, for: .normal)
    }
    
    
    @objc func textFieldDidChange(text: UITextField)  {
        changePpasswordViewModel.apiToken = api_token
        guard let texts = text.text else { return  }
        if let floatingLabelTextField = text as? SkyFloatingLabelTextField {
            
            if text == oldPasswordTextField {
                if (texts.count < 8 ) {
                    floatingLabelTextField.errorMessage = "password must have 8 character".localized
                    changePpasswordViewModel.oldPass = nil
                }
                else {
                    changePpasswordViewModel.oldPass  = texts
                    floatingLabelTextField.errorMessage = ""
                }
                
            }else if text == newPasswordTextField {
                if(texts.count < 8 ) {
                    floatingLabelTextField.errorMessage = "password must have 8 character".localized
                    changePpasswordViewModel.newPassword = nil
                }
                else {
                    changePpasswordViewModel.newPassword =   texts
                    floatingLabelTextField.errorMessage = ""
                }
                
            }else {
                if text.text != newPasswordTextField.text {
                    floatingLabelTextField.errorMessage = "Passowrd should be same".localized
                    changePpasswordViewModel.confirmNewPassword = nil
                }
                else {
                    changePpasswordViewModel.confirmNewPassword  = texts
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
    
    
}
