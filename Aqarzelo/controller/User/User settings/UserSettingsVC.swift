//
//  UserSettingsVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import MOLH
//import MaterialComponents.MaterialSnackbar


class UserSettingsVC: UIViewController {
    
    
    
    var user:UserModel? {
        didSet{
            guard let user = user else { return  }
            fetchInfo(user )
            //             fetchData()
            isLogin = true
        }
    }
    
    
    
    
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return v
    }()
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    
    lazy var customSignOutView:CustomSignOoutUserView = {
        let v = CustomSignOoutUserView()
        //        v.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        v.setupAnimation(name: "15179-confirm-popup")
        v.okButton.addTarget(self, action: #selector(handleSignOutOk), for: .touchUpInside)
        v.cancelButton.addTarget(self, action: #selector(handleSignOutCancel), for: .touchUpInside)
        //        v.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return v
    }()
    
    lazy var customChangeLanguage:CustomChangeLanguageView = {
        let c = CustomChangeLanguageView()
        c.arabicButton.addTarget(self, action: #selector(handleArabicLanguage), for: .touchUpInside)
        c.englishButton.addTarget(self, action: #selector(handleEnglishLanguage), for: .touchUpInside)
        return c
    }()
    lazy var customTopUserView:CustomTopUserView = {
        let v = CustomTopUserView()
        //        v.constrainHeight(constant: <#T##CGFloat#>)
        v.handleEditProfiles = { [unowned self] in
            if !ConnectivityInternet.isConnectedToInternet {
                self.customMainAlertVC.addCustomViewInCenter(views: self.customNoInternetView, height: 200)
                self.customNoInternetView.problemsView.play()
                
                self.customNoInternetView.problemsView.loopMode = .loop
                self.timerForAlerting.invalidate()
                self.timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fireTimer), userInfo: ["view": "customAlerLoginView"], repeats: false)
                self.present(self.customMainAlertVC, animated: true)
            }else{
                if self.checkIfNotLogin() {
                    self.goToEditProfile()
                }else {
                    if v.userNameLabel.text == "LOGIN" {
                        self.goToLogin()
                    }else{
                        self.customMainAlertVC.addCustomViewInCenter(views: self.customAlerLoginView, height: 200)
                        self.customAlerLoginView.problemsView.play()
                        
                        self.customAlerLoginView.problemsView.loopMode = .loop
                        self.timerForAlerting.invalidate()
                        self.timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fireTimer), userInfo: ["view": "customAlerLoginView"], repeats: false)
                        self.present(self.customMainAlertVC, animated: true)
                    }
                }
                
            }
        }
        return v
    }()
    lazy var customAlerLoginView:CustomMustLogInView = {
        let v = CustomMustLogInView()
        v.setupAnimation(name: "15179-confirm-popup")
        v.okButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        v.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return v
    }()
    
    lazy var mainImage:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Rectangle 7"))
        i.isUserInteractionEnabled = true
        return i
    }()
    
    lazy var tableView:UITableView = {
        let t = UITableView(backgroundColor: .white)
        t.delegate = self
        t.dataSource = self
        t.tableFooterView = UIView()
        t.separatorStyle = .none
        t.backgroundColor = .white
        t.showsVerticalScrollIndicator=false
        //        tableView.contentInset = .init(top: 16, left: 16, bottom: 0, right: 16)
        t.register(BaseSettingCell.self, forCellReuseIdentifier: cellId)
        t.register(NotificationSettingCell.self, forCellReuseIdentifier: cellNotifyId)
        return t
    }()
    
    var timerForAlerting = Timer()
    
    var baseSetttingData: BaseSettingModel?
    fileprivate let cellId="cellId"
    fileprivate let cellNotifyId = "cellNotifyId"
    fileprivate var isLogin = false
    fileprivate var isDataFetched = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        statusBarBackgroundColor()
    }
    
    
    //MARK: - override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        showOrHideCustomTabBar(hide: true)
        
        if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
            user = cacheCurrentUserCodabe.storedValue
            isLogin = true
            tableView.reloadData()
        }
        
        if !userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
            user=nil
            isLogin = false
            tableView.reloadData()
        }
        
        //        fetchData()
        //self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        //        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:-User methods
    
    fileprivate func fetchInfo(_ user:UserModel)  {
        guard let url = URL(string: user.photoURL) else{return}
        customTopUserView.userImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "man-user").withRenderingMode(.alwaysTemplate))
        customTopUserView.userNameLabel.text = "HI, ".localized + "\(user.name)"
        //        customTopUserView.isLogin = true
    }
    
    fileprivate func fetchData()  {
        if isDataFetched {
            //            UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
            var group1: BaseSettingModel?
            //        var group2: BaseAqarModel?
            SVProgressHUD.setForegroundColor(UIColor.green)
            SVProgressHUD.show(withStatus: "Looding....".localized)
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            SettingServices.shared.getAllSettings(completion: { (base, error) in
                dispatchGroup.leave()
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();return
                }
                group1 = base
            })
            
            dispatchGroup.notify(queue: .main) { [unowned self]  in
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.baseSetttingData = group1
                //            self.aqarArray =  group2?.data ?? []
                self.isDataFetched = false
                self.tableView.reloadData()
            }
        }else {}
    }
    
    fileprivate  func loadUserData()  {
        
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1)//ColorConstant.mainBackgroundColor
        view.addSubview(mainImage)
        mainImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 16, left: -8, bottom: -8, right: -8))
        mainImage.addSubview(tableView)
        tableView.fillSuperview(padding: .init(top: 16, left: 24, bottom: 0, right: 24))
    }
    
    fileprivate func resetAppLanguage(_ isArabic:Bool) {
        //reset language
        self.navigationController?.popViewController(animated: true)
        if isArabic {
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "ar")
        }else {
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "ar" ? "en" : "en")
        }
        MOLH.reset()
    }
    
    //TODO:-Handle methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleArabicLanguage(sender:UIButton)  {
        resetAppLanguage(true)
        removeViewWithAnimation(vvv: customChangeLanguage)
        customMainAlertVC.dismiss(animated: true)
        //        resetAppLanguage(true)
        changeButtonsPropertyWhenSelected(sender, vv: customChangeLanguage.englishButton)
        
    }
    
    
    @objc  func fireTimer(timer:Timer)  {
        if  let userInfo = timerForAlerting.userInfo as? [String: String]   {
            
            removeViewWithAnimation(vvv: customNoInternetView)
            removeViewWithAnimation(vvv: customAlerLoginView)
            
            customMainAlertVC.dismiss(animated: true)
        }
    }
    
    @objc fileprivate  func handleEnglishLanguage(sender:UIButton)  {
        resetAppLanguage(false)
        removeViewWithAnimation(vvv: customChangeLanguage)
        customMainAlertVC.dismiss(animated: true)
        //        resetAppLanguage(false)
        changeButtonsPropertyWhenSelected(sender, vv: customChangeLanguage.arabicButton)
        
    }
    
    @objc fileprivate func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func goToLogin() {
        //        showOrHideCustomTabBar(hide: true)
        let login = LoginVC()
        let nav = UINavigationController(rootViewController: login)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc fileprivate  func handleLogin()  {
        removeViewWithAnimation(vvv:customAlerLoginView)
        customMainAlertVC.dismiss(animated: true)
        goToLogin()
        //        navigationController?.pushViewController(login, animated: true)
        
        
    }
    
    
    
    @objc func handleSignOutOk()  {
        removeViewWithAnimation(vvv: customSignOutView)
        customMainAlertVC.dismiss(animated: true)
        sigoutUser()
    }
    
    @objc func handleSignOutCancel()  {
        removeViewWithAnimation(vvv: customSignOutView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc func handleOk()  {
        
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc fileprivate func handleCancel()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        customMainAlertVC.dismiss(animated: true)
    }
}

//MARK:-Extensions

extension UserSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ss = section == 3 && isLogin == true
        let dd = section == 3 && isLogin == false
        return section == 0 ? 1 : section == 2 ? 1 : ss ? 4  :  dd ? 3 : 2
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellNotifyId, for: indexPath) as! NotificationSettingCell
            cell.handleMuteNotification = {[unowned self] bool in
                bool ? UIApplication.shared.unregisterForRemoteNotifications() : () // unregister for remote notifications
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseSettingCell
        if indexPath.section == 0 {
            addCellValues(cell, section: 0, index: 0, text: "Chat".localized, image: #imageLiteral(resourceName: "Group 3923-12"))
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                addCellValues(cell, section: 1, index: 0, text: "Edit Profile".localized, image: #imageLiteral(resourceName: "Group 3924-2"))
            }else {
                addCellValues(cell, section: 2, index: 1, text: "Change Password".localized, image: #imageLiteral(resourceName: "Group 3925-2"))
            }
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                addCellValues(cell, section: 3, index: 0, text: "Languages".localized, image: #imageLiteral(resourceName: "Group 3927-1"))
            } else if indexPath.row == 1 {
                addCellValues(cell, section: 3, index: 1, text: "Help".localized, image: #imageLiteral(resourceName: "Group 3928-1"))
            } else if indexPath.row == 2 {
                addCellValues(cell, section: 3, index: 2, text: "Contact Us".localized, image: #imageLiteral(resourceName: "Group 3929-1"))
            }else {
                let ss = !checkIfNotLogin()
                addCellValues(cell, section: 3, index: 0, text: "LogOut".localized, image: #imageLiteral(resourceName: "Group 3930-1"),hide: !isLogin)
                
            }
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 100 : 30
    }
    
    fileprivate func sigoutUser() {
        userDefaults.set(false, forKey: UserDefaultsConstants.isUserLogined)
        userDefaults.set(false, forKey: UserDefaultsConstants.isUserEditProfile)
        userDefaults.set(false, forKey: UserDefaultsConstants.isMessagedCahced)
        userDefaults.set(true, forKey: UserDefaultsConstants.isWelcomeVCAppear)
        userDefaults.set(true, forKey: UserDefaultsConstants.isAllCachedHome)
        userDefaults.set(false, forKey: UserDefaultsConstants.isCachedDriopLists)
        userDefaults.set(false, forKey: UserDefaultsConstants.isFavoriteFetched)
        userDefaults.set(false, forKey: UserDefaultsConstants.isNotificationsFetched)
        userDefaults.set(false, forKey: UserDefaultsConstants.isAllUserPostsDetailsFetched)
        
        userDefaults.synchronize()
        userDefaults.synchronize()
        self.user = nil
        cacheCurrentUserCodabe.deleteFile(cacheCurrentUserCodabe.storedValue!)
        
        isLogin = !isLogin
        customTopUserView.userNameLabel.text = "Login".localized
        customTopUserView.userImageView.image = #imageLiteral(resourceName: "Group 3931-1")
        creatMainSnackBar(message: "Sign Out Successfully...".localized)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        guard let ss = cacheMessagesUserCodabe.storedValue,let cc = cacheMessagessssUserCodabe.storedValue,let sss = cacheFavoriteAqarsCodabe.storedValue else { return }
        cacheMessagesUserCodabe.deleteFile(ss )
        cacheMessagessssUserCodabe.deleteFile(cc)
        cacheFavoriteAqarsCodabe.deleteFile(sss)
    }
    
    fileprivate  func goToChatVC()  {
        
        let chats = SecondMessagesCollectionVC()
        
        //        let chats = MessagesVC(token: user?.apiToken ?? "")
        navigationController?.pushViewController(chats, animated: true)
    }
    
    func goToChangePaasowrd()  {
        let change = ChangePasswordVC(token: user?.apiToken ?? "")
        navigationController?.pushViewController(change, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !ConnectivityInternet.isConnectedToInternet {
            customMainAlertVC.addCustomViewInCenter(views:customNoInternetView , height: 200)
            self.customNoInternetView.problemsView.play()
            
            customNoInternetView.problemsView.loopMode = .loop
            self.timerForAlerting.invalidate()
            self.timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fireTimer), userInfo: ["view": "customAlerLoginView"], repeats: false)
            self.present(customMainAlertVC, animated: true)
        }else {
            
            if indexPath.section == 0  {
                if indexPath.row == 0 {
                    if checkIfNotLogin() {
                        goToChatVC()
                    }else {
                        customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
                        self.customAlerLoginView.problemsView.play()
                        
                        customAlerLoginView.problemsView.loopMode = .loop
                        
                        self.present(self.customMainAlertVC, animated: true)
                    }
                    
                }
            }else if indexPath.section == 1 {
                if indexPath.row == 0 { //edit profile
                    if checkIfNotLogin() {
                        goToEditProfile()
                    }else {
                        customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
                        self.customAlerLoginView.problemsView.play()
                        
                        customAlerLoginView.problemsView.loopMode = .loop
                        self.timerForAlerting.invalidate()
                        self.timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fireTimer), userInfo: ["view": "customAlerLoginView"], repeats: false)
                        self.present(self.customMainAlertVC, animated: true)
                    }
                }else if indexPath.row == 1 { //change password
                    
                    if checkIfNotLogin() {
                        
                        goToChangePaasowrd()
                    }else {
                        customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
                        self.customAlerLoginView.problemsView.play()
                        
                        customAlerLoginView.problemsView.loopMode = .loop
                        self.timerForAlerting.invalidate()
                        self.timerForAlerting = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.fireTimer), userInfo: ["view": "customAlerLoginView"], repeats: false)
                        self.present(self.customMainAlertVC, animated: true)
                    }
                }
            }
            else if indexPath.section == 3 {
                if indexPath.row == 0 {
                    //                tableView.deselectRow(at: indexPath, animated: false)
                    
                    customMainAlertVC.addCustomViewInCenter(views: customChangeLanguage, height: 200)
                    self.present(self.customMainAlertVC, animated: true)
                } else if indexPath.row == 1 {
                    let help = HelpVC()
                    //                    _ = MOLHLanguage.isRTLLanguage() ? baseSetttingData?.data[5] : baseSetttingData?.data[1]
                    //                    help.help = setting
                    navigationController?.pushViewController(help, animated: true)
                }else if indexPath.row == 2 {
                    
                    
                    let contact = ContactUsVC()
                    navigationController?.pushViewController(contact, animated: true)
                }else {
                    if checkIfNotLogin() {
                        customMainAlertVC.addCustomViewInCenter(views: customSignOutView, height: 200)
                        self.customSignOutView.problemsView.play()
                        
                        customSignOutView.problemsView.loopMode = .loop
                        
                        self.present(self.customMainAlertVC, animated: true)
                    }else {
                        self.creatMainSnackBar(message: "You Must Log In First...".localized)
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            return customTopUserView
        }
        
        
        let text = section == 0 ? "" : section == 1 ? "Profile".localized : section == 2 ? "Notifications".localized : "General".localized
        
        let label = UILabel(text: text, font: .systemFont(ofSize: 20), textColor: .black)
        label.backgroundColor = .white
        label.padding = .init(top: 0, left: 24, bottom: 0, right: 0)
        label.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        return label
    }
    
    func checkIfNotLogin() -> Bool  {
        return userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) ? true : false
    }
    
    fileprivate func goToEditProfile()  {
        //        showOrHideCustomTabBar(hide: true)
        guard let user = user else { return  }
        //        let help = UserProfileVC(user: user)
        let help = UserProfileVC()
        help.user=user
        navigationController?.pushViewController(help, animated: true)
    }
    
    fileprivate func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: MOLHLanguage.isRTLLanguage() ? "back-arrow(1)" : "back-arrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack)) //back button-2
        navigationItem.title = "Setting".localized
    }
    
    fileprivate func addCellValues(_ cell: BaseSettingCell,section:Int,index:Int,text:String,image:UIImage,hide:Bool? = false) {
        cell.nameLabel.text = text
        cell.logoImageView.image = image
        [cell.nameLabel,cell.logoImageView].forEach({$0.isHide(hide ?? false)})
    }
    
    
    
    
    
    
}
