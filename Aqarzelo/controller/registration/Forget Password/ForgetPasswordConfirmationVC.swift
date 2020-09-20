//
//  ForgetPasswordConfirmationVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import MOLH
import SkyFloatingLabelTextField

class ForgetPasswordConfirmationVC: UIViewController {
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customForgetPassConfirmView:CustomForgetPasswordConfirmationView = {
        let v = CustomForgetPasswordConfirmationView()
        v.token = token
        v.phone = phone
        v.confirmButton.addTarget(self, action: #selector(handleConfirmReset), for: .touchUpInside)
        v.resendSMSButton.addTarget(self, action: #selector(handleResendSMS), for: .touchUpInside)
        v.backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        return v
    }()
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return v
    }()
    lazy var customResetPasswordView:CustomResetPasswordView = {
        let v = CustomResetPasswordView()
        v.setupAnimation(name: "success")
        v.constrainHeight(constant: 150)
        return v
    }()
    
    
    fileprivate var token:String!
    fileprivate let phone:String!
    
    init(token:String,phone:String) {
        self.token = token
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModelObserver()
        statusBarBackgroundColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHide(true)
        tabBarController?.tabBar.isHide(true)
    }
    
    //MARK:-User methods
    
    fileprivate  func setupViewModelObserver()  {
        customForgetPassConfirmView.forgetPassConfirmViewModel.bindableIsFormValidate.bind {[unowned self] (isValidForm) in
            guard let isValid = isValidForm else {return}
            self.customForgetPassConfirmView.confirmButton.isEnabled = isValid
            
            self.changeButtonState(enable: isValid, vv: self.customForgetPassConfirmView.confirmButton)
        }
        customForgetPassConfirmView.forgetPassConfirmViewModel.bindableIsConfirm.bind {  [unowned self] (isReg) in
            if isReg == true {
                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
                self.progressHudProperties()
                
            }else {
                SVProgressHUD.dismiss()
                self.activeViewsIfNoData()
            }
        }
        
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        view.addSubview(customForgetPassConfirmView)
        customForgetPassConfirmView.fillSuperview()
    }
    
    fileprivate  func goToMainTab()  {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    fileprivate func saveToken(token:String) {
        userDefaults.set(token, forKey: UserDefaultsConstants.userApiToken)
        //        userDefaults.set(true, forKey: UserDefaultsConstants.isUserWaitForSMSCode)
        
        userDefaults.synchronize()
        //        SVProgressHUD.dismiss()
    }
    
    //TODO:-Handle methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate  func handleResendSMS()  {
        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
       progressHudProperties()
        RegistrationServices.shared.forgetPassword(phone: phone) {[unowned self] (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let user = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            
            self.token = user.apiToken //?? self.token
            
        }
        
    }
    
    
    
    @objc fileprivate func handleConfirmReset()  {
        
        customForgetPassConfirmView.forgetPassConfirmViewModel.performConfirmation { (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let token = base?.data?.apiToken else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            self.saveToken(token: token)
            SVProgressHUD.showSuccess(withStatus: "Password reset successfully".localized)
            
            DispatchQueue.main.async {
                self.goToMainTab()
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

