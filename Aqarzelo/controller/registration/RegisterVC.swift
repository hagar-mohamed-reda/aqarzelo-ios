//
//  RegisterVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SVProgressHUD
import GoogleSignIn
import MOLH
import SkyFloatingLabelTextField
import AuthenticationServices

class RegisterVC: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = .clear// #colorLiteral(red: 0.187464118, green: 0.7181431651, blue: 0.703643024, alpha: 1)
        v.showsVerticalScrollIndicator=false
        return v
    }()
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customRegisterView:CustomRegisterView = {
        let v = CustomRegisterView()
        
        v.signUpButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSignUp)))
        v.googleImagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGoogleLogin)))
        v.facebookImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFacebookLogin)))
        v.backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBack)))
        if #available(iOS 13.0, *) {
            v.appleLogInButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        return v
    }()
    
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.okButton.addTarget(self, action: #selector(handleOk), for: .touchUpInside)
        return v
    }()
    
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor:#colorLiteral(red: 0.187464118, green: 0.7181431651, blue: 0.703643024, alpha: 1) )
        v.constrainHeight(constant: 900)
        v.constrainWidth(constant: view.frame.width)
        return v
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setupViews()
        setupRegisterViewModelObserver()
        setupNavigation()
        scrollView.delegate=self
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
    
    func setupNavigation()  {
        navigationController?.navigationBar.isHide(true)
    }
    
    fileprivate    func setupRegisterViewModelObserver()  {
        customRegisterView.registerViewModel.bindableIsFormValidate.bind { (isValidForm) in
            guard let isValid = isValidForm else {return}
            //        self.customRegisterView.signUpButton.isEnabled = isValid
            
            self.changeButtonState(enable: isValid, vv: self.customRegisterView.signUpButton)
            
        }
        customRegisterView.registerViewModel.bindableIsResgiter.bind(observer: {  [unowned self] (isReg) in
            if isReg == true {
                UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
                SVProgressHUD.setForegroundColor(UIColor.green)
                
                SVProgressHUD.show(withStatus: "Register...".localized)
                
            }else {
                SVProgressHUD.dismiss()
                self.activeViewsIfNoData()
            }
        })
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        
        view.addSubview(scrollView)
        
        scrollView.fillSuperview()
        scrollView.addSubview(mainView)
        mainView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        mainView.addSubview(customRegisterView)
        customRegisterView.fillSuperview()
        
        
    }
    
    fileprivate func goToMainTab()  {
//        cacheCurrentUserCodabe.save(user)
        
                userDefaults.set(true, forKey: UserDefaultsConstants.isUserLogined)
                      userDefaults.synchronize()
        
        //        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    fileprivate  func saveToken(token:String) {
        userDefaults.set(token, forKey: UserDefaultsConstants.userApiToken)
        //        userDefaults.set(true, forKey: UserDefaultsConstants.isUserWaitForSMSCode)
        
        userDefaults.synchronize()
        
    }
    
    fileprivate func handleFacebookLoginAction() {
        RegistrationServices.shared.loginUsingFacebook(vc: self) {[unowned self] (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let token = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            self.saveToken(token: token.apiToken)
            DispatchQueue.main.async {
                self.goToMainTab()
            }
        }
        
    }
    
    func makeOtherRegisterExternal(fullName:String,email:String)  {
        RegistrationServices.shared.loginWithExternal(name: fullName, photo: "", email: email) {[unowned self] (base, error) in
            if let err=error{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let token = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            self.saveToken(token: token.apiToken)
            
            DispatchQueue.main.async {
                self.goToMainTab()
            }
        }
    }
    
    //TODO:-Handle methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate  func handleSignUp(sender:UIButton)  {
        
        customRegisterView.registerViewModel.performRegister { (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            guard let user = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn) ;return}
            self.saveToken(token: user.apiToken)
            
            DispatchQueue.main.async {
                self.goToMainTab()
            }
        }
        
    }
    
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
    
    @objc fileprivate func handleGoogleLogin()  {
        ConnectivityInternet.isConnectedToInternet ? GIDSignIn.sharedInstance().signIn() : creatMainSnackBar(message: "No Internet Connection Avaliable".localized)
    }
    
    
    
    @objc  fileprivate func handleFacebookLogin()  {
        
        ConnectivityInternet.isConnectedToInternet ? handleFacebookLoginAction() : creatMainSnackBar(message: "No Internet Connection Avaliable".localized)
        
    }
    
    @objc func handleOk()  {
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    @objc func handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK:-extension

extension RegisterVC:  GIDSignInDelegate {
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                SVProgressHUD.showInfo(withStatus: "The user has not signed in before or they have since signed out.")
            } else {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
            return
        }
        // Perform any operations on signed in user here.
        // Safe to send to the server
        let fullName = user.profile.name ?? ""
        let email = user.profile.email ?? ""
        
        RegistrationServices.shared.loginWithExternal(name: fullName, photo: "", email: email) {[unowned self] (base, error) in
            if let err=error{
                SVProgressHUD.showError(withStatus: err.localizedDescription)
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            
            guard let token = base?.data else {SVProgressHUD.showError(withStatus: MOLHLanguage.isRTLLanguage() ? base?.messageAr : base?.messageEn); return}
            self.saveToken(token: token.apiToken)
            DispatchQueue.main.async {
                self.goToMainTab()
            }
        }
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(023)
    }
}






extension RegisterVC: ASAuthorizationControllerDelegate{
    
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

extension RegisterVC: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}



extension RegisterVC:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.y
        let screenHeight = UIScreen.main.bounds.size.height
        let ss:CGFloat
        
        ss = screenHeight < 600  ? 300 : screenHeight < 600 ? 200 :  screenHeight < 800 ? 130 : 60
        
        //        if screenHeight < 600 {
        //            ss = 300
        //        }  else if screenHeight < 800 {
        //            ss = 130
        //        }else {
        //            ss = 60
        //        }
        
        if x < 0 {
            scrollView.contentOffset.y =  0
        }else if x > ss {
            scrollView.contentOffset.y = ss
        }
    }
}
