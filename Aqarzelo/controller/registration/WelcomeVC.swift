//
//  WelcomeVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit


protocol WelcomeVCProtocol {
    func getUserLocation(lat:Double,lng:Double)
}

class WelcomeVC: UIViewController {
    
    
    lazy var mainWelcomeView:CustomWelcomeView = {
        let v =  CustomWelcomeView()
        v.currentLocationButton.addTarget(self, action: #selector(handleCurrentLocation), for: .touchUpInside)
        v.goLocationButton.addTarget(self, action: #selector(handleGoLocation), for: .touchUpInside)
        return v
    }()
    
    lazy var views = [
        mainWelcomeView.logoImageView,
        mainWelcomeView.currentLocationButton,
        mainWelcomeView.infoLabel,
        mainWelcomeView.goLocationButton
    ]
    var isDataSaved = false
    var userLat:Double?
    var userLng:Double?
    var delgate:WelcomeVCProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        fetchData()
        saveData()
        setupViews()
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        AppInstance.showLoader()
        print(userDefaults.value(forKey: UserDefaultsConstants.categoryNameArabicArray))
        //                                removeObservers()
        setupAnimation()
        userDefaults.set(true, forKey: UserDefaultsConstants.fetchRecommendPosts)
        userDefaults.synchronize()
        //        userDefaults.set(false, forKey: UserDefaultsConstants.isUserLogined)
        //        userDefaults.synchronize()
    }
    
    //MARK:-User methods
    
    
    
    fileprivate func removeObservers()  {
        
        userDefaults.removeObject(forKey: UserDefaultsConstants.categoryNameArray)
        userDefaults.removeObject(forKey: UserDefaultsConstants.areaNameArray)
        userDefaults.removeObject(forKey: UserDefaultsConstants.cityNameArray)
        
        userDefaults.removeObject(forKey: UserDefaultsConstants.categoryNameArabicArray)
        userDefaults.removeObject(forKey: UserDefaultsConstants.areaNameArabicArray)
        userDefaults.removeObject(forKey: UserDefaultsConstants.cityNameArabicArray)
        
        userDefaults.removeObject(forKey: UserDefaultsConstants.areaIdArray)
        userDefaults.removeObject(forKey: UserDefaultsConstants.cityIdArray)
        userDefaults.removeObject(forKey: UserDefaultsConstants.areaIdsArrays)
        userDefaults.set(false, forKey: UserDefaultsConstants.isCachedDriopLists)
        userDefaults.synchronize()
    }
    
    
    fileprivate func reloadMainData(group0:[CountryModel],group1:[CityModel]?,group2:[AreaModel]?,group3:[CityModel]?)  {
        
        var categoryNameArray = [String]()
        var cityNameData = [String]()
        var areaNameDatas = [String]()
        
        var areaNameArabicDatas = [String]()
        var categoryNameArabicArray = [String]()
        var cityNameArabicData = [String]()
        
        var cityIdData = [Int]()
        var areasIdData = [Int]()
        var areasIds = [Int]()
        var categoryIdArray = [Int]()
        
        DispatchQueue.main.sync {
            
            
            //            SVProgressHUD.dismiss()
            
            group1?.forEach({ (city) in
                cityNameData.append(city.nameEn)
                cityNameArabicData.append(city.nameAr)
                cityIdData.append(city.id)
            })
            group2?.forEach({ (area) in
                areaNameDatas.append( area.nameEn)
                areaNameArabicDatas.append(area.nameAr)
                areasIdData.append(area.cityID ?? 1)
                areasIds.append(area.id)
            })
            
            group3?.forEach({ (categ) in
                categoryNameArray.append(categ.nameEn)
                categoryNameArabicArray.append(categ.nameAr)
                categoryIdArray.append(categ.id)
            })
            cacheAreaInCodabe.deleteFile(group2)
            cacheAreaInCodabe.save(group2 ?? nil)
            
            userDefaults.set(categoryIdArray, forKey: UserDefaultsConstants.categoryIdsArray)
            userDefaults.set(cityIdData, forKey: UserDefaultsConstants.cityIdArray)
            userDefaults.set(areasIdData, forKey: UserDefaultsConstants.areaIdArray)
            
            userDefaults.set(categoryNameArray, forKey: UserDefaultsConstants.categoryNameArray)
            userDefaults.set(cityNameData, forKey: UserDefaultsConstants.cityNameArray)
            userDefaults.set(areaNameDatas, forKey: UserDefaultsConstants.areaNameArray)
            
            userDefaults.set(cityNameArabicData, forKey: UserDefaultsConstants.cityNameArabicArray)
            userDefaults.set(categoryNameArabicArray, forKey: UserDefaultsConstants.categoryNameArabicArray)
            userDefaults.set(areaNameArabicDatas, forKey: UserDefaultsConstants.areaNameArabicArray)
            
            userDefaults.set(areasIds, forKey: UserDefaultsConstants.areaIdsArrays)
            userDefaults.set(true, forKey: UserDefaultsConstants.fetchUserInfoAndLocation)
            userDefaults.set(false, forKey: UserDefaultsConstants.isUserEditProfile)
            
            userDefaults.set(true, forKey: UserDefaultsConstants.isCachedDriopLists)
            userDefaults.set(true, forKey: UserDefaultsConstants.fetchRecommendPosts)
            userDefaults.synchronize()
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func cachedDropLists() {
        
        
        var group1: [CityModel]?
        var group0: [CountryModel]?
        var group2: [AreaModel]?
        var group3 : [CityModel]?
        
        
        //        SVProgressHUD.show(withStatus: "Looding....".localized)
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            
            FilterServices.shared.getCountries(completion: { (base,error) in
                
                group0 = base?.data
                semaphore.signal()
            })
            semaphore.wait()
            
            // uget citites
            FilterServices.shared.getCities(completion: { (base,error) in
                
                group1 = base?.data
                semaphore.signal()
            })
            semaphore.wait()
            
            //get areas
            FilterServices.shared.getAllAreas { (base, error) in
                group2 = base?.data
                semaphore.signal()
            }
            semaphore.wait()
            
            FilterServices.shared.getCategoriess(completion: { (base, err) in
                group3 = base?.data
                semaphore.signal()
            })
            semaphore.wait()
            
            
            
            semaphore.signal()
            self.reloadMainData(group0:group0,group1: group1,group2: group2,group3:group3)
            semaphore.wait()
        }
    }
    
    fileprivate func saveData() {
        
        !userDefaults.bool(forKey: UserDefaultsConstants.isCachedDriopLists) ? cachedDropLists() : ()
        
        
        
        
    }
    var timer:Timer?
    
    
    fileprivate func fetchData()  {
        
        if userDefaults.value(forKey: UserDefaultsConstants.areaIdsArrays) == nil &&
            userDefaults.value(forKey: UserDefaultsConstants.areaIdArray) == nil &&
            userDefaults.value(forKey: UserDefaultsConstants.cityNameArray) == nil &&
            userDefaults.value(forKey: UserDefaultsConstants.cityIdArray) == nil {
            saveData()
        }else {
            print(99999)
        }
    }
    
    fileprivate func setupAnimation()  {
        views.forEach({$0.alpha = 1})
        
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -1000)
        let translateButtons = CGAffineTransform.init(translationX: -1000, y: 0)
        
        [mainWelcomeView.infoLabel,mainWelcomeView.currentLocationButton,mainWelcomeView.goLocationButton].forEach({$0.transform = translateButtons})
        self.mainWelcomeView.logoImageView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.mainWelcomeView.logoImageView.transform = .identity
        }
        
        self.addTransform()
        
        //delay: 0.6 * 1.3
        
        UIView.animate(withDuration: 0.7, delay: 0.7, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.goToNextVC()
            //            [self.mainWelcomeView.infoLabel,self.mainWelcomeView.currentLocationButton,self.mainWelcomeView.goLocationButton].forEach({$0.transform = .identity})
        })
    }
    
    func goToNextVC()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {//+4
            [self.mainWelcomeView.infoLabel,self.mainWelcomeView.currentLocationButton,self.mainWelcomeView.goLocationButton].forEach({$0.transform = .identity})        }
        
    }
    
    func addTransform()  {
        var rotationAnimation = CABasicAnimation()
        rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: (Double.pi))
        rotationAnimation.duration = 0.5 //1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = 2.0//4.0
        mainWelcomeView.logoImageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    fileprivate  func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        
        view.addSubview(mainWelcomeView)
        
        mainWelcomeView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
    }
    
    fileprivate func presentHomeTab(lat: Double, lng: Double) {
        let home = HomeTabBarVC()
        
        home.selectedIndex = 0
        
        let navigationController  = home.selectedViewController as! UINavigationController
        let controllers = navigationController.viewControllers // will give array
        if controllers.count > 0 {
            if let viewC = controllers[0] as? LocationVC {
                // do desired work
                viewC.userLocation.latitude = lat
                viewC.userLocation.longitude = lng
                viewC.isCheckUserLocation = false
            }
        }
        userDefaults.set(false, forKey: UserDefaultsConstants.isWelcomeVCAppear)
        userDefaults.synchronize()
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true, completion: nil)
    }
    
    
    //TODO:-Handle methods
    
    
    @objc fileprivate func handleCurrentLocation()  {
        let home = HomeTabBarVC()
//        AppInstance.hideLoader()
        userDefaults.set(false, forKey: UserDefaultsConstants.isWelcomeVCAppear)
        userDefaults.synchronize()
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleGoLocation()  {
        let choose = ChooseLocationVC()
//        AppInstance.hideLoader()
        choose.delgate = self
        let nav = UINavigationController(rootViewController: choose)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
}

//MARK:-extension

extension WelcomeVC: ChooseLocationVCProtocol {
    func getLatAndLong(lat: Double, long: Double) {
        delgate?.getUserLocation(lat: lat, lng: long)
        presentHomeTab(lat:lat,lng:long)
    }
    
    
}
