//
//  ListOfPhotoMainSecVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/30/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import MOLH


class ListOfPhotoMainSecVC: UIViewController {
    
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
        //        b.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
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
    
    lazy var picker: UIImagePickerController = {
        let pi = UIImagePickerController()
        pi.delegate = self
        pi.allowsEditing = true
        return pi
    }()
    
    var mainImageView:UIImage!

    var pushedImage:UIImage!
    var photosArray = [SecondPhotoModel]()
    var mainMasterPhoto: SecondPhotoModel?
    var imageSize = 0.0
    var imageType = 0

    var imageName = ""
    
    fileprivate let cellId="cellId"
    fileprivate let cellMasterId="cellMasterId"
    fileprivate let cellFooterId="cellFooterId"
    
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
    
    
    func loadAllImages()  {
        guard let image = aqar.images.first  else {return}
        self.mainMasterPhoto = SecondPhotoModel(image: nil, name: image.image, size: 0.0, isUploaded: true, isMasterPhoto: true, imageUrl: image.src, is360: image.is360 ?? 0)
        
    }
    
    func getAllImagesNotMaster()  {
        var group1: [ImageModel]?
        
        //            UIApplication.shared.beginIgnoringInteractionEvents() // disbale all events in the screen
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
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func addImagesUploaded(image:  [ImageModel]) {
        image.forEach({ (image) in
            
            //            let urlString = image.image
            let photo = SecondPhotoModel(image: nil, name: image.image, size: 0.0, isUploaded: true, isMasterPhoto: false, imageUrl: image.src, is360: image.is360 ?? 0)
            self.photosArray.append(photo)
        })
    }
    
    func processToDeleteImage(index:Int,imageImdex:Int)   {
        ImagesServices.shared.deleteImage(id: imageImdex, token: currentUserToken) {[unowned self] (base, err) in
            if let err=err{
                SVProgressHUD.showError(withStatus: err.localizedDescription);return
            }
            self.photosArray.remove(at: index)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    fileprivate func goToZoomImage(index:Int,section:Int,img:UIImage? = nil)  {
        if section == 0 {
            if img != nil {
                let zoom = ZoomUserImageVC(img:  mainImageView )
                navigationController?.pushViewController(zoom, animated: true)
            }else{
                if  let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? ListOfPhotoMaseterCell {
                    let zoom = ZoomUserImageVC(img:   cell.img)
                    navigationController?.pushViewController(zoom, animated: true)
                    
                }
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
    
    fileprivate func presentPhotoLibrary(source:UIImagePickerController.SourceType,imagePicked:Int)  {
           self.imageType = imagePicked
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
    
    fileprivate func uploadChoosedPhoto(_ img:UIImage,_ size:Double,_ name:String,_ picked:Int)  {
        
        let photo = SecondPhotoModel(image: img, name: name, size: size, isUploaded: false, isMasterPhoto: false, imageUrl: nil, is360: picked)
        userDefaults.set(true, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        photosArray.insert(photo, at: photosArray.count)
        userDefaults.set(true, forKey: UserDefaultsConstants.isSecondPhotoUploading)
        userDefaults.synchronize()
        self.uploadPhoto(photo, index: photosArray.count, picked: picked)
        
    }
    
    fileprivate func uploadPhoto(_ photo:SecondPhotoModel,index:Int,picked:Int)  {
           
           
           let semaphore = DispatchSemaphore(value: 0)
           
           let dispatchQueue = DispatchQueue.global(qos: .background)
           
           
           dispatchQueue.async {
               
               semaphore.signal()
               self.reloadDataAfterUploading()
               semaphore.wait()
               
               PostServices.shared.uploadOtherImagesss(index:index ,photoModel: photo, token: self.currentUserToken) { (base, error) in
                   if let error = error {
                       SVProgressHUD.showError(withStatus: error.localizedDescription)
                       self.activeViewsIfNoData()
                       //                UIApplication.shared.endIgnoringInteractionEvents()
                   }
                   guard let base = base?.data else {return}
                let photo = SecondPhotoModel(image: nil, name: base.image, size: photo.size, isUploaded: true, isMasterPhoto: false, imageUrl: nil, is360: picked)

//                   self.nextPhoto = PhotoModel(image: UIImage(), name: base.image, size: photo.size, isUploaded: true, isMasterPhoto: false, id: base.id ?? 0, imageUrl: base.image, is360: picked)
                   self.photosArray.removeLast()
                   self.photosArray.append(photo)
//                   self.isUploadNextImage = true
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
            
            }
        }
    }
    
    @objc func takeNormalPhoto()  {
           createAlertForChoposingImage(ind: 0)
       }
       
       @objc func take360Photo()  {
              createAlertForChoposingImage(ind: 1)
          }
       
        
}


extension ListOfPhotoMainSecVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 :   photosArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  cellMasterId, for: indexPath) as! ListOfPhotoMaseterCell
            cell.photoSecond = mainMasterPhoto
            cell.handleInteruptUpload = {[unowned self]  (index) in
                self.creatMainSnackBar(message: "Master Photo can't be deleted...".localized)
            }
            
            return cell
        }
        
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:  cellId, for: indexPath) as! ListOfFhotoCell
        let photo = photosArray[indexPath.item]
        cell.photoSecond = photo
        cell.index = indexPath.item
        cell.handleRemovedImage = {[unowned self] (index,imageId) in
            
            userDefaults.bool(forKey: UserDefaultsConstants.isStillImageUpload) ? self.processToDeleteImage(index:index,imageImdex:imageId) : self.creatMainSnackBar(message: "Wait until imagee uploaded...".localized)
        }
        cell.handleInteruptUpload = {[unowned self] (index,imageId) in
            self.processToDeleteImage(index:index,imageImdex:imageId)
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if aqar != nil {
            goToZoomImage(index: indexPath.item,section:indexPath.section)
        }else {
            goToZoomImage(index: indexPath.item,section:indexPath.section,img: mainImageView)
        }
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


extension ListOfPhotoMainSecVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        uploadChoosedPhoto(pushedImage,imageChoosen,imageName,imageType)
        //        self.isUploadNextImage = false
        dismiss(animated: true)
    }
}


