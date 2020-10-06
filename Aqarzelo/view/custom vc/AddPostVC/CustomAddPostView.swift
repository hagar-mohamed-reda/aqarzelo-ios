//
//  CustomAddPostView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class CustomAddPostView: UIView {
    
    lazy var mainImage:UIImageView = {
        let i = UIImageView(image: UIImage(named: "Group 3923-7"))
        i.isUserInteractionEnabled = true
        //        i.clipsToBounds = true
        return i
    }()
    
    lazy var logoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "upload-cloud"))
        i.constrainHeight(constant: 100)
        i.contentMode = .scaleAspectFill
        i.translatesAutoresizingMaskIntoConstraints=false
        return i
    }()
    //    lazy var maximumLabel = UILabel(text: "The maximum upload limit \n for photos is 20".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .center,numberOfLines: 2)
    lazy var firstPhotoLabel = UILabel(text: "The first photo is master seen".localized, font: .systemFont(ofSize: 16), textColor: .black,textAlignment: .center)
    lazy var bottomStack:UIStackView = {
        let b = getStack(views: firstPhotoLabel,uploadMasterPhotoButton,cameraButton, spacing: 8, distribution: .fillEqually, axis: .vertical)
        return b
    }()
    lazy var cameraButton = createSimeBottomViews(title: " Camera ".localized, image: #imageLiteral(resourceName: "photo-camera (3)"),  color: #colorLiteral(red: 0.9249336123, green: 0.9250853658, blue: 0.9249013662, alpha: 1))
    lazy var uploadMasterPhotoButton = createSimeBottomViews(title: "Upload master photo ".localized, image: #imageLiteral(resourceName: "gallery (1)"),  color: #colorLiteral(red: 0.9249336123, green: 0.9250853658, blue: 0.9249013662, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        
        addSubview(mainImage)
        
        mainImage.fillSuperview()
        
        //        mainImage.addSubViews(views: logoImageView,maximumLabel,bottomStack)
        mainImage.addSubViews(views: logoImageView,bottomStack)
        
//        logoImageView.centerInSuperview()
//        logoImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 60, left: 0, bottom: 8, right: 0))
        
        //        maximumLabel.anchor(top: logoImageView.bottomAnchor, leading: leadingAnchor, bottom: bottomStack.topAnchor, trailing: trailingAnchor,padding: .init(top: 24, left: 48, bottom: 24, right: 48))
        bottomStack.anchor(top: nil, leading: mainImage.leadingAnchor, bottom: mainImage.bottomAnchor, trailing: mainImage.trailingAnchor,padding: .init(top: 20, left: 48, bottom: 48, right: 48))
        
        NSLayoutConstraint.activate([logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -120)
        ])
    }
    
    func createSimeBottomViews(title: String,image:UIImage,color:UIColor) -> UIView {
        let v = UIView(backgroundColor: color)
        v.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        v.layer.cornerRadius = 24
        v.clipsToBounds=true
//        v.constrainHeight(constant: 50)
        let la = UILabel(text: title, font: .systemFont(ofSize: 16), textColor: .black, textAlignment: .center)
        
        let im = UIImageView(image: image)
        im.constrainWidth(constant: 60)
        im.clipsToBounds=true
        im.contentMode = .scaleToFill
        if MOLHLanguage.isRTLLanguage() {
            v.hstack(la,im).withMargins(.init(top: 16, left: 24, bottom: 16, right: 24))
        }else {
            v.hstack(im,la).withMargins(.init(top: 16, left: 24, bottom: 16, right: 24))
        }
        return v
    }
    
}
