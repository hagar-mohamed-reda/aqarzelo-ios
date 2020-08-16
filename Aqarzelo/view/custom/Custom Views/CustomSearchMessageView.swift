//
//  CustomSearchMessageView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class CustomSearchMessageView: CustomBaseView {
    
    lazy var searchImage:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Search"))
        i.constrainWidth(constant: 40)
        i.isUserInteractionEnabled = true
        return i
    }()
    lazy var textView:UITextView = {
        let tx = UITextView()
        
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        //        tx.delegate = self
        return tx
    }()
    let placeHolderLabel = UILabel(text: "Search ...".localized, font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    override func setupViews() {
        placeHolderLabel.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        backgroundColor = .white
        placeHolderLabel.constrainWidth(constant: 80)
        hstack(textView,searchImage,alignment: .center).withMargins(.init(top: 8, left: 16, bottom: 8, right: 16))
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: 8, right: 0))
    }
    
    @objc  func handleTextChanged()  {
        placeHolderLabel.isHidden = textView.text.count != 0
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //for avoiding retain cycle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

