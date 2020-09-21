//
//  ChangePasswordVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import SkyFloatingLabelTextField
import MOLH

class ChangePasswordVC: UIViewController {
    
    fileprivate let api_token:String!
    init(token:String) {
        self.api_token = token
        super.init(nibName: nil, bundle: nil)
    }
    lazy var customErrorView:CustomErrorView = {
           let v = CustomErrorView()
           v.setupAnimation(name: "4970-unapproved-cross")
           v.okButton.addTarget(self, action: #selector(handleDoneError), for: .touchUpInside)
           return v
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
    
    lazy var customChangePassword:CustomChangePasswordView = {
        let v = CustomChangePasswordView()
        v.api_token = api_token
        v.submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        setupViewModelObserver()
        statusBarBackgroundColor()
    }
    
    
    
    //MARK: - override methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        //        fetchData()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        SVProgressHUD.dismiss()
        
        //        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupViews()  {
        view.backgroundColor = #colorLiteral(red: 0.3416801989, green: 0.7294322848, blue: 0.6897809505, alpha: 1)//ColorConstant.mainBackgroundColor
        
        view.addSubViews(views: customChangePassword)
        //        mainView.addSubview(customChangePassword)
        customChangePassword.fillSuperview(padding: .init(top: 16, left: 0, bottom: -20, right: 0))
        
    }
    
    func updateUserProfile()  {
        
        
        customChangePassword.changePpasswordViewModel.performLogging {[unowned self] (base,err) in
            if let err = err {
                DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                self.callMainError(err: err.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView)
                            }
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let user = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn);return}
            SVProgressHUD.showSuccess(withStatus: "Updated successfully...".localized)
            self.activeViewsIfNoData()
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }
        
        
    }
    
    func setupNavigation()  {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Change Password".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  #imageLiteral(resourceName: "left-arrow") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    func makeAlert(title:String,message:String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Update".localized, style: .default) { (_) in
            self.updateUserProfile()
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .default) { (_) in
            alert.dismiss(animated: true)
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setupViewModelObserver()  {
        customChangePassword.changePpasswordViewModel.bindableIsFormValidate.bind { (isValid) in
            guard let isValid=isValid else {return}
            self.changeButtonState(enable: isValid, vv: self.customChangePassword.submitButton)
            
        }
        
        customChangePassword.changePpasswordViewModel.bindableIsLogging.bind(observer: {  [unowned self] (isReg) in
            if isReg == true {
                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
                self.progressHudProperties()
                
            }else {
                SVProgressHUD.dismiss()
                self.activeViewsIfNoData()
            }
        })
        
    }
    
    //TODO: - handle methods
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDoneError()  {
           removeViewWithAnimation(vvv: customErrorView)
           customMainAlertVC.dismiss(animated: true)
       }
    
    @objc func handleSubmit()  {
        guard let _ = customChangePassword.changePpasswordViewModel.oldPass , let _ = customChangePassword.changePpasswordViewModel.newPassword else {self.creatMainSnackBar(message: "All fields should be filled...".localized);  return  }
        if !ConnectivityInternet.isConnectedToInternet {
            customMainAlertVC.addCustomViewInCenter(views: customNoInternetView, height: 200)
            self.customNoInternetView.problemsView.play()
            
            customNoInternetView.problemsView.loopMode = .loop
            self.present(self.customMainAlertVC, animated: true)
        }else {
            makeAlert(title: "Update Profile".localized, message: "Do You Want To Update Your Profile Information?".localized)
        }
        
    }
    
    @objc func handleOk()  {
        
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    
    
    @objc  func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
