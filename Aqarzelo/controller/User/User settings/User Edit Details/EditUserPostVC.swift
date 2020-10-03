//
//  EditUserPostVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH

class EditUserPostVC: BaseViewController {
    
    lazy var customAddPostListOfPhotoView:CustomAddPostListOfPhotoEditingView = {
        let v =  CustomAddPostListOfPhotoEditingView()
        //        v.photosArray = photosArray
        v.collectionView.delegate = self
        v.collectionView.dataSource = self
        v.nextButton.isEnabled = true
        v.nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return v
    }()
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
    lazy var picker: UIImagePickerController = {
        let pi = UIImagePickerController()
        pi.delegate = self
        pi.allowsEditing = true
        return pi
    }()
    
    var aqar:AqarModel?
    
    var imagePicked = 0
    var imageProfileView:UIImageView?
    var imageBackgroundView:UIImageView?
    
    var photosFinishedArray = [ImageModel]()
    var pushedImage:UIImage!
    var imageSize:Double = 0.0
    var imageName:String    =  ""
    fileprivate let cellId = "cellId"
    
    fileprivate let currentUserToken:String!
    fileprivate let postId:Int!
    
    init(token:String,postId:Int) {
        self.currentUserToken = token
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        fetchAllPhotos()
        statusBarBackgroundColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    fileprivate func setupObservers()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadNextProgress), name: .uoloadNextProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadNextComplete), name: .uploadNextComplete, object: nil)
    }
    
    override func setupNavigation() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        navigationItem.title = "Edit Post".localized
        let img:UIImage = (MOLHLanguage.isRTLLanguage() ?  UIImage(named:"back button-2") : #imageLiteral(resourceName: "back button-2")) ?? #imageLiteral(resourceName: "back button-2")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back button-2").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBack))
    }
    
    override func setupViews() {
        view.backgroundColor = ColorConstant.mainBackgroundColor
        
        view.addSubview(customAddPostListOfPhotoView)
        customAddPostListOfPhotoView.fillSuperview(padding: .init(top: 0, left: 0, bottom: -8, right: 0))
    }
    
    func fetchAllPhotos()  {
        self.photosFinishedArray.removeAll()
        view.isUserInteractionEnabled=false
//        UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
        progressHudProperties()
        
        UploadImagesServices.shared.getAllUserImagesWithPostId(postId:postId,api_token: currentUserToken) { (base, error) in
            if let error = error {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.callMainError(err: error.localizedDescription, vc: self.customMainAlertVC, views: self.customErrorView,height: 260)
                }
                self.activeViewsIfNoData();return
            }
            SVProgressHUD.dismiss()
            
            self.activeViewsIfNoData()
            self.photosFinishedArray = base?.data ?? []
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.customAddPostListOfPhotoView.nextButton.isEnabled = true
                self.customAddPostListOfPhotoView.collectionView.reloadData()
            }
        }
    }
    
    func uploadChoosedPhoto(_ img:UIImage,_ size:Double,_ name:String)  {
        //        let photo = PhotoModel(image: img, name: name, size: size)
        //        photosArray.append(photo)
        //        nextPhoto =  PhotoModel(image: img, name: name, size: size)
        //        //        photosFinishedArray.append(photo)
        //        DispatchQueue.main.async {
        //            //            self.isBeginUploadPhoto = !self.isBeginUploadPhoto
        //            //            self.customAddPostListOfPhotoView.photosArray.append(photo)
        //
        //            self.customAddPostListOfPhotoView.collectionView.reloadData()
        //        }
    }
    
    func deletImageUsing(id:Int,token:String,index:Int)  {
        ImagesServices.shared.deleteImage(id: id, token: token) { (base, err) in
            guard let base = base else {return}
            
            base.messageEn == "done" ?   SVProgressHUD.showSuccess(withStatus:  " Done successfully...") : SVProgressHUD.showError(withStatus: "An Error Occured..")
            self.refreshData(index: index)
        }
    }
    
    func refreshData (index:Int)  {
        
        DispatchQueue.main.async {
            self.photosFinishedArray.remove(at: index)
            self.customAddPostListOfPhotoView.collectionView.reloadData()
        }
    }
    
    func goToEditPost()  {
        guard let aqar = aqar else { return  }
        let post = MainCreatePostVC(token: currentUserToken)
        post.aqar = aqar
        showOrHideCustomTabBar(hide: true)
        navigationController?.pushViewController(post, animated: true)
    }
    
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
        cell.progressPhoto.setProgress(Float(progress), animated: true) //=  Float(progress / size )
        let unique = UUID().uuidString
        
        cell.namePhotoLabel.text =  userInfo["name"] as? String //?? unique
        cell.progressLabel.text = "\(Int(progress * 100 ))%"
        cell.progressLabel.isHidden = false
        
        cell.photoImageView.image = image
        if progress == 1 {
            cell.deleteButton.isHidden = false
            cell.closeButton.isHide(true)
            cell.progressLabel.isHidden = true
            cell.trueImageView.isHide(false)
        }
        
    }
    
    @objc func handleUploadNextComplete()  {
        userDefaults.set(true, forKey: UserDefaultsConstants.isImageUploaded)
        userDefaults.set(false, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        customAddPostListOfPhotoView.nextButton.isEnabled = true
    }
    
    @objc func handleDoneError()  {
              removeViewWithAnimation(vvv: customErrorView)
              customMainAlertVC.dismiss(animated: true)
          }
    
    @objc fileprivate  func  handleBack()  {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNext()  {
        photosFinishedArray.count > 0 ? goToEditPost() : ()
    }
    
    @objc func handleChooseImage()  {
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }
    
    @objc func handleChoose360Image()  {
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }
    
    @objc func handleDismiss()  {
           dismiss(animated: true, completion: nil)
       }
}


extension EditUserPostVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.noDataFound(photosFinishedArray.count, text: "No Data Added Yet".localized)
        
        return   photosFinishedArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MasterPhotoCell
        cell.image = photosFinishedArray[indexPath.item]
        cell.index = indexPath.item
        cell.handleRemovedImage = {[unowned self] (index,image) in
            self.deletImageUsing(id: image.id ?? 1, token: self.currentUserToken, index: index)
            
        }
        cell.handleNotDeleted = {[unowned self] in
            self.creatMainSnackBar(message: "Master Photo Can't Be Deleted...")
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.item, section: 0) ) as? MasterPhotoCell{
            let img = cell.photoImageView.image ?? UIImage()
            
            let zoom = ZoomUserImageVC(img: img)
            navigationController?.pushViewController(zoom, animated: true)
        }
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: customAddPostListOfPhotoView.cellFooterId, for: indexPath) as! ListOfPhotoFooterCell
        cell.mainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseImage)))
        cell.secondMainImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChoose360Image)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return  .init(width: view.frame.width-32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width-32, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
}



extension EditUserPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[.editedImage] as? UIImage {
            
        }
        if let img = info[.originalImage] as? UIImage {
            pushedImage = img
        }
        let jpegData = pushedImage.jpegData(compressionQuality: 1.0)
        let jpegSize: Int = jpegData?.count ?? 0
        let sizeKB = Double(jpegSize) / 1000
        _ = (Double(jpegSize) / 1000 / 1000)
        
        imageSize =  sizeKB
        
        
        if let url = info[.imageURL] as? URL {
            let fileName = url.lastPathComponent
            imageName = fileName
        }
        
        uploadChoosedPhoto(pushedImage,imageSize,imageName)
        dismiss(animated: true)
    }
}
