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
            
            getCategoryIds(aqar.categoryID)
            handleTextContents?(aqar.categoryID,true)
            iconImageView.image = #imageLiteral(resourceName: "Group 3931")
        }
    }
    
    func getCategoryIds(_ ids:Int)  {
        let ss = categoryIds.indexes(of: ids)
        guard  let s = ss.first else { return  }
        
        if  let cell = categoryCollectionVC.collectionView.cellForItem(at: IndexPath(item: s, section: 0)) as? CategoryCollectionCell {
            cell.landButton.setTitleColor(.white, for: .normal)
            cell.landButton.backgroundColor = ColorConstant.mainBackgroundColor
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
    
    lazy var categoryQuestionLabel = UILabel(text: "What kind of real estate category?".localized, font: .systemFont(ofSize: 16), textColor: .black)
    
    
    lazy var categoryCollectionVC:CategoryCollectionVC = {
        let v = CategoryCollectionVC()
        v.view.isHidden=true
        v.handleChossenCategory={[unowned self] ids in
            self.handleTextContents?(ids,true)
        }
        return v
    }()
    var handleTextContents:((Int,Bool)->Void)?
    weak var createFirstListCollectionVC:CreateFirstListCollectionVC?
    var categoryIds = [Int]()
    var categoryNames = [String]()
    
    
    
    override func setupViews() {
        fetchData()
        categoryLabel.constrainHeight(constant: 30)
        categoryQuestionLabel.isHide(true)
        backgroundColor = .white
        
        [categoryLabel,categoryQuestionLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let second = stack(categoryLabel,categoryQuestionLabel,categoryCollectionVC.view,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 32, bottom: 0, right: 8))
    }
    
    fileprivate func fetchData()  {
        
        fetchEnglishData(isArabic: MOLHLanguage.isRTLLanguage())
    }
    
    fileprivate func fetchEnglishData(isArabic:Bool) {
        if isArabic {
            
            
            if  let cityArray = userDefaults.value(forKey: UserDefaultsConstants.categoryNameArabicArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.categoryIdsArray) as? [Int]  {
                
                putData(cityIds,cityArray)
            }
        }else {
            if let cityArray = userDefaults.value(forKey: UserDefaultsConstants.categoryNameArray) as? [String],let cityIds = userDefaults.value(forKey: UserDefaultsConstants.categoryIdsArray) as? [Int]  {
                putData(cityIds,cityArray)  }
        }
        DispatchQueue.main.async {
            self.categoryCollectionVC.collectionView.reloadData()
            self.layoutIfNeeded()
        }
    }
    
    func putData(_ ids:[Int],_ ss:[String])  {
        categoryIds=ids
        categoryNames=ss
        categoryCollectionVC.categoryNames=ss
        categoryCollectionVC.categoryIds=ids
    }
    
    
    @objc func handleShowViews()  {
        if self.createFirstListCollectionVC?.is2CellIsError == false {
            self.createFirstListCollectionVC?.creatMainSnackBar(message: "Title in Arabic Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: categoryQuestionLabel,categoryCollectionVC.view, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3931"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}
