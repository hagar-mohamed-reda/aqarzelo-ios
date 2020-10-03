//
//  LoginVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import GoogleSignIn
import MOLH
//import MaterialComponents.MaterialSnackbar
import SkyFloatingLabelTextField
import AuthenticationServices

let userDefaults = UserDefaults.standard

class LoginVC: UIViewController {
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customLoginView:CustomLoginView = {
        let v = CustomLoginView()
        
        v.googleImagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGoogleLogin)))
        v.facebookImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFacebookLogin)))
        v.loginButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLogin)))
        v.createAccountButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlSignUp)))
        v.forgetPasswordButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlForgetPassword)))
        v.backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        if #available(iOS 13.0, *) {
            v.appleLogInButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        return v
    }()
    
    @objc func handleLogInWithAppleID() {
        if #available(iOS 13.0, *) {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            //                     let controller = ASAuthorizationController(authorizationRequests: [request])
            //
            //                     controller.delegate = self
            //                     controller.presentationContextProvider = self
            //
            //                     controller.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    lazy var customErrorView:CustomErrorView = {
        let v = CustomErrorView()
        v.setupAnimation(name: "4970-unapproved-cross")
        v.okButton.addTarget(self, action: #selector(handleDoneError), for: .touchUpInside)
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
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        
        setupViews()
        setupLoginViewModelObserver()
        setupNavigation()
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
        userDefaults.bool(forKey: UserDefaultsConstants.isUserLogined) ? dismiss(animated: true) : ()
    }
    
    
    //MARK:-User methods
    
    fileprivate func setupLoginViewModelObserver(){
        
        customLoginView.loginViewModel.bindableIsFormValidate.bind { (isValidForm) in
            guard let isValid = isValidForm else {return}
            //            self.customLoginView.loginButton.isEnabled = isValid
            
            self.changeButtonState(enable: isValid, vv: self.customLoginView.loginButton)
        }
        customLoginView.loginViewModel.bindableIsLogging.bind(observer: {  [unowned self] (isReg) in
            if isReg == true {
                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
                self.progressHudProperties()
                
            }else {
                SVProgressHUD.dismiss()
                self.activeViewsIfNoData()
            }
        })
    }
    
    func setupNavigation()  {
        
        navigationController?.navigationBar.isHide(true)
    }
    
    fileprivate  func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        
        view.addSubview(customLoginView)
        customLoginView.fillSuperview()
        
    }
    
    fileprivate func goToMainTab(_ user:UserModel)  {
        cacheCurrentUserCodabe.save(user)
        userDefaults.set(true, forKey: UserDefaultsConstants.isUserLogined)
        userDefaults.synchronize()
        //        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    fileprivate func saveToken(token:String) {
        userDefaults.set(token, forKey: UserDefaultsConstants.userApiToken)
        userDefaults.synchronize()
        SVProgressHUD.dismiss()
    }
    
    fileprivate func handleFacebookLoginAction() {
        RegistrationServices.shared.loginUsingFacebook(vc: self) {[unowned self] (base, err) in
            if let err=err{
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.callMainError(err: err.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView,height: 260)
                }
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            let xx = MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn
            
//            guard let user = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
           
            
            DispatchQueue.main.async {
                guard let user = base?.data else {self.callMainError(err: xx ?? "There is an error happened".localized , vc: self.customMainAlertVC, views: self.customErrorView,height: 260); return}
                self.saveToken(token: user.apiToken)
                self.goToMainTab(user)
            }
        }
        
    }
    
    //TODO:-Handle methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDoneError()  {
        removeViewWithAnimation(vvv: customErrorView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc fileprivate func handleLogin()  {
        
        customLoginView.loginViewModel.performLogging {[unowned self] (base,err) in
            if let err = err {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.callMainError(err: err.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView)
                }
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            let xx = MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn
            
            
            
            DispatchQueue.main.async {
                guard let user = base?.data else {self.callMainError(err: xx ?? "There is an error happened".localized , vc: self.customMainAlertVC, views: self.customErrorView,height: 260); return}
                self.saveToken(token: user.apiToken)
                self.goToMainTab(user)
            }
            
            
        }
        
        
    }
    
    @objc  func handlSignUp()  {
        
        let register = RegisterVC()
        navigationController?.pushViewController(register, animated: true)
    }
    
    @objc fileprivate func handleGoogleLogin()  {
        
        ConnectivityInternet.isConnectedToInternet ? GIDSignIn.sharedInstance().signIn() : creatMainSnackBar(message: "No Internet Connection Avaliable".localized)
        
    }
    
    @objc fileprivate func handleFacebookLogin()  {
        
        ConnectivityInternet.isConnectedToInternet ? handleFacebookLoginAction() : creatMainSnackBar(message: "No Internet Connection Avaliable".localized)
        
    }
    
    @objc fileprivate func handlForgetPassword()  {
        let forget = ForgetPasswordVC()
        navigationController?.pushViewController(forget, animated: true)
    }
    
    @objc func handleOk()  {
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc func handleBack()  {
        dismiss(animated: true, completion: nil)
        //        navigationController?.popViewController(animated: true)
    }
    
    
    
    
}

//MARK:-extension


extension LoginVC:  GIDSignInDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                SVProgressHUD.showError(withStatus: "The user has not signed in before or they have since signed out.".localized)
            } else {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
            return
        }
        // Perform any operations on signed in user here.
        // Safe to send to the server
        let fullName = user.profile.name ?? ""
        let email = user.profile.email ?? ""
        
        makeOtherRegisterExternal(fullName: fullName, email: email)
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func makeOtherRegisterExternal(fullName:String,email:String)  {
        RegistrationServices.shared.loginWithExternal(name: fullName, photo: "", email: email) {[unowned self] (base, error) in
            if let err=error{
                self.callMainError(err: err.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView)
                //                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
//            guard let token = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
//            self.saveToken(token: token.apiToken)
            
            DispatchQueue.main.async {
                guard let token = base?.data else {self.callMainError(err: MOLHLanguage.isRTLLanguage() ? base?.messageEn as! String : base?.messageEn as! String, vc: self.customMainAlertVC, views: self.customErrorView,height: 260); return}
                self.saveToken(token: token.apiToken)
                self.goToMainTab(token)
            }
        }
    }
}


extension LoginVC: ASAuthorizationControllerDelegate{
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email ?? ""
            
            let ff = fullName?.givenName ?? ""
            
            makeOtherRegisterExternal(fullName: ff, email: email)
            
            print(userIdentifier)
            
            
            //        switch authorization.credential {
            //        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            //            let userIdentifier = appleIDCredential.user
            //
            //            let defaults = UserDefaults.standard
            //            defaults.set(userIdentifier, forKey: "userIdentifier1")
            //
            //            //Save the UserIdentifier somewhere in your server/database
            //            let vc = UIViewController()
            //            vc.view.backgroundColor = .red
            ////            vc.userID = userIdentifier
            //            self.present(UINavigationController(rootViewController: vc), animated: true)
            //            break
            //        default:
            //            break
            //        }
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {// Handle error.}
    }
    
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
