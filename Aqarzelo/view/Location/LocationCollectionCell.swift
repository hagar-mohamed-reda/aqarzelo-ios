//
//  LocationCollectionCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH
//import Gemini

class LocationCollectionCell: BaseCollectionCell {
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return  }
            locationTitleLabel.text = MOLHLanguage.isRTLLanguage() ? aqar.titleAr :  aqar.title
            let km = aqar.price >= 1000000 ? "M".localized :  "K".localized
                       let k = aqar.price >= 1000000 ? aqar.price / 1000000 : aqar.price / 1000
            let space = Int(aqar.space.toInt() ?? 0/1000)
            
            locationDistanceLabel.text = "\(k) \(km) , \(space) "+"M²".localized
            guard let urlString = aqar.images.first?.image,let url = URL(string: urlString) else { return  }
            
            locationImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))
            
            
            //space meter,  price k 1000
        }
    }
    
    
    
    
    lazy var locationImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))
        i.constrainHeight(constant: 100)
        i.clipsToBounds = true
        return i
    }()
    
    lazy var locationTitleLabel = UILabel(text: "Hotel", font: .systemFont(ofSize: 14), textColor: .black,numberOfLines: 2)
    lazy var locationDistanceLabel = UILabel(text: "250 k, 1000 m", font: .systemFont(ofSize: 16), textColor: #colorLiteral(red: 0.820566833, green: 0.8206856251, blue: 0.8205407858, alpha: 1))
    
    
    
    override func setupViews() {
        backgroundColor = .white
        layer.cornerRadius=16
        clipsToBounds=true
        [locationTitleLabel,locationDistanceLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        let ss = stack(locationTitleLabel,locationDistanceLabel).withMargins(.init(top: 0, left: 16, bottom: 8, right: 16))
        
        stack(locationImageView,ss)
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ?  #colorLiteral(red: 0.2816769481, green: 0.634985745, blue: 0.6430925131, alpha: 1) : .white
            transform = isSelected ?  CGAffineTransform(scaleX: 1, y: 1.2) : .identity
            [locationTitleLabel,locationDistanceLabel].forEach({$0.textColor = isSelected ? .white : .black })
            layoutIfNeeded()
        }
    }
    
}
