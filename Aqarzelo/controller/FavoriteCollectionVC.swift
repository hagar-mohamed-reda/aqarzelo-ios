//
//  FavoriteCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import Lottie
import MOLH

class FavoriteCollectionVC: BaseCollectionVC {
    
    lazy var problemsView:AnimationView = {
        let i = AnimationView()
        i.animation = Animation.named("10223-search-empty")
        i.play()
        i.loopMode = .loop
        //    i.constrainHeight(constant: 150)
        //    i.constrainWidth(constant: v)
        //        i.contentMode = .scaleAspectFit
        return i
    }()
    
    lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.black
        return refreshControl
        
    }()
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return v
    }()
    lazy var customAlerLoginView:CustomAlertForLoginView = {
        let v = CustomAlertForLoginView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        v.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return v
    }()
    
    fileprivate let cellId = "cellId"
    var favoriteArray: [AqarModel]?  {
        didSet {
            guard let favoriteArray = favoriteArray else { return  }
            DispatchQueue.main.async {
                self.collectionView.backgroundView?.alpha = favoriteArray.count > 0 ? 0.0 : 1.0
            }
        }
    }
    var favoriteArrayTotal = [Int]()
    
    var aqars:[AqarModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2015180886, green: 0.811791122, blue: 0.7185178995, alpha: 1)
        setupCollections()
        statusBarBackgroundColor()
        loadFavorites()
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
            userDefaults.bool(forKey: UserDefaultsConstants.isFavoriteFetched) ? () : loadFavorites()
        }else {
            customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
            self.customNoInternetView.problemsView.play()
            
            customAlerLoginView.problemsView.loopMode = .loop
            self.present(self.customMainAlertVC, animated: true)
        }
        tabBarController?.tabBar.isHide(false)
        UIApplication.getMainTabBarController()?.viewControllers?[3].tabBarItem.badgeValue = nil
        problemsView.play()
        problemsView.loopMode = .loop
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let favoriteArray = favoriteArray else { return 0 }
        //        collectionView.noDataFound(favoriteArray.count, text: "No Data Added Yet".localized)
        
        return favoriteArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteCollectionCell
        guard let favoriteArray = favoriteArray else { return  UICollectionViewCell()}
        
        let aqar = favoriteArray[indexPath.item]
        //
        cell.aqar = aqar
        //        cell.locationCollectionCell.aqar = aqar
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16  ) / 2
        return .init(width: width, height: width + 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let favoriteArray = favoriteArray else { return}
        let aqar = favoriteArray[indexPath.item]
        let detailAqar = AqarDetailsInfoVC(aqar: aqar)
        self.navigationController?.pushViewController(detailAqar, animated: true)
        
    }
    
    //MARK:-User methods
    
    fileprivate func loadFavorites()  {
        
        favoriteArray = cacheFavoriteAqarsCodabe.storedValue
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.beginRefreshing()
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    
    
    fileprivate func setupCollections() {
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 16
        collectionView.clipsToBounds = true
        collectionView.showsVerticalScrollIndicator=false
        
        collectionView.register(FavoriteCollectionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = .init(top: 16, left: 16, bottom: 8, right: 16)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        collectionView.alwaysBounceVertical=true
        collectionView.refreshControl = refreshControl
        collectionView.backgroundView = problemsView
        
    }
    
    override func setupNavigation() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Favorite".localized
    }
    
    //MARK:-handle methods
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc  func didPullToRefresh()  {
        loadFavorites()
    }
    
    @objc func handleOk()  {
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
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
