//
//  FirstCreatePriceCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import MOLH

class FirstCreatePriceCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3933")
            iconImageView.isUserInteractionEnabled = true
            //            mainView.isHide(false)
            textView.text = aqar.pricePerMeter
            handleTextContents?(Int(aqar.pricePerMeter) ?? 0,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3929"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    
    lazy var categoryLabel = UILabel(text: "Price Per Meter".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    lazy var mainView:UIView = {
        let l = UIView(backgroundColor: .white)
        l.layer.cornerRadius = 8
        l.layer.borderWidth = 1
        l.layer.borderColor = #colorLiteral(red: 0.4835817814, green: 0.4836651683, blue: 0.4835640788, alpha: 1).cgColor
        l.constrainWidth(constant: frame.width - 126)
        l.isHide(true)
        return l
    }()
    lazy var textView:UITextView = {
        let tx = UITextView()
        tx.addSubview(placeHolderLabel)
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        tx.keyboardType = .numberPad
        //        tx.isHide(true)
        tx.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left
        tx.delegate = self
        tx.sizeToFit()
        return tx
    }()
    
    lazy var placeHolderLabel = UILabel(text: "Enter Message".localized, font: .systemFont(ofSize: 16), textColor: .lightGray)
    lazy var priceLabel = UILabel(text: "Per meter".localized, font: .systemFont(ofSize: 20), textColor: .black)
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    
    var handleTextContents:((Int,Bool)->Void)?
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var priceString:String!
    weak var createFirstListCollectionVC:CreateFirstListCollectionVC?
    
    
    override func setupViews() {
        categoryLabel.constrainHeight(constant: 30)
        priceLabel.isHide(true)
        backgroundColor = .white
        
        [categoryLabel,priceLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        let ss = stack(iconImageView,seperatorView,alignment:.center)//,distribution:.fill
        mainView.addSubViews(views: textView,placeHolderLabel)
        textView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        placeHolderLabel.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        let second = stack(categoryLabel,mainView,priceLabel,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 32, bottom: 0, right: 8))
        
    }
    @objc func handleShowViews()  {
        if self.createFirstListCollectionVC?.is7CellIsError == false {
            self.createFirstListCollectionVC?.creatMainSnackBar(message: "Bathrooms number Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: mainView,priceLabel, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3933"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
    
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
    
}



extension FirstCreatePriceCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        mainView.layer.borderColor = UIColor.black.cgColor
        guard var texts = textView.text else { return  }
        priceString = texts
        
        if  texts.count == 0 {
            handleTextContents?(Int(priceString) ?? 0,false)
        }
        else {
            priceString = texts
            handleTextContents?(Int(priceString) ?? 0,true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textFieldHasText = (textView.text), !textFieldHasText.isEmpty else {
            //early escape if nil
            return true
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal

        //remove any existing commas
        let textRemovedCommma = textFieldHasText.replacingOccurrences(of: ",", with: "")

        //update the textField with commas
        let formattedNum = formatter.string(from: NSNumber(value: Int(textRemovedCommma)!))
        textView.text = formattedNum
        return false
    }
}

