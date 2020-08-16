//
//  MessageCollectionCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import MOLH

class MessageCollectionCell: BaseCollectionCell {
    
    var user:UserIdsModel!{
        didSet {
            guard let user=user else{return}
            userNameLabel.text = user.name
            textMessageLabel.text = user.lastMessage
            let urlString = user.photoURL
            guard let url = URL(string: urlString) else { return  }
            userMessageImageView.sd_setImage(with: url)
            
        }
    }
    
    
    var message:MessageModel!  {
        didSet{
            guard let message=message else{return}
            
            let urlString = message.to.photoURL
            guard let url = URL(string: urlString) else { return  }
            userMessageImageView.sd_setImage(with: url)
            
        }
    }
    
    
    lazy var userMessageImageView:UIImageView = {
        let im = UIImageView(backgroundColor: .gray)
        im.constrainWidth(constant: 80)
        im.layer.cornerRadius = 8
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    //    let stateImageView:UIImageView = {
    //        let im = UIImageView(image: #imageLiteral(resourceName: "badge"))
    //
    //        im.constrainWidth(constant: 60)
    //        im.contentMode = .scaleAspectFit
    //        im.clipsToBounds = true
    //        return im
    //    }()
    lazy var userNameLabel = UILabel(text: "dfdsf", font: .boldSystemFont(ofSize: 18), textColor: .black)
    lazy var textMessageLabel = UILabel(text: "dsfdsf\n dfgfdg", font: .systemFont(ofSize: 14), textColor: .lightGray, numberOfLines: 2)
    lazy var seperatorView:UIView = {
        let vi=UIView(backgroundColor: .gray)
        vi.constrainHeight(constant: 1)
        return vi
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(seperatorView)
        //        let ss = hstack(userNameLabel,stateImageView)
        [userNameLabel,textMessageLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        
        hstack(userMessageImageView,stack(userNameLabel,textMessageLabel,spacing: 8),spacing: 16,alignment:.center).withMargins(.init(top: 0, left: 16, bottom: 8, right: 0))
        
        seperatorView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 32, bottom: 0, right: 0))
    }
}
