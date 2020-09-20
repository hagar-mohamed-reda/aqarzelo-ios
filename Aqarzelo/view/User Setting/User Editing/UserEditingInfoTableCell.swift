//
//  UserEditingInfoTableCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import MOLH

class UserEditingInfoTableCell: BaseTableViewCell {
    
    var index:Int! {
        didSet {
            guard let index = index else { return }

            texts = index == 2 ? "Enter your email".localized : index == 3 ? "Enter your Phone".localized : index == 4 ? "Enter your facebook".localized : index == 5 ? "Enter your address".localized :  "Enter your website".localized
        }
    }
    
    var texts = ""
    
    lazy var profilePictureLabel = UILabel(text: "Profile Picture".localized, font: .systemFont(ofSize: 18), textColor: #colorLiteral(red: 0.4835856557, green: 0.483658731, blue: 0.4835696816, alpha: 1))
    lazy var editButton:UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        b.setTitle("Edit".localized, for: .normal)
        b.setTitleColor(#colorLiteral(red: 0.3446323574, green: 0.889023602, blue: 0.7731447816, alpha: 1), for: .normal)
        return b
    }()
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.lightGray.cgColor
        v.addSubview(editingTextField)
        v.isUserInteractionEnabled = false
        return v
    }()
    lazy var editingTextField:CustomTextField = {
        let t = CustomTextField(padding: 16)
        t.placeholder = texts
        t.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return t
    }()
    
    var handleEditUsingIndex:((Int,UserEditingInfoTableCell)->Void)?
    var handleGetTextValue:((Int,String?)->Void)?
    
    
    override func setupViews() {
        backgroundColor = .white
        selectionStyle = .none
        editingTextField.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        let topStack = MOLHLanguage.isRTLLanguage() ? hstack(profilePictureLabel,UIView(),editButton)  : hstack(editButton,UIView(),profilePictureLabel)
        
        
        stack(topStack,mainView,spacing:8).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        editingTextField.fillSuperview()
    }
    
    @objc func handleEdit()  {
        handleEditUsingIndex?(index,self)
    }
    
    @objc fileprivate func handleTextChange(text:SkyFloatingLabelTextField)  {
        
        
        guard let texts = text.text else { return  }
        if let floatingLabelTextField = text as? SkyFloatingLabelTextField {
            if index == 2 {
                if !texts.isValidEmail     {
                    floatingLabelTextField.errorMessage = "Invalid E-mail or Phone".localized
                    //                    email = nil
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                    handleGetTextValue?(index,texts)
                    //                    email = texts
                }
                
            }else if index == 3 {
                if !texts.isValidPhoneNumber  {
                    floatingLabelTextField.errorMessage = "Invalid Phone number".localized
                    
                }
                else {
                    floatingLabelTextField.errorMessage = ""
                    handleGetTextValue?(index,texts)
                    
                }
            }else {
                handleGetTextValue?(index,texts)
            }
        }
    }
    
    //    @objc fileprivate func handleTextChange(text:UITextField)  {
    //        handleGetTextValue?(index,text.text)
    //    }
    
}
