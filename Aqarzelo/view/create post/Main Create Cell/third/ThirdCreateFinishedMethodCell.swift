//
//  ThirdCreateFinishedMethodCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class ThirdCreateFinishedMethodCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.isUserInteractionEnabled = true
            iconImageView.image = #imageLiteral(resourceName: "Group 3958")
            
            if aqar.finishingType == "without_finished" {
                noButton.backgroundColor = ColorConstant.mainBackgroundColor
                
                handleTextssContents?(noButton.tag,true)
                handleTextssContentsSecondChange?(0, true)
                //                handleTextContents?(FinishedTypeEnum.without_finished.rawValue, true)
            }else {
                //                [semiFinishedButton,luxButton,superLuxButton,extraSuperLuxButton,withoutFinishedButton].forEach { (sender) in
                
                
                switch aqar.finishingType {
                case FinishedTypeEnum.semi_finished.rawValue:
                    semiFinishedButton.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextssContentsSecondChange?( 1,true)
                case FinishedTypeEnum.lux.rawValue:
                    luxButton.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextssContentsSecondChange?( 2,true)
                case FinishedTypeEnum.super_lux.rawValue:
                    superLuxButton.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextssContentsSecondChange?( 3,true)
                case FinishedTypeEnum.extra_super_lux.rawValue:
                    extraSuperLuxButton.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextssContentsSecondChange?( 4,true)
                    
                    
                default:
                    withoutFinishedButton.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextssContentsSecondChange?( 5,true)
                }
            }
            //            }
            
            
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3949"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var categoryLabel = UILabel(text: "Finished".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var categoryQuestionLabel:UILabel =  {
        let l = UILabel(text: "Is The Property Finished ?".localized, font: .systemFont(ofSize: 18), textColor: .black)
        l.isHide(true)
        //        l.constrainHeight(constant: 20)
        return l
    }()
    lazy var yesButton = createButtons(title: "Yes".localized, tag: 1 )
    lazy var noButton = createButtons(title: "No".localized, tag: 2 )
    
    lazy var categorySecondQuestionLabel:UILabel =  {
        let l = UILabel(text: "Is The Property Finished ?".localized, font: .systemFont(ofSize: 18), textColor: .black)
        return l
    }()
    
    lazy var semiFinishedButton = createSecondButtons(title: FinishedTypeEnum.semi_finished.rawValue, tag: 1)
    lazy var luxButton = createSecondButtons(title: FinishedTypeEnum.lux.rawValue, tag: 2)
    lazy var superLuxButton = createSecondButtons(title: FinishedTypeEnum.super_lux.rawValue, tag: 3)
    lazy var extraSuperLuxButton = createSecondButtons(title: FinishedTypeEnum.extra_super_lux.rawValue, tag: 4)
    lazy var withoutFinishedButton = createSecondButtons(title: FinishedTypeEnum.without_finished.rawValue, tag: 5)
    
    lazy var firstStack:UIStackView = {
        let b = hstack(semiFinishedButton,luxButton,spacing:8)
        return b
    }()
    lazy var firstssStack:UIStackView = {
        let b = hstack(superLuxButton,extraSuperLuxButton,spacing:8)
        return b
    }()
    lazy var secondStack:UIStackView = {
        let b = hstack(withoutFinishedButton,UIView(),spacing:8)
        return b
    }()
    //
    lazy var totalStackFinished:UIStackView = {
        let b = stack(categorySecondQuestionLabel,firstStack,firstssStack,secondStack,spacing:8)
        b.isHide(true)
        return b
    }()
    lazy var totalFirstStackFinished:UIStackView = {
        let b = stack(categoryQuestionLabel,buttonStack,spacing:8,distribution: .fillProportionally)
        b.isHide(true)
        buttonStack.constrainWidth(constant: frame.width - 120)
        return b
    }()
    lazy var buttonStack:UIStackView = {
        let buttonStack = hstack(yesButton,noButton, spacing: 8, distribution: .fillEqually)
        //        buttonStack.isHide(true)
        return buttonStack
    }()
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextssContents:((Int,Bool)->Void)?
    var handleTextssContentsSecondChange:((Int,Bool)->Void)?
    var handleTextContents:((String,Bool)->Void)?
    weak var createThirddListCollectionVC:CreateThirddListCollectionVC?
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        backgroundColor = .white
        [categoryLabel,categoryQuestionLabel,categorySecondQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let second = stack(categoryLabel,totalFirstStackFinished,totalStackFinished,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 20, bottom: 0, right: 8))
        
    }
    
    func createButtons(title:String,tag:Int) -> UIButton {
        let b = UIButton()
        b.setTitle(title, for: .normal)
        b.setTitleColor(  .black , for: .normal)
        //         b.setTitleColor(  .white , for: .selected)
        b.addTarget(self, action: #selector(handleChoosedButton), for: .touchUpInside)
        b.titleLabel?.font = .systemFont(ofSize: 14)
        //        let b = UIButton(title: title, titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleChoosedButton))
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = #colorLiteral(red: 0.1809101701, green: 0.6703525782, blue: 0.6941398382, alpha: 1).cgColor
        b.tag = tag
        
        //        b.backgroundColor = b.isSelected ? .white :  ColorConstant.mainBackgroundColor
        b.constrainWidth(constant: 120)
        //        b.se
        return b
    }
    
    func createSecondButtons(title:String,tag:Int) -> UIButton {
        let b = UIButton(title: title, titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleChoosedButtonDetails))
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = #colorLiteral(red: 0.1809101701, green: 0.6703525782, blue: 0.6941398382, alpha: 1).cgColor
        b.tag = tag
        
        //                b.constrainWidth(constant: 120)
        return b
    }
    
    @objc func handleChoosedButton(sender:UIButton)  {
        let views = [yesButton,noButton]
        
        colorBackgroundSelectedButton(sender: sender, views: views)
        sender.backgroundColor = ColorConstant.mainBackgroundColor
        
        handleTextssContents?(sender.tag,true)
        
        totalStackFinished.isHidden = sender.tag == 2 ? true : false
        //        sender.tag == 2 ? handleTextContents?(FinishedTypeEnum.without_finished.rawValue, true) : handleTextContents?(FinishedTypeEnum.without_finished.rawValue, false)
        sender.tag == 2 ? handleTextssContentsSecondChange?(5, true) : handleTextssContentsSecondChange?(0, false)
    }
    
    @objc  func handleChoosedButtonDetails(sender:UIButton)  {
        let views = [semiFinishedButton,luxButton,superLuxButton,extraSuperLuxButton,withoutFinishedButton]
        
        colorBackgroundSelectedButton(sender: sender, views: views)
        sender.backgroundColor = ColorConstant.mainBackgroundColor
        //        handleTextContents?(sender.titleLabel!.text!,true)
        handleTextssContentsSecondChange?(sender.tag,true)
    }
    
    @objc func handleShowViews()  {
        if aqar != nil {
            [semiFinishedButton,luxButton,superLuxButton,extraSuperLuxButton,withoutFinishedButton].forEach { (sender) in
                yesButton.backgroundColor = ColorConstant.mainBackgroundColor
                totalStackFinished.isHide(false)
                totalFirstStackFinished.isHide(false)
                if sender.tag == getNameAccordingToTag(text: aqar?.finishingType ?? "" ){
                    sender.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextssContentsSecondChange?(sender.tag,true)
                }
                //                if sender.titleLabel!.text?.lowercased() == aqar?.finishingType {
                //                    sender.backgroundColor = ColorConstant.mainBackgroundColor
                //                    handleTextContents?(sender.titleLabel!.text!.lowercased(), true)
                //                }
            }
        }
        
        if self.createThirddListCollectionVC?.is1CellIError == false {
            self.createThirddListCollectionVC?.creatMainSnackBar(message: "Payment method Should Be Filled First...".localized)
            return
        }
        
        showHidingViews(views: categoryQuestionLabel,totalFirstStackFinished, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3942"), seperator: seperatorView)
        
        handleHidePreviousCell?(index)
    }
    
    func getNameAccordingToTag(text:String) -> Int  {
        switch text {
        case FinishedTypeEnum.semi_finished.rawValue :
            return  1
        case FinishedTypeEnum.lux.rawValue:
            return 2
        case FinishedTypeEnum.super_lux.rawValue:
            return 3
        case FinishedTypeEnum.extra_super_lux.rawValue:
            return 4
            
        default:
            return 5
        }
    }
}
