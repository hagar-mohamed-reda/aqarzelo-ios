//
//  NavigationBar.swift
//  Aqarzeoo
//
//  Created by hosam on 1/30/20.
//  Copyright © 2020 hosam. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
extension UIViewController {
    
    
    func showToast(context ctx: UIViewController, msg: String) {
              let la = UILabel(text: msg, font: .systemFont(ofSize: 16), textColor: .white, textAlignment: .center, numberOfLines: 0)
              let height = msg.getFrameForText(text: msg)
              la.constrainHeight(constant: height.height+20)
              la.constrainWidth(constant: view.frame.width)
              la.layer.cornerRadius=12
              la.clipsToBounds=true
              la.backgroundColor = UIColor.black
              ctx.view.addSubview(la)
              la.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 16, right: 0))
              UIView.animate(withDuration: 10.0, delay: 0.2,
                             options: .curveEaseOut, animations: {
                              la.alpha = 0.0
              }, completion: {(isCompleted) in
                  la.removeFromSuperview()
              })
          }
    
    func checkIfUserLoginBefore() -> Bool {
        return userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined)
    }
    
    func showErrorMessage(message:String)  {
        SVProgressHUD.showError(withStatus: message)
    }
    
     func showError(message:String)  {
        let alert = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func addCustomViewInCenter(views:UIView,height:CGFloat)  {
        
        view.addSubview(views)
        views.centerInSuperview(size: .init(width: view.frame.width-64, height: height))
        views.transform = .init(translationX: -1000, y: 0)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            views.transform = .identity
        })
    }
   
    
    func removeCustomViewIntoVC(vi:UIView)  {
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            vi.transform = .init(translationX: 1000, y: 0)
            
        }) {(_) in
            vi.removeFromSuperview()
        }
    }
    
}
