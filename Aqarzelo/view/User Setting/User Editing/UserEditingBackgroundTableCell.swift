//
//  UserEditingBackgroundTableCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class UserEditingBackgroundTableCell: BaseTableViewCell {
    
    var index:Int? {
        didSet {
            guard let user = index else { return }
        }
    }
    
    var user:UserModel?{
        didSet{
            guard let user = user else { return }

            guard let urlPhoto = URL(string:  user.coverURL)else {return}
            backgroundImageView.sd_setImage(with: urlPhoto,placeholderImage: #imageLiteral(resourceName: "joshua-rawson-harris-LX0pplSjE2g-unsplash"))
        }
    }
    
    var isEdit:Bool = false
    lazy var backgroundImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))
        i.layer.cornerRadius = 8
        i.clipsToBounds = true
        i.isUserInteractionEnabled = true
         i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseImage)))
        i.tag = 1
        return i
    }()
    lazy var coverPictureLabel = UILabel(text: "Cover Picture".localized, font: .systemFont(ofSize: 18), textColor: #colorLiteral(red: 0.4835856557, green: 0.483658731, blue: 0.4835696816, alpha: 1))
    lazy var editButton:UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        b.setTitle("Edit".localized, for: .normal)
        b.setTitleColor(#colorLiteral(red: 0.3446323574, green: 0.889023602, blue: 0.7731447816, alpha: 1), for: .normal)
        return b
    }()
    
     var handleEditUsingIndex:((Int,UserEditingBackgroundTableCell,Int)->Void)?
     var handleChooseImageClosure:((UIImage)->Void)?
     var handleImageScalling:((UIImage)->Void)?
    
    override func setupViews() {
        accessoryType = .none
        backgroundColor = .white
        selectionStyle = .none
        let topStack = MOLHLanguage.isRTLLanguage() ? hstack(coverPictureLabel,UIView(),editButton) :
        hstack(editButton,UIView(),coverPictureLabel)
        
        stack(topStack,backgroundImageView,spacing:8).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        
        
        
    }
    
    @objc func handleChooseImage()  {
        isEdit ?  handleChooseImageClosure?(backgroundImageView.image ?? UIImage()) :   handleImageScalling?(backgroundImageView.image ?? UIImage())
    }
    
    
    
    @objc func handleEdit()  {
        guard let index = index else { return  }
        handleEditUsingIndex?(index,self,1)
    }
}
