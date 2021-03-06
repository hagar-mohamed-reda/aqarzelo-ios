//
//  ListOfFhotoCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage

class ListOfFhotoCell: BaseCollectionCell {
    
    
    var index:Int! {
        didSet{
            
        }
    }
    
    var photoSecond:SecondPhotoModel? {
        didSet {
            
            guard let photo = photoSecond else { return }
            //            photoImageView.image = photo.image
            //            namePhotoLabel.text = photo.imageName
            namePhotoLabel.text = photo.name
            
            if photo.size > 1000 {
                let value = round(photo.size / 1000)
                
                sizePhotoLabel.text = "\(value) MB"
            }else {
                sizePhotoLabel.text = "\(round(photo.size)) KB"
            }
            
            if  photo.image != nil {
                photoImageView.image = photo.image
            }else {
                guard let url = URL(string: photo.imageUrl ?? "") else {return}
                photoImageView.sd_setImage(with: url)
            }
        }
    }
    
    var img = UIImage()
    var is360Image = false
    var imageUrl = ""
    
    var photo:PhotoModel? {
        didSet {
            
            guard let photo = photo else { return }
            //            photoImageView.image = photo.image
            namePhotoLabel.text = photo.name
            if photo.size > 1000 {
                let value = round(photo.size / 1000)
                
                sizePhotoLabel.text = "\(value) MB"
            }else {
                sizePhotoLabel.text = "\(round(photo.size)) KB"
            }
            if photo.imageUrl != "" || photo.imageUrl != nil {
                guard let url = URL(string: photo.imageUrl ?? "") else {return}
                photoImageView.sd_setImage(with: url)
            }
        }
    }
    
    var image:ImageModel?{
        didSet {
            guard let image = image else { return }
            
            if isFinishedUpload {
                let urlString = image.image ; guard let url = URL(string: urlString) else {return}
                photoImageView.sd_setImage(with: url)
            }
        }
    }
    
    lazy var logo360ImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "360-degrees"))
        i.constrainWidth(constant: 32)
        i.constrainHeight(constant: 32)
        i.clipsToBounds = true
        i.isHide(true)
        return i
    }()
    lazy var trueImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "correct"))
        i.constrainWidth(constant: 20)
        i.constrainHeight(constant: 20)
        i.clipsToBounds = true
        i.isHide(true)
        return i
    }()
    lazy var photoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "315730-1474502491-5"))
        i.contentMode = .scaleAspectFill
        i.constrainWidth(constant: 150)
        i.addSubViews(views: logo360ImageView,trueImageView)
        i.clipsToBounds = true
        return i
    }()
    lazy var progressPhoto:UIProgressView = {
        let s = UIProgressView()
        s.progress = 0
        s.progressTintColor =  #colorLiteral(red: 0.3672481477, green: 0.8992366791, blue: 0.7968696356, alpha: 1)
        s.isHide(true)
        s.constrainHeight(constant: 1)
        return s
    }()
    lazy var namePhotoLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var sizePhotoLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var progressLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var closeButton:UIButton = {
        let b = UIButton()
        b.setImage(UIImage(named: "×-1"), for: .normal)
        b.constrainWidth(constant: 40)
        b.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return b
    }()
    lazy var deleteButton:UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "rubbish-bin-1"), for: .normal)
        b.constrainWidth(constant: 40)
        b.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        b.isHidden = true
        return b
    }()
    var isFinishedUpload:Bool = false
    
    var handleInteruptUpload:((Int,Int)->Void)?
    var handleRemovedImage:((Int,Int)->Void)?
    //    var handleInteruptUpload:(Void)? = <#value#>
    
    
    fileprivate func setupCornerCell() {
        //        layer.cornerRadius = 16
        //        clipsToBounds = true
        //        layer.borderWidth = 3
        //        layer.borderColor = UIColor.gray.cgColor
        
        [progressLabel,namePhotoLabel,sizePhotoLabel].forEach({$0.isHide(true)})
    }
    
    override func setupViews() {
        setupCornerCell()
        progressLabel.constrainWidth(constant: 40)
        let top = hstack(namePhotoLabel,UIView())
        let bott = hstack(sizePhotoLabel,deleteButton,closeButton)
        let pStack = hstack(progressPhoto,progressLabel)
        
        let mainStack = stack(top,pStack,bott)
        
        
        if photoSecond?.isMasterPhoto ?? false {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        }
        else  if  userDefaults.bool(forKey: UserDefaultsConstants.isFinishedGetUploadPhotos) && !userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) {
            deleteButton.isHide(false)
            let ss = hstack(UIView(),deleteButton)
            stack(photoImageView)
            stack(UIView(),stack(UIView(),ss))
            
        }
        else if userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && photoSecond?.isUploaded == false  {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
            [progressLabel,namePhotoLabel,sizePhotoLabel,progressPhoto].forEach({$0.isHide(false)})
            
        }else if userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) && photoSecond?.isUploaded == false {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
            //            trueImageView.centerInSuperview()
            [progressLabel,namePhotoLabel,sizePhotoLabel,progressPhoto].forEach({$0.isHide(false)})
        }
        else {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
            //            trueImageView.centerInSuperview()
            [progressLabel,namePhotoLabel,sizePhotoLabel,progressPhoto].forEach({$0.isHide(false)})
        }
        trueImageView.centerInSuperview()
        logo360ImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        
        //        if photo?.isMasterPhoto ?? false {
        //            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        //        }
        //        else  if  userDefaults.bool(forKey: UserDefaultsConstants.isFinishedGetUploadPhotos) && !userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) {
        //            deleteButton.isHide(false)
        //            let ss = hstack(UIView(),deleteButton)
        //            stack(photoImageView)
        //            stack(UIView(),stack(UIView(),ss))
        //
        //        }
        //        else if userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && photo?.isUploaded == false  {
        //            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        //
        //        }else if userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) && photo?.isUploaded == false {
        //            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        //            //            trueImageView.centerInSuperview()
        //            [progressLabel,namePhotoLabel,sizePhotoLabel,progressPhoto].forEach({$0.isHide(false)})
        //        }
        //        else {
        //            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        //            //            trueImageView.centerInSuperview()
        //            [progressLabel,namePhotoLabel,sizePhotoLabel,progressPhoto].forEach({$0.isHide(false)})
        //        }
        //        trueImageView.centerInSuperview()
        //        logo360ImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        
    }
    
    
    
    @objc func handleClose()  {
        //        handleInteruptUpload?(index,photoSecond?.id ?? 0)
        //        handleInteruptUpload?(index,photo?.id ?? 0)
        
    }
    
    @objc func handleDelete()  {
        //        handleRemovedImage?(index,photoSecond?.id ?? 0)
        //        handleRemovedImage?(index,photo?.id ?? 0)
        
    }
}
