//
//  FavoriteCollectionCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH

class FavoriteCollectionCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar=aqar else{return}
            self.locationTitleLabel.text = aqar.title
            let price = Int(aqar.price / 1000)
            let space = aqar.space
            
            self.locationDistanceLabel.text = "\(price) K, \(space) M"
            guard let urlString = aqar.images.first?.image,let url = URL(string: urlString) else { return  }
            self.locationImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "WhatsApp Image 2020-07-25 at 05.50.46"))
            
            
        }
    }
    
    lazy var locationImageView:UIImageView = {
        let i = UIImageView(backgroundColor: .gray)
        //        i.clipsToBounds = true
        return i
    }()
    
    lazy var locationTitleLabel = UILabel(text: "", font: .systemFont(ofSize: 14), textColor: .black)
    lazy var locationDistanceLabel = UILabel(text: "", font: .systemFont(ofSize: 14), textColor: #colorLiteral(red: 0.820566833, green: 0.8206856251, blue: 0.8205407858, alpha: 1))
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        clipsToBounds = true
        setupShadow(opacity: 0.2, radius: 10, offset: .init(width: 0, height: 10), color: .gray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        [locationTitleLabel,locationDistanceLabel].forEach { (l) in
            l.constrainHeight(constant: 30)
            l.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        }
        backgroundColor = .white
        let ss = stack(locationImageView).withMargins(.init(top: 0, left: -8, bottom: 0, right: -8))
        
        stack(ss,locationTitleLabel,locationDistanceLabel).withMargins(.init(top: 0, left: 8, bottom: 8, right: 8))
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ?  ColorConstant.mainBackgroundColor : .white
            transform = isSelected ?  CGAffineTransform(scaleX: 1, y: 1.2) : .identity
            locationTitleLabel.textColor = isSelected ? .white : .black
            layoutIfNeeded()
        }
    }
}
