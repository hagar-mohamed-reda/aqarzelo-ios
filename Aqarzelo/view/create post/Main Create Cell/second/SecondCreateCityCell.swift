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
            //            cityDrop.selectedIndex = aqar.cityID-1
            cityDrop.text = MOLHLanguage.isRTLLanguage() ? aqar.city?.nameAr :  aqar.city?.nameEn
            cityDrop.selectedIndex = aqar.cityID-1
            //            let cc = aqar.cityID
            //
            //                       let city = getCityFromIndex(cc)
            //            cityDrop.text = city
            //            if let arr = MOLHLanguage.isRTLLanguage() ? userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String] :  userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String] {
            //                       cityDrop.text = arr[aqar.cityID-1]
            //                   }
            
            
            handleTextContents?(aqar.cityID-1,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3946"))
        im.isUserInteractionEnabled = true
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
    
    lazy var mainDrop1View:UIView =  {
        
        let v = makeMainSubViewWithAppendView(vv: [cityDrop])
        v.hstack(cityDrop).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        v.isHide(true)
        v.constrainWidth(constant: frame.width - 140)//120
        return v
    }()
    
    lazy var cityDrop:DropDown = {
        let i = returnMainDropDown(plcae: "Select City".localized)
        if var arr = MOLHLanguage.isRTLLanguage() ? userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String] :  userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String] {
            
            i.optionArray = arr
        }
        i.constrainHeight(constant: 40)
        //        v.constrainWidth(constant: frame.width - 128)
        //        i.isHide(true)
        
        i.didSelect(completion: {[unowned self] (choosed, index, id) in
            self.handleTextContents?(self.cityIDSArray[index],true)
        })
        
        return i
    }()
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((Int?,Bool)->Void)?
    var handleOpenDropDown:((CGRect)->Void)?
    weak var createSecondListCollectionVC:CreateSecondListCollectionVC?
    var cityArray = [String]() //["one","two","three","sdfdsfsd"]
    
    var cityIDSArray = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        //        mainDrop1View.isUserInteractionEnabled=true
        
        
        categoryLabel.constrainHeight(constant: 30)
        backgroundColor = .white
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let dd = hstack(mainDrop1View,UIView())
        //        makeThissss(xx: mainDrop1View, cc: cityDrop, img: cityImage)
        
        let second = stack(categoryLabel,categoryQuestionLabel,dd,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
    }
    
    fileprivate func fetchData()  {
        
//        fetchEnglishData(isArabic: MOLHLanguage.isRTLLanguage())
        guard  let ff = cacheCityInCodabe.storedValue,let f = ff else {return}
        let xx = f.map({MOLHLanguage.isRTLLanguage() ? $0.nameAr : $0.nameEn});let ids = f.map({$0.id})
        self.cityArray = xx
        
        self.cityIDSArray=ids
        self.cityDrop.optionArray = cityArray
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
        
    }
    
    fileprivate func fetchEnglishData(isArabic:Bool) {
        if isArabic {
            
            
            if  let cityArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int]  {
                
                self.cityArray = cityArray
                self.cityIDSArray=cityIds
            }
        }else {
            if let cityArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int]  {
                
                self.cityArray = cityArray
                
                self.cityIDSArray=cityIds
            }
        }
        
        self.cityDrop.optionArray = cityArray
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
    }
    
    fileprivate func getCityFromIndex(_ index:Int) -> String {
        var citName = [String]()
        var cityId = [Int]()
        
        if MOLHLanguage.isRTLLanguage() {
            
            
            
            if let  cityArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int]{
                
                citName = cityArray
                cityId = cityIds
                
                
                
            }}else {
                if let cityArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int] {
                    citName = cityArray
                    cityId = cityIds
                }
            }
        let ss = cityId.filter{$0 == index}
        let ff = ss.first ?? 1
        
        return citName[ff - 1 ]
    }
    
    @objc func handleShowViews()  {
        if self.createSecondListCollectionVC?.is2CellIsError == false {
            self.createSecondListCollectionVC?.creatMainSnackBar(message: "Country Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: categoryQuestionLabel,mainDrop1View, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3938"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
    
    @objc  func handleOpenDrops()  {
        handleOpenDropDown?(mainDrop1View.frame)
    }
}
