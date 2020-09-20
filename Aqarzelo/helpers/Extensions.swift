//
//  Extensions.swift
//  Aqarzeoo
//
//  Created by hosam on 2/1/20.
//  Copyright © 2020 hosam. All rights reserved.
//

import UIKit
//import MaterialComponents.MaterialSnackbar
//import Toaster

import MOLH
import SVProgressHUD

extension UIViewController {
    
    func callMainError(err:String,vc:UIViewController,views:CustomErrorView)  {
        DispatchQueue.main.async {
            
        
         vc.addCustomViewInCenter(views: views, height: 220)
        views.errorInfoLabel.text = err
               views.problemsView.play()
               views.problemsView.loopMode = .loop
               
               self.present(vc, animated: true)
        }
    }
    
    func progressHudProperties() {
        let height =  UIScreen.main.bounds.height/12
        SVProgressHUD.setRingThickness(20)
        SVProgressHUD.setRingNoTextRadius(height)
    
//        SVProgressHUD.setMinimumSize(.init(width: 180, height: 20))
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.2015180886, green: 0.811791122, blue: 0.7185178995, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.show()
    }
    
    func showOrHideCustomTabBar(hide:Bool)  {
        let home = UIWindow.key?.rootViewController as? HomeTabBarVC
//        home?.customTabBarView.isHide(hide)
    }
    
    func hidedCustomWhiteViewTabBar(hide:Bool)  {
        let home = HomeTabBarVC()
//        home.customTabBarView.isHide(hide)
//        home.customTabBarView.removeFromSuperview()
        DispatchQueue.main.async {
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
       
        
    }
    
    //    func addGradient(_ toAlpha: CGFloat, _ color2: UIColor, _ color1: UIColor) {
    //        let gradient = CAGradientLayer()
    //        gradient.colors = [
    ////            color1.cgColor,color2.cgColor
    //            color1.withAlphaComponent(toAlpha).cgColor,
    //            color1.withAlphaComponent(toAlpha).cgColor,
    //            color1.withAlphaComponent(0).cgColor,
    //
    //            color2.withAlphaComponent(toAlpha).cgColor,
    //            color2.withAlphaComponent(toAlpha).cgColor,
    //            color2.withAlphaComponent(0).cgColor
    //        ]
    //        gradient.locations = [0, 1]
    //        var frame = bounds
    //        frame.size.height += UIApplication.shared.statusBarFrame.size.height
    //        frame.origin.y -= UIApplication.shared.statusBarFrame.size.height
    //        gradient.frame = frame
    //        layer.insertSublayer(gradient, at: 1)
    //    }
    
    
    func activeViewsIfNoData()  {
        DispatchQueue.main.async {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func addStatusBarBackgroundView(viewController: UIViewController) -> Void {
        let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size:CGSize(width: SCREEN_WIDTH, height:20))
        let view : UIView = UIView.init(frame: rect)
        view.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) //Replace value with your required background color
        viewController.view?.addSubview(view)
    }
    
    
   
    
    func creatMainSnackBar(message:String)  {
        
        showToast(context: self, msg: message)
    }
    
     func removeViewWithAnimation(vvv:UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                vvv.transform = .init(translationX: 10000, y: 0)
            }) { (_) in
                
                vvv.removeFromSuperview()
            }
        }
    }
    
    func changeButtonsPropertyWhenSelected(_ sender: UIButton,vv:UIButton) {
        sender.backgroundColor = ColorConstant.mainBackgroundColor
        sender.setTitleColor(.white, for: .normal)
        vv.backgroundColor = .white
        vv.setTitleColor(.black, for: .normal)
    }
    
    func changeButtonState(enable:Bool,vv:UIButton)  {
        if enable {
            vv.backgroundColor = #colorLiteral(red: 0.4301581085, green: 0.8535569906, blue: 0.6972886324, alpha: 1)
            vv.setTitleColor(.white, for: .normal)
        }else {
            vv.backgroundColor = .white
            vv.setTitleColor(.black, for: .normal)
        }
        vv.isEnabled = enable
    }
}

extension UICollectionViewCell {
    
    func showHidingViews(views: UIView...,imageView:UIImageView,image:UIImage,seperator:UIView)  {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            views.forEach({$0.isHide(false)})
            seperator.backgroundColor = ColorConstant.createPostImageChoosedColor
            imageView.image = image
        })
    }
    
    func showHidingViewsWithoutSepertor(views: UIView...,imageView:UIImageView,image:UIImage)  {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            views.forEach({$0.isHide(false)})
            imageView.image = image
        })
    }
    
    
    func hideViewsAgain  (views:UIView...   )  {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            views.forEach({$0.isHide(true)})
        })
    }
    
    func colorBackgroundSelectedButton(sender:UIButton,views:[UIButton])  {
        views.forEach { (bt) in
            bt.setTitleColor(.black, for: .normal)
            bt.backgroundColor = .white
        }
        sender.backgroundColor = ColorConstant.mainBackgroundColor
    }
}


//MARK: - UIApplication Extension
extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        return viewController
    }
    
    
        static func getMainTabBarController() -> HomeTabBarVC? {
            if #available(iOS 13, *) {
                return UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController as? HomeTabBarVC
                   } else {
                return UIWindow.key?.rootViewController as? HomeTabBarVC
                   }
//            return shared.keyWindow?.rootViewController as? HomeTabBarVC
        }
    
}

extension UICollectionView{
    
    func noDataFound(_ dataCount:Int,text:String){
        if dataCount <=  0 {
            
            let label = UILabel()
            label.frame = self.frame
            label.frame.origin.x = 0
            label.frame.origin.y = 0
            label.textAlignment = .center
            label.text =  text
            self.backgroundView = label
        }else{
            self.backgroundView = nil
        }
    }
    
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 71
//        return sizeThatFits
//    }
}

extension UIBarButtonItem {
    
    var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }
    
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
    
  
    
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1

      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    
}

extension UIViewController{
    func statusBarBackgroundColor() {
           if #available(iOS 13, *)
           {
               let statusBar = UIView(frame: (UIWindow.key?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor =  #colorLiteral(red: 0.2301297784, green: 0.5344927907, blue: 0.5495229959, alpha: 1)
               UIWindow.key?.addSubview(statusBar)
           } else {
               // ADD THE STATUS BAR AND SET A CUSTOM COLOR
               let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
               if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor =  #colorLiteral(red: 0.2301297784, green: 0.5344927907, blue: 0.5495229959, alpha: 1)
               }
           }
       }
    
    func hideStatusBarBackground() {
         UIWindow.key?.subviews.forEach({$0.backgroundColor = .clear})
    }
}
