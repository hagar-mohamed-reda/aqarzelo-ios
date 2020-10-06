//
//  FirstCreatePostCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class FirstCreatePostCell: BaseCollectionCell,UITextFieldDelegate {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3930")
            textView.text = aqar.title
            handleTextChanged()
            counttitleLabel.text = "\(textView.text.count) "+"letter".localized
            handleTextContents?(textView.text!,true)
        }
    }
    
    
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3923-3"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var titleLabel = UILabel(text: "Title in English".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var textView:UITextView = {
        let tx = UITextView()
        tx.addSubview(placeHolderLabel)
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        //        tx.isHide(true)
        tx.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left
        tx.delegate = self
        tx.sizeToFit()
        return tx
    }()
    lazy var placeHolderLabel = UILabel(text: "Enter Title".localized, font: .systemFont(ofSize: 16), textColor: .lightGray)
    lazy var mainView:UIView = {
        let l = UIView(backgroundColor: .white)
        l.layer.cornerRadius = 8
        l.layer.borderWidth = 1
        l.layer.borderColor = #colorLiteral(red: 0.4835817814, green: 0.4836651683, blue: 0.4835640788, alpha: 1).cgColor
        l.constrainWidth(constant: frame.width - 126)
        l.isHide(true)
        
        return l
    }()
    
    
    lazy var counttitleLabel = UILabel(text: "50 letter".localized, font: .systemFont(ofSize: 16), textColor: .lightGray,textAlignment: .right)
    
    var handleTextContents:((String?,Bool)->Void)?
    var titleString:String = ""
    weak var createFirstListCollectionVC:CreateFirstListCollectionVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc  func handleTextChanged()  {
        placeHolderLabel.isHidden = textView.text.count != 0
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //for avoiding retain cycle
    }
    
    
    override func setupViews() {
        titleLabel.constrainHeight(constant: 30)
        counttitleLabel.isHide(true)
        backgroundColor = .white
        
        [titleLabel,counttitleLabel,placeHolderLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        mainView.addSubViews(views: textView,placeHolderLabel)
        textView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        placeHolderLabel.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        let second = stack(titleLabel,mainView,counttitleLabel,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 32, bottom: 0, right: 8))
        
    }
    
    //
    @objc func handleShowViews()  {
        self.showHidingViews(views: counttitleLabel,mainView, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3930"), seperator: seperatorView)
        self.createFirstListCollectionVC?.is1CellIsOpen=true
        self.createFirstListCollectionVC?.collectionView.reloadData()
    }
    
    
}


extension FirstCreatePostCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        mainView.layer.borderColor = UIColor.black.cgColor
        guard var texts = textView.text else { return  }
        titleString = texts
        
        if  texts.count == 0 {
            handleTextContents?(titleString,false)
        }
        else {
            titleString = texts
            handleTextContents?(titleString,true)
        }
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        let maxString = min( numberOfChars,50)
        counttitleLabel.text = "\(50-maxString) letter"
        return numberOfChars < 50    // 10 Limit Value
    }
    
}
