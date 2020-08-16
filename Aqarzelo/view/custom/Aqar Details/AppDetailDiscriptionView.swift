//
//  AppDetailDiscriptionView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class AppDetailDiscriptionView: UIView {
    
    var aqar:AqarModel?{
        didSet {
            guard let aqar = aqar else { return  }

            discriptionDetailLabel.text = aqar.datumDescription
        }
    }
    
    
    lazy var discriptionDetailLabel = UILabel(text: "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment", font: .systemFont(ofSize: 16), textColor: .lightGray,textAlignment: .left,numberOfLines: 0)
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.9489304423, green: 0.9490666986, blue: 0.94890064, alpha: 1))
        v.constrainHeight(constant: 1)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .white
        addSubview(seperatorView)
        stack(discriptionDetailLabel,spacing:-8).withMargins(.init(top: 0, left: 0, bottom: 8, right: 0))
        
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
