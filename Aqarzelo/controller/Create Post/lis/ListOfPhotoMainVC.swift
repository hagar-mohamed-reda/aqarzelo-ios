//
//  ListOfPhotoMainVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/30/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH

class ListOfPhotoMainVC:  UIViewController{
    
    
    lazy var nextButton:UIButton = {
           let b = UIButton()
           b.setTitle("Next".localized, for: .normal)
           b.setTitleColor(.black, for: .normal)
           b.backgroundColor = .white
          
           b.layer.borderWidth = 4
           b.layer.borderColor = #colorLiteral(red: 0.3588023782, green: 0.7468322515, blue: 0.7661533952, alpha: 1).cgColor
           b.layer.cornerRadius = 16
           b.clipsToBounds = true
           b.isEnabled = false
           b.constrainHeight(constant: 50)
           b.isEnabled = false
        b.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
           return b
       }()
    
    lazy var collectionView:UICollectionView = {
            let c = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            c.backgroundColor = .white
            c.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            c.delegate = self
            c.dataSource = self
            c.register(ListOfPhotoMaseterCell.self, forCellWithReuseIdentifier:  cellMasterId)
            c.register(ListOfFhotoCell.self, forCellWithReuseIdentifier: cellId)
            c.register(ListOfPhotoFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: cellFooterId)
        c.layer.cornerRadius = 16
        c.clipsToBounds=true
            return c
        }()
    
// lazy var customAddPostListOfPhotoView:CustomAddPostListOfPhotoView = {
//        let v =  CustomAddPostListOfPhotoView()
//        //        v.photosArray = photosArray
//        v.collectionView.delegate = self
//        v.collectionView.dataSource = self
//
////        v.nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
//        return v
//    }()
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
    var imageUrl = ""
    
    var imagePicked = 0
    var imageProfileView:UIImageView?
    var imageBackgroundView:UIImageView?
    fileprivate let cellId="cellId"
    fileprivate let cellMasterId="cellMasterId"
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    var photosArray = [PhotoModel]()
    var photosFinishedArray = [ImageModel]()
    var photoMasterArray = [PhotoModel]()
    var isFinishedUpload = false
    var nextPhoto:PhotoModel!
    var choosenImage = UIImage()
    
    fileprivate let cellFooterId="cellFooterId"
    
    
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
             nextButton.isEnabled = false
            
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
        if  self.photosArray.count == 0 || self.photosArray.count == 1 {
             DispatchQueue.main.async {
            self.collectionView.reloadData()
            }
                       return}
        else {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            //
//            let indexSet = IndexSet(integer: 1)
//            self.collectionView.reloadSections(indexSet)
           
 
//            let zz = self.photosArray.count-1
//
//            let ind = IndexPath(item: zz, section: 1)
//
//            self.collectionView.reloadItems(at: [ind])
            
//            self.collectionView.reloadSections(IndexSet(sec))
//            self.collectionView.reloadData()
        }
        }
    }
    
    fileprivate func refreshData(_ data:UploadImageModel)  {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func processToUploadMasterPhoto(photo:PhotoModel)  {
        photoMasterArray.removeAll()
        photosArray.removeAll()
        photoMasterArray.insert(photo, at: 0)
        
        var group1:  [ImageModel]?
        
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
        
        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
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
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = ColorConstant.mainBackgroundColor
            //            self.activeViewsIfNoData()
            
//            let zz = self.photosArray.count-1
//
//                       let ind = IndexPath(item: zz, section: 1)
//
//                       self.collectionView.reloadItems(at: [ind])
            
//            let indexSet = IndexSet(integer: 1)
//                       self.collectionView.reloadSections(indexSet)
            self.collectionView.reloadData()
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
        view.backgroundColor = #colorLiteral(red: 0.3410083055, green: 0.7299206853, blue: 0.6936879754, alpha: 1)//ColorConstant.mainBackgroundColor
        
        view.addSubViews(views: collectionView,nextButton)
        collectionView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        nextButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 24, right: 16))
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
                self.collectionView.reloadData()
//                let zz = self.photosArray.count-1
//                           
//                           let ind = IndexPath(item: zz, section: 1)
//                           
//                           self.collectionView.reloadItems(at: [ind])
                
//                let indexSet = IndexSet(integer: 1)
//                           self.collectionView.reloadSections(indexSet)
//                self.collectionView.reloadData()
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
    
    fileprivate func goToZoomImage(index:Int,section:Int)  {
        if section == 0 {
            if  let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ListOfPhotoMaseterCell {
                let zoom = ZoomUserImageVC(img:   cell.img)
                navigationController?.pushViewController(zoom, animated: true)

            }

        }else {
           let photo = photosArray[index]
                   let zoom = ZoomUserImageVC(img:   photo.image ?? UIImage())
                   if let p = photo.imageUrl {
                       zoom.imageName = p
                   }
                   
                   navigationController?.pushViewController(zoom, animated: true)
        }
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
        userDefaults.set(false, forKey: UserDefaultsConstants.isStillImageUpload)

        userDefaults.synchronize()
        nextButton.isEnabled = false
        guard let userInfo = notify.userInfo as? [String:Any] else { return  }
        guard let index = userInfo["index"] as? Int else { return  }
        guard let progress = userInfo["progress"] as? Double else { return  }
        guard let size = userInfo["size"] as? Double else { return  }
        guard let image = userInfo["image"] as? UIImage else { return  }
        
        guard let cell =  collectionView.cellForItem(at: IndexPath(item: index-1, section: 1)) as? ListOfFhotoCell else { return  }
        DispatchQueue.main.async {
            
            
            cell.progressPhoto.setProgress(Float(progress), animated: true) //=  Float(progress / size )
            let unique = UUID().uuidString
            
            cell.namePhotoLabel.text =  userInfo["name"] as? String //?? unique
            cell.progressLabel.text = "\(Int(progress * 100 ))%"
            cell.progressLabel.isHidden = false
            
            cell.photoImageView.image = image
            cell.logo360ImageView.isHide(cell.photo?.is360 == 0 ? true : false)
            if progress == 1 {
                cell.deleteButton.isHidden = false
                cell.closeButton.isHide(true)
                cell.progressLabel.isHidden = true
                cell.trueImageView.isHide(false)
            }
        }
    }
    
    @objc func handleUploadNextComplete(notify: Notification)  {
        nextButton.isEnabled = true

        guard let userInfo = notify.userInfo as? [String:Any] ,let index = userInfo["index"] as? Int, let cell =  collectionView.cellForItem(at: IndexPath(row: index, section: 1)) as? ListOfFhotoCell else { return  }
               DispatchQueue.main.async {
                   cell.trueImageView.isHide(false)
                self.nextButton.isEnabled = true

               }
        
        userDefaults.set(true, forKey: UserDefaultsConstants.isImageUploaded)
        userDefaults.set(true, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.set(true, forKey: UserDefaultsConstants.isStillImageUpload)

//        userDefaults.set(false, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
    }
    
   @objc func takeNormalPhoto()  {
        createAlertForChoposingImage(ind: 0)
    }
    
    @objc func take360Photo()  {
           createAlertForChoposingImage(ind: 1)
       }
    
     func createAlertForChoposingImage(ind:Int)  {
              let alert = UIAlertController(title: "Choose Image".localized, message: "Choose image fROM ".localized, preferredStyle: .alert)
              let camera = UIAlertAction(title: "Camera".localized, style: .default) {[unowned self] (_) in
                self.presentPhotoLibrary(source: .camera,imagePicked: ind)

              }
              let gallery = UIAlertAction(title: "Open From Gallery".localized, style: .default) {[unowned self] (_) in
                self.presentPhotoLibrary(source: .photoLibrary,imagePicked: ind)
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
        guard let cell =  collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ListOfPhotoMaseterCell else { return  }
        DispatchQueue.main.async {
            cell.trueImageView.isHide(false)
        }
         nextButton.isEnabled = true
        userDefaults.set(true, forKey: UserDefaultsConstants.isImageUploaded)
//        userDefaults.set(false, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.set(true, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.set(true, forKey: UserDefaultsConstants.isStillImageUpload)

        userDefaults.synchronize()
        
    }
    
    @objc fileprivate func handleUploadProgress(notify: Notification){
        userDefaults.set(false, forKey: UserDefaultsConstants.isImageUploaded)
        userDefaults.set(false, forKey: UserDefaultsConstants.isStillImageUpload)
        userDefaults.synchronize()
         nextButton.isEnabled = false
        guard let userInfo = notify.userInfo as? [String:Any] else { return  }
        //        guard let name = userInfo["name"] as? String else { return  }
        guard let progress = userInfo["progress"] as? Double else { return  }
        guard let size = userInfo["size"] as? Double else { return  }
        guard let image = userInfo["image"] as? UIImage else { return  }
        guard let cell =  collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ListOfPhotoMaseterCell else { return  }
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
    
}

extension ListOfPhotoMainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? photoMasterArray.count :   photosArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  cellMasterId, for: indexPath) as! ListOfPhotoMaseterCell
            let photo = photoMasterArray[indexPath.item]
            cell.photo = photo
            cell.img = choosenImage
            cell.handleInteruptUpload = {[unowned self]  (index) in
                self.creatMainSnackBar(message: "Master Photo can't be deleted...".localized)
            }
            
            return cell
        }
        
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:  cellId, for: indexPath) as! ListOfFhotoCell
        let photo = photosArray[indexPath.item]
        cell.photo = photo
        cell.index = indexPath.item
        cell.handleRemovedImage = {[unowned self] (index,imageId) in
           
            userDefaults.bool(forKey: UserDefaultsConstants.isStillImageUpload) ? self.processToDeleteImage(index:index,imageImdex:imageId) : self.creatMainSnackBar(message: "Wait until imagee uploaded...".localized)
//            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) || userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) ? self.processToDeleteImage(index:index,imageImdex:imageId) : self.creatMainSnackBar(message: "Wait until imagee uploaded...".localized)
        }
        cell.handleInteruptUpload = {[unowned self] (index,imageId) in
//            userDefaults.bool(forKey: UserDefaultsConstants.isStillImageUpload) ? self.processToDeleteImage(index:index,imageImdex:imageId) : self.creatMainSnackBar(message: "Wait until imagee uploaded...".localized)

            self.processToDeleteImage(index:index,imageImdex:imageId)
//            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) || userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) ? self.processToDeleteImage(index:index,imageImdex:imageId) : self.creatMainSnackBar(message: "Wait until imagee uploaded...".localized)
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if aqar != nil {
            goToZoomImage(index: indexPath.item,section:indexPath.section)
//            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) || isUploadNextImage && userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) ? goToZoomImage(index: indexPath.item)  : self.creatMainSnackBar(message: "Wait until Upload image...".localized)
        }else {
            goToZoomImage(index: indexPath.item,section:indexPath.section)
//            userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) || isUploadNextImage && userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload)  ? goToZoomImage(index: indexPath.item)  : self.creatMainSnackBar(message: "Wait until Upload image...".localized)
        }
        //        userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) ? goToZoomImage(index: indexPath.item)  : ()
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:  cellFooterId, for: indexPath) as! ListOfPhotoFooterCell
        cell.mainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takeNormalPhoto)))
        cell.secondMainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(take360Photo)))
        
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


extension ListOfPhotoMainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        let xx = Int(imageSize)
        let imageChoosen = min(imageSize,3000.0)
        
        //reduce image size if it is big
        pushedImage = xx > 3001 ?   pushedImage.resized(toWidth: 1300) : pushedImage
        
        if let url = info[.imageURL] as? URL {
            let fileName = url.lastPathComponent
            imageName = fileName
        }
        uploadChoosedPhoto(pushedImage,imageChoosen,imageName,imagePicked)
        //        self.isUploadNextImage = false
        dismiss(animated: true)
    }
}

