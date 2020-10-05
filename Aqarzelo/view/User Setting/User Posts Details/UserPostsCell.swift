//
//  UserPostsCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH

class UserPostsCell: BaseCollectionCell {
    
    var index:Int = 0
    
    
    var post:AqarModel? {
        didSet{
            guard let post = post else { return }
            postTitleLabel.text = post.title
            let price = Int(post.price / 1000)
            let space = post.space
            
            postInfoLabel.text = "\(price) K, \(space) M"
            postStatusLabel.text = post.status
            guard let urlString = post.images.first?.image,let url = URL(string: urlString) else { return  }
            postImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "58889593bc2fc2ef3a1860c1"))
            
        }
    }
    lazy var dotsImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 3928-3"))
        i.constrainWidth(constant: 4)
        i.isUserInteractionEnabled = true
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlMoreOptions)))
        i.clipsToBounds = true
        return i
    }()
    
    lazy var postImageView:UIImageView = {
        let i = UIImageView(backgroundColor: .gray)
        i.clipsToBounds = true
        return i
    }()
    
    lazy var postTitleLabel = UILabel(text: "", font: .systemFont(ofSize: 14), textColor: .black)
    
    lazy var postInfoLabel = UILabel(text: "", font: .systemFont(ofSize: 12), textColor: .white,textAlignment: .center)
    lazy var postStatusLabel = UILabel(text: "", font: .systemFont(ofSize: 18), textColor: .brown,textAlignment: .center)
    
    var handleMoreOptions:((AqarModel,Int)->())?
    
    override func setupViews() {
        backgroundColor = ColorConstant.mainBackgroundColor
        postTitleLabel.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        [postTitleLabel,postInfoLabel,postStatusLabel].forEach({$0.constrainHeight(constant: 20)})
        let topStack = MOLHLanguage.isRTLLanguage() ? hstack(dotsImageView,postTitleLabel,spacing:8) :  hstack(postTitleLabel,dotsImageView,spacing:8)
        
        let subLabels = stack(topStack,postInfoLabel,postStatusLabel)
        let ss = stack(postImageView).padLeft(-8).padRight(-8)
        
        stack(ss,subLabels,spacing: 8).withMargins(.init(top: 0, left: 8, bottom: 8, right: 8))
        
    }
    
    @objc func handlMoreOptions()  {
        guard let post = post else { return }

        handleMoreOptions?(post,index)
    }
}
