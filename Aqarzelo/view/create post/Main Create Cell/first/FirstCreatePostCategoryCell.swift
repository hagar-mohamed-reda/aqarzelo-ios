//
//  FirstCreatePostCategoryCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class FirstCreatePostCategoryCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.isUserInteractionEnabled = true
            [homeButton,appartmentButton,landButton,towerButton,villaButton,doublexButton,officeButton,chaleButton].forEach { (sender) in
                if sender.tag == aqar.categoryID {
                    sender.backgroundColor = ColorConstant.mainBackgroundColor
                    handleTextContents?(sender.tag,true)
                }
            }
            iconImageView.image = #imageLiteral(resourceName: "Group 3931")
        }
    }
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3924-1"))
                im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var categoryLabel = UILabel(text: "Category".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var categoryQuestionLabel = UILabel(text: "What kind of real estate category?".localized, font: .systemFont(ofSize: 18), textColor: .black)
    
    lazy var homeButton = createButtons(title: "Home".localized,tag: 1 )
    lazy var appartmentButton = createButtons(title: " Appartment  ".localized ,tag: 2)
    lazy var landButton = createButtons(title: "   Land    ".localized,tag: 3 )
    lazy var towerButton = createButtons(title: "  Towar   ".localized ,tag: 4)
    lazy var villaButton = createButtons(title: "   Villa   ".localized ,tag: 5)
    lazy var doublexButton = createButtons(title: "Doublex".localized ,tag: 6)
    lazy var officeButton = createButtons(title: "  Office  ".localized ,tag: 7)
    lazy var chaleButton = createButtons(title: "   Chalet  ".localized ,tag: 8)
    
    lazy var firstStack:UIStackView = {
        let b = hstack(homeButton,appartmentButton,landButton,spacing:8)
        return b
    }()
    lazy var firstssStack:UIStackView = {
        let b = hstack(towerButton,villaButton,doublexButton,spacing:8)
        return b
    }()
    lazy var secondStack:UIStackView = {
        let b = hstack(officeButton,chaleButton,UIView(),spacing:8)
        return b
    }()
    
    lazy var buttonStack:UIStackView = {
        let buttonStack = stack(firstStack,firstssStack,secondStack, spacing: 8, distribution: .fillEqually)
        buttonStack.isHide(true)
        return buttonStack
    }()
    
    var handleTextContents:((Int,Bool)->Void)?
    weak var createFirstListCollectionVC:CreateFirstListCollectionVC?
    
    
    
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
        b.tag = tag
        return b
    }
    
    @objc func handleChoosedButton(sender:UIButton)  {
        let views = [homeButton,appartmentButton,landButton,towerButton,villaButton,doublexButton,officeButton,chaleButton]
        
        colorBackgroundSelectedButton(sender: sender, views: views)
        //    [homeButton,appartmentButton,landButton,towerButton,villaButton,doublexButton,officeButton,chaleButton].forEach { (bt) in
        //        bt.setTitleColor(.black, for: .normal)
        //        bt.backgroundColor = .white
        //    }
        //    sender.backgroundColor = ColorConstant.mainBackgroundColor
        handleTextContents?(sender.tag,true)
        
    }
    
    @objc func handleShowViews()  {
        if self.createFirstListCollectionVC?.is2CellIsError == false {
            self.createFirstListCollectionVC?.creatMainSnackBar(message: "Title in Arabic Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: categoryQuestionLabel,buttonStack, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3931"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}
