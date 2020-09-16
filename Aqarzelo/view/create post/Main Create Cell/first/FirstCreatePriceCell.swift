//
//  FirstCreatePriceCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import MOLH

class FirstCreatePriceCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3933")
            iconImageView.isUserInteractionEnabled = true
            //            mainView.isHide(false)
            priceTextField.text = aqar.pricePerMeter
            handleTextContents?(Int(aqar.pricePerMeter) ?? 0,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3929"))
        //        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    
    lazy var categoryLabel = UILabel(text: "Price Per Meter".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var mainView:UIView = {
        let l = UIView(backgroundColor: .white)
        l.layer.cornerRadius = 8
        l.layer.borderWidth = 1
        l.layer.borderColor = #colorLiteral(red: 0.4835817814, green: 0.4836651683, blue: 0.4835640788, alpha: 1).cgColor
        l.constrainWidth(constant: frame.width - 126)
        l.isHide(true)
        return l
    }()
    lazy var priceTextField:SkyFloatingLabelTextField = {
        let t = SkyFloatingLabelTextField()
        t.textColor = .white
                      t.errorColor = .white
                      t.tintColor = .white
                      t.selectedTitleColor = .white
        t.titleColor = .white
        t.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        t.keyboardType = UIKeyboardType.numberPad
        t.placeholder = "enter price".localized
        t.addTarget(self, action: #selector(textFieldDidChange(text:)), for: .editingChanged)
        return t
    }()
    lazy var priceLabel = UILabel(text: "Per meter".localized, font: .systemFont(ofSize: 20), textColor: .black)
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    
    var handleTextContents:((Int,Bool)->Void)?
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var priceString:String!
    
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        priceLabel.isHide(true)
        backgroundColor = .white
        
        [categoryLabel,priceLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        mainView.addSubViews(views: priceTextField)
        priceTextField.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        let second = stack(categoryLabel,mainView,priceLabel,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 32, bottom: 0, right: 8))
        
    }
    
    @objc func textFieldDidChange(text: UITextField)  {
        mainView.layer.borderColor = UIColor.black.cgColor
        guard let texts = text.text else { return  }
        priceString = texts
        if let floatingLabelTextField = text as? SkyFloatingLabelTextField {
            if text == priceTextField {
                
                if  texts.count == 0 {
                    handleTextContents?(Int(priceString) ?? 0,false)
                    floatingLabelTextField.errorMessage = "Invalid Price".localized
                    
                }
                else {
                    
                    floatingLabelTextField.errorMessage = ""
                    handleTextContents?(Int(priceString) ?? 0,true)
                }
            }
        }
    }
    
    @objc func handleShowViews()  {
        showHidingViews(views: mainView,priceLabel, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3933"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}
