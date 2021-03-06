//
//  SecondCreateAreaCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import iOSDropDown
import MOLH


class SecondCreateAreaCell: BaseCollectionCell {
    
    var categroy_id:Int? {
        didSet{
            guard let categroy_id = categroy_id else { return  }
            let x = categroy_id == 4 ? true : false
            
            if x {
                seperatorView.isHide(true)
               ss =  stack(iconImageView,UIView(),alignment:.center)
                setupViews()
            }else {
                seperatorView.isHide(false)
                ss =  stack(iconImageView,seperatorView,alignment:.center)
                setupViews()
            }
//            setupViews()
        }
    }
    
    var finalFilteredAreaNames:[String]? {
        didSet{
            guard let finalFilteredAreaNames = finalFilteredAreaNames else { return  }
            areaDrop.optionArray=finalFilteredAreaNames
        }
    }
    var allAreasSelectedArray = [Int]()
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3933")
            iconImageView.isUserInteractionEnabled = true
            let aa = aqar.areaID
            self.getAreaAccordingToCityId(index: aqar.cityID-1)
            let area = getAreassFromIndex( aa)
            areaDrop.selectedIndex = area-1
            areaDrop.text = MOLHLanguage.isRTLLanguage() ?  aqar.area?.nameAr : aqar.area?.nameEn
            //            if  let foo = areaIDSArray.firstIndex(of: aqar.areaID){
            //
            //            let xx = areaArray[foo]
            //
            //            areaDrop.text = xx
            //            }
            self.handleTextContents?(aqar.areaID,true)
        }
    }
    
//    var cityId:Int?{
//        didSet {
//            guard let cityId = cityId else { return  }
//            getAreaAccordingToCityId(index: cityId)
//        }
//    }
    
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3947"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var categoryLabel = UILabel(text: "Area".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var categoryQuestionLabel:UILabel =  {
        let l = UILabel(text: "Choose the Area".localized, font: .systemFont(ofSize: 18), textColor: .black)
        l.isHide(true)
        return l
    }()
    lazy var mainDrop1View:UIView =  {
        
        let v = makeMainSubViewWithAppendView(vv: [areaDrop])
        v.hstack(areaDrop).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        v.isHide(true)
        v.constrainWidth(constant: frame.width - 140)//120
        return v
    }()
    lazy var areaDrop:DropDown = {
        let i = returnMainDropDown(plcae: "Select Area".localized)
        i.constrainHeight(constant: 40)
        
        i.didSelect(completion: {[unowned self] (choosed, index, id) in
            self.handleTextContents?(self.allAreasSelectedArray[index],true)
        })
        
        return i
    }()
    lazy var ss = UIStackView()
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((Int?,Bool)->Void)?
    
    var cityArray = [String]() //["one","two","three","sdfdsfsd"]
    var areaArray = [String]()
    
    var cityIDSArray = [Int]() //["one","two","three","sdfdsfsd"]
    var areaIDSArray = [Int]()
    weak var createSecondListCollectionVC:CreateSecondListCollectionVC?
    
    fileprivate func getAreaAccordingToCityId(index:Int)  {
        areaIDSArray.removeAll()
        areaArray.removeAll()
        
        if let  cityIdArra = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int],let areaIdArra = userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int],let areaIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaIdsArrays) as? [Int],let areasStringArray =  MOLHLanguage.isRTLLanguage() ? userDefaults.value(forKey: UserDefaultsConstants.areaNameArabicArray) as? [String] : userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String]  {
            //            self.areaNumberArray = cityIdArra
            
            let areas = self.cityIDSArray[index]
            
            let areasFilteredArray = areaIdArra.indexes(of: areas)
            areasFilteredArray.forEach { (s) in
                areaIDSArray.append(areaIdArra[s])
            }
            areasFilteredArray.forEach { (indexx) in
                
                
                areaArray.append( areasStringArray[indexx])
                
            }
            
            self.areaDrop.optionArray = areaArray
            
            DispatchQueue.main.async {
                self.layoutIfNeeded()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fetchData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fetchData()  {
        
        fetchEnglishData(isArabic: MOLHLanguage.isRTLLanguage())
    }
    
    fileprivate func getAreassFromIndex(_ index:Int) -> Int {
        var citName = [String]()
        var cityId = [Int]()
        
        if MOLHLanguage.isRTLLanguage() {
            
            
            
            if let  cityArray = userDefaults.value(forKey: UserDefaultsConstants.areaNameArabicArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int]{
                
                citName = cityArray
                cityId = cityIds
                
                
                
            }}else {
            if let cityArray = userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int] {
                citName = cityArray
                cityId = cityIds
            }
        }
        let ss = cityId.filter{$0 == index}
        
        let ff = ss.first ?? 1
        
        return cityId[ff - 1 ]
    }
    
    fileprivate func fetchEnglishData(isArabic:Bool) {
        if isArabic {
            
            
            if  let cityArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int],let degreeNames = userDefaults.value(forKey: UserDefaultsConstants.areaNameArabicArray) as? [String] , let degreeIds =  userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int]  {
                
                self.cityArray = cityArray
                self.areaArray = degreeNames
                self.cityIDSArray = cityIds
                areaIDSArray = degreeIds
            }
        }else {
            if let cityArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int],let degreeNames = userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String] , let degreeIds =  userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int]  {
                
                self.cityArray = cityArray
                self.areaArray = degreeNames
                self.cityIDSArray = cityIds
                areaIDSArray = degreeIds
                
            }
        }
        
        self.areaDrop.optionArray = areaArray
        DispatchQueue.main.async {
            self.layoutIfNeeded()
        }
    }
    
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        backgroundColor = .white
//        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let dd = hstack(mainDrop1View,UIView())
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let second = stack(categoryLabel,categoryQuestionLabel,dd,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
    }
    
    @objc func handleShowViews()  {
        if self.createSecondListCollectionVC?.is3CellIsError == false {
            self.createSecondListCollectionVC?.creatMainSnackBar(message: "City Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: categoryQuestionLabel,mainDrop1View, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3933"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}
