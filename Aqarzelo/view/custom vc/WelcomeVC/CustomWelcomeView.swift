//
//  CustomWelcomeView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CustomWelcomeView: UIView {
    
    lazy var logoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "يبير"))
        i.constrainHeight(constant: 128)
        i.constrainWidth(constant: 101)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "1"))
        i.isUserInteractionEnabled = true
        return i
    }()
    
    lazy var mainLabel:UILabel = UILabel(text: "AQAR ZELO".localized, font: .systemFont(ofSize: 44), textColor: .white, textAlignment: .center)
    lazy var infoLabel = UILabel(text: "What Location you want the application \n to opened on ?".localized, font: .systemFont(ofSize: 20), textColor: .white,textAlignment: .center, numberOfLines: 2)
    lazy var currentLocationButton:UIButton = {
        let b = UIButton()
        b.setTitle("current location".localized, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = #colorLiteral(red: 0.4325206876, green: 0.8569215536, blue: 0.6972793937, alpha: 1) //#colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1)
        b.constrainHeight(constant: 60)
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2211710215, green: 0.7151315808, blue: 0.645074904, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    lazy var goLocationButton:UIButton = {
        let b = UIButton()
        b.setTitle("Go location".localized, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = .clear
        b.constrainHeight(constant: 60)
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2142036259, green: 0.6693813801, blue: 0.6946871877, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        addSubview(mainImageView)
        
        mainImageView.fillSuperview()
        let bottomStack = getStack(views: infoLabel,currentLocationButton,goLocationButton, spacing: 16, distribution: .fill, axis: .vertical)
        
        mainImageView.addSubViews(views: mainLabel,logoImageView,bottomStack)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            ])
        
        mainLabel.centerInSuperview()
        logoImageView.anchor(top: nil, leading: nil, bottom: mainLabel.topAnchor, trailing: nil)
        bottomStack.anchor(top: mainLabel.bottomAnchor, leading: mainImageView.leadingAnchor, bottom: nil, trailing: mainImageView.trailingAnchor,padding: .init(top: 32, left: 16, bottom: 0, right: 16))
        
    }
}
