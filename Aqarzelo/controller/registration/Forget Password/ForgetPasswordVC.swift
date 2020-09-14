//
//  ForgetPasswordVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import MOLH
import SkyFloatingLabelTextField

class ForgetPasswordVC: UIViewController {
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customForgetPassView:CustomForgetPasswordView = {
        let v = CustomForgetPasswordView()
        v.confirmButton.addTarget(self, action: #selector(handleConfirmReset), for: .touchUpInside)
        v.backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        return v
    }()
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModelObserver()
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHide(true)
        tabBarController?.tabBar.isHide(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    //MARK:-User methods
    
    
    
    fileprivate    func setupViewModelObserver()  {
        customForgetPassView.forgetPassViewModel.bindableIsFormValidate.bind {[unowned self] (isValidForm) in
            guard let isValid = isValidForm else {return}
            self.customForgetPassView.confirmButton.isEnabled = isValid
            
            self.changeButtonState(enable: isValid, vv: self.customForgetPassView.confirmButton)
        }
        customForgetPassView.forgetPassViewModel.bindableIsLogging.bind(observer: {  [unowned self] (isReg) in
            if isReg == true {
                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
                SVProgressHUD.setForegroundColor(UIColor.green)
                
                SVProgressHUD.show(withStatus: "Waiting...".localized)
                
            }else {
                SVProgressHUD.dismiss()
                self.activeViewsIfNoData()
            }
        })
        
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        view.addSubview(customForgetPassView)
        customForgetPassView.fillSuperview()
    }
    
    fileprivate  func goToNextTab(token:String,telephone:String)  {
        userDefaults.set(true, forKey: UserDefaultsConstants.isUserHaveSMSCode)
        userDefaults.synchronize()
        let forget = ForgetPasswordConfirmationVC(token: token, phone: telephone)
        navigationController?.pushViewController(forget, animated: true)
    }
    
    //TODO:-Handle methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleConfirmReset()  {
        
        customForgetPassView.forgetPassViewModel.performForget {[unowned self] (base,err) in
            if let err = err {
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let user = base?.data else  {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            
            DispatchQueue.main.async {
                self.goToNextTab(token:user.apiToken , telephone: self.customForgetPassView.forgetPassViewModel.email ?? "")
            }
        }
    }
    
    @objc func handleOk()  {
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    
}
