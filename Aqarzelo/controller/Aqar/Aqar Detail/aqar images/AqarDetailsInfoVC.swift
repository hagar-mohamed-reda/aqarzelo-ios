//
//  AqarDetailsInfoVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import MOLH

class AqarDetailsInfoVC: UIViewController {
    
    fileprivate let cellID = "cellID"
    fileprivate let cellTopId = "cellTopId"
    fileprivate let cellHidedId = "cellHidedId"
    
    fileprivate let aqarModel:AqarModel!
    var aqarsArray = [AqarModel]()
    var userToken:String = ""
    
    //    fileprivate let aqarsArray:[AqarModel]!
    init(aqar:AqarModel) {
        self.aqarModel = aqar
        
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    
    lazy var customStarView:CustomStarViews = {
        let v = CustomStarViews()
        v.closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveStars)))
        v.doneButton.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return v
    }()
    lazy var customErrorView:CustomErrorView = {
        let v = CustomErrorView()
        v.setupAnimation(name: "4970-unapproved-cross")
        v.okButton.addTarget(self, action: #selector(handleDoneError), for: .touchUpInside)
        return v
    }()
    lazy var customAlerLoginView:CustomAlertForLoginView = {
        let v = CustomAlertForLoginView()
        v.setupAnimation(name: "4970-unapproved-cross")
        v.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        v.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return v
    }()
    
    lazy var backImageView:UIImageView = {
        let i =  UIImageView(image:  MOLHLanguage.isRTLLanguage() ?  #imageLiteral(resourceName: "left-arrow") : #imageLiteral(resourceName: "back button-2"))
        return i
    }()
    lazy var bView:UIView = {
        let v = UIView(backgroundColor: .clear)
        v.constrainWidth(constant: 40)
        v.constrainHeight(constant: 40)
        v.layer.cornerRadius = 20
        v.layer.borderWidth = 3
        v.layer.borderColor = UIColor.gray.cgColor
        v.clipsToBounds = true
        v.addSubview(backImageView)
        backImageView.fillSuperview()
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        return v
    }()
    
    lazy var logoImageView:UIImageView = {
        let i = UIImageView()
        
        
        if let urlString = aqarModel.user?.coverURL, let url = URL(string: urlString) {
            i.sd_setImage(with: url)
        }
        i.isUserInteractionEnabled = true
        i.constrainWidth(constant: 30)
        i.constrainHeight(constant: 30)
        i.layer.cornerRadius = 15
        i.clipsToBounds = true
        return i
    }()
    
    lazy var aqarDetailHorizentalCollectionView:AqarDetailHorizentalVC = {
        let v =  AqarDetailHorizentalVC()
        v.mainAqar = aqarModel
        
        v.collectionView.reloadData()
        v.view.constrainHeight(constant: fixedGeight)
        v.handleRatesAction = {[unowned self] aqar in
            if !self.checkIfUserLoginBefore() {
                self.customMainAlertVC.addCustomViewInCenter(views: self.customAlerLoginView, height: 200)
                self.customAlerLoginView.problemsView.play()
                self.customAlerLoginView.problemsView.loopMode = .loop
                self.present(self.customMainAlertVC, animated: true)
            }else {
                self.customMainAlertVC.addCustomViewInCenter(views:self.customStarView , height: 250)
                self.present(self.customMainAlertVC, animated: true, completion: nil)
            }
        }
        v.handleShowImages = {[unowned self] images in
            //            self.showOrHideCustomTabBar(hide: true)
            let vc = ShowSeperateAqarImagesCV(images: images)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        v.collectionView.showsHorizontalScrollIndicator = false
        return v
    }()
    lazy var aqarDetailBottomCollectionView:AppDetailBottomCollectionVC = {
        let v = AppDetailBottomCollectionVC(aqar:aqarModel,aqars:  aqarsArray)
        v.view.isHide(false)
        //        v.view.isHide(true)
        v.collectionView.showsVerticalScrollIndicator = false
        v.handleShowHoghlightedView = {[unowned self] show in
            DispatchQueue.main.async {
                self.collectionViewHighlighted.isHide(show)
                self.subView.isHide(show)
            }
            
        }
        v.handleSelectedAqar = {[unowned self] aqar in
            let detailAqar = AqarDetailsInfoVC(aqar: aqar)
            detailAqar.aqarsArray = self.aqarsArray
            detailAqar.userToken = self.userToken
            self.navigationController?.pushViewController(detailAqar, animated: true)
        }
        
        return v
    }()
    lazy var postMessagesCollectionView:PostMessagesCollectionVC = {
        let v = PostMessagesCollectionVC(postId: aqarModel.images.first?.postID ?? 1)
        v.view.isHide(true)
        v.collectionView.showsVerticalScrollIndicator = false
        return v
    }()
    lazy var aqarDetailTopView:AqarDetailTopView = {
        let v = AqarDetailTopView()
        v.backgroundColor = .clear
        v.textView.delegate = self
        //        v.constrainHeight(constant: 50)
        v.aqar = aqarModel
        v.messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowChatMessage)))
        v.sendButton.addTarget(self, action: #selector(handleShowContents), for: .touchUpInside)
        v.favoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFavoritePost)))
        v.textView.delegate = self
        v.textView.isUserInteractionEnabled = self.checkIfUserLoginBefore()
        return v
    }()
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    let aqarDetailInfoView = AqarDetailInfoView()
    let appDetailDiscriptionView = AppDetailDiscriptionView()
    
    lazy var subView:UIView = {
        let v = UIView(backgroundColor: .white)
        
        v.constrainHeight(constant: 160)
        v.isHide(true)
        return v
    }()
    lazy var collectionViewHighlighted:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.register(LocationCollectionCell.self, forCellWithReuseIdentifier: cellIds)
        c.constrainHeight(constant: 220)
        c.backgroundColor = .clear
        c.delegate = self
        c.dataSource = self
        c.isHide(true)
        c.showsHorizontalScrollIndicator = false
        return c
    }()
    
    var cityName = ""
    
    lazy var fixedGeight = (view.frame.height - 64 ) / 2
    fileprivate let cellIds = "cellIds"
    
    override func viewDidLayoutSubviews() {
        subView.addGradientBackground(firstColor: #colorLiteral(red: 0.8280106187, green: 0.8881947994, blue: 0.8735718727, alpha: 1), secondColor: #colorLiteral(red: 0.3111050725, green: 0.7003450394, blue: 0.717197597, alpha: 1))
    }
    
    //    override var prefersStatusBarHidden: Bool {
    //        return true
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //         subView.addGradientBackground(firstColor: #colorLiteral(red: 0.4169815183, green: 0.83258003, blue: 0.6895253658, alpha: 1), secondColor: #colorLiteral(red: 0.4569166303, green: 0.8946051002, blue: 0.7911534905, alpha: 1))
        //        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanned)))
        setupViews()
        //        setupNavigation()
        addReviewForPost()
        getCityAccordingToAqar(id:aqarModel.cityID)
        hideStatusBarBackground()
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHide(true)
        tabBarController?.tabBar.isHide(true)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarBackgroundColor()
        UIApplication.shared.isStatusBarHidden = false
        SVProgressHUD.dismiss()
        
    }
    
    //MARK:-User methods
    
    
    fileprivate func getCityAccordingToAqar(id:Int)  {
        SVProgressHUD.show(withStatus: "Looding...".localized)
        FilterServices.shared.getCities(completion: { (base,error) in
            if let err = error {
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            guard let cities  = base?.data else {return}
            self.getCity(citys:cities)
        })
    }
    
    fileprivate func getCity(citys:[CityModel])  {
        citys.forEach { (city) in
            if city.id == aqarModel.cityID {
                cityName = MOLHLanguage.isRTLLanguage() ?  city.nameAr : city.nameEn
            }
        }
        
    }
    
    fileprivate func addReviewForPost()  {
        let macAddress = UIDevice().identifierForVendor?.uuidString ?? ""
        
        PostServices.shared.getPostReviewsUsingMacAddress(postId: aqarModel.images.first?.postID ?? 1, mac_address: macAddress) { (base, error) in
            if let error=error{
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    fileprivate func showHighlightTapped(index: Int,text: String)  {
        //        let tabBarItem = UIApplication.getMainTabBarController()?.tabBar.items?[index]
        ////        UIApplication.getMainTabBarController()?.viewControllers?[index].tabBarItem.badgeValue = text
        //        DispatchQueue.main.async(execute: {
        //            tabBarItem?.badgeValue = text
        //        })
        UIApplication.getMainTabBarController()?.viewControllers?[index].navigationController?.tabBarItem.badgeValue = text
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = .white
        //        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleOpenHideCollection)))
        view.addSubViews(views: aqarDetailHorizentalCollectionView.view,mainView,aqarDetailTopView,bView,logoImageView,aqarDetailBottomCollectionView.view,subView,collectionViewHighlighted,postMessagesCollectionView.view)
        //
        mainView.fillSuperview(padding: .init(top: fixedGeight, left: 0, bottom: 0, right: 0))
        aqarDetailHorizentalCollectionView.view.anchor(top: view.superview?.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        //
        bView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 48, left: 16, bottom: 0, right: 0))//32
        logoImageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 48, left: 0, bottom: 0, right: 16))//32  //16
        aqarDetailTopView.anchor(top: mainView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: -24, left: 0, bottom: 0, right: 0))
        //        //
        aqarDetailBottomCollectionView.view.anchor(top: aqarDetailTopView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        //
        postMessagesCollectionView.view.anchor(top: aqarDetailTopView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        //        collectionViewHighlighted.anchor(top: aqarDetailTopView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 60, left: 0, bottom: 0, right: 0))
        //         subView.anchor(top: aqarDetailTopView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 100, left: 0, bottom: 0, right: 0))
        collectionViewHighlighted.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        subView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func manipulateHide(_ ishide: Bool) {
        aqarDetailTopView.messageImageView.isHide(ishide)
        aqarDetailTopView.hidedView.isHide(ishide)
        
        aqarDetailTopView.sendButton.isHide(!ishide)
        postMessagesCollectionView.view.isHide(!ishide)
    }
    
    fileprivate func manipulateUnHide(_ ishide: Bool) {
        aqarDetailTopView.messageImageView.isHide(ishide)
        aqarDetailTopView.hidedView.isHide(ishide)
        
        aqarDetailTopView.sendButton.isHide(!ishide)
        postMessagesCollectionView.view.isHide(!ishide)
    }
    
    fileprivate  func showHideViews(ishide:Bool)  {
        if ishide {
            manipulateHide(ishide)
        }else {
            manipulateUnHide(ishide)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func createCustomNavBar()  {
        let v = UIView(backgroundColor: .red)
        v.frame = .init(x: 0, y: 0, width: view.frame.width, height: 60)
        view.addSubview(v)
        
        v.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: -20, left: 0, bottom: 0, right: 0))
    }
    
    fileprivate func resetAllData() {
        self.aqarDetailTopView.textView.text = ""
        aqarDetailTopView.handleTextChanged()
        //        textViewDidChange(aqarDetailTopView.textView)
        self.aqarDetailTopView.textView.resignFirstResponder()
    }
    
    
    
    
    
    //TODO:-Handle methods
    
    
    
    @objc  func handleDismiss()  {
        dismiss(animated: true)
    }
    
    @objc func handleDoneError()  {
        removeViewWithAnimation(vvv: customErrorView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc func handleRemoveStars()  {
        removeViewWithAnimation(vvv: customStarView)
        customMainAlertVC.dismiss(animated: true)
        
    }
    
    @objc fileprivate func handleShowChatMessage()  {
        //        showHideViews(ishide: true)
        
        if !checkIfUserLoginBefore() {
            self.customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
            self.customAlerLoginView.problemsView.play()
            customAlerLoginView.problemsView.loopMode = .loop
            self.present(customMainAlertVC, animated: true)
        }else {
            
            if aqarModel.user?.apiToken == userToken {
                self.customMainAlertVC.addCustomViewInCenter(views: customErrorView, height: 200)
                self.customErrorView.problemsView.play()
                customErrorView.problemsView.loopMode = .loop
                
                self.present(customMainAlertVC, animated: true)
            }else {
                
                showOrHideCustomTabBar(hide: true)
                let messages = ChatLogCollectionVC(userId: aqarModel.userID , token: userToken)
                messages.targetUesrName = aqarModel.user?.name
                messages.targetUesrPhotoUrl = aqarModel.user?.photoURL
                navigationController?.pushViewController(messages, animated: true)
            }
        }
    }
    
    @objc fileprivate func handleShowContents()  {
        guard let message = aqarDetailTopView.textView.text else { return  }
        
        
        PostServices.shared.addPost(api_token: userToken, post_id: aqarModel.images.first?.postID ?? 1, comment: message) { (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
            }
            
        }
        
        self.postMessagesCollectionView.loadNewerMessages()
        self.resetAllData()
        self.showHideViews(ishide: false)
        
    }
    
    @objc fileprivate  func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc  func handleDone()  {
        print(customStarView.rating)
        //        SVProgressHUD.show(withStatus: "Looding...".localized)
        //        view.isUserInteractionEnabled = false
        
        
        PostServices.shared.addPost(api_token: userToken, post_id: aqarModel.id,rate:Int(customStarView.rating)) {[unowned self] (base, error) in
            if let err=error{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                //                self.view.isUserInteractionEnabled = true
            }
            SVProgressHUD.dismiss()
            
            self.removeViewWithAnimation(vvv: self.customStarView)
            DispatchQueue.main.async {
                
                self.customMainAlertVC.dismiss(animated: true)
                //                self.view.isUserInteractionEnabled = true
            }
            //            self.removeCustomStarView()
            
        }
        
    }
    
    func setupChangedPan(gesture:UIPanGestureRecognizer)  {
        let translation = gesture.translation(in: nil)
        let heights = collectionViewHighlighted.frame.origin.y
        print(translation.y,"               ",heights)
        if translation.y > 0 {
            collectionViewHighlighted.isHide(true)
        }else {
            collectionViewHighlighted.isHide(false)
        }
        
        //        self.transform = .init(translationX: 0, y: translation.y)
        //        self.smallView.alpha = 1+translation.y/200
        //        self.bigView.alpha = -translation.y/200
        
    }
    
    @objc fileprivate func handleLogin ()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        customMainAlertVC.dismiss(animated: true)
        let login = LoginVC()
        let nav = UINavigationController(rootViewController: login)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
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
    
    @objc  func handleFavoritePost()  {
        
        //         favoriteImageView.image =   favorite.contains(aqar.id ) ? #imageLiteral(resourceName: "Group 3923-10") : #imageLiteral(resourceName: "Group 3923s")
        
        if !checkIfUserLoginBefore() {
            self.customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
            self.customAlerLoginView.problemsView.play()
            self.customAlerLoginView.problemsView.loopMode = .loop
            
            self.present(customMainAlertVC, animated: true)
        }else {
            
            var texy = "New".localized
            var favorite = false
            //            var varrrss = [Int]()
            
            //cahce aqars
            var dd = cacheFavoriteAqarsCodabe.storedValue
            
            if dd?.contains(where: {$0.id == aqarModel.id}) ?? true {
                texy = "Removed".localized
                favorite = false
                dd?.removeAll(where: {$0.id == aqarModel.id})
            }else {
                texy = "New".localized
                favorite = true
                dd?.append(self.aqarModel)
                
            }
            cacheFavoriteAqarsCodabe.save(dd ?? [aqarModel])
            
            DispatchQueue.main.async {
                self.showHighlightTapped(index: 3, text: texy.localized)
                userDefaults.set(true, forKey: UserDefaultsConstants.favoriteArray)
                
                //                           userDefaults.set(arras, forKey: UserDefaultsConstants.favoriteArray)
                userDefaults.synchronize()
                self.aqarDetailTopView.favoriteImageView.image =  favorite ? #imageLiteral(resourceName: "Group 3923-10") : #imageLiteral(resourceName: "Group 3923s")
                self.view.layoutIfNeeded()
            }
            
            
            //            if  userDefaults.value(forKey: UserDefaultsConstants.favoriteArray) as? [Int] == nil {
            //                varrrss.append(aqarModel.id)
            //                texy = "New".localized
            //                favorite = true
            //                userDefaults.set(varrrss, forKey: UserDefaultsConstants.favoriteArray)
            //                userDefaults.synchronize()
            //
            //                DispatchQueue.main.async {
            //                    self.showHighlightTapped(index: 3, text: texy.localized)
            //                    //                userDefaults.set(arras, forKey: UserDefaultsConstants.favoriteArray)
            //                    //                userDefaults.synchronize()
            //                    self.aqarDetailTopView.favoriteImageView.image =  favorite ? #imageLiteral(resourceName: "Group 3923-10") : #imageLiteral(resourceName: "Group 3923s")
            //                    self.view.layoutIfNeeded()
            //                }
            //                return
            //            }
            //
            //            guard var arras = userDefaults.value(forKey: UserDefaultsConstants.favoriteArray) as? [Int] else {return}
            //            if arras.contains(aqarModel.id) {
            //                arras.remove(object: aqarModel.id)
            //                texy = "Removed".localized
            //                favorite = false
            //            }else {
            //                arras.append(aqarModel.id)
            //                texy = "New".localized
            //                favorite = true
            //            }
            //            DispatchQueue.main.async {
            //                self.showHighlightTapped(index: 3, text: texy.localized)
            //                userDefaults.set(arras, forKey: UserDefaultsConstants.favoriteArray)
            //                userDefaults.synchronize()
            //                self.aqarDetailTopView.favoriteImageView.image =  favorite ? #imageLiteral(resourceName: "Group 3923-10") : #imageLiteral(resourceName: "Group 3923s")
            //                self.view.layoutIfNeeded()
            //            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension AqarDetailsInfoVC: UITextViewDelegate {
    
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //        if !checkIfUserLoginBefore() {
        //            self.customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
        //            self.present(customMainAlertVC, animated: true)
        //        }else {
        //
        //        }
        showHideViews(ishide: true)
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            aqarDetailTopView.sendButton.isEnabled = true
            aqarDetailTopView.sendButton.setTitleColor(.black, for: .normal)
            
        }else {
            aqarDetailTopView.sendButton.isEnabled = false
            aqarDetailTopView.sendButton.setTitleColor(.lightGray, for: .normal)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension AqarDetailsInfoVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point = view.convert(collectionViewHighlighted.center, to: collectionViewHighlighted)
        
        guard
            let indexPath = collectionViewHighlighted.indexPathForItem(at: point)     else {
                return
        }
        collectionViewHighlighted.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionViewHighlighted.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    }
}


extension AqarDetailsInfoVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aqarsArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIds, for: indexPath) as! LocationCollectionCell
        let aqar = aqarsArray[indexPath.item]
        
        cell.aqar = aqar
        return cell
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let aqar = aqarsArray[indexPath.item]
        let detailAqar = AqarDetailsInfoVC(aqar: aqar)
        detailAqar.aqarsArray = aqarsArray
        detailAqar.userToken = userToken
        navigationController?.pushViewController(detailAqar, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 5 * 8  ) / 2
        return .init(width: width   , height: 150)
        //        return .init(width: view.frame.width , height: 150)
    }
}
