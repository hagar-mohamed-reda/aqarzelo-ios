//
//  SendChatView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class SendChatView: UIView {
    
    lazy var textView:UITextView = {
        let tx = UITextView()
        
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        
        tx.delegate = self
        return tx
    }()
    lazy var placeHolderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    
    lazy var sendImageView:UIImageView = {
        let b = UIImageView(image: #imageLiteral(resourceName: "Group 3923-1"))
        //        b.setTitle("asd", for: .normal)
        
        b.constrainWidth(constant: 50)
        
        b.clipsToBounds = true
        return b
    }()
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        sendButton.isEnabled = false
        
        layer.cornerRadius = 24
        clipsToBounds = true
        backgroundColor = #colorLiteral(red: 0.9111731052, green: 0.9113041759, blue: 0.9111444354, alpha: 1)
        autoresizingMask = .flexibleHeight
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -12), color: .lightGray)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
//        addSubViews(views:placeHolderLabel)
        
        hstack(textView,alignment: .center).withMargins(.init(top: 0, left: 8, bottom: 0, right: 8))
        textView.addSubview(sendImageView)
        
        textView.hstack(UIView(),sendImageView,UIView())
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

extension SendChatView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
        }else {
        }
    }
}

