//
//  SecondCreateCityCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH
import iOSDropDown

class SecondCreateCityCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3938")
            iconImageView.isUserInteractionEnabled = true
            cityDrop.selectedIndex = aqar.cityID-1
            if let arr = MOLHLanguage.isRTLLanguage() ? userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String] :  userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String] {
                       cityDrop.text = arr[aqar.cityID-1]
                   }
            
            
            handleTextContents?(aqar.cityID-1,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3946"))
        //        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var categoryLabel = UILabel(text: "City".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var categoryQuestionLabel:UILabel =  {
        let l = UILabel(text: "Choose the city".localized, font: .systemFont(ofSize: 18), textColor: .black)
        l.isHide(true)
        //        l.constrainHeight(constant: 20)
        return l
    }()
    lazy var cityDrop:DropDown = {
        let i = returnMainDropDown(plcae: "Select City".localized)
        if let arr = MOLHLanguage.isRTLLanguage() ? userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String] :  userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String] {
            i.optionArray = arr
        }
        i.constrainHeight(constant: 40)
        i.constrainWidth(constant: frame.width - 128)
        i.isHide(true)
        
        i.didSelect(completion: {[unowned self] (choosed, index, id) in
            self.handleTextContents?(index,true)
        })
        
        return i
    }()
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((Int?,Bool)->Void)?
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        backgroundColor = .white
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let dd = hstack(cityDrop,UIView())
        
        let second = stack(categoryLabel,categoryQuestionLabel,dd,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
    }
    
    @objc func handleShowViews()  {
        showHidingViews(views: categoryQuestionLabel,cityDrop, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3938"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}
