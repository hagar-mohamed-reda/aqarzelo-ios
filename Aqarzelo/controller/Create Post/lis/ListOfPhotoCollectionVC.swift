//
//  ListOfPhotoCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH
//import MaterialComponents.MaterialSnackbar

class ListOfPhotoCollectionVC: UIViewController {
    
    lazy var customAddPostListOfPhotoView:CustomAddPostListOfPhotoView = {
        let v =  CustomAddPostListOfPhotoView()
        //        v.photosArray = photosArray
        v.collectionView.delegate = self
        v.collectionView.dataSource = self
        
        v.nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return v
    }()
    lazy var picker: UIImagePickerController = {
        let pi = UIImagePickerController()
        pi.delegate = self
        pi.allowsEditing = true
        return pi
    }()
    
    var pushedImage:UIImage!
    var isUploadNextImage = true
    
    var isLogin:Bool = false
    var isBeginUploadPhoto:Bool = false
    var imageSize:Double = 0.0
    var imageName:String    =  ""
    var userToekn:String?
    var photoIndex:Int = 0
    
    var imagePicked = 0
    var imageProfileView:UIImageView?
    var imageBackgroundView:UIImageView?
    
    var aqar:AqarModel!{
        didSet{
            loadAllImages()
            getAllImagesNotMaster()
        }
    }
    
    fileprivate let currentUserToken:String!
    init(currentUserToken:String) {
        self.currentUserToken = currentUserToken
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    var photosArray = [PhotoModel]()
    var photosFinishedArray = [ImageModel]()
    var photoMasterArray = [PhotoModel]()
    var isFinishedUpload = false
    var nextPhoto:PhotoModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        statusBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObservers()
        showOrHideCustomTabBar(hide: true)
        tabBarController?.tabBar.isHide(true)
        if photoMasterArray.first == nil {
            navigationController?.popViewController(animated: true)
            customAddPostListOfPhotoView.nextButton.isEnabled = false
            
        }else {
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHide(false)
        showOrHideCustomTabBar(hide: false)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:-User methods
    
    func loadAllImages()  {
        guard let image = aqar.images.first  else {return}
        
        let photo = PhotoModel(image: nil, name: image.photo, size: 0.0, isUploaded: true, isMasterPhoto: true, id: image.id ?? 0, imageUrl: image.image, is360: image.is360 ?? 0)
        self.photoMasterArray.append(photo)
        
    }
    
    fileprivate func uploadOtherPhotos()  {
        nextPhoto != nil ? uploadPhoto(nextPhoto,index:photoIndex, picked: 0) : ()
    }
    
    fileprivate func uploadPhoto(_ photo:PhotoModel,index:Int,picked:Int)  {
        
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            
            semaphore.signal()
            self.reloadDataAfterUploading()
            semaphore.wait()
            
            PostServices.shared.uploadOtherImagess(index:index ,photoModel: photo, token: self.currentUserToken) { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData()
                    //                UIApplication.shared.endIgnoringInteractionEvents()
                }
                guard let base = base?.data else {return}
                self.nextPhoto = PhotoModel(image: UIImage(), name: base.image, size: photo.size, isUploaded: true, isMasterPhoto: false, id: base.id ?? 0, imageUrl: base.image, is360: picked)
                self.photosArray.removeLast()
                self.photosArray.append(self.nextPhoto)
                self.isUploadNextImage = true
                semaphore.signal()
            }
            semaphore.wait()
        }
    }
    
    func reloadDataAfterUploading()  {
        DispatchQueue.main.async {
            //
            
            self.customAddPostListOfPhotoView.collectionView.reloadData()
        }
    }
    
    fileprivate func refreshData(_ data:UploadImageModel)  {
        DispatchQueue.main.async {
            self.customAddPostListOfPhotoView.collectionView.reloadData()
        }
        
    }
    
    func processToUploadMasterPhoto(photo:PhotoModel)  {
        photoMasterArray.removeAll()
        photosArray.removeAll()
        photoMasterArray.insert(photo, at: 0)
        
        var group1:  [ImageModel]?
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding...".localized)
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            // using user location
            UploadImagesServices.shared.getAllUserImages(api_token: self.currentUserToken) { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData()
                    //                UIApplication.shared.endIgnoringInteractionEvents()
                }
                let ss = base?.data ?? []
                group1 = Array(ss.dropFirst())
                //                group1 =  Array(group1?.dropFirst()  )
                userDefaults.set(true, forKey: UserDefaultsConstants.isFinishedGetUploadPhotos)
                userDefaults.synchronize()
                semaphore.signal()
            }
            semaphore.wait()
            
            semaphore.signal()
            self.reloadMainData(group1: group1)
            semaphore.wait()
            
            //get ads
            PostServices.shared.uploadImagess(photoModel:photo , token: self.currentUserToken) { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData()
                    //                UIApplication.shared.endIgnoringInteractionEvents()
                }
                userDefaults.set(true, forKey: UserDefaultsConstants.isFirstMasterPhotoUpload)
                userDefaults.synchronize()
                semaphore.signal()
            }
            semaphore.wait()
        }
    }
    
    func getAllImagesNotMaster()  {
        var group1: [ImageModel]?
        
        SVProgressHUD.setForegroundColor(UIColor.green)
        SVProgressHUD.show(withStatus: "Looding...".localized)
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        
        dispatchQueue.async {
            UploadImagesServices.shared.getAllUserImages(api_token: self.currentUserToken) { (base, error) in
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    self.activeViewsIfNoData();
                    //                UIApplication.shared.endIgnoringInteractionEvents()
                }
                //            let ss = base?.data ?? []
                group1 = base?.data ?? []
                semaphore.signal()
            }
            semaphore.wait()
            
            semaphore.signal()
            self.reloadMainData(group1: group1)
            semaphore.wait()
        }
    }
    
    fileprivate  func reloadMainData (group1 :  [ImageModel]?) {
        DispatchQueue.main.async {
            
            
            SVProgressHUD.dismiss()
            self.activeViewsIfNoData()
            self.addImagesUploaded(image:  group1 ?? [])
            //            userDefaults.set(true, forKey: UserDefaultsConstants.isFirstMasterPhotoUpload)
            userDefaults.set(true, forKey: UserDefaultsConstants.isNextButtonPostMaded)
            userDefaults.set(true, forKey: UserDefaultsConstants.isFinishedGetUploadPhotos)
            userDefaults.set(true, forKey: UserDefaultsConstants.isNextButtonPostUpdated)
            userDefaults.set(false, forKey: UserDefaultsConstants.isFirstMasterPhotoUpload)
            userDefaults.set(false, forKey: UserDefaultsConstants.isSecondPhotoUploading)
            userDefaults.synchronize()
            self.customAddPostListOfPhotoView.nextButton.isEnabled = true
            self.customAddPostListOfPhotoView.nextButton.backgroundColor = ColorConstant.mainBackgroundColor
            //            self.activeViewsIfNoData()
            self.customAddPostListOfPhotoView.collectionView.reloadData()
        }
    }
    
    func uploadMasterPhoto()  {
        //        !userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) ? processToUploadMasterPhoto() : ()
    }
    
    fileprivate func addImagesUploaded(image:  [ImageModel]) {
        image.forEach({ (image) in
            //            let urlString = image.image
            let photo = PhotoModel(image:UIImage() , name: image.photo,size: 23.0, isUploaded: true, isMasterPhoto: false, id: image.id ?? 0, imageUrl: image.src, is360: image.is360 ?? 0)
            self.photosArray.append(photo)
        })
    }
    
    fileprivate func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        
        view.addSubview(customAddPostListOfPhotoView)
        customAddPostListOfPhotoView.fillSuperview(padding: .init(top: 0, left: 0, bottom: -8, right: 0))
    }
    
    fileprivate func setupObservers()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadProgress), name: .uoloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadComplete), name: .uploadComplete, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadNextProgress), name: .uoloadNextProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadNextComplete), name: .uploadNextComplete, object: nil)
    }
    
    
    
    
    
    
    fileprivate func setupNavigation() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        navigationItem.title = "Create Post".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
             
             navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    func processToDeleteImage(index:Int,imageImdex:Int)   {
        ImagesServices.shared.deleteImage(id: imageImdex, token: currentUserToken) {[unowned self] (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription);return
            }
            self.photosArray.remove(at: index)
            DispatchQueue.main.async {
                self.customAddPostListOfPhotoView.collectionView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    fileprivate func presentPhotoLibrary(source:UIImagePickerController.SourceType,imagePicked:Int)  {
        self.imagePicked = imagePicked
        switch source {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.sourceType = .camera
                self.present(self.picker, animated: true, completion: nil)
            }else {
                showError(message: "UNavaiable".localized)
            }
        default:
            self.picker.sourceType = source
            self.present(self.picker, animated: true, completion: nil)
            
        }
    }
    
    fileprivate func goToZoomImage(index:Int)  {
        let photo = photosArray[index]
        let zoom = ZoomUserImageVC(img:   photo.image ?? UIImage())
        if let p = photo.imageUrl {
            zoom.imageName = p
        }
        
        navigationController?.pushViewController(zoom, animated: true)
    }
    
    fileprivate func uploadChoosedPhoto(_ img:UIImage,_ size:Double,_ name:String,_ picked:Int)  {
        
        nextPhoto = PhotoModel(image: img, name: name, size: size, isUploaded: false, isMasterPhoto: false, id: 0, imageUrl: "", is360: picked)
        userDefaults.set(true, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        photoIndex = photosArray.count
        
        //        photosArray.append(nextPhoto)
        photosArray.insert(nextPhoto, at: photosArray.count)
        userDefaults.set(true, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        self.isUploadNextImage = false
        self.uploadPhoto(nextPhoto, index: photosArray.count, picked: picked)//photoIndex)
        
    }
    
    fileprivate func goToMainCreatePost()  {
        let createMainPost = MainCreatePostVC(token: currentUserToken)
        //    createMainPost.aqar = aqar
        navigationController?.pushViewController(createMainPost, animated: true)
    }
    
    fileprivate func goToMainUpdatedPost()  {
        let createMainPost = MainCreatePostVC(token: currentUserToken)
        createMainPost.aqar = aqar
        navigationController?.pushViewController(createMainPost, animated: true)
    }
    
    //TODO:-Handle methods
    
    @objc func handleUploadNextProgress(notify: Notification){
        userDefaults.set(false, forKey: UserDefaultsConstants.isImageUploaded)
        userDefaults.synchronize()
        customAddPostListOfPhotoView.nextButton.isEnabled = false
        guard let userInfo = notify.userInfo as? [String:Any] else { return  }
        guard let index = userInfo["index"] as? Int else { return  }
        guard let progress = userInfo["progress"] as? Double else { return  }
        guard let size = userInfo["size"] as? Double else { return  }
        guard let image = userInfo["image"] as? UIImage else { return  }
        
        guard let cell = customAddPostListOfPhotoView.collectionView.cellForItem(at: IndexPath(item: index-1, section: 1)) as? ListOfFhotoCell else { return  }
        DispatchQueue.main.async {
            
            
            cell.progressPhoto.setProgress(Float(progress), animated: true) //=  Float(progress / size )
            let unique = UUID().uuidString
            
            cell.namePhotoLabel.text =  userInfo["name"] as? String //?? unique
            cell.progressLabel.text = "\(Int(progress * 100 ))%"
            cell.progressLabel.isHidden = false
            
            cell.photoImageView.image = image
            cell.logo360ImageView.isHide(false)
            if progress == 1 {
                cell.deleteButton.isHidden = false
                cell.closeButton.isHide(true)
                cell.progressLabel.isHidden = true
                cell.trueImageView.isHide(false)
            }
        }
    }
    
    @objc func handleUploadNextComplete()  {
        
        userDefaults.set(true, forKey: UserDefaultsConstants.isImageUploaded)
        userDefaults.set(false, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        customAddPostListOfPhotoView.nextButton.isEnabled = true
    }
    
    @objc func createAlertForChoposingImage()  {
              let alert = UIAlertController(title: "Choose Image".localized, message: "Choose image fROM ".localized, preferredStyle: .alert)
              let camera = UIAlertAction(title: "Camera".localized, style: .default) {[unowned self] (_) in
                self.presentPhotoLibrary(source: .camera,imagePicked: 1)

              }
              let gallery = UIAlertAction(title: "Open From Gallery".localized, style: .default) {[unowned self] (_) in
                self.presentPhotoLibrary(source: .photoLibrary,imagePicked: 0)
              }
              let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { (_) in
                  alert.dismiss(animated: true)
              }
              
              alert.addAction(camera)
              alert.addAction(gallery)
              alert.addAction(cancel)
              present(alert, animated: true)
          }
    
    
    
    @objc fileprivate  func  handleBack()  {
        
        if aqar != nil {
            if  isUploadNextImage  {
                navigationController?.popViewController(animated: true)
            }else {
                self.creatMainSnackBar(message: "Wait until Upload image...".localized)
            }
        }else {
            
            if userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) || isUploadNextImage && userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) {
                navigationController?.popViewController(animated: true)
            }else {
                self.creatMainSnackBar(message: "Wait until Upload image...".localized)
            }
        }
    }
    
    
    @objc fileprivate func handleUploadComplete(notify: Notification){
        guard let cell = customAddPostListOfPhotoView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ListOfPhotoMaseterCell else { return  }
        DispatchQueue.main.async {
            cell.trueImageView.isHide(false)
        }
        customAddPostListOfPhotoView.nextButton.isEnabled = true
        userDefaults.set(true, forKey: UserDefaultsConstants.isImageUploaded)
        userDefaults.set(false, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        userDefaults.synchronize()
        
    }
    
    @objc fileprivate func handleUploadProgress(notify: Notification){
        userDefaults.set(false, forKey: UserDefaultsConstants.isImageUploaded)
        userDefaults.synchronize()
        customAddPostListOfPhotoView.nextButton.isEnabled = false
        guard let userInfo = notify.userInfo as? [String:Any] else { return  }
        //        guard let name = userInfo["name"] as? String else { return  }
        guard let progress = userInfo["progress"] as? Double else { return  }
        guard let size = userInfo["size"] as? Double else { return  }
        guard let image = userInfo["image"] as? UIImage else { return  }
        guard let cell = customAddPostListOfPhotoView.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ListOfPhotoMaseterCell else { return  }
        DispatchQueue.main.async {
            cell.progressPhoto.setProgress(Float(progress), animated: true) //=  Float(progress / size )
            let unique = UUID().uuidString
            
            cell.namePhotoLabel.text =  userInfo["name"] as? String //?? unique
            cell.progressLabel.text = "\(Int(progress * 100 ))%"
            cell.progressLabel.isHidden = false
            cell.logoImageView.isHide(false)
            cell.photoImageView.image = image
            if progress == 1 {
                cell.deleteButton.isHidden = false
                cell.closeButton.isHide(true)
                cell.progressLabel.isHidden = true
                cell.trueImageView.isHide(false)
            }
        }
    }
    
   
    
    @objc fileprivate func handleNext()  {
        
        if aqar != nil {
            if  isUploadNextImage  {
                goToMainUpdatedPost()
                //                navigationController?.popViewController(animated: true)
            }else {
                self.creatMainSnackBar(message: "Wait until Upload image...".localized)
            }
        }else {
            
            if userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) || isUploadNextImage && userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) {
                goToMainCreatePost()
                //                navigationController?.popViewController(animated: true)
            }else {
                self.creatMainSnackBar(message: "Wait until Upload image...".localized)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ListOfPhotoCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? photoMasterArray.count :   photosArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customAddPostListOfPhotoView.cellMasterId, for: indexPath) as! ListOfPhotoMaseterCell
            let photo = photoMasterArray[indexPath.item]
            cell.photo = photo
            
            cell.handleInteruptUpload = {[unowned self]  (index) in
                self.creatMainSnackBar(message: "Master Photo can't be deleted...")
            }
            
            return cell
        }
        
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: customAddPostListOfPhotoView.cellId, for: indexPath) as! ListOfFhotoCell
        let photo = photosArray[indexPath.item]
        cell.photo = photo
        cell.index = indexPath.item
        cell.handleRemovedImage = {[unowned self] (index,imageId) in
            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) || userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) ? self.processToDeleteImage(index:index,imageImdex:imageId) : self.creatMainSnackBar(message: "Wait until imagee uploaded...".localized)
        }
        cell.handleInteruptUpload = {[unowned self] (index,imageId) in
            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) || userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) ? self.processToDeleteImage(index:index,imageImdex:imageId) : self.creatMainSnackBar(message: "Wait until imagee uploaded...".localized)
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if aqar != nil {
            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) || isUploadNextImage && userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) ? goToZoomImage(index: indexPath.item)  : self.creatMainSnackBar(message: "Wait until Upload image...".localized)
        }else {
            
            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) || isUploadNextImage && userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload)  ? goToZoomImage(index: indexPath.item)  : self.creatMainSnackBar(message: "Wait until Upload image...".localized)
        }
        //        userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) ? goToZoomImage(index: indexPath.item)  : ()
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: customAddPostListOfPhotoView.cellFooterId, for: indexPath) as! ListOfPhotoFooterCell
        cell.mainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createAlertForChoposingImage)))
        cell.secondMainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createAlertForChoposingImage)))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? .zero :  .init(width: view.frame.width-32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width-32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    
    
}


extension ListOfPhotoCollectionVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[.editedImage] as? UIImage {
            pushedImage = img
        }
        if let img = info[.originalImage] as? UIImage {
            pushedImage = img
            
        }
        let jpegData = pushedImage.jpegData(compressionQuality: 1.0)
        let jpegSize: Int = jpegData?.count ?? 0
        let sizeKB = Double(jpegSize) / 1000
        
        imageSize =  sizeKB
        //reduce image size if it is big
        pushedImage = imagePicked == 1 ?   pushedImage.resized(toWidth: 1300) : pushedImage
        
        if let url = info[.imageURL] as? URL {
            let fileName = url.lastPathComponent
            imageName = fileName
        }
        uploadChoosedPhoto(pushedImage,imageSize,imageName,imagePicked)
        //        self.isUploadNextImage = false
        dismiss(animated: true)
    }
}
