//
//  AqarDetailDiscriptionCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class AqarDetailDiscriptionCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet {
            guard let aqar = aqar else { return }

            discriptionDetailLabel.text = aqar.datumDescription
//            print(aqar.datumDescription)
        }
    }
    
    
    lazy var discriptionDetailLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .lightGray,numberOfLines: 0)
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: #colorLiteral(red: 0.9489304423, green: 0.9490666986, blue: 0.94890064, alpha: 1))
        v.constrainHeight(constant: 1)
        return v
    }()
    
    override func setupViews()  {
        backgroundColor = .white
        addSubview(seperatorView)
        discriptionDetailLabel.textAlignment = MOLHLanguage.isRTLLanguage() ? .right :.left
        stack(discriptionDetailLabel,spacing:8).withMargins(.init(top: 0, left: 8, bottom: 8, right: 8))
        
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
}
