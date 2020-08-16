//
//  MasterPhotoCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class MasterPhotoCell: BaseCollectionCell {
    
    var index:Int! {
        didSet{
            
        }
    }
    
    var image:ImageModel!{
        didSet {
            //            if isFinishedUpload {
            let urlString = image.image ; guard let url = URL(string: urlString) else {return}
            photoImageView.sd_setImage(with: url)
            //            }
        }
    }
    
    
    lazy var photoImageView:UIImageView = {
        let i = UIImageView(backgroundColor: .gray)
        i.constrainWidth(constant: 150)
        i.clipsToBounds = true
        return i
    }()
    lazy var progressPhoto:UIProgressView = {
        let s = UIProgressView()
        s.progress = 0
        s.progressTintColor =  #colorLiteral(red: 0.3672481477, green: 0.8992366791, blue: 0.7968696356, alpha: 1)
        return s
    }()
    lazy var trueImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 3923-6"))
        //        i.constrainWidth(constant: 150)
        i.clipsToBounds = true
        i.isHide(true)
        return i
    }()
    lazy var namePhotoLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black)
    lazy var sizePhotoLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .lightGray)
    lazy var progressLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .lightGray)
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
    
    var handleInteruptUpload:((Int)->Void)?
    var handleRemovedImage:((Int,ImageModel)->Void)?
    //    var handleInteruptUpload:(Void)? = <#value#>
    var handleNotDeleted:(()->Void)?
    
    
    fileprivate func setupCornerCell() {
        layer.cornerRadius = 16
        clipsToBounds = true
        layer.borderWidth = 3
        layer.borderColor = UIColor.gray.cgColor
    }
    
    override func setupViews() {
        setupCornerCell()
        progressLabel.constrainWidth(constant: 40)
        let top = hstack(namePhotoLabel,UIView())
        let bott = hstack(sizePhotoLabel,deleteButton,closeButton)
        let pStack = hstack(progressPhoto,progressLabel)
        
        let mainStack = stack(top,pStack,bott)
        
        
        
        
        
        
        deleteButton.isHide(false)
        
        stack(photoImageView)
        
        let ss = hstack(UIView(),deleteButton)
        
        stack(UIView(),ss)
        
        
        
        
    }
    
    
    
    @objc func handleClose()  {
        handleInteruptUpload?(index)
    }
    
    @objc func handleDelete()  {
        index == 0 ?  handleNotDeleted?() :  handleRemovedImage?(index,image)
    }
    
    
}
