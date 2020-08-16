//
//  DiscriptionAqarView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH

class DiscriptionAqarView: UIView {
    
    var ads:AdsModel?{
        didSet{
            guard let ads = ads else { return  }
            detailLabel.text = MOLHLanguage.isRTLLanguage() ? ads.titleAr : ads.titleEn
            asdLabel.text = MOLHLanguage.isRTLLanguage() ? ads.descriptionAr : ads.descriptionEn
            
            setuptimer()
            
            let urlString = ads.image
            guard let url = URL(string: urlString) else { return  }
            aqarDetailsImage.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "58889593bc2fc2ef3a1860c1"))
            
        }
    }
    
    
    lazy var aqarDetailsImage:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))
        i.constrainWidth(constant: 120)
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    lazy var detailLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right :  .left,numberOfLines: 2)
    lazy var asdLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .lightGray,textAlignment:MOLHLanguage.isRTLLanguage() ? .right : .left,numberOfLines: 2)
    
    var handleOpenAdss:((AdsModel)->Void)?
    var timer:Timer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        clipsToBounds = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenAds)))
        setupViews()
    }
    
    fileprivate func setuptimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self , selector:
            #selector(startScrolling), userInfo: nil, repeats: true)
        
    }
    
    fileprivate func setupViews()  {
        backgroundColor = .white
        //        detailLabel.constrainHeight(constant: 30)
        let ss = stack(detailLabel,asdLabel).withMargins(.init(top: -16, left: 8, bottom: 0, right: 8))
        
        [asdLabel,detailLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        
        if  MOLHLanguage.isRTLLanguage() {
            hstack(ss,aqarDetailsImage,spacing: 16,alignment:.center)
            
        } else {
            hstack(aqarDetailsImage,ss,spacing: 16,alignment:.center)
        }
        
        
    }
    
    @objc func startScrolling()  {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.alpha = 1
        }
    }
    
    @objc func handleOpenAds()  {
        guard let ads = ads else { return  }
        handleOpenAdss?(ads)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
