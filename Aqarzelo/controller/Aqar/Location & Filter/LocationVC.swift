//
//  LocationVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import GoogleMaps
import SVProgressHUD
import SDWebImage
import MOLH
//import MaterialComponents.MaterialSnackbar

class LocationVC: UIViewController {
    
    lazy var customErrorView:CustomErrorView = {
           let v = CustomErrorView()
           v.setupAnimation(name: "4970-unapproved-cross")
           v.okButton.addTarget(self, action: #selector(handleDoneError), for: .touchUpInside)
           return v
       }()
    lazy var userProfileImage:UIImageView = {
        let la = UIImageView(image: #imageLiteral(resourceName: "Group 3931-1"))
        la.constrainWidth(constant: 40)
        la.constrainHeight(constant: 40)
        la.layer.cornerRadius = 20
//        la.frame = .init(x: 0, y: 0, width: 40, height: 40)
        la.clipsToBounds = true
        la.isUserInteractionEnabled = true
        la.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowUser)))
        return la
    }()
    lazy var closeImage:UIImageView = {
        let la = UIImageView(image: #imageLiteral(resourceName: "×-1"))
        la.isUserInteractionEnabled = true
        la.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemvoeAds)))
        return la
    }()
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customAqarView:CustomAqarsView = {
        let v = CustomAqarsView()
        v.handleInfoAqar = { [unowned self] aqar in
            self.handleOpenAqar(aqar)
        }
        return v
    }()
    lazy var customAlerLoginView:CustomAlertForLoginView = {
        let v = CustomAlertForLoginView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        v.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return v
    }()
    
    lazy var customConfirmationView:CustomConfirmationView = {
        let v = CustomConfirmationView()
        v.okImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemovecustomConfirmationView)))
        return v
    }()
    
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return v
    }()
    
    lazy var customLocationView:CustomLocationView = {
        let v = CustomLocationView()
        //        v.collectionView.isHide(true)
        v.handleBackAction = {[unowned self] vc in
            self.showOrHideCustomTabBar(hide: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        v.collectionView.showsHorizontalScrollIndicator = false
        
        v.mapView.delegate = self
        v.collectionView.delegate = self
        v.collectionView.dataSource = self
        v.collectionView.isPagingEnabled=true
        //        v.closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClose)))
        v.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowUser)))
        return v
    }()
    
    lazy var    customMarkerLocationView:CustomMarkerLocationView = {
        let v = CustomMarkerLocationView(backgroundColor: .clear)
        v.constrainHeight(constant: 80)
        v.constrainWidth(constant: 80)
        return v
    }()
    
    lazy var discriptionAqarView:DiscriptionAqarView = {
        let v = DiscriptionAqarView()
        v.handleOpenAdss = { [unowned self] ads in
            //            self.removeViewWithAnimation(vvv: self.discriptionAqarView)
            //            self.removeViewWithAnimation(vvv: self.customMarkerLocationView)
            //            self.handleDismiss()
            guard let url = URL(string: ads.url) else { return  }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return v
    }()
    fileprivate let cellId = "cellId"
    var currentUser:UserModel?{
        didSet{
            guard let user = currentUser else { return  }
            self.putUserPhoto(photoUrl:user.photoURL)
        }
    }
    var isCheckUserLocation = true
    let locationManager = CLLocationManager()
    var isLogin = false
    var userLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var aqarsArray = [AqarModel]()
    var adsArray = [AdsModel]()
    
    var isCloseNavAppear: Int = 0
    var timerForAlerting  = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaults.set(true, forKey: UserDefaultsConstants.fetchUserInfoAndLocation)
        userDefaults.set(false, forKey: UserDefaultsConstants.isUserEditProfile)
        //        userDefaults.set(true, forKey: UserDefaultsConstants.isWelcomeVCAppear)
        userDefaults.synchronize()
        setupViews()
        getData()
        setupNavigation()
        getUserLocation()
//        statusBarBackgroundColor()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHide(false)
           navigationController?.navigationBar.isHide(false)
        let ss = UIDevice().type
        if ss == .iPhone6S || ss == .iPhone6 || ss == .iPhone6SPlus || ss == .iPhone6Plus  {
            self.navigationController?.navigationBar.frame.origin = CGPoint(x: 0, y: 20)
        }
        setNeedsStatusBarAppearanceUpdate()
         //solve problem of place of navigation 20
        print(topbarHeight)
           statusBarBackgroundColor()
           
           
           if userDefaults.bool(forKey: UserDefaultsConstants.isWelcomeVCAppear) {
               let welcome = WelcomeVC()
               welcome.modalPresentationStyle = .fullScreen
               present(welcome, animated: true)
           }else    {
               
               if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined)  {
                   updateUserProfile()
                   //                currentUser=cacheCurrentUserCodabe.storedValue
               }
               
               if !userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
                   currentUser=nil
               }
               
               if userDefaults.bool(forKey: UserDefaultsConstants.isAllCachedHome) && userDefaults.bool(forKey: UserDefaultsConstants.fetchRecommendPosts) {
                   fetchRecoomedPosts()
               }else{}
               
               
               
               //            if  userDefaults.bool(forKey: UserDefaultsConstants.isPostUpdated) {
               //                aaddCustomConfirmationView(text: "Post updated Successfully...".localized)
               //                present(customMainAlertVC, animated: true)
               //            }else {}
               //
               //            if  userDefaults.bool(forKey: UserDefaultsConstants.isPostMaded) {
               //                aaddCustomConfirmationView(text: "Post Created Successfully...".localized)
               //                present(customMainAlertVC, animated: true)
               //            }else {}
               
               if !ConnectivityInternet.isConnectedToInternet {
                   customMainAlertVC.addCustomViewInCenter(views: customNoInternetView, height: 200)
                   self.customNoInternetView.problemsView.play()
                   
                   self.customNoInternetView.problemsView.loopMode = .loop
                   timerForAlerting.invalidate()
                   timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fireTimer), userInfo: ["view": "customNoInternetView"], repeats: false)
                   self.present(customMainAlertVC, animated: true)
               }else if ConnectivityInternet.isConnectedToInternet && userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {//|| isCheckUserLocation {
                   //            getUserLocation()
                   fetchUserProfile()
               }else if ConnectivityInternet.isConnectedToInternet && !userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) && userDefaults.bool(forKey: UserDefaultsConstants.fetchRecommendPosts)  {
                   fetchRecoomedPosts()
                   customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
                   self.customAlerLoginView.problemsView.play()
                   
                   customAlerLoginView.problemsView.loopMode = .loop
                   timerForAlerting.invalidate()
                   timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fireTimer), userInfo: ["view": "customAlerLoginView"], repeats: false)
                   self.present(customMainAlertVC, animated: true)
                   
                   
               }else {
                   //                checkUserLogin()
               }
           }
           
           //                }
       }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        tabBarController?.tabBar.isHide(false)
//        navigationController?.navigationBar.isHide(false)
//
//
//
//        if userDefaults.bool(forKey: UserDefaultsConstants.isWelcomeVCAppear) {
//            let welcome = WelcomeVC()
//            welcome.modalPresentationStyle = .fullScreen
//            present(welcome, animated: true)
//        }else {
//
//        if !ConnectivityInternet.isConnectedToInternet {
//            customMainAlertVC.addCustomViewInCenter(views: customNoInternetView, height: 200)
//            self.customNoInternetView.problemsView.play()
//
//            self.customNoInternetView.problemsView.loopMode = .loop
//            timerForAlerting.invalidate()
//            timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fireTimer), userInfo: ["view": "customNoInternetView"], repeats: false)
//            self.present(customMainAlertVC, animated: true)
//        }
//            if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined)  {
//                       updateUserProfile()
//                       fetchRecoomedPosts()
//                       //                currentUser=cacheCurrentUserCodabe.storedValue
//                   }
//            if !userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
//
////            } userDefaults.bool(forKey: UserDefaultsConstants.isFirstLoginedScreen) {
//                 currentUser=nil
//                fetchRecoomedPosts()
//                customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
//                                  self.customAlerLoginView.problemsView.play()
//
//                                  customAlerLoginView.problemsView.loopMode = .loop
//                                  timerForAlerting.invalidate()
//                                  timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fireTimer), userInfo: ["view": "customAlerLoginView"], repeats: false)
//                                  self.present(customMainAlertVC, animated: true)
//            }
//        }
//
//    }
    
    
    //MARK:-User methods
    
    func getData()  {
        
       
       }
    
    @objc  func fireTimer(timer:Timer)  {
        if  let userInfo = timerForAlerting.userInfo as? [String: String]   {
            
            removeViewWithAnimation(vvv: customNoInternetView)
            removeViewWithAnimation(vvv: customAlerLoginView)
            
            customMainAlertVC.dismiss(animated: true)
        }
    }
    
    fileprivate func handleOpenAqar(_ aqar:AqarModel)  {
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.customAqarView.transform = .init(translationX: 1000, y: 0)
        }) { (_) in
            self.customAqarView.removeFromSuperview()
            let detailAqar = AqarDetailsInfoVC(aqar: aqar)
            detailAqar.aqarsArray = self.aqarsArray
            self.customLocationView.handleBackAction?(detailAqar)
        }
        
        
    }
    
    fileprivate func makeSomeChnagesInBottomArea()  {
        tabBarController?.tabBar.isHide(false)
        navigationController?.navigationBar.isHide(false)
        //        showOrHideCustomTabBar(hide: false)
    }
    
    fileprivate func updateUserProfile()  {
        currentUser=cacheCurrentUserCodabe.storedValue
        if currentUser != nil {
            return
        }
        guard let api_Key = userDefaults.string(forKey: UserDefaultsConstants.userApiToken) else { return  }
        //                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
       progressHudProperties()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        UserServices.shared.getUserData(apiKey: api_Key) { (base, err) in
            if let err=err{
                self.callMainError(err: err.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView)
//                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            dispatchGroup.leave()
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData() // disbale all events in the screen
            guard let user = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            self.currentUser = user
            self.putUserPhoto(photoUrl:user.photoURL)
            
        }
        
    }
    
    fileprivate func fetchUserProfile()  {
        
        if userDefaults.bool(forKey: UserDefaultsConstants.isUserEditProfile) {
            updateUserProfile()
        }else if userDefaults.bool(forKey: UserDefaultsConstants.fetchUserInfoAndLocation) {
            getUserDataAndRecommendPosts()
        }else {}
        
        
    }
    
    fileprivate func reloadMainData(group2:BaseAqarModel?,group3:BaseAqarModel?) {
        DispatchQueue.main.async {
            
            
            SVProgressHUD.dismiss()
            if let group2 = group2,let group3 = group3 {
                
                self.aqarsArray = (group2.data?.count ?? 0 > 0 ? group2.data : group3.data) ?? []
                self.addMarkerInMapView()
                userDefaults.set(false, forKey: UserDefaultsConstants.fetchUserInfoAndLocation)
                userDefaults.synchronize()
                self.customLocationView.subView.isHide(self.aqarsArray.count > 0 ? false : true)
                self.customLocationView.collectionView.reloadData()
                self.view.layoutIfNeeded()
                UIApplication.shared.endIgnoringInteractionEvents() // disbale all events in the screen
            }
            
            
        }
        
    }
    
    fileprivate  func getUserDataAndRecommendPosts()  {
        userDefaults.bool(forKey: UserDefaultsConstants.fetchUserInfoAndLocation) ? getUserPostsAndUserProfile() : ()
        
        
    }
    
    fileprivate  func getUserPostsAndUserProfile()  {
        //        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        
        
        var group2: BaseAqarModel?
        var group3: BaseAqarModel?
       progressHudProperties()
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            // using user location
            PostServices.shared.getPostsUsingLocation(lat: self.userLocation.latitude, longi: self.userLocation.longitude) { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                group2 = base
                semaphore.signal()
            }
            semaphore.wait()
            
            //get ads
            PostServices.shared.getPostAds { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                self.adsArray = base?.data ?? []
                semaphore.signal()
            }
            semaphore.wait()
            
            //            UserServices.shared.getUserData(apiKey: api_Key, completon: { (base, err) in
            //                if let err=err{
            //                    SVProgressHUD.showError(withStatus: err.localizedDescription)
            //                    self.activeViewsIfNoData();return
            //                    //
            //                }
            //                guard let user = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            //                //                group1 = user
            //                self.currentUser = user
            //                self.putUserPhoto(photoUrl:user.photoURL)
            //                semaphore.signal()
            //
            //            })
            //            semaphore.wait()
            
            //using related posts
            
            PostServices.shared.getPostsRecommended { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                group3 = base
                semaphore.signal()
            }
            semaphore.wait()
            
            semaphore.signal()
            self.reloadMainData(group2: group2,group3: group3)
            semaphore.wait()
        }
    }
    
    
    fileprivate func putUserPhoto(photoUrl:String)  {
        guard let url = URL(string: photoUrl) else { return  }
        userProfileImage.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "man-user"))
    }
    
    
    
    
    
    fileprivate  func getUserLocation()  {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    fileprivate func refreshCollectionView() {
        userDefaults.set(false, forKey: UserDefaultsConstants.fetchRecommendPosts)
        userDefaults.synchronize()
        SVProgressHUD.dismiss()
        self.activeViewsIfNoData()
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            self.customLocationView.mapView.camera = GMSCameraPosition.camera(withLatitude: self.userLocation.latitude ,
                                                                              longitude: self.userLocation.longitude, zoom: 16)
            self.addMarkerInMapView()
            //            self.customLocationView.subView.isHide(self.aqarsArray.count > 0 ? false : true)
            self.customLocationView.collectionView.reloadData()
        }
    }
    
    fileprivate  func signOutUser()  {
        currentUser = nil
        userProfileImage.image = #imageLiteral(resourceName: "man-user")
        fetchRecoomedPosts()
    }
    
    fileprivate  func checkUserLogin()  {
        currentUser == nil ? fetchRecoomedPosts() : signOutUser()
    }
    
    fileprivate func fetchRecoomedPosts()  {
        if aqarsArray != nil && aqarsArray.count < 0  {
            return
        }
        //        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
       progressHudProperties()
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            PostServices.shared.getPostsRecommended { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                SVProgressHUD.dismiss()
                self.activeViewsIfNoData()
                guard let aqars = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
                self.aqarsArray = aqars
                
                userDefaults.set(false, forKey: UserDefaultsConstants.fetchRecommendPosts)
                userDefaults.synchronize()
                semaphore.signal()
            }
            semaphore.wait()
            
            //get ads
            PostServices.shared.getPostAds { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                self.adsArray = base?.data ?? []
                semaphore.signal()
            }
            semaphore.wait()
            
            
            semaphore.signal()
            self.refreshCollectionView()
            semaphore.wait()
        }
    }
    
    
    fileprivate  func setupViews()  {
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1) //#colorLiteral(red: 0.207870394, green: 0.8542298079, blue: 0.7240723968, alpha: 1)
        view.addSubViews(views: customLocationView)
        customLocationView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 48, right: 0))

//        customLocationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 48, right: 0))
    }
    
    fileprivate func setupNavigation()  {
        navigationController?.navigationBar.backgroundColor = .red
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userProfileImage)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "textfield").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleShowMenu))
    }
    
    func aaddCustomConfirmationView(text:String) {
        customConfirmationView.detailInformationLabel.text = text
        //        addCustomViewInCenter(views: customConfirmationView, height: 200)
        customMainAlertVC.addCustomViewInCenter(views: customConfirmationView, height: 200)
        
        self.present(customMainAlertVC, animated: true)
        userDefaults.set(false, forKey: UserDefaultsConstants.isPostUpdated)
        userDefaults.synchronize()
    }
    
    
    fileprivate func addDiscriptionAqarView()  {
        
        customMainAlertVC.view.addSubViews(views: discriptionAqarView)
        discriptionAqarView.constrainHeight(constant: 120)
        discriptionAqarView.ads = adsArray[0]
        discriptionAqarView.anchor(top: nil, leading: customMainAlertVC.view.leadingAnchor, bottom: customMainAlertVC.view.safeAreaLayoutGuide.bottomAnchor, trailing: customMainAlertVC.view.trailingAnchor,padding: .init(top: 0, left: 32, bottom: 8, right: 32))
        
    }
    
    //TODO:-Handle methods
    //remove popup view
    @objc fileprivate func handleDismiss()  {
        if isCloseNavAppear == 1 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "textfield").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleShowMenu))
        }
        removeViewWithAnimation(vvv: customAlerLoginView)
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleShowMenu()  {
        showOrHideCustomTabBar(hide: true)
        let filter = FilterVC()
        filter.delgate = self
        //        filter.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filter, animated: true)
    }
    
    
    
    @objc fileprivate func handleShowUser()  {
        hidedCustomWhiteViewTabBar(hide: true)
        showOrHideCustomTabBar(hide: true)
        let user = UserSettingsVC()
        user.user = currentUser
        navigationController?.pushViewController(user, animated: true)
    }
    
    
    @objc fileprivate func handleLogin ()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        customMainAlertVC.dismiss(animated: true)
        let login = LoginVC()
        let nav = UINavigationController(rootViewController: login)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
        
    }
    
    
    @objc  func handleRemovecustomConfirmationView()  {
        removeViewWithAnimation(vvv: customConfirmationView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc fileprivate func handleSignUp ()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        customMainAlertVC.dismiss(animated: true)
        let login = LoginVC()
        let nav = UINavigationController(rootViewController: login)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true) {
            login.handlSignUp()
        }
        
    }
    
    @objc func handleOk()  {
        
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc func handleDoneError()  {
           removeViewWithAnimation(vvv: customErrorView)
           customMainAlertVC.dismiss(animated: true)
       }
    
    @objc func handleRemvoeAds()  {
        removeViewWithAnimation(vvv: customAqarView)
        removeViewWithAnimation(vvv: discriptionAqarView)
        customMainAlertVC.dismiss(animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "textfield").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleShowMenu))
        isCloseNavAppear = 2
        
        
    }
}

// MARK: - UIScrollViewDelegate

extension LocationVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point = view.convert(customLocationView.collectionView.center, to: customLocationView.collectionView)
        
        guard
            let indexPath = customLocationView.collectionView.indexPathForItem(at: point)     else {
                return
        }
        customLocationView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        customLocationView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
}

extension LocationVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aqarsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LocationCollectionCell
        let aqar = aqarsArray[indexPath.item]
        
        cell.aqar = aqar
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let aqar = aqarsArray[indexPath.item]
        let detailAqar = AqarDetailsInfoVC(aqar: aqar)
        detailAqar.aqarsArray = aqarsArray
        if let token = currentUser?.apiToken {
            detailAqar.userToken = token
        }
        customLocationView.handleBackAction?(detailAqar)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5 * 16  ) / 2
        return .init(width: width   , height: 170)
        //        return .init(width: view.frame.width , height: 150)
    }
    
    func searchForResults(categoryId:Int?,citId: Int?, areaId: Int?, price1: Int, price2: Int, space1: Int, space2: Int, type: String?, bedroom_number: Int?, bathroom_number: Int?)  {
        //        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        // make search to find aqars
       progressHudProperties()
        
        PostServices.shared.getPostsUsingSearchData(category_id: categoryId, price2: price2 , price1: price1, bedNumber: bedroom_number, bathNumber: bathroom_number, type: type, city_id: citId, area_id: areaId, space1: space1, space2: space2) { (base, err) in
            
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            self.refreshData(base: base)
        }
    }
    
    func refreshData(base:BaseAqarModel?)  {
        guard let based = base else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
        if based.data?.count ?? 0 <= 0 {
            SVProgressHUD.showInfo(withStatus: "No data available......".localized)
        }else {
            self.aqarsArray.removeAll()
            
            self.aqarsArray = based.data ?? []
            
            
        }
        DispatchQueue.main.async {
            self.customLocationView.mapView.clear()
            self.addMarkerInMapView()
            self.customLocationView.collectionView.reloadData()
        }
    }
}

//MARK:-Extensions

extension LocationVC: CLLocationManagerDelegate{
    
    
    
    fileprivate func addMarkerInMapView() {
        
        aqarsArray.forEach { (aqar) in
            
            
            let marker = GMSMarker()
            let latitude = (aqar.lat as NSString).doubleValue
            let longitude = (aqar.lng as NSString).doubleValue
            
            
            
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude:longitude)
            customMarkerLocationView.aqar = aqar
            //            customMarkerLocationView.distanceLabel.text = "\(aqar.price)"
            marker.iconView = customMarkerLocationView
            marker.map = customLocationView.mapView
            
            
        }
        guard let latitude = (aqarsArray.first?.lat as? NSString)?.doubleValue
            ,let longitude = (aqarsArray.first?.lng as? NSString)?.doubleValue else{return}
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude:longitude, zoom: 16.5)//16.5
        customLocationView.mapView.camera = camera
        //                customLocationView.mapView.animate(toZoom: 16.5)
        customLocationView.mapView.setMinZoom(2, maxZoom: 13)//8 //4
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {return}
        self.userLocation = userLocation.coordinate
        
        locationManager.stopUpdatingLocation()
    }
}

extension LocationVC:GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return self.customMarkerLocationView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //do what ever you want
        if let ma = marker.iconView as? CustomMarkerLocationView {
            customAqarView.aqar =   ma.aqar
            //            addCustomViewInCenter(views:customAqarView, height: 150)
            customMainAlertVC.addCustomViewInCenter(views:customAqarView, height: 150)
            addDiscriptionAqarView()
            isCloseNavAppear = 1
            present(customMainAlertVC, animated: true, completion: nil)
            //            userDefaults.set(true, forKey: UserDefaultsConstants.isAdsAppeared)
            //            userDefaults.synchronize()
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeImage)
        }
        return true
    }
}

extension LocationVC: FilterVCProtocol {
    func getaqarsAccordingTo(citId: Int?, areaId: Int?, price1: Int, price2: Int, space1: Int, space2: Int, type: String?, bedroom_number: Int?, bathroom_number: Int?, categoryId: Int?) {
        self.searchForResults(categoryId: categoryId, citId: citId, areaId: areaId, price1: price1, price2: price2, space1: space1, space2: space2, type: type, bedroom_number: bedroom_number, bathroom_number: bathroom_number)
    }
    
    
}

extension UIViewController {

    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0.0
//        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
//            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
