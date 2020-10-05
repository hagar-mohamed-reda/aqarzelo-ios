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
    
    
    
    lazy var asd = UILabel(text: "cutomtopView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 60, left: 0, bottom: 0, right: 0)) let ind = MyIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), image: #imageLiteral(resourceName: ))  view.addSubview(ind)  ind.startAnimating()  view.addSubview(logoImageView) logoImageView.centerInSuperview()", font: .systemFont(ofSize: 25), textColor: .black,numberOfLines: 0)
    
    lazy var ddd:ASD = {
       let t = ASD()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customAlerLoginView:CustomAlertForLoginView = {
        let v = CustomAlertForLoginView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
//        v.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
//        v.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ddd.addCustomViewInCenter(views: customAlerLoginView, height: 200)
        self.customAlerLoginView.problemsView.play()
        
        self.customAlerLoginView.problemsView.loopMode = .loop
        present(ddd, animated: true)
    }
    
    @objc fileprivate func handleDismiss()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        dismiss(animated: true, completion: nil)
    }
    
   
}

class ASD: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.alpha = 0.5
//        let blurFx = UIBlurEffect(style: UIBlurEffect.Style.dark)
//        let blurFxView = UIVisualEffectView(effect: blurFx)
//        blurFxView.frame = view.bounds
//        blurFxView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.insertSubview(blurFxView, at: 0)
    }
}
