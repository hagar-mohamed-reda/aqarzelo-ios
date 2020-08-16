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
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3933")
            iconImageView.isUserInteractionEnabled = true
            self.getAreaAccordingToCityId(index: aqar.cityID)
            areaDrop.selectedIndex = aqar.areaID
            if  let foo = areaNumberArray.firstIndex(of: aqar.areaID){
            
            let xx = areaNameArray[foo]
            
            areaDrop.text = xx
            }
            self.handleTextContents?(aqar.areaID,true)
        }
    }
    
    func getIndexFrom(aqar:Int)  {
        if let areaIdArra = userDefaults.value(forKey: UserDefaultsConstants.areaIdsArrays) as? [Int],let areaIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int],let areasStringArray = userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String]  {
            //            self.areaNumberArray = cityIdArra
            
            //            let areas = areaIdArray.indexes(of: index)
            //            areasFilteredArray.forEach { (s) in
            //                areaNumberArray.append(areaIdArra[s])
            //            }
            //            areasFilteredArray.forEach { (index) in
            //
            //                areaNameArray.append(areasStringArray[index])
            //
            //            }
            //
            //            self.areaDrop.optionArray = areaNameArray
            //
            //            DispatchQueue.main.async {
            //                self.layoutIfNeeded()
            //            }
        }
    }
    
    var cityId:Int?{
        didSet {
            guard let cityId = cityId else { return  }

            if cityId == 0 {
                return
            }
            getAreaAccordingToCityId(index: cityId)
        }
    }
    
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3947"))
        //        im.isUserInteractionEnabled = true
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
        //        l.constrainHeight(constant: 20)
        return l
    }()
    lazy var areaDrop:DropDown = {
        let i = returnMainDropDown(plcae: "Select Area".localized)
        i.constrainWidth(constant: frame.width - 128)
        i.constrainHeight(constant: 40)
        i.isHide(true)
        
        i.didSelect(completion: {[unowned self] (choosed, index, id) in
            self.handleTextContents?(self.areaNumberArray[index],true)
        })
        
        return i
    }()
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((Int?,Bool)->Void)?
    
    var areaNumberArray = [Int]()
    var areaNameArray = [String]()
    
    fileprivate func getAreaAccordingToCityId(index:Int)  {
        areaNumberArray.removeAll()
        areaNameArray.removeAll()
        
        if let cityIdArra = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int],let areaIdArra = userDefaults.value(forKey: UserDefaultsConstants.areaIdsArrays) as? [Int],let areaIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int],let areasStringArray =  MOLHLanguage.isRTLLanguage() ? userDefaults.value(forKey: UserDefaultsConstants.areaNameArabicArray) as? [String] : userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String]  {
            //            self.areaNumberArray = cityIdArra
            
            let areas = cityIdArra[index]
            let areasFilteredArray = areaIdArray.indexes(of: areas)
            areasFilteredArray.forEach { (s) in
                areaNumberArray.append(areaIdArra[s])
            }
            areasFilteredArray.forEach { (indexx) in
                
                
                areaNameArray.append( areasStringArray[index])
                
            }
            
            self.areaDrop.optionArray = areaNameArray
            
            DispatchQueue.main.async {
                self.layoutIfNeeded()
            }
        }
    }
    
    override func setupViews() {
        
        backgroundColor = .white
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let dd = hstack(areaDrop,UIView())
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let second = stack(categoryLabel,categoryQuestionLabel,dd,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
    }
    
    @objc func handleShowViews()  {
        showHidingViews(views: categoryQuestionLabel,areaDrop, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3933"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}
