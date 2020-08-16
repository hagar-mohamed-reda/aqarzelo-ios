//
//  CustomStarView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import Cosmos
import MOLH

class CustomStarView: CustomBaseView {
    
    
    lazy var centerImageView:UIImageView = {
        let i = UIImageView(image:  UIImage(named: "house"))
        i.constrainWidth(constant: 100)
        i.constrainHeight(constant: 100)
        i.clipsToBounds = true
        return i
    }()
    
    lazy var starView:CosmosView = {
        let v = CosmosView()
        //        v.tintColor = #colorLiteral(red: 0.9761752486, green: 0.7643268704, blue: 0, alpha: 1)
        v.settings.emptyImage = UIImage(named: "star")
        v.settings.filledImage = #imageLiteral(resourceName: "star2")
        v.settings.minTouchRating = 0
        v.settings.totalStars = 5
        v.rating = 0
        v.didTouchCosmos = {[unowned self] rate in
            self.rating = rate
            switch rate {
            case 0.0: self.centerImageView.image = UIImage(named: "house")
            case 1.0: self.centerImageView.image = UIImage(named: "house1")
            case 2.0: self.centerImageView.image = UIImage(named: "house2")
            case 3.0: self.centerImageView.image = UIImage(named: "house3")
            case 4.0: self.centerImageView.image = UIImage(named: "house4")
            default:
                self.centerImageView.image = UIImage(named: "house5")
            }
//            self.handleRateValue?(Int(rate))
        }
        return v
    }()
    
    
    lazy var doneButton:UIButton = {
        let b = UIButton()
        b.setTitle("Done".localized, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1)
        b.constrainHeight(constant: 40)
        b.constrainWidth(constant: 100)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    
    lazy var closeImageView:UIImageView = {
        let i = UIImageView(image: UIImage(named: "×-1")?.withRenderingMode(.alwaysOriginal))
        i.constrainWidth(constant: 40)
        i.constrainHeight(constant: 40)
        i.clipsToBounds = true
        i.isUserInteractionEnabled = true
        return i
    }()
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.gray.cgColor
        return v
    }()
    lazy var subView:UIView = {
        let v =  UIView(backgroundColor: .clear)
        return v
    }()
    
    var rating:Double = 0.0
    var handleRateValue:((Int)->Void)?
    
    
    override func setupViews()  {
        
         addSubViews(views: mainView,subView,doneButton)
//        addSubViews(views: mainView,doneButton)
        mainView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
//        mainView.fillSuperview(padding: .init(top: 0, left: 0, bottom: -20, right: 0))
//        mainView.addSubViews(views: subView)
        
        subView.addSubViews(views: closeImageView,centerImageView,starView)
        
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            starView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
        subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        centerImageView.centerInSuperview()
        NSLayoutConstraint.activate([doneButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
                                     starView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
            ])
       
        closeImageView.anchor(top: subView.topAnchor, leading: nil, bottom: nil, trailing: subView.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        starView.anchor(top: subView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: -16, left: 0, bottom: 0, right: 0))
         doneButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: -16, right: 16))
    }
}
