//
//  ThirdCreateMoreCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class ThirdCreateMoreCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.isUserInteractionEnabled = true
            iconImageView.image = #imageLiteral(resourceName: "Group 3958")
            [furnishedButton,parkingButton,gardenButton].forEach { (sender) in
                if  aqar.hasGarden == 1 {
                    gardenButton.setImage(#imageLiteral(resourceName: "Rectangle 155-1"), for: .normal)
                    handleTextContents?(gardenButton.tag,true)
                }else if aqar.hasParking == 1 {
                    parkingButton.setImage(#imageLiteral(resourceName: "Rectangle 155-1"), for: .normal)
                    handleTextContents?(parkingButton.tag,true)
                }else {
                    furnishedButton.setImage(#imageLiteral(resourceName: "Rectangle 155-1"), for: .normal)
                    handleTextContents?(furnishedButton.tag,true)
                }
                
                
            }
        }
        
        
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3956"))
                im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var categoryLabel = UILabel(text: "More".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    
    
    
    lazy var furnishedLabel:UILabel =  {
        let l = UILabel(text: " Furnished".localized, font: .systemFont(ofSize: 18), textColor: .black)
        return l
    }()
    lazy var parkingLabel:UILabel =  {
        let l = UILabel(text: " Parking".localized, font: .systemFont(ofSize: 18), textColor: .black)
        return l
    }()
    lazy var gardenLabel:UILabel =  {
        let l = UILabel(text: " Garden".localized, font: .systemFont(ofSize: 18), textColor: .black)
        return l
    }()
    
    lazy var furnishedButton = createButtons(tag: 0)
    lazy var parkingButton = createButtons(tag: 1)
    lazy var gardenButton = createButtons(tag: 2)
    
    lazy var firstStack:UIStackView = {
        let b =  hstack(furnishedButton,furnishedLabel,spacing:8)
        return b
    }()
    lazy var secondStack:UIStackView = {
        let b = hstack(parkingButton,parkingLabel,spacing:8)
        return b
    }()
    lazy var thirdStack:UIStackView = {
        let b = hstack(gardenButton,gardenLabel,spacing:8)
        return b
    }()
    //
    lazy var totalStackFinished:UIStackView = {
        let b = stack(firstStack,secondStack,thirdStack,spacing:8)
        b.isHide(true)
        return b
    }()
    
    var index:Int = 1
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((Int,Bool)->Void)?
    
    override func setupViews() {
        
        
        backgroundColor = .white
        
        [categoryLabel,gardenLabel,parkingLabel,parkingLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,UIView(),alignment:.center)//,distribution:.fill
        let second = stack(categoryLabel,totalStackFinished,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 20, bottom: 0, right: 8))
        
    }
    
    func createButtons(tag:Int) -> UIButton {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "Rectangle 159"), for: .normal)
        b.addTarget(self, action: #selector(handleChoosedButton), for: .touchUpInside)
        b.tag = tag
        b.constrainWidth(constant: 20)
        return b
    }
    
    
    
    @objc func handleChoosedButton(sender:UIButton)  {
        [furnishedButton,parkingButton,gardenButton].forEach({$0.setImage(#imageLiteral(resourceName: "Rectangle 159"), for: .normal)})
        
        sender.setImage(#imageLiteral(resourceName: "Rectangle 155-1"), for: .normal)
        handleTextContents?(sender.tag,true)
        
    }
    
    @objc func handleShowViews()  {
        //        [c,c2,c3,c4].forEach({$0.isHide(false)})
        showHidingViewsWithoutSepertor(views: totalStackFinished, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3960"))
        handleHidePreviousCell?(index)
    }
}
