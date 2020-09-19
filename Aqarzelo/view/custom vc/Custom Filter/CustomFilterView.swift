//
//  CustomFilterView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import iOSDropDown
//import RangeSeekSlider
import MOLH

class CustomFilterView:CustomBaseView {
    
    
    //    lazy var mainDrop1View:UIView =  makeMainSubViewWithAppendView(vv: [cityDrop,cityImage])
    //    lazy var cityDrop = UILabel(text: "City".localized, font: .systemFont(ofSize: 16), textColor: .black)
    //    lazy var cityImage:UIImageView = {
    //        let i = UIImageView(image: UIImage(named: "arrow-pointing-downwards(1)"))
    //        i.contentMode = .scaleAspectFit
    //
    //        return i
    //    }()
    //
    //    lazy var mainDrop2View:UIView =  makeMainSubViewWithAppendView(vv: [areaDrop,areaImage])
    //    lazy var areaDrop = UILabel(text: "Area".localized, font: .systemFont(ofSize: 16), textColor: .black)
    //    lazy var areaImage:UIImageView = {
    //        let i = UIImageView(image: UIImage(named: "arrow-pointing-downwards(1)"))
    //        i.contentMode = .scaleAspectFit
    //        return i
    //    }()
    //
    //    lazy var mainDrop3View:UIView =  makeMainSubViewWithAppendView(vv: [catDrop,catImage])
    //    lazy var catDrop = UILabel(text: "Category".localized, font: .systemFont(ofSize: 16), textColor: .black)
    //    lazy var catImage:UIImageView = {
    //        let i = UIImageView(image: UIImage(named: "arrow-pointing-downwards(1)"))
    //        i.contentMode = .scaleAspectFit
    //
    //        return i
    //    }()
    //
    //    lazy var mainDrop4View:UIView =  makeMainSubViewWithAppendView(vv: [typeDrop,typeImage])
    //    lazy var typeDrop = UILabel(text: "Type".localized, font: .systemFont(ofSize: 16), textColor: .black)
    //    lazy var typeImage:UIImageView = {
    //        let i = UIImageView(image: UIImage(named: "arrow-pointing-downwards(1)"))
    //        i.contentMode = .scaleAspectFit
    //
    //        return i
    //    }()
    lazy var mainDrop1View:UIView =  {
        
        let v = makeMainSubViewWithAppendView(vv: [cityDrop])
        v.hstack(cityDrop).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        return v
    }()
    lazy var cityDrop:DropDown = {
        let i = returnMainDropDown(plcae: "City".localized)
        i.constrainHeight(constant: 50)
        return i
    }()
    lazy var mainDrop2View:UIView =  {
        
        let v = makeMainSubViewWithAppendView(vv: [areaDrop])
        v.hstack(areaDrop).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        return v
    }()
    lazy var areaDrop:DropDown = {
        let i = returnMainDropDown(plcae: "Area".localized)
        i.constrainHeight(constant: 50)
        return i
    }()
    lazy var mainDrop3View:UIView =  {
        
        let v = makeMainSubViewWithAppendView(vv: [TypeDrop])
        v.hstack(TypeDrop).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        return v
    }()
    lazy var TypeDrop:DropDown = {
        let i = returnMainDropDown(plcae: "Type".localized)
        i.constrainHeight(constant: 50)
        i.optionArray = ["All".localized,"Sale".localized, "Rent".localized]
        
        return i
    }()
    lazy var mainDrop4View:UIView =  {
        
        let v = makeMainSubViewWithAppendView(vv: [categoryDrop])
        v.hstack(categoryDrop).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        return v
    }()
    lazy var categoryDrop:DropDown = {
        let i = returnMainDropDown(plcae: "Category".localized)
        i.constrainHeight(constant: 50)
        return i
    }()
    
    lazy var numRoomsLabel = UILabel(text: "Num Rooms".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var numOfBathsView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.9659802318, green: 0.9661383033, blue: 0.9659466147, alpha: 1))
        v.layer.cornerRadius = 16
        v.constrainHeight(constant: 50)
        return v
    }()
    lazy var numBathsLabel = UILabel(text: "Num Bathrooms".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.9008116722, green: 0.9009597301, blue: 0.9007802606, alpha: 1))
        v.constrainHeight(constant: 1)
        return v
    }()
    lazy var priceLabel = UILabel(text: "Price Per Meter.".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    
    lazy var minimumPriceLabel = UILabel(text: "0", font: .systemFont(ofSize: 16), textColor: .black )
    //     lazy var maxPriceLabel = UILabel(text: "1000000", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var maxPriceLabel = UILabel(text: "1000000", font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .right)
    lazy var spaceLabel = UILabel(text: "Space".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    
    lazy var priceSlider:RangeSlider = {
        let r = RangeSlider()
        r.minimumValue=0.0
        r.maximumValue=10000
        r.lowerValue=0.0
        r.upperValue=10000
        return r
    }()
    
    lazy var spaceSlider:RangeSlider = {
        let r = RangeSlider()
        r.minimumValue=330.0
        r.maximumValue=9906.0
        r.lowerValue=330.0
        r.upperValue=9906.0
        return r
    }()
    
    lazy var minimumSpaceLabel = UILabel(text: "330", font: .systemFont(ofSize: 16), textColor: .black)
    //    lazy var maxSpaceLabel = UILabel(text: "9906", font: .systemFont(ofSize: 16), textColor: .black)
    
    lazy var maxSpaceLabel = UILabel(text: "9906", font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .right)
    
    lazy var roomsMinusAddView = CustomAddMinusView()
    lazy var bathsMinusAddView = CustomAddMinusView()
    lazy var submitButton:UIButton = {
        let b = UIButton()
        b.setTitle("Submit".localized, for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.backgroundColor = ColorConstant.mainBackgroundColor
        b.constrainHeight(constant: 50)
        b.layer.cornerRadius = 16
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.8415495753, green: 0.937597096, blue: 0.9429816604, alpha: 1).cgColor
        b.clipsToBounds = true
        //           b.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return b
    }()
    //    lazy var mainStackView:UIStackView = {
    //        let mainStackView = getStack(views: dropStack,totalStack,total2Stack,seperatorView, spacing: 24, distribution: .fill, axis: .vertical)
    //        return mainStackView
    //    }()
    //    lazy var dropStack:UIStackView = {
    //        let dropStack = getStack(views: mainDrop1View,mainDrop2View,mainDrop3View,mainDrop4View, spacing: 16, distribution: .fillEqually, axis: .vertical)
    //        return dropStack
    //    }()
    lazy var mainStackView:UIStackView = {
        let mainStackView = getStack(views: dropStack,totalStack,total2Stack,seperatorView, spacing: 24, distribution: .fill, axis: .vertical)
        return mainStackView
    }()
    lazy var dropStack:UIStackView = {
        let dropStack = getStack(views: mainDrop1View,mainDrop2View,mainDrop3View,mainDrop4View, spacing: 16, distribution: .fillEqually, axis: .vertical)
        return dropStack
    }()
    lazy var totalStack:UIStackView = {
        let totalStack = getStack(views: numRoomsLabel,roomsMinusAddView, spacing: 8, distribution: .fillEqually, axis: .horizontal)
        return totalStack
    }()
    lazy var total2Stack:UIStackView = {
        let total2Stack = getStack(views: numBathsLabel,bathsMinusAddView, spacing: 8, distribution: .fillEqually, axis: .horizontal)
        return total2Stack
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = priceLabel.frame.origin.x
        let margidn: CGFloat = priceLabel.frame.origin.y+32
        
        let width = bounds.width - 2.0 * margin
        priceSlider.frame = CGRect(x: margin, y: margidn, width: width, height: 31.0)
        
        let marginss: CGFloat = spaceLabel.frame.origin.x
        let margidddn: CGFloat = spaceLabel.frame.origin.y+32
        
        //        let width = bounds.width - 2.0 * margin
        spaceSlider.frame = CGRect(x: marginss, y: margidddn, width: width, height: 31.0)
    }
    
    override func setupViews() {
        var priceStack :UIStackView
        var spaceStack:UIStackView
        if MOLHLanguage.isRTLLanguage() {
            [cityDrop,areaDrop,categoryDrop].forEach({$0.textAlignment = .right})
            [priceLabel,spaceLabel].forEach({$0.textAlignment = .right})
            [minimumPriceLabel,minimumSpaceLabel].forEach({$0.textAlignment = .left})
            [maxPriceLabel,maxSpaceLabel].forEach({$0.textAlignment = .right})
            //            [minimumPriceLabel,minimumSpaceLabel].forEach({$0.textAlignment = .left})
            //            [maxPriceLabel,maxSpaceLabel].forEach({$0.textAlignment = .right})
            
            priceStack = getStack(views: maxPriceLabel,minimumPriceLabel, spacing: 8, distribution: .fillEqually, axis: .horizontal)
            spaceStack = getStack(views: maxSpaceLabel,minimumSpaceLabel, spacing: 8, distribution: .fillEqually, axis: .horizontal)
        }else {
            priceStack = getStack(views: minimumPriceLabel,maxPriceLabel, spacing: 8, distribution: .fillEqually, axis: .horizontal)
            spaceStack = getStack(views: minimumSpaceLabel,maxSpaceLabel, spacing: 8, distribution: .fillEqually, axis: .horizontal)
            
        }
        
        
        
        addSubViews(views: mainStackView,submitButton,priceLabel,priceSlider,priceStack,spaceLabel,spaceSlider,spaceStack)
        
        mainStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 32, left: 16, bottom: 0, right: 16))
        priceLabel.anchor(top: mainStackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 32, left: 16, bottom: 0, right: 16))
        
        priceStack.anchor(top: priceLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 48, left: 16, bottom: 0, right: 16))
        
        spaceLabel.anchor(top: priceStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        
        spaceStack.anchor(top: spaceLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 48, left: 16, bottom: 0, right: 16))
        
        
        submitButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 8, right: 16))
    }
    
    
}

