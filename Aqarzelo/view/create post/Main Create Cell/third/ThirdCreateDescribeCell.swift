//
//  ThirdCreateDescribeCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class ThirdCreateDescribeCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3957")
            iconImageView.isUserInteractionEnabled = true
            textView.text = aqar.datumDescription
            handleTextChanged()
            counttitleLabel.text = "\(textView.text.count) "+"letter".localized
            handleTextContents?(textView.text!,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3953"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var titleLabel = UILabel(text: "Describe".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var textView:UITextView = {
        let tx = UITextView()
        //        tx.addSubview(placeHolderLabel)
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        //        tx.isHide(true)
        tx.delegate = self
        tx.sizeToFit()
        return tx
    }()
    lazy var mainView:UIView = {
        let l = UIView(backgroundColor: .white)
        l.layer.cornerRadius = 8
        l.layer.borderWidth = 1
        l.layer.borderColor = #colorLiteral(red: 0.4835817814, green: 0.4836651683, blue: 0.4835640788, alpha: 1).cgColor
        l.constrainWidth(constant: frame.width - 126)
        l.isHide(true)
        
        return l
    }()
    lazy var counttitleLabel = UILabel(text: "0 / 250".localized, font: .systemFont(ofSize: 16), textColor: .lightGray,textAlignment: .right)
    lazy var placeHolderLabel = UILabel(text: "Enter Text".localized, font: .systemFont(ofSize: 16), textColor: .lightGray)
    
    var index:Int!
    var handleTextContents:((String?,Bool)->Void)?
    var handleHidePreviousCell:((Int)->Void)?
    weak var createThirddListCollectionVC:CreateThirddListCollectionVC?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        backgroundColor = .white
        titleLabel.constrainHeight(constant: 30)
        counttitleLabel.isHide(true)
        mainView.addSubViews(views: textView,placeHolderLabel)
        textView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        placeHolderLabel.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        let second = stack(titleLabel,mainView,counttitleLabel,UIView(),spacing:8)
        
        textView.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left
        
        [titleLabel,counttitleLabel,placeHolderLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 20, bottom: 0, right: 8))
        
        
    }
    
    @objc  func handleTextChanged()  {
        placeHolderLabel.isHidden = textView.text.count != 0
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //for avoiding retain cycle
    }
    
    //
    @objc func handleShowViews()  {
        
        showHidingViews(views: mainView,counttitleLabel, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3957"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
    
    var discribeString:String = ""
    
    
}



extension ThirdCreateDescribeCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        mainView.layer.borderColor = ColorConstant.mainBackgroundColor.cgColor
        guard var texts = textView.text else { return  }
        discribeString = texts
        
        if  texts.count == 0 {
            handleTextContents?(discribeString,false)
        }
        else {
            discribeString = texts
            handleTextContents?(discribeString,true)
        }
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        let maxString = min( numberOfChars,250)
        counttitleLabel.text = "\(250-maxString) / 250"
        return numberOfChars < 250    // 10 Limit Value
    }
    
}

