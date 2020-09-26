//
//  SecondCreateLocationCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class SecondCreateLocationCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3930")
            guard let lat = Double(aqar.lat), let longi = Double(aqar.lng) else {return}
            handlerNext?(lat,longi,true)
            mapButton.backgroundColor = ColorConstant.mainBackgroundColor
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3945"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        im.contentMode = .scaleAspectFit
        im.clipsToBounds = true
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var categoryLabel = UILabel(text: "Location".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var categoryQuestionLabel = UILabel(text: "Select the location from the map".localized, font: .systemFont(ofSize: 16), textColor: .black)
    lazy var mapButton:UIButton = {
        let b = UIButton(title: "Map".localized, titleColor: .black, font: .systemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleChoosedLocation))
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.layer.borderWidth = 1
        b.layer.borderColor = #colorLiteral(red: 0.1809101701, green: 0.6703525782, blue: 0.6941398382, alpha: 1).cgColor
        b.constrainWidth(constant: 90)
        b.constrainHeight(constant: 40)
        b.isHide(true)
        return b
    }()
    
    var handlerChooseLocation:(()->Void)?
    var handlerNext:((Double,Double,Bool)->Void)?
     weak var createSecondListCollectionVC:CreateSecondListCollectionVC?
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        categoryQuestionLabel.isHide(true)
        backgroundColor = .white
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let dd = hstack(mapButton,UIView())
        let second = stack(categoryLabel,categoryQuestionLabel,dd,UIView(),spacing:8)
        hstack(ss,second,UIView(),spacing: 16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
    }
    
    @objc  func handleChoosedLocation()  {
        handlerChooseLocation?()
    }
    
    @objc func handleShowViews()  {
        
        showHidingViews(views: categoryQuestionLabel,mapButton, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3937"), seperator: seperatorView)
        self.createSecondListCollectionVC?.is1CellIsOpen=true
        self.createSecondListCollectionVC?.collectionView.reloadData()
    }
}
