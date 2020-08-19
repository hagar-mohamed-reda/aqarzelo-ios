//
//  SecondCreateFloorNumberCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class SecondCreateFloorNumberCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3943")
            customAddMinusView.numberOfItemsLabel.text = "\(aqar.floorNumber)"
            handleTextContents?(Int(aqar.floorNumber) ?? 0,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3951"))
        //        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var categoryLabel = UILabel(text: "Floor number".localized, font: .systemFont(ofSize: 20), textColor: .black)
    lazy var questionLabel:UILabel = {
        let l = UILabel(text: "What is the property floor number ?".localized, font: .systemFont(ofSize: 16), textColor: .black)
        //        l.constrainHeight(constant: 20)
        l.isHide(true)
        return l
    }()
    
    
    lazy var customAddMinusView:CustomAddMinusView = {
        let v = CustomAddMinusView()
        v.isHide(true)
        v.constrainHeight(constant: 40)
        v.constrainWidth(constant: (frame.width - 32 )/2)
        v.minusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMinusOne)))
        v.plusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddOne)))
        return v
    }()
    
    
    
    lazy var count = customAddMinusView.count
    
    var handleTextContents:((Int,Bool)->Void)?
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    
    override func setupViews() {
        backgroundColor = .white
        
        let ss = stack(iconImageView,UIView(),alignment:.center)//,distribution:.fill
        let dd = hstack(customAddMinusView)
        
        [questionLabel,categoryLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let second = stack(categoryLabel,questionLabel,dd,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
        
        
    }
    
    @objc func handleShowViews()  {
        showHidingViewsWithoutSepertor(views: customAddMinusView,questionLabel, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3943"))
        handleHidePreviousCell?(index)
    }
    
    @objc func handleAddOne()  {
        count += 1
        customAddMinusView.numberOfItemsLabel.text = "\(count)"
        handleTextContents?(count,true)
    }
    
    @objc func handleMinusOne()  {
        count = max( 0,count-1)
        customAddMinusView.numberOfItemsLabel.text = "\(count)"
        handleTextContents?(count,true)
    }
}
