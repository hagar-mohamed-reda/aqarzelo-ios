//
//  AppDelegate.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import FBSDKCoreKit
import GoogleSignIn
import MOLH


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MOLHResetable {
    
    
    
    
    var window: UIWindow?
    fileprivate let clientIdGoogle = "257735554348-8nahudhh60gautul3mgpoadlp3nmo1cf.apps.googleusercontent.com"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = clientIdGoogle
        GMSServices.provideAPIKey(apiKey)
        setupFacebook()
        MOLH.shared.activate(true)
        //        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //        statusBar.backgroundColor = #colorLiteral(red: 0.2279164791, green: 0.7175155878, blue: 0.7035514712, alpha: 1)
        setupGradientLayer() //for nav bar color
        keyboardChanges()
        saveUserFefults()
        window = UIWindow()
        window?.makeKeyAndVisible()
        //                 checkLoginState()
        window?.rootViewController = UINavigationController(rootViewController: MainCreatePostVC(token: ""))
        //        window?.rootViewController = UINavigationController(rootViewController: MainCreatePostVC()
        //        window?.rootViewController = UINavigationController(rootViewController: UserSettingsVC())//MainCreatePostVC(token: "17e798c152737ecb6084a124186c0d0900abd3f5506e50c68c56f0e151763fba"))//FilterVC()//HomeTabBarVC()//FilterVC()//HomeTabBarVC()//UINavigationController(rootViewController: LoginVC())//UserSettingTableVC()//UINavigationController(rootViewController: ListOfPhotoCollectionVC())
        
        //        setupGradientLayer()
        //        changeBackground()
        return true
    }
    
    func reset() {
        userDefaults.set(true, forKey: UserDefaultsConstants.isWelcomeVCAppear)
        userDefaults.set(true, forKey: UserDefaultsConstants.isAllCachedHome)
        
        userDefaults.synchronize()
        window?.rootViewController = HomeTabBarVC()
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled = false
        
        if url.absoluteString.contains("fb") {
            handled = ApplicationDelegate.shared.application(app, open: url, options: options)
            
        } else {
            //            handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        }
        
        return handled
        
        
    }
    
    func setupFacebook()  {
        
        
        //        GIDSignIn.sharedInstance().delegate = self
        
        // Configure Google Sign in
        //        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    func checkLoginState()  {
        window?.rootViewController = userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) ? HomeTabBarVC() :  UINavigationController(rootViewController: LoginVC())
    }
    
    fileprivate func keyboardChanges() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    
    func setupGradientLayer()  {
        
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        
        gradient.frame = defaultNavigationBarFrame
        
        gradient.colors = [ #colorLiteral(red: 0.2297443748, green: 0.7248970866, blue: 0.7031157017, alpha: 1).cgColor,#colorLiteral(red: 0.2283563912, green: 0.733122766, blue: 0.6636189222, alpha: 1).cgColor]
        
        UINavigationBar.appearance().setBackgroundImage(self.image(fromLayer: gradient), for: .default)
        
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveUserFefults()
    }
    
    fileprivate func saveUserFefults() {
        userDefaults.set(false, forKey: UserDefaultsConstants.isPostMaded)
        userDefaults.set(false, forKey: UserDefaultsConstants.isPostUpdated)
        
        userDefaults.set(true, forKey: UserDefaultsConstants.isWelcomeVCAppear)
        userDefaults.set(true, forKey: UserDefaultsConstants.isAllCachedHome)
        userDefaults.set(false, forKey: UserDefaultsConstants.isCachedDriopLists)
        userDefaults.set(false, forKey: UserDefaultsConstants.isFavoriteFetched)
        userDefaults.set(false, forKey: UserDefaultsConstants.isNotificationsFetched)
        userDefaults.set(false, forKey: UserDefaultsConstants.isAllUserPostsDetailsFetched)
        userDefaults.set(true, forKey: UserDefaultsConstants.fetchRecommendPosts)
        userDefaults.set(true, forKey: UserDefaultsConstants.fetchUserInfoAndLocation)

        
        
        userDefaults.synchronize()
    }
    
}

extension UIApplication {
var statusBarUIView: UIView? {

    if #available(iOS 13.0, *) {
        let tag = 3848245

        let keyWindow = UIApplication.shared.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows.first

        if let statusBar = keyWindow?.viewWithTag(tag) {
            return statusBar
        } else {
            let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            let statusBarView = UIView(frame: height)
            statusBarView.tag = tag
            statusBarView.layer.zPosition = 999999

            keyWindow?.addSubview(statusBarView)
            return statusBarView
        }

    } else {

        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
    }
    return nil
  }
}
