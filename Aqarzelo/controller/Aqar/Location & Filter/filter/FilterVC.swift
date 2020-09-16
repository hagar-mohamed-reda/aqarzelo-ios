//
//  FilterVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//
import UIKit
import iOSDropDown
//import RangeSeekSlider
import SVProgressHUD
import MOLH
//import fluid_slider

protocol FilterVCProtocol {
    func getaqarsAccordingTo(citId:Int,areaId:Int,price1:Int,price2:Int,space1:Int,space2:Int,type:String,bedroom_number:Int,bathroom_number:Int,categoryId:Int)
}

class FilterVC: UIViewController {
    
    lazy var transparentView = UIView()
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .clear
        //        v.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1)//ColorConstant.mainBackgroundColor
        v.showsVerticalScrollIndicator=false
        return v
    }()
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.constrainHeight(constant: 820)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        v.constrainWidth(constant: view.frame.width)
        return v
    }()
    
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
//        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    
//    lazy var dropDownTableViewVC:DropDownAllTableViewVC = {
//        let v = DropDownAllTableViewVC()
//        v.view.layer.cornerRadius = 8
//        v.view.clipsToBounds=true
//        v.handleCheckedIndex = {[unowned self] types,select,index in
//            self.checkSelectedDropDown(types,select,index)
//            self.removeTransparentView()
//        }
//        return v
//    }()
//
//    func checkSelectedDropDown(_ type:String,_ seleced:String,_ index:Int)  {
//        if type == "city" {
//            self.customFilterView.cityDrop.text = seleced
//            self.getAreaAccordingToCityId(index: index-1)
//            self.selectedCityId = index
//        }else if type == "area" {
//            self.customFilterView.areaDrop.text = seleced
//            self.selectedAreaId = self.allAreasSelectedArray[index-1]
//
//        }else if type == "cat" {
//            self.customFilterView.catDrop.text = seleced
//            self.selectedCategoryId = self.categoryIdsArray[index]
//
//        }else if type == "type" {
//            self.customFilterView.typeDrop.text = seleced
//            self.selectedType = seleced
//        }
//    }
    lazy var customFilterView:CustomFilterView = {
        let v = CustomFilterView()
//        [v.mainDrop1View,v.mainDrop2View,v.mainDrop3View,v.mainDrop4View].forEach({$0.isUserInteractionEnabled=true})
//        v.mainDrop1View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCitys)))
//        v.mainDrop2View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAreas)))
//        v.mainDrop3View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCategoriess)))
//        v.mainDrop4View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTypess)))
//
//
//        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeTransparentView)))
        
        
        
                v.cityDrop.didSelect(completion: {[unowned self] (ss, index, id) in
                            self.getAreaAccordingToCityId(index: index)
                    self.selectedCityId = self.getCityFromIndex(index)
        
                })
                v.areaDrop.didSelect(completion: { [unowned self] (selected, index, _) in
                    self.selectedAreaId = self.allAreasSelectedArray[index]
                })
                v.categoryDrop.didSelect(completion: {[unowned self] (selected, index, _) in
                    self.selectedCategoryId = self.categoryIdsArray[index]
                    print(self.selectedCategoryId)
                })
                v.TypeDrop.didSelect(completion: {[unowned self] (selected, _, _) in
                    self.selectedType = selected
                })
        v.priceSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        v.spaceSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
        v.submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return v
    }()
    
    var finalFilteredAreaNames = [String]()
    var allAreasSelectedArray = [Int]()
    var delgate:FilterVCProtocol?
    var citysArray = [CityModel]()
    //    var categoriessArray = [CategoryModel]()
    var aresArray = [AreaModel]()
    
    var citysStringArray = [String]()
    var categoryStringArray = [String]()
    
    var areasStringArray = [String]()
    var citysNumberArray = [Int]()
    var numberOfRooms = 0
    var numberOfBaths = 0
    var minimuPrice = 0
    var maximumPrice = 100000
    
    var minimuSpace = 350
    var maximumSpace = 9906
    var selectedType = "Sale"
    var selectedCityId = 1
    var selectedAreaId = 1
    var selectedCategoryId = 1
    var allCategoriesSelectedArray = [Int]()
    var categoryIdsArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        //        makeThisss()
        setupNavigation()
        addOrMinusOperation()
        fetchData()
        scrollView.delegate=self
        statusBarBackgroundColor()
        
    }
    
    
    //MARK: - override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        hidedCustomWhiteViewTabBar(hide: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        removeDefaults()
    }
    
    //MARK:-User methods
    
    func removeDefaults()  {
        userDefaults.removeObject(forKey: UserDefaultsConstants.cityCahcedValue)
        userDefaults.removeObject(forKey: UserDefaultsConstants.areaCahcedValue)
        userDefaults.removeObject(forKey: UserDefaultsConstants.categoryCahcedValue)
        userDefaults.removeObject(forKey: UserDefaultsConstants.typeCahcedValue)
        userDefaults.synchronize()
    }
    
    fileprivate func fetchAreas(_ base: BaseAqarAreaModel?) {
        SVProgressHUD.dismiss()
        self.aresArray = []
        self.areasStringArray = []
        self.aresArray = base?.data ?? []
        
        self.aresArray.forEach({(area) in
            self.self.areasStringArray.append(area.nameEn)
        })
        //        self.customFilterView.areaDrop.optionArray =  self.areasStringArray
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate  func getAreaAccordingTo(id:Int)  {
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding....".localized)
        FilterServices.shared.getAreaAccordingToCity(id: citysNumberArray.firstIndex(of: id) ?? 1) {[unowned self] (base, error) in
            if let error=error{
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.activeViewsIfNoData();return
            }
            self.fetchAreas(base)
        }
    }
    
    //    fileprivate func fetchEnglishData() {
    //        if let cityNameArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String],let cityIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String],let categoryNames = userDefaults.value(forKey: UserDefaultsConstants.categoryNameArray) as? [String], let cateIds =  userDefaults.value(forKey: UserDefaultsConstants.categoryIdsArray) as? [Int] {
    //            self.citysStringArray = cityNameArray
    //            self.areasStringArray = cityIdArray
    //            self.categoryStringArray = categoryNames
    //            self.categoryIdsArray = cateIds
    //        }
    //        self.customFilterView.cityDrop.optionArray = self.citysStringArray
    //        self.customFilterView.areaDrop.optionArray = self.areasStringArray
    //        self.customFilterView.categoryDrop.optionArray = self.categoryStringArray
    //
    //        DispatchQueue.main.async {
    //            self.view.layoutIfNeeded()
    //        }
    //    }
    
    fileprivate func fetchEnglishData(isArabic:Bool) {
        if isArabic {
            
            
            if let cityNameArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArabicArray) as? [String],let cityIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaNameArabicArray) as? [String],let categoryNames = userDefaults.value(forKey: UserDefaultsConstants.categoryNameArabicArray) as? [String], let cateIds =  userDefaults.value(forKey: UserDefaultsConstants.categoryIdsArray) as? [Int] {
                self.citysStringArray = cityNameArray
                self.areasStringArray = cityIdArray
                self.categoryStringArray = categoryNames
                self.categoryIdsArray = cateIds
            }
        }else {
            if let cityNameArray = userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) as? [String],let cityIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String],let categoryNames = userDefaults.value(forKey: UserDefaultsConstants.categoryNameArray) as? [String], let cateIds =  userDefaults.value(forKey: UserDefaultsConstants.categoryIdsArray) as? [Int] {
                self.citysStringArray = cityNameArray
                self.areasStringArray = cityIdArray
                self.categoryStringArray = categoryNames
                self.categoryIdsArray = cateIds
            }
        }
                self.customFilterView.cityDrop.optionArray = self.citysStringArray
                self.customFilterView.areaDrop.optionArray = self.areasStringArray
                self.customFilterView.categoryDrop.optionArray = self.categoryStringArray
        
//        self.dropDownTableViewVC.cityDataSource=citysStringArray
//        self.dropDownTableViewVC.areaDataSource=areasStringArray
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func getCityFromIndex(_ index:Int) -> Int {
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
           
           return cityId[index ]
       }
    
    fileprivate func fetchData()  {
        
        fetchEnglishData(isArabic: MOLHLanguage.isRTLLanguage())
    }
    
    
    fileprivate func getAreaAccordingToCityId(index:Int)  {
        finalFilteredAreaNames.removeAll()
        allAreasSelectedArray.removeAll()
        
        if let cityIdArra = userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) as? [Int],let areaIdArra = userDefaults.value(forKey: UserDefaultsConstants.areaIdsArrays) as? [Int],let areaIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) as? [Int],let cityIdArray = userDefaults.value(forKey: UserDefaultsConstants.areaNameArray) as? [String]{
            self.citysNumberArray = cityIdArra
            
            let areas = citysNumberArray[index]
            let areasFilteredArray = areaIdArray.indexes(of: areas)
            areasFilteredArray.forEach { (s) in
                allAreasSelectedArray.append(areaIdArra[s])
            }
            areasFilteredArray.forEach { (index) in
                
                finalFilteredAreaNames.append(areasStringArray[index])
                
            }
            
                        self.customFilterView.areaDrop.optionArray = finalFilteredAreaNames
//            self.dropDownTableViewVC.areaDataSource=finalFilteredAreaNames
            DispatchQueue.main.async {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1)//ColorConstant.mainBackgroundColor
        
        
        view.addSubViews(views: scrollView)
        scrollView.fillSuperview(padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        scrollView.addSubview(mainView)
        mainView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        mainView.addSubViews(views: customFilterView)
        customFilterView.fillSuperview()
    }
    
    fileprivate  func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Filter".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    fileprivate func addOrMinusOperation() {
        customFilterView.roomsMinusAddView.handleAddClousre = {[unowned self] count in
            self.numberOfRooms = count
        }
        customFilterView.roomsMinusAddView.handleMinusClousre = {[unowned self] count in
            self.numberOfRooms = count
        }
        
        customFilterView.bathsMinusAddView.handleAddClousre = {[unowned self] count in
            self.numberOfBaths = count
        }
        customFilterView.bathsMinusAddView.handleMinusClousre = {[unowned self] count in
            self.numberOfBaths = count
        }
    }
    
    func addValues(min:Double,max:Double,minLabel:UILabel,maxLabel:UILabel,isPrcie:Bool)  {
        minLabel.text = String(Int(min))
        maxLabel.text = String(Int(max))
        if isPrcie {
            minimuPrice = Int(min)
            maximumPrice = Int(max)
        }else {
            minimuSpace = Int(min)
            maximumSpace = Int(max)
        }
        
    }
    
//    fileprivate func showDropDownMenu(_ v:UIView,type:String) {
//        let bView = v
//        dropDownTableViewVC.areaDataSource.removeAll();        dropDownTableViewVC.cityDataSource.removeAll()
//        ;  dropDownTableViewVC.categoryDataSource.removeAll(); dropDownTableViewVC.typeDataSource.removeAll()
//        if type == "city" {
//            dropDownTableViewVC.cityDataSource = citysStringArray
//        }else if type == "area" {
//            dropDownTableViewVC.areaDataSource = finalFilteredAreaNames//areasStringArray
//        }else if type == "cat" {
//            dropDownTableViewVC.categoryDataSource = categoryStringArray
//        }else if type == "type" {
//            dropDownTableViewVC.typeDataSource = ["Sale".localized, "Rent".localized]
//        }
//        dropDownTableViewVC.types=type
//        dropDownTableViewVC.tableView.reloadData()
//
//        let xx = dropDownTableViewVC.view!
//        let ff = bView.frame.origin.y + bView.frame.height + 5
//
//        let window = UIWindow.key
//        transparentView.frame = window?.frame ?? self.view.frame
//        self.view.addSubViews(views: transparentView,xx)
//
//        view.addSubview(xx)
//
//        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
//        transparentView.addGestureRecognizer(tapgesture)
//        transparentView.alpha = 0
//        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//            self.transparentView.alpha = 0.5
//            xx.fillSuperview(padding: .init(top: ff, left: 16, bottom: 0, right: 16))
//        }, completion: nil)
//    }
    
    
    //TODO:-Handle methods
    
    //MARK:-Handle drop down methods
    
//    @objc  func handleAreas()  {
//        showDropDownMenu(customFilterView.mainDrop2View, type: "area")
//        dropDownTableViewVC.view.isHide(dropDownTableViewVC.areaDataSource.count > 0 ? false : true)
//    }
//
//    @objc  func handleCategoriess()  {
//        showDropDownMenu(customFilterView.mainDrop3View, type: "cat")
//        dropDownTableViewVC.view.isHide(false)
//    }
//
//    @objc  func handleTypess()  {
//        showDropDownMenu(customFilterView.mainDrop4View, type: "type")
//        dropDownTableViewVC.view.isHide(false)
//    }
//
//    @objc  func handleCitys()  {
//        showDropDownMenu(customFilterView.mainDrop1View, type: "city")
//        dropDownTableViewVC.view.isHide(false)
//    }
    
//    @objc func removeTransparentView() {
//        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//            self.transparentView.alpha = 0
//            self.dropDownTableViewVC.view.removeFromSuperview()
//        }, completion: nil)
//    }
    
//    @objc func handleDismiss()  {
//        dismiss(animated: true, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//            self.transparentView.alpha = 0
//            self.dropDownTableViewVC.view.removeFromSuperview()
//            //            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
//        }, completion: nil)
//        //        [customNoInternetView,transparentView].forEach({$0.})
//    }
    
    @objc func rangeSliderValueChanged(slider:RangeSlider) {
        
        if slider === customFilterView.priceSlider {
            addValues(min: slider.lowerValue, max: slider.upperValue, minLabel: customFilterView.minimumPriceLabel, maxLabel: customFilterView.maxPriceLabel, isPrcie: true)
        } else  {
            addValues(min: slider.lowerValue, max: slider.upperValue, minLabel: customFilterView.minimumSpaceLabel, maxLabel: customFilterView.maxSpaceLabel, isPrcie: false)
        }
    }
    
    @objc fileprivate  func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate  func handleMinusOne()  {
        print(65)
    }
    
    @objc fileprivate func handleAddOne()  {
        print(65)
    }
    
    @objc fileprivate func handleSubmit()  {   delgate?.getaqarsAccordingTo(citId:selectedCityId,areaId:selectedAreaId,price1:minimuPrice,price2:maximumPrice,space1:minimuSpace,space2:maximumSpace,type:selectedType,bedroom_number:2,bathroom_number:2, categoryId: selectedCategoryId)
        navigationController?.popViewController(animated: true)
    }
}

//MARK:-Extensions

//MARK:-Extensions
extension FilterVC:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //        let x = scrollView.contentOffset.y
        //        let screenHeight = UIScreen.main.bounds.size.height
        //        let ss:CGFloat
        //        if screenHeight < 800 {
        //            ss = 130
        //        }else {
        //            ss = 60
        //        }
        //        if x < 0 {
        //            scrollView.contentOffset.y =  0
        //        }else if x > ss {
        //            scrollView.contentOffset.y = ss
        //        }
        
        //                let x = scrollView.contentOffset.y
        
        let screenHeight = UIScreen.main.bounds.size.height
        let x = scrollView.contentOffset.y
        var dd = x+screenHeight
        
        var ww:CGFloat = screenHeight < 760 ? 890 : 920
        
        
        if x < 0 {
            scrollView.contentOffset.y =  0
            //        }
            //            scrollView.isScrollEnabled = dd < 920 ? true : false
            
        }else if dd > ww {
            
            scrollView.contentOffset.y = ww-screenHeight
        }else{
            //             scrollView.isScrollEnabled = true
            scrollView.contentOffset.y = x
        }
        
        
        //            if x > 80 && screenHeight > 820 {
        //            scrollView.contentOffset.y = 80
        //        }else  if x > 260  {
        //            scrollView.contentOffset.y = 230
        //            //                     scrollView.contentOffset.y = 180
        //        }
    }
}
