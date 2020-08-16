//
//  NotificationCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Lottie
import SVProgressHUD
import MOLH

class NotificationCollectionVC: BaseCollectionVC {
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.black
        return refreshControl
        
    }()
    
    lazy var problemsView:AnimationView = {
        let i = AnimationView()
        i.animation = Animation.named("10002-empty-notification")
        i.play()
        i.loopMode = .loop
        //    i.constrainHeight(constant: 150)
        //    i.constrainWidth(constant: v)
        //        i.contentMode = .scaleAspectFit
        return i
    }()
    
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
    lazy var customAlerLoginView:CustomAlertForLoginView = {
        let v = CustomAlertForLoginView()
        v.setupAnimation(name: "4970-unapproved-cross")
        v.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        v.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return v
    }()
    
    fileprivate let cellId = "cellId"
    fileprivate let cellHeaderId = "cellHeaderId"
    var notificationsArray: [NotificationModel]?  {
        didSet {
            guard let notificationsArray = notificationsArray else { return  }
            DispatchQueue.main.async {
                self.collectionView.backgroundView?.alpha = notificationsArray.count > 0 ? 0.0 : 1.0
                
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2015180886, green: 0.811791122, blue: 0.7185178995, alpha: 1)
        setupCollections()
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHide(false)
        if !ConnectivityInternet.isConnectedToInternet {
            customMainAlertVC.addCustomViewInCenter(views: customNoInternetView, height: 200)
            self.customNoInternetView.problemsView.play()
            
            customNoInternetView.problemsView.loopMode = .loop
            
            self.present(self.customMainAlertVC, animated: true)
        }else if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
            userDefaults.bool(forKey: UserDefaultsConstants.isNotificationsFetched) ? () : loadNotifications()
        }else {
            customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
            self.customAlerLoginView.problemsView.play()
            
            customAlerLoginView.problemsView.loopMode = .loop
            
            self.present(self.customMainAlertVC, animated: true)
        }
        tabBarController?.tabBar.isHide(false)
        problemsView.play()
        problemsView.loopMode = .loop
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let notificationsArray = notificationsArray else { return 0 }
        
        //        collectionView.noDataFound(notificationsArray.count, text: "No Data Added Yet".localized)
        
        return notificationsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NotificationCollectionCell
        guard let notificationsArray = notificationsArray else { return UICollectionViewCell()  }
        
        let notify = notificationsArray[indexPath.item]
        
        cell.notify = notify
        //        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let notificationsArray = notificationsArray else { return .zero}
        
        let notifyq = notificationsArray[indexPath.item]
        
        let notificationCell  = NotificationCollectionCell(frame: .init(x: 0, y: 0, width: view.frame.width-16, height: 1000))
        notificationCell.notificationDiscriptioneLabel.text = notifyq.body
        notificationCell.layoutIfNeeded()
        let estimated = notificationCell.systemLayoutSizeFitting(.init(width: view.frame.width-16, height: 1000))
        
        return .init(width: view.frame.width-32, height: estimated.height+60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let notificationsArray = notificationsArray else { return  }
        
        let postId = notificationsArray[indexPath.item]
        guard let aqar = postId.post else { return  }
        let aqars = AqarDetailsInfoVC(aqar: aqar)
        navigationController?.pushViewController(aqars, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    //MARK:-User methods
    
    fileprivate func loadNotifications()  {
        
        guard let token = userDefaults.value(forKey: UserDefaultsConstants.userApiToken) as? String else { return }
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding...".localized)
        NotificationAndFavoriteServices.shared.getAllNotifications(apiToke: token) {[unowned self] (bases, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
            }
            SVProgressHUD.dismiss()
            guard let base = bases?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? bases?.messageAr : bases?.messageEn); return}
            self.notificationsArray = base
            userDefaults.set(true, forKey: UserDefaultsConstants.isNotificationsFetched)
            userDefaults.synchronize()
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.collectionView.refreshControl?.beginRefreshing()
                self.collectionView.refreshControl?.endRefreshing()
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupCollections() {
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
        collectionView.showsVerticalScrollIndicator=false
        
        collectionView.clipsToBounds = true
        //        collectionView.backgroundColor = #colorLiteral(red: 0.2015180886, green: 0.811791122, blue: 0.7185178995, alpha: 1)
        collectionView.register(NotificationCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(NotificationHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellHeaderId)
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 8, right: 16)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.alwaysBounceVertical=true
        collectionView.refreshControl = refreshControl
        collectionView.backgroundView = problemsView
    }
    
    override func setupNavigation() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Notifications".localized
    }
    
    //TODO:-Hnadle methods
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleOk()  {
        
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc  func didPullToRefresh()  {
        loadNotifications()
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
    
    
}
