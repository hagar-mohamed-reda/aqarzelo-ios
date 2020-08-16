//
//  CustomSendView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class CustomSendView: UIView {
    lazy var textView:UITextView = {
        let tx = UITextView()
        tx.backgroundColor = #colorLiteral(red: 0.9180622697, green: 0.918194294, blue: 0.918033421, alpha: 1)
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        tx.delegate = self
        tx.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        return tx
    }()
    lazy var placeHolderLabel = UILabel(text: "Enter Message".localized, font: .systemFont(ofSize: 16), textColor: .lightGray,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    
    
    lazy var sendButton:UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "Group 3923-1"), for: .normal)
        b.constrainWidth(constant: 40)
        b.constrainHeight(constant: 50)
        return b
    }()
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 24
        clipsToBounds = true
        backgroundColor =  #colorLiteral(red: 0.9111731052, green: 0.9113041759, blue: 0.9111444354, alpha: 1)
        autoresizingMask = .flexibleHeight
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -12), color: .lightGray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
        SsetupViews()
    }
    
    fileprivate func SsetupViews() {
        if MOLHLanguage.isRTLLanguage() {
            hstack(sendButton,textView,alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 8))
        }else {
            hstack(textView,sendButton,alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 8))
            
        }
        addSubViews(views:placeHolderLabel)
        
        if MOLHLanguage.isRTLLanguage() {
            placeHolderLabel.anchor(top: nil, leading: textView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 0))
            
        }else {
            placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: sendButton.leadingAnchor,padding: .init(top: 0, left: 20, bottom: 0, right: 0))
            
        }
        placeHolderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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

extension CustomSendView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            sendButton.isEnabled = true
            sendButton.setTitleColor(.black, for: .normal)
            
        }else {
            sendButton.isEnabled = false
            sendButton.setTitleColor(.lightGray, for: .normal)
        }
    }
}
