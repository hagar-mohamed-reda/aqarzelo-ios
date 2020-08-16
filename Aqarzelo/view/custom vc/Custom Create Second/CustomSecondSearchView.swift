//
//  CustomSecondSearchView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CustomSecondSearchView: UIView {
    
    lazy var searchImageView:UIImageView = {
       let i = UIImageView(image: #imageLiteral(resourceName: "Search"))
        i.isUserInteractionEnabled = true
        i.constrainWidth(constant: 40)
        return i
    }()
    lazy var searchTextField:UITextField = {
       let t = UITextField()
        t.placeholder = "enter place"
        
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 24
        clipsToBounds = true
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .gray
        
        addSubViews(views: searchImageView,searchTextField)
        
        searchImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        searchTextField.anchor(top: topAnchor, leading: searchImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 16, bottom: 0, right: 0))
    }
}
