//
//  HomeTabBarVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeTabBarVC: UITabBarController {
    
    
    lazy var cornerView:UIView = {
        let roundedView=UIView(backgroundColor: #colorLiteral(red: 0.8861995339, green: 0.8863242269, blue: 0.8861603141, alpha: 1))
        
        roundedView.layer.masksToBounds = true
        roundedView.layer.cornerRadius = 28//24
        //        roundedView.layer.borderWidth = 2.0
        roundedView.isUserInteractionEnabled = false
        //        roundedView.layer.borderColor = UIColor.lightGray.cgColor
        return roundedView
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
    var isUserLogined = false
    var selectedIndexxx = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndexxx = tabBarController?.selectedIndex ?? 0
        //        if userDefaults.integer(forKey: UserDefaultsConstants.lastSelectedIndexTabBar) != nil {
        //            self.selectedIndexxx = userDefaults.integer(forKey: UserDefaultsConstants.lastSelectedIndexTabBar)
        //        }
        
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        
        gradient.frame = defaultNavigationBarFrame
        
        
        gradient.colors = [#colorLiteral(red: 0.2775115967, green: 0.6328162551, blue: 0.6509115696, alpha: 1).cgColor, #colorLiteral(red: 0.4237544537, green: 0.8377003074, blue: 0.6738700867, alpha: 1).cgColor,#colorLiteral(red: 0.2374193072, green: 0.5496195555, blue: 0.5651212931, alpha: 1).cgColor]
        view.backgroundColor = .white
        self.delegate = self
        tabBar.addSubview(cornerView)
        cornerView.fillSuperview(padding: .init(top: 8, left: 12, bottom: 8, right: 12))//16
        setupTabBar()
        setupViewControllers()
        //        UINavigationBar.appearance().barTintColor  = #colorLiteral(red: 0.1800859272, green: 0.6703509688, blue: 0.6941409707, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
            isUserLogined = true
        }else {
            isUserLogined = false
        }
    }
    
    private func customizeTabBarView() {
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .default
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        object_setClass(self.tabBar, CustomTabBarss.self)
        
        /* some stuff here */
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tabBar.itemPositioning = .centered
        tabBar.layer.cornerRadius = 24
        tabBar.layer.masksToBounds = true
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:-User methods
    
    fileprivate func setupTabBar() {
        self.viewDidLayoutSubviews()
    }
    
    
    fileprivate func setupViewControllers() {
        let location = templateNavControllerVC( selectedImage: #imageLiteral(resourceName: "placeholder-filled-point (1)"), rootViewController: LocationVC())
        let cart = templateNavControllerVC( selectedImage: #imageLiteral(resourceName: "plus (2)-1"), rootViewController: AddPostVC() )
        let love = templateNavControllerVC( selectedImage: #imageLiteral(resourceName: "favorite-heart-button (2)"), rootViewController: FavoriteCollectionVC())
        let notification = templateNavControllerVC( selectedImage: #imageLiteral(resourceName: "notification"), rootViewController: NotificationCollectionVC())
        
        
        tabBar.barTintColor = #colorLiteral(red: 0.9966195226, green: 0.9997286201, blue: 0.9998206496, alpha: 1)
        
        viewControllers = [
            location,
            cart ,
            
            
            
            notification,
            love,
        ]
        guard let items = tabBar.items else { return }
        var myDefaultFontSize: CGFloat = -8
        
        
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S: myDefaultFontSize = -8
        case .iPhone6, .iPhone7, .iPhone8, .iPhone6S,.iPhone6SPlus, .iPhoneX: myDefaultFontSize = -8
        default: myDefaultFontSize = -42
        }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: myDefaultFontSize, right: 0)
        }
        
    }
    
    fileprivate func templateNavControllerVC(  selectedImage: UIImage, rootViewController: UIViewController ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        //        navController.tabBarItem.title = nil
        navController.tabBarItem.image = selectedImage
        
        navController.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        return navController
    }
    
    fileprivate func remvoeView(_ views:UIView) {
        views.removeFromSuperview()
    }
    
    fileprivate func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    func showAlertLogin()  {
        customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
        self.customAlerLoginView.problemsView.play()
        
        self.customAlerLoginView.problemsView.loopMode = .loop
        present(customMainAlertVC, animated: true)
    }
    
    //TODO:-Handle methods
    
    @objc fileprivate func handleLogin ()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        customMainAlertVC.dismiss(animated: true)
        let login = LoginVC()
        let nav = UINavigationController(rootViewController: login)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        removeIconTitle()
        
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
        removeIconTitle()
    }
    
    func removeIconTitle()  {
        guard let tabs = tabBar.items else {return}
        tabs[2].image = #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysTemplate)
        tabs[3].image = #imageLiteral(resourceName: "favorite-heart-button (2)").withRenderingMode(.alwaysTemplate)
    }
    
    @objc fileprivate func handleDismiss()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        dismiss(animated: true, completion: nil)
        removeIconTitle()
    }
    
}

extension HomeTabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        
        guard let tabs = tabBar.items else {return}
        let ff = tabBarController.selectedIndex
        selectedIndexxx=ff==2||ff==3 ? selectedIndexxx : ff
        if !isUserLogined {
            if tabBarController.selectedIndex == 2{
                tabBarController.selectedIndex = self.selectedIndexxx
                showAlertLogin()
                tabs[2].image = #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal)
                tabs[3].image = #imageLiteral(resourceName: "favorite-heart-button (2)").withRenderingMode(.alwaysTemplate)
                return
            }
            if tabBarController.selectedIndex == 3{
                tabBarController.selectedIndex = self.selectedIndexxx
                tabs[3].image = #imageLiteral(resourceName: "favorite-heart-button (2)").withRenderingMode(.alwaysOriginal)
                tabs[2].image = #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysTemplate)
                showAlertLogin()
                return
            }
            if tabBarController.selectedIndex == 0 || tabBarController.selectedIndex == 1 {
                tabs[2].image = #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysTemplate)
                tabs[3].image = #imageLiteral(resourceName: "favorite-heart-button (2)").withRenderingMode(.alwaysTemplate)
            }
        }else {}
        
    }
    // for disable tabed
    //        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    //            if !userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
    //
    //
    //                if let tabs = tabBar.items {
    //                    if viewController == tabBarController.viewControllers?[3]  {
    //                        tabs[3].selectedImage = #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal)
    //                        return false
    //                    } else if viewController ==  tabBarController.viewControllers?[2] {
    //                        tabs[2].selectedImage = #imageLiteral(resourceName: "favorite-heart-button (2)").withRenderingMode(.alwaysOriginal)
    //                        return false
    //                    }else {
    //
    //                    }
    //                }
    //
    //            }else {
    //                return true
    //            }
    //            return true
    //        }
}
