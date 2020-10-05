//
//  PostsDetailsView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class PostsDetailsView: UIView {
    
    lazy var postsButton:UIButton = {
        let b = UIButton()
        b.setTitle("Posts".localized, for: .normal)
        b.setTitleColor(#colorLiteral(red: 0.5761474967, green: 0.9580560327, blue: 0.9207853079, alpha: 1), for: .normal)
        b.backgroundColor = .white
        return b
    }()
    lazy var detailsButton:UIButton = {
        let b = UIButton()
    b.setTitle("Details".localized, for: .normal)
    b.setTitleColor(.black, for: .normal)
    b.backgroundColor = .white
        
    return b
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.9761839509, green: 0.9763434529, blue: 0.9761499763, alpha: 1))
        v.constrainWidth(constant: 3)
        
        return v
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 24
        layer.borderWidth = 3
        layer.borderColor = #colorLiteral(red: 0.9761839509, green: 0.9763434529, blue: 0.9761499763, alpha: 1).cgColor
       
        dropShadow(color: .red, offSet: CGSize(width: 2.0, height: 2.0))
//        clipsToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        
        if  MOLHLanguage.isRTLLanguage() { hstack(detailsButton,seperatorView,postsButton,distribution:.fillProportionally)
        }else{
        hstack(postsButton,seperatorView,detailsButton,distribution:.fillProportionally)
        }
    }
    
    
    
}
