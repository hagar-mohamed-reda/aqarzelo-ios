//
//  CustomAqarsView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH

class CustomAqarsView: UIView {
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return  }

            
//            guard let urlString2 = aqar.user?.coverURL, let urlString = aqar.images.first?.src,let url = URL(string: urlString), let url2 = URL(string: urlString2) else {return}
            guard let urlString = aqar.images.first?.image,let url = URL(string: urlString) else { return  }
            
            aqarImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))
//            aqarImageView.sd_setImage(with: url)
//            aqarLogoImage.sd_setImage(with: url2)
            locationTitleLabel.text = MOLHLanguage.isRTLLanguage() ? aqar.titleAr : aqar.title
            
            let space = aqar.space
            let km = aqar.price >= 1000000 ? "M".localized :  "K".localized
                       let k = aqar.price >= 1000000 ? aqar.price / 1000000 : aqar.price / 1000
            locationDistanceLabel.text = "\(k) \(km) , \(space) M"
        }
    }
    
    
    
    var handleInfoAqar:((AqarModel)->Void)?
    
    lazy var aqarLogoImage:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "info"))
        i.constrainWidth(constant: 20)
        i.constrainHeight(constant: 20)
        return i
    }()
    
    lazy var aqarImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))
        i.clipsToBounds = true
        i.constrainHeight(constant: 80)
        return i
    }()
    lazy var locationTitleLabel = UILabel(text: "sdfs", font: .systemFont(ofSize: 14), textColor: .black,numberOfLines: 2)
    lazy var locationDistanceLabel = UILabel(text: "sdfdsf", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        clipsToBounds = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDetails)))
        setupViews()
    }
    
    func setupViews()  {
        backgroundColor = ColorConstant.mainBackgroundColor
        [locationTitleLabel,locationDistanceLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        addSubViews(views: aqarImageView,aqarLogoImage,locationTitleLabel,locationDistanceLabel)
        
        aqarImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        aqarLogoImage.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        
        locationTitleLabel.anchor(top: aqarImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 8, left: 16, bottom: 0, right: 16))
        
        locationDistanceLabel.anchor(top: locationTitleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        
    }
    
    @objc  func handleDetails()  {
        guard let aqar = aqar else { return  }

        handleInfoAqar?(aqar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
