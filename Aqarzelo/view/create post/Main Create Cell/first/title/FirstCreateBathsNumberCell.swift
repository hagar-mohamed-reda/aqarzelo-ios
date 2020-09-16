//
//  FirstCreateBathsNumberCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class FirstCreateBathsNumberCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3935")
            iconImageView.isUserInteractionEnabled = true
            customAddMinusView.numberOfItemsLabel.text = "\(aqar.bathroomNumber)"
            handleTextContents?(Int(aqar.bathroomNumber) ?? 0,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3928"))
        //        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    
    lazy var categoryLabel = UILabel(text: "Bathrooms number".localized, font: .systemFont(ofSize: 20), textColor: .black)
    lazy var questionLabel:UILabel = {
        let l = UILabel(text: "How many baths ?".localized, font: .systemFont(ofSize: 16), textColor: .black)
        //        l.constrainHeight(constant: 20)
        l.isHide(true)
        return l
    }()
    lazy var customAddMinusView:CustomAddMinusView = {
        let v = CustomAddMinusView()
        v.isHide(true)
        v.constrainHeight(constant: 40)
        v.constrainWidth(constant: (frame.width - 48 )/2)
        v.minusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMinusOne)))
        v.plusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddOne)))
        return v
    }()
    lazy var count = customAddMinusView.count
    
    var handleTextContents:((Int,Bool)->Void)?
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        backgroundColor = .white
        
        [categoryLabel,questionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let dd = hstack(customAddMinusView)
        
        let second = stack(categoryLabel,questionLabel,dd,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 32, bottom: 0, right: 8))
    }
    
    @objc func handleShowViews()  {
        showHidingViews(views: customAddMinusView,questionLabel, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3935"), seperator: seperatorView)
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
