//
//  PostMessagesCell.swift
//  Alamofire
//
//  Created by Hossam on 8/8/20.
//


import UIKit
import MOLH

class PostMessagesCell: BaseCollectionCell {
    
    var message:GetPostModel! {
        didSet{
            guard let message=message else{return}
            
            userNameLabel.text = message.user.name
            textMessageLabel.text = message.comment
            guard let urlString = message.user.photoURL,let url = URL(string: urlString) else {return}
            userMessageImageView.sd_setImage(with: url)
        }
    }
    
    lazy var userMessageImageView:UIImageView = {
        let im = UIImageView(backgroundColor: .gray)
        im.backgroundColor = .gray
        im.constrainWidth(constant: 60)
        im.constrainHeight(constant: 60)
        im.layer.cornerRadius = 30
        im.contentMode = .scaleAspectFit
        im.clipsToBounds = true
        return im
    }()
    
    lazy var  userNameLabel = UILabel(text: "dfdsf", font: .boldSystemFont(ofSize: 18), textColor: .black)
    lazy var  textMessageLabel = UILabel(text: "", font: .systemFont(ofSize: 14), textColor: .lightGray,textAlignment: .left, numberOfLines: 0)
    lazy var  seperatorView:UIView = {
        let vi=UIView(backgroundColor: .gray)
        vi.constrainHeight(constant: 1)
        return vi
    }()
    
    override func setupViews() {
        backgroundColor = .white
        addSubview(seperatorView)
        let ss = stack(userMessageImageView,UIView())
        [userNameLabel,textMessageLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        if MOLHLanguage.isRTLLanguage() {
            hstack(stack(userNameLabel,textMessageLabel,ss,spacing: 0),spacing: 16).padLeft(16).padRight(16)
        }else {
            hstack(ss,stack(userNameLabel,textMessageLabel,spacing: 0),spacing: 16).padLeft(16).padRight(16)
        }
        
        
        seperatorView.anchor(top: textMessageLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 60, bottom: 0, right: 0))
    }
    
}
