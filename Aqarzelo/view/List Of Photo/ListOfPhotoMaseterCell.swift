//
//  ListOfPhotoMaseterCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SwiftUI
import SDWebImage

class ListOfPhotoMaseterCell: BaseCollectionCell {
    
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
  
    
    var photo:PhotoModel? {
        didSet {
            
            guard let photo = photo else { return }
            //            photoImageView.image = photo.image
//            namePhotoLabel.text = photo.imageName
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
    
    var img = UIImage()
    
    
    lazy var logoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "home(1)"))
        i.constrainWidth(constant: 20)
        i.constrainHeight(constant: 20)
        i.clipsToBounds = true
        return i
    }()
    lazy var photoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "315730-1474502491-5"))
        i.contentMode = .scaleAspectFill

        i.constrainWidth(constant: 150)
        i.addSubViews(views: logoImageView,trueImageView)
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
    lazy var trueImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "correct"))
        i.constrainWidth(constant: 32)
        i.constrainHeight(constant: 32)
        i.clipsToBounds = true
        i.isHide(true)
        return i
    }()
    lazy var namePhotoLabel = UILabel(text: "hosam.png", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var sizePhotoLabel = UILabel(text: "3 mb", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var progressLabel = UILabel(text: "20", font: .systemFont(ofSize: 16), textColor: .black)
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
    
    var handleInteruptUpload:((Int)->Void)?
    
    
    fileprivate func setupCornerCell() {
        layer.cornerRadius = 16
        clipsToBounds = true
        layer.borderWidth = 3
        layer.borderColor = UIColor.gray.cgColor
        
        [progressLabel,namePhotoLabel,sizePhotoLabel].forEach({$0.isHide(true)})
    }
    
    override func setupViews() {
        setupCornerCell()
        progressLabel.constrainWidth(constant: 40)
        let top = hstack(namePhotoLabel,UIView())
        let bott = hstack(sizePhotoLabel,deleteButton,closeButton)
        let pStack = hstack(progressPhoto,progressLabel)
        
        let mainStack = stack(top,pStack,bott)
        
        
        
        if photo?.isMasterPhoto ?? false {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
        }
        else  if  userDefaults.bool(forKey: UserDefaultsConstants.isFinishedGetUploadPhotos) && !userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) {
            deleteButton.isHide(false)
            let ss = hstack(UIView(),deleteButton)
            stack(photoImageView)
            stack(UIView(),stack(UIView(),ss))
//            stack(hstack(logoImageView,UIView()),UIView())
        }
        else if userDefaults.bool(forKey: UserDefaultsConstants.isFirstMasterPhotoUpload) && photo?.isUploaded == false  {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
            stack(hstack(logoImageView,UIView()),UIView())
            
        }else if userDefaults.bool(forKey: UserDefaultsConstants.isSecondPhotoUploading) && photo?.isUploaded == false {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
//            trueImageView.centerInSuperview()
            [progressLabel,namePhotoLabel,sizePhotoLabel,progressPhoto].forEach({$0.isHide(false)})
//            stack(hstack(logoImageView,UIView()),UIView())
        }
        else {
            hstack(photoImageView,mainStack,spacing: 16).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
//            trueImageView.centerInSuperview()
            [progressLabel,namePhotoLabel,sizePhotoLabel,progressPhoto].forEach({$0.isHide(false)})
//            stack(hstack(logoImageView,UIView()),UIView())
        }
        
        trueImageView.centerInSuperview()
        logoImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        
    }
    
    
    
    @objc func handleClose()  {
        handleInteruptUpload?(photo?.id ?? 0)
    }
    
    @objc func handleDelete()  {
        handleInteruptUpload?(photo?.id ?? 0)
    }
}

struct AAA:UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    
    func makeUIView(context: Context) -> some UIView {
        return ListOfPhotoMaseterCell()
    }
}

struct ContentView : View {
    
    var body: some View {
        AAA()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 400, height: 100))
    }
}
