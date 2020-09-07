//
//  FloatingLabeledTextFields.swift
//  Aqarzelo
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class FloatingLabeledTextFields: UITextField {

    let padding:CGFloat

    var texst:String? = "placeholder" {
        didSet{
            guard let texst = texst else { return  }
            floatingLabel.text = texst
            self.placeholder = texst
        }
    }
    var errorInput:Bool? = false {
        didSet {
            guard let errorInput = errorInput else { return  }
            showError(errorInput)
        }
    }
    
    func showError(_ b:Bool)  {
        floatingLabel.textColor = b ? .red : .black
        layer.borderWidth = 2
        layer.borderColor = b ? UIColor.red.cgColor :  #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1).cgColor
    }
    
    
   lazy var floatingLabel = UILabel(text: "", font: UIFont.systemFont(ofSize: 16), textColor: .black)

  

   var floatingLabelHeight: CGFloat = 30 //30

    init(padding:CGFloat) {
           self.padding = padding
           super.init(frame: .zero)
           backgroundColor = .white
        setupViews()
       }
       
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    func setupViews()  {
         self.addSubview(floatingLabel)

         NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)

          NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
    }

   
 
    func putErrorMessage(err:Bool,errMess:String,truMess:String)  {
        floatingLabel.textColor = err ? .red : .black
               layer.borderWidth = 1
               layer.borderColor = err ? UIColor.red.cgColor :  #colorLiteral(red: 0.2641228139, green: 0.9383022785, blue: 0.9660391212, alpha: 1).cgColor
     floatingLabel.text = err ? errMess : truMess
    }



@objc func textFieldDidBeginEditing(_ textField: UITextField) {

    if self.text == "" {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.frame = CGRect(x: self.padding, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)
        }
        self.placeholder = ""
    }
}

@objc func textFieldDidEndEditing(_ textField: UITextField) {

    if self.text == "" {
        UIView.animate(withDuration: 0.1) {
           self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        }
        self.placeholder = texst
    }
}
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

deinit {

    NotificationCenter.default.removeObserver(self)

  }
}
