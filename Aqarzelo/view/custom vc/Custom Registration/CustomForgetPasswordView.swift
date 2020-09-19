//
//  CustomForgetPasswordView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH
import SkyFloatingLabelTextField

class CustomForgetPasswordView: UIView {
    
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "1"))
        return i
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
    
    lazy var phoneTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.lineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.placeholder = "Phone".localized
        t.keyboardType = UIKeyboardType.numberPad
        t.title = "Phone"
        t.placeholderColor = .white
        t.selectedLineColor = #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1)
        t.textColor = .white
                      t.errorColor = .red
                      t.tintColor = .white
                      t.selectedTitleColor = .white
        t.titleColor = .white
        t.addTarget(self, action: #selector(textFieldDidChange(text:)), for: .editingChanged)

        return t
    }()
      lazy var backImageView:UIImageView = {
         let i =  UIImageView(image:  MOLHLanguage.isRTLLanguage() ?  #imageLiteral(resourceName: "left-arrow") : #imageLiteral(resourceName: "back button-2"))
         i.isUserInteractionEnabled = true
         return i
     }()
    
    let forgetPassViewModel = ForgetPassViewModel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        
        
        addSubViews(views: mainImageView,backImageView,phoneTextField,confirmButton)
        mainImageView.fillSuperview()
        backImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 60, left: 16, bottom: 0, right: 0))

        phoneTextField.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        NSLayoutConstraint.activate([
            phoneTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            phoneTextField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40)
            ])
        confirmButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 32, right: 16))
    }
    
   @objc func textFieldDidChange(text: UITextField)  {
          
          guard let texts = text.text else { return  }
          if let floatingLabelTextField = text as? SkyFloatingLabelTextField {
              
              if !texts.isValidPhoneNumber  {
                  floatingLabelTextField.errorMessage = "Invalid Phone number".localized
                 forgetPassViewModel.email = nil
              }
              else {
                  // The error message will only disappear when we reset it to nil or empty string
                  floatingLabelTextField.errorMessage = ""
                  forgetPassViewModel.email = texts
              }
          }
          
      }
  
}
