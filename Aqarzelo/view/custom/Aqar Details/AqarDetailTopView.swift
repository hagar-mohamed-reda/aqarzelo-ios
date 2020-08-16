//
//  AqarDetailTopView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class AqarDetailTopView: UIView {
    
    var aqar:AqarModel?{
        didSet {
            guard let aqar = aqar else {return}
            let ff = cacheFavoriteAqarsCodabe.storedValue?.contains(where: {$0.id==aqar.id}) ?? false
          
                           favoriteImageView.image =   ff ? #imageLiteral(resourceName: "Group 3923-10") : #imageLiteral(resourceName: "Group 3923s")
                       
            
//            if let favorite = userDefaults.value(forKey: UserDefaultsConstants.favoriteArray) as? [Int] {
//                favoriteImageView.image =   favorite.contains(aqar.id ) ? #imageLiteral(resourceName: "Group 3923-10") : #imageLiteral(resourceName: "Group 3923s")
//            }
        }
    }
    
    
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .lightGray)
        //        v.constrainWidth(constant: 80)
        v.layer.cornerRadius = 24
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.backgroundColor = #colorLiteral(red: 0.9557610154, green: 0.9558982253, blue: 0.9557310939, alpha: 1)
        return v
    }()
    lazy var textView:UITextView = {
        let tx = UITextView()
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        
        //        tx.delegate = self
        return tx
    }()
    lazy var placeHolderLabel = UILabel(text: "Enter Message".localized, font: .systemFont(ofSize: 16), textColor: .lightGray,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var favoriteImageView:UIImageView = {
        let b = UIImageView(image: #imageLiteral(resourceName: "Group 3923s"))
        b.isUserInteractionEnabled = true
        b.contentMode = .scaleAspectFill
        b.clipsToBounds = true
        return b
    }()
    lazy var sendButton:UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "Group 3923-1"), for: .normal)
        b.constrainWidth(constant: 40)
        b.constrainHeight(constant: 50)
        b.isHidden = true
        b.isEnabled = false
        return b
    }()
    lazy var messageImageView:UIImageView = {
        let b = UIImageView(image: #imageLiteral(resourceName: "Group 3924-3").withRenderingMode(.alwaysOriginal))
        //        b.constrainWidth(constant: 40)
        b.contentMode = .scaleAspectFill
        b.isUserInteractionEnabled = true
        //  b.constrainHeight(constant: 50)
        //        b.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHideMessage)))
        b.clipsToBounds = true
        return b
    }()
    lazy var hidedView:UIView = {
        let v = UIView()
        v.isHide(false)
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        layer.cornerRadius = 24
        //        clipsToBounds = true
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .white
        let imageStack = hstack(favoriteImageView,messageImageView,spacing:8,distribution: .fillEqually)
        let iss = stack(imageStack,UIView())
        let dd = stack(sendButton,UIView())
        let ff = stack(mainView,hidedView)
        
        hstack(iss,ff,dd,spacing: 8).withMargins(.init(top: -8, left: 16, bottom: 0, right: 16))
        //        hstack(imageStack,mainView,sendImageView,spacing: 8).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        mainView.addSubViews(views: textView,placeHolderLabel)
        if MOLHLanguage.isRTLLanguage() {
             textView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 8, right: 12))
            placeHolderLabel.anchor(top: mainView.topAnchor, leading: nil, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 8, left: 0, bottom: 8, right: 16))
        }else {
        textView.fillSuperview(padding: .init(top: 8, left: 12, bottom: 8, right: 0))
        placeHolderLabel.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: nil,padding: .init(top: 8, left: 16, bottom: 8, right: 0))
        }
    }
    
    @objc  func handleHideMessage()  {
        self.messageImageView.isHide(true)
        self.sendButton.isHide(false)
        self.hidedView.isHide(true)
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        })
        
    }
    
    @objc  func handleTextChanged()  {
        placeHolderLabel.isHidden = textView.text.count != 0
        
    }
    
    @objc  func handleHideSend()  {
        self.messageImageView.isHide(false)
        self.sendButton.isHide(true)
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        })
        
    }
    
}
