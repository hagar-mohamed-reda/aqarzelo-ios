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
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        
        gradient.frame = defaultNavigationBarFrame
        
        
        gradient.colors = [#colorLiteral(red: 0.2775115967, green: 0.6328162551, blue: 0.6509115696, alpha: 1).cgColor, #colorLiteral(red: 0.4237544537, green: 0.8377003074, blue: 0.6738700867, alpha: 1).cgColor,#colorLiteral(red: 0.2374193072, green: 0.5496195555, blue: 0.5651212931, alpha: 1).cgColor]
        view.backgroundColor = .white
        self.delegate = self
        tabBar.addSubview(cornerView)
        cornerView.fillSuperview(padding: .init(top: 8, left: 12, bottom: 8, right: 12))//16
        addCustomTabBarView()
        setupTabBar()
        setupViewControllers()
        //        UINavigationBar.appearance().barTintColor  = #colorLiteral(red: 0.1800859272, green: 0.6703509688, blue: 0.6941409707, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
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
    
    fileprivate func addCustomTabBarView() {
        
        
        
        
    }
    
    
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
    
    //TODO:-Handle methods
    
}

extension HomeTabBarVC: UITabBarControllerDelegate {
    
    // for disable tabed
    //    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    //        if !userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) {
    //
    //
    //            if let tabs = tabBar.items {
    //                if viewController == tabBarController.viewControllers?[3]  {
    //                    tabs[3].selectedImage = #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal)
    //                    return false
    //                } else if viewController ==  tabBarController.viewControllers?[2] {
    //                    tabs[2].selectedImage = #imageLiteral(resourceName: "favorite-heart-button (2)").withRenderingMode(.alwaysOriginal)
    //                    return false
    //                }else {
    //
    //                }
    //            }
    //
    //        }else {
    //            return true
    //        }
    //        return true
    //    }
}
