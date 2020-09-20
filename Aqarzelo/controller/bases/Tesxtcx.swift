//
//  Tesxtcx.swift
//  Aqarzelo
//
//  Created by Hossam on 9/20/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD

class Tesxtcx: UIViewController {
    
    lazy var myActivityIndicator:UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        v.color = .red
        
        v.constrainHeight(constant: 60)
        v.constrainWidth(constant: 60)
        return v
    }()
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    
    lazy var customErrorView:CustomErrorView = {
        let v = CustomErrorView()
        v.setupAnimation(name: "4970-unapproved-cross")
        v.okButton.addTarget(self, action: #selector(handleDoneError), for: .touchUpInside)
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
       
    }
    
    @objc  func handleDismiss()  {
        dismiss(animated: true)
    }
    
    @objc func handleDoneError()  {
        removeViewWithAnimation(vvv: customErrorView)
        customMainAlertVC.dismiss(animated: true)
    }
}
