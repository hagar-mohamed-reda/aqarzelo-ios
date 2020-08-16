//
//  FirstCreateSellOrRentCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class FirstCreateSellOrRentCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            [sellButton,rentButton].forEach { (sender) in
                let type = aqar.type
                switch type {
                case PostTypeEnum.sale.rawValue:
                    colorBackgroundSelectedButton(sender: sellButton, views: [rentButton])
                     handleTextContents?(type,true)
                default:
                    colorBackgroundSelectedButton(sender: rentButton, views: [sellButton])
 handleTextContents?(type,true)
                }
                if sender.titleLabel?.text!.lowercased() == aqar.type {
                    sender.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextContents?(sender.titleLabel!.text!.lowercased(),true)
                }
            }
            iconImageView.image = #imageLiteral(resourceName: "Group 3932")
            iconImageView.isUserInteractionEnabled = true
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3925-1"))
        //        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var categoryLabel = UILabel(text: "Sale or rent".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var categoryQuestionLabel = UILabel(text: "What type of property offer ?".localized, font: .systemFont(ofSize: 18), textColor: .black)
    
    lazy var sellButton = createButtons(title: "Sale".localized ,tag: 0)
    lazy var rentButton = createButtons(title: "Rent".localized ,tag: 1)
    
    lazy var buttonStack:UIStackView = {
        let buttonStack = hstack(sellButton,rentButton,UIView(), spacing: 8)
        buttonStack.isHide(true)
        return buttonStack
    }()
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((String,Bool)->Void)?
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        categoryQuestionLabel.isHide(true)
        backgroundColor = .white
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let second = stack(categoryLabel,categoryQuestionLabel,buttonStack,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 32, bottom: 0, right: 8))
    }
    
    func createButtons(title:String,tag:Int) -> UIButton {
        let b = UIButton(title: title, titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleChoosedButton))
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = #colorLiteral(red: 0.1809101701, green: 0.6703525782, blue: 0.6941398382, alpha: 1).cgColor
        b.constrainWidth(constant: 50)
        b.tag  = tag
        return b
    }
    
    @objc func handleChoosedButton(sender:UIButton)  {
        let views = [sellButton,rentButton]
        colorBackgroundSelectedButton(sender: sender, views: views)
        let text = sender.tag == 0 ? PostTypeEnum.sale.rawValue :  PostTypeEnum.rent.rawValue
        
        handleTextContents?(text,true)
    }
    
    @objc func handleShowViews()  {
        showHidingViews(views: categoryQuestionLabel,buttonStack, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3932"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
    
    
}
