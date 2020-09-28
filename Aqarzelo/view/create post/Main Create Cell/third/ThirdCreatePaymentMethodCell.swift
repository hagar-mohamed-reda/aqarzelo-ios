//
//  ThirdCreatePaymentMethodCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class ThirdCreatePaymentMethodCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.isUserInteractionEnabled = true
            [cashButton,installmentButton].forEach { (sender) in
                if sender.titleLabel!.text!.lowercased() == aqar.paymentMethod {
                    sender.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextContents?(sender.titleLabel!.text!.lowercased(),true)
                }
            }
            iconImageView.image = #imageLiteral(resourceName: "Group 3958")
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3955"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var categoryLabel = UILabel(text: "Payment method".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var categoryQuestionLabel:UILabel =  {
        let l = UILabel(text: "How to pay ?".localized, font: .systemFont(ofSize: 18), textColor: .black,textAlignment: .left,numberOfLines: 2)
        l.isHide(true)
        //        l.constrainHeight(constant: 20)
        return l
    }()
    lazy var cashButton = createButtons(title: "Cash".localized ,tag: 1)
    lazy var installmentButton = createButtons(title: "Installment".localized ,tag: 2)
    
    lazy var buttonStack:UIStackView = {
        let buttonStack = hstack(cashButton,installmentButton, spacing: 8, distribution: .fillProportionally)
        buttonStack.isHide(true)
        buttonStack.constrainWidth(constant: frame.width - 120)
        return buttonStack
    }()
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((String,Bool)->Void)?
    weak var createThirddListCollectionVC:CreateThirddListCollectionVC?
    
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        categoryQuestionLabel.isHide(true)
        backgroundColor = .white
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let second = stack(categoryLabel,categoryQuestionLabel,buttonStack,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 20, bottom: 0, right: 8))
    }
    
    func createButtons(title:String,tag:Int) -> UIButton {
        let b = UIButton(title: title, titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleChoosedButton))
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = #colorLiteral(red: 0.1809101701, green: 0.6703525782, blue: 0.6941398382, alpha: 1).cgColor
        //        b.constrainWidth(constant: 120)
        b.tag = tag
        return b
    }
    
    @objc func handleChoosedButton(sender:UIButton)  {
        let views = [cashButton,installmentButton]
        
        colorBackgroundSelectedButton(sender: sender, views: views)
        sender.backgroundColor = ColorConstant.mainBackgroundColor
        handleTextContents?(sender.titleLabel!.text!.lowercased(),true)
    }
    
    @objc func handleShowViews()  {
        if self.createThirddListCollectionVC?.is2CellIsError == false {
            self.createThirddListCollectionVC?.creatMainSnackBar(message: "Owner type Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: categoryQuestionLabel,buttonStack, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3959"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}
