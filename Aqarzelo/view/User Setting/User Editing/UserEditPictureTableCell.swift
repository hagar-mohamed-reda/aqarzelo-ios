//
//  UserEditPictureTableCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH

class UserEditPictureTableCell: BaseTableViewCell {
    
    var index:Int! {
        didSet {
            print(index)
        }
    }
    
    var user:UserModel?{
        didSet{
            guard let user = user else { return }
            
            guard let urlPhoto = URL(string:  user.photoURL)else {return}
            profileImageView.sd_setImage(with: urlPhoto,placeholderImage: #imageLiteral(resourceName: "Group 3931-1").withRenderingMode(.alwaysTemplate))
        }
    }
    
    
    var isEdit:Bool = false
    
    
    lazy var profileImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "jackFinniganRriAi0NhcbcUnsplash"))
        i.constrainWidth(constant: 60)
        i.constrainHeight(constant: 60)
        i.isUserInteractionEnabled = true
        i.clipsToBounds = true
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseImage)))
        i.tag = 0
        return i
    }()
    lazy var profilePictureLabel = UILabel(text: "Profile Picture".localized, font: .systemFont(ofSize: 18), textColor: #colorLiteral(red: 0.4835856557, green: 0.483658731, blue: 0.4835696816, alpha: 1))
    lazy var editButton:UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        b.setTitle("Edit".localized, for: .normal)
        b.setTitleColor(#colorLiteral(red: 0.3446323574, green: 0.889023602, blue: 0.7731447816, alpha: 1), for: .normal)
        return b
    }()
    var widthImageView:NSLayoutConstraint!
    var handleChooseImageClosure:((UIImage)->Void)?
    var handleEditUsingIndex:((Int,UserEditPictureTableCell,Int)->Void)?
    
    var handleImageScalling:((UIImage)->Void)?
    
    
    override func setupViews() {
        accessoryType = .none
        
        selectionStyle = .none
        backgroundColor = .white
        //        let topStack = MOLHLanguage.isRTLLanguage() ? hstack(editButton,UIView(),profilePictureLabel) :  hstack(profilePictureLabel,UIView(),editButton)
        let topStack = MOLHLanguage.isRTLLanguage() ? hstack(profilePictureLabel,UIView(),editButton)  :  hstack(editButton,UIView(),profilePictureLabel)
        
        
        let bottomStack = MOLHLanguage.isRTLLanguage() ? hstack(profileImageView,UIView()) :  hstack(UIView(),profileImageView)
        
        stack(topStack,bottomStack,spacing:8).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        
        
        
    }
    
    @objc func handleChooseImage()  {
        isEdit ?  handleChooseImageClosure?(profileImageView.image ?? UIImage()) :   handleImageScalling?(profileImageView.image ?? UIImage())
    }
    
    @objc func handleEdit()  {
        handleEditUsingIndex?(index,self,0)
        
    }
}
