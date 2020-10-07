//
//  AddPostVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import Photos

protocol AddPostVCProtocol {
    func addImage(image:PhotoModel)
}

class AddPostVC: UIViewController {
    
    lazy var customMainAlertVC:CustomMainAlertVC = {
        let t = CustomMainAlertVC()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customAddPostView:CustomAddPostView = {
        let v = CustomAddPostView()
        v.cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(handleTakeImage)))
        v.uploadMasterPhotoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(handleChooseImage)))
        
        //        v.cameraButton.addTarget(self, action: #selector(handleTakeImage), for: .touchUpInside)
        //        v.uploadMasterPhotoButton.addTarget(self, action: #selector(handleChooseImage), for: .touchUpInside)
        return v
    }()
    lazy var customAlerLoginView:CustomMustLogInView = {
        let v = CustomMustLogInView()
        v.setupAnimation(name: "15179-confirm-popup")
        
        v.okButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        v.cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return v
    }()
    lazy var customNoInternetView:CustomNoInternetView = {
        let v = CustomNoInternetView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
        v.okButton.addTarget(self, action: #selector(handleRemovecustomNoInternetView), for: .touchUpInside)
        return v
    }()
    
    lazy var picker: UIImagePickerController = {
        let pi = UIImagePickerController()
        pi.delegate = self
        pi.allowsEditing = true
        return pi
    }()
    lazy var customConfirmationView:CustomConfirmationView = {
        let v = CustomConfirmationView()
        v.okImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemovecustomConfirmationView)))
        return v
    }()
    
    var pushedImage:UIImage!
    var isLogin:Bool = false
    var imageSize:Double = 0.0
    var imageName:String    =  ""
    var userToekn:String?
    var delgate:AddPostVCProtocol?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        statusBarBackgroundColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !ConnectivityInternet.isConnectedToInternet {
            customMainAlertVC.addCustomViewInCenter(views: customNoInternetView, height: 150)
            self.present(customMainAlertVC, animated: true)
        }else   if let apiToken = userDefaults.string(forKey: UserDefaultsConstants.userApiToken)  {
            userToekn = apiToken
            userDefaults.set(false, forKey: UserDefaultsConstants.isFirstMasterPhotoUpload)
            userDefaults.synchronize()
        }
        
        tabBarController?.tabBar.isHidden = false
        hidedCustomWhiteViewTabBar(hide: false)
        
        if  userDefaults.bool(forKey: UserDefaultsConstants.isPostUpdated) {
            aaddCustomConfirmationView(text: "Post updated Successfully...".localized)
            present(customMainAlertVC, animated: true)
        }else {}
        
        if  userDefaults.bool(forKey: UserDefaultsConstants.isPostMaded) {
            aaddCustomConfirmationView(text: "Post Created Successfully...".localized)
            present(customMainAlertVC, animated: true)
        }else {}
        
    }
    
    //MARK:-User methods
    
    func aaddCustomConfirmationView(text:String) {
        customConfirmationView.detailInformationLabel.text = text
        //        addCustomViewInCenter(views: customConfirmationView, height: 200)
        customMainAlertVC.addCustomViewInCenter(views: customConfirmationView, height: 200)
        
        self.present(customMainAlertVC, animated: true)
        userDefaults.set(false, forKey: UserDefaultsConstants.isPostUpdated)
        userDefaults.synchronize()
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = #colorLiteral(red: 0.3486061692, green: 0.7345923781, blue: 0.6780440807, alpha: 1) // #colorLiteral(red: 0.2015180886, green: 0.811791122, blue: 0.7185178995, alpha: 1)//ColorConstant.mainBackgroundColor
        
        view.addSubview(customAddPostView)
        customAddPostView.fillSuperview(padding: .init(top: 0, left: -32, bottom: 60, right: -32))//-16
    }
    
    fileprivate func setupNavigation() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Create Post".localized
    }
    
    
    fileprivate func createButtons(title: String,image:UIImage,selector: Selector,color:UIColor) -> UIButton {
        let bt = UIButton()
        bt.setTitle(title, for: .normal)
        bt.setImage(image, for: .normal)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.imageEdgeInsets = .init(top: 0, left: -30, bottom: 0, right: 0)
        bt.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        bt.addTarget(self, action: selector, for: .touchUpInside)
        bt.layer.cornerRadius = 24
        bt.backgroundColor = color
        bt.setTitleColor(.black, for: .normal) //#colorLiteral(red: 0.706050694, green: 0.7061684728, blue: 0.70602566, alpha: 1)
        bt.constrainHeight(constant: 50)
        return bt
    }
    
    
    
    
    
    fileprivate func remvoeView(_ views:UIView) {
        views.removeFromSuperview()
    }
    
    //TODO:-Handle methods
    
    //remove popup view
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    @objc  func handleRemovecustomConfirmationView()  {
        removeViewWithAnimation(vvv: customConfirmationView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleChooseImage()  {
        
        if  userToekn==nil { //!checkIfUserLoginBefore() {
            customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
            self.customAlerLoginView.problemsView.play()
            
            customAlerLoginView.problemsView.loopMode = .loop
            self.present(customMainAlertVC, animated: true)
        }
        else {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            }else {
                showError(message: "UNavaiable".localized)
            }
        }
    }
    
    @objc fileprivate func handleTakeImage()  {
        if userToekn==nil { //!checkIfUserLoginBefore() {
            customMainAlertVC.addCustomViewInCenter(views: customAlerLoginView, height: 200)
            self.customAlerLoginView.problemsView.play()
            
            customAlerLoginView.problemsView.loopMode = .loop
            
            self.present(customMainAlertVC, animated: true)
        }
        else {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            }else {
                showError(message: "UNavaiable".localized)
            }
        }
    }
    
    @objc fileprivate func handleLogin ()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        customMainAlertVC.dismiss(animated: true)
        let login = LoginVC()
        let nav = UINavigationController(rootViewController: login)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    
    @objc  func handleRemovecustomNoInternetView()  {
        removeViewWithAnimation(vvv: customNoInternetView)
        customMainAlertVC.dismiss(animated: true)
    }
    
    
    @objc fileprivate func handleCancel()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        removeViewWithAnimation(vvv: customConfirmationView)
        customMainAlertVC.dismiss(animated: true)
    }
}


extension AddPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[.editedImage] as? UIImage {
            pushedImage = img
        }
        if let img = info[.originalImage] as? UIImage {
            pushedImage = img
            //            saveImage(image: pushedImage, path: fileInDocumentsDirectory(filename: "tempImage"))
        }
        let jpegData = pushedImage.jpegData(compressionQuality: 1.0)
        let jpegSize: Int = jpegData?.count ?? 0
        let sizeKB = Double(jpegSize) / 1000
        _ = (Double(jpegSize) / 1000 / 1000)
        
        imageSize =  sizeKB
        
        
        if let url = info[.imageURL] as? URL {
            let fileName = url.lastPathComponent
            imageName = fileName
            print(fileName,"                ")
        }
        pushedImage = jpegSize > 30000 ? pushedImage.resized(toWidth: 1300) : pushedImage
        
        //        let photoModel = PhotoModel(image: pushedImage, name: imageName, size: imageSize, isUploaded: false,isMasterPhoto: true, id: 1, imageUrl: nil, is360: 0)
        let photoModel = SecondPhotoModel(image: pushedImage, name: imageName, size: imageSize, isUploaded: false, isMasterPhoto: true, imageUrl: nil, is360: 0)
        //            PhotoModel(image: pushedImage, name: imageName, size: imageSize, isUploaded: false,isMasterPhoto: true, id: 1, imageUrl: nil, is360: 0)
        
        showOrHideCustomTabBar(hide: true)
        let listOfPhoto = ListOfPhotoMainSecVC(currentUserToken:  userToekn ?? "", isFromUpdatePost: false) //ListOfPhotoCollectionVC( currentUserToken: userToekn ?? "")
        //        let listOfPhoto = ListOfPhotoCollectionVC(photo: photoModel, currentUserToken: userToekn ?? "")
        userDefaults.set(false, forKey: UserDefaultsConstants.isFirstMasterPhotoUpload)
        userDefaults.set(false, forKey: UserDefaultsConstants.isFinishedGetUploadPhotos)
        userDefaults.set(false, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        listOfPhoto.pushedImage = pushedImage
        listOfPhoto.processToUploadMasterPhoto(photo: photoModel)
        navigationController?.pushViewController(listOfPhoto, animated: true)
        dismiss(animated: true)
    }
}

