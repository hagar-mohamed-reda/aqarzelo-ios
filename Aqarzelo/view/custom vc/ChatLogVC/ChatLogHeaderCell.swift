//
//  ChatLogHeaderCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class ChatLogHeaderCell: UIView {
    
//    var toUser:FromModel! {
//        didSet{
//
//            DispatchQueue.main.async {
//                self.titleNameLabel.text = self.toUser.name
//            }
//
//        }
//    }
    
    var targetName:String? = ""
    var targutUrl:String? {
        didSet{
            
            guard let urlString = targutUrl ,let url = URL(string: urlString) else { return }
            userImageView.sd_setImage(with: url)
            
            DispatchQueue.main.async {
                self.titleNameLabel.text = self.targetName
            }
        }
    }
    
    
    lazy var userImageView:UIImageView = {
        let i = UIImageView(backgroundColor: .gray)
        i.clipsToBounds = true
        i.constrainWidth(constant: 80)
        i.layer.cornerRadius = 8
        return i
    }()
    lazy var titleNameLabel = UILabel(text: targetName, font: .systemFont(ofSize: 18), textColor: .black,textAlignment:MOLHLanguage.isRTLLanguage() ? .right : .left )
    
    lazy var seperatorView:UIView = {
       let v = UIView(backgroundColor: .gray)
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
        hstack(userImageView,titleNameLabel,spacing:16,alignment:.center).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
