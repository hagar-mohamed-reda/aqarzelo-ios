//
//  SecondCreateAddressCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class SecondCreateAddressCell: BaseCollectionCell {
    
    var categroy_id:Int? {
        didSet{
            guard let categroy_id = categroy_id else { return  }
            let x = categroy_id == 4 ? true : false
            
            if x {
               ss =  stack(iconImageView,UIView(),alignment:.center)
            }else {
                ss =  stack(iconImageView,seperatorView,alignment:.center)
            }
            setupViews()
        }
    }
    
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3940")
            iconImageView.isUserInteractionEnabled = true
            textView.text = aqar.address
            handleTextChanged()
            counttitleLabel.text = "\(textView.text.count) "+"letter".localized
            handleTextContents?(textView.text!,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3948"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    lazy var titleLabel = UILabel(text: "Address".localized, font: .systemFont(ofSize: 20), textColor: .black,textAlignment: MOLHLanguage.isRTLLanguage() ? .right : .left)
    lazy var textView:UITextView = {
        let tx = UITextView()
        tx.addSubview(placeHolderLabel)
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        tx.isHide(true)
        tx.delegate = self
        tx.sizeToFit()
        return tx
    }()
    lazy var counttitleLabel = UILabel(text: "30 letter", font: .systemFont(ofSize: 16), textColor: .lightGray,textAlignment: .right)
    lazy var placeHolderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 16), textColor: .lightGray)
    lazy var categoryQuestionLabel:UILabel =  {
        let l = UILabel(text: "Write down the property address\nin detail", font: .systemFont(ofSize: 14), textColor: .lightGray)
        l.isHide(true)
        //        l.constrainHeight(constant: 20)
        return l
    }()
    lazy var ss = UIStackView()//stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
    var addressString:String = ""
    
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((String?,Bool)->Void)?
    weak var createSecondListCollectionVC:CreateSecondListCollectionVC?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        counttitleLabel.isHide(true)
        backgroundColor = .white
        
        let second = stack(titleLabel,categoryQuestionLabel,textView,counttitleLabel,UIView(),spacing:8)
        placeHolderLabel.anchor(top: textView.topAnchor, leading: textView.leadingAnchor, bottom: textView.bottomAnchor, trailing: nil)
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
        
    }
    
    @objc  func handleTextChanged()  {
        placeHolderLabel.isHidden = textView.text.count != 0
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //for avoiding retain cycle
    }
    
    //
    @objc func handleShowViews()  {
        if self.createSecondListCollectionVC?.is3CellIsError == false {
            self.createSecondListCollectionVC?.creatMainSnackBar(message: "Area Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: counttitleLabel,textView,counttitleLabel,categoryQuestionLabel, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3940"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
}



extension SecondCreateAddressCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard var texts = textView.text else { return  }
        addressString = texts
        
        if  texts.count == 0 {
            handleTextContents?(addressString,false)
        }
        else {
            addressString = texts
            handleTextContents?(addressString,true)
        }
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        
        let maxString = min( numberOfChars,30)
        counttitleLabel.text = "\(30-maxString) letter"
        return numberOfChars < 30    // 10 Limit Value
    }
    
}
