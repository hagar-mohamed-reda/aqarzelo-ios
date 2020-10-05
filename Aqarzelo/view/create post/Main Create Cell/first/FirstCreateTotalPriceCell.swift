//
//  FirstCreateTotalPriceCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField
import MOLH

class FirstCreateTotalPriceCell: BaseCollectionCell {
    
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3933")
            iconImageView.isUserInteractionEnabled = true
            textView.text = "\(aqar.price)"
            handleTextContents?(Int(aqar.price) ?? aqar.pricePerMeter.toInt() ?? 100,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3929"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    
    lazy var categoryLabel = UILabel(text: "Price".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
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
        tx.keyboardType = .numberPad
        tx.font = UIFont.systemFont(ofSize: 16)
        //        tx.isHide(true)
        tx.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left
        tx.delegate = self
        tx.sizeToFit()
        
//        tx.addTarget(self, action:#selector(textFieldValDidChange), for: .editingChanged)
        return tx
    }()
    
    lazy var placeHolderLabel = UILabel(text: "Enter Message".localized, font: .systemFont(ofSize: 16), textColor: .lightGray)
    lazy var priceLabel = UILabel(text: "Total Price".localized, font: .systemFont(ofSize: 20), textColor: .black)
    
    
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
        
        let ss = stack(iconImageView,UIView(),alignment:.center)//,distribution:.fill
        mainView.addSubViews(views: textView,placeHolderLabel)
        textView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        placeHolderLabel.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        let second = stack(categoryLabel,mainView,priceLabel,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 32, bottom: 0, right: 8))
        
    }
    
    @objc func handleShowViews()  {
        if self.createFirstListCollectionVC?.is8CellIsError == false {
            self.createFirstListCollectionVC?.creatMainSnackBar(message: "Price Per Meter Should Be Filled First...".localized)
            return
        }
        showHidingViewsWithoutSepertor(views: mainView,priceLabel, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3933"))
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
    
    @objc func textFieldValDidChange(_ textField: UITextField) {
       let formatter = NumberFormatter()
       formatter.numberStyle = NumberFormatter.Style.decimal
       if textField.text!.count >= 1 {
//          let number = Double(bottomView.balanceTxtField.text!.replacingOccurrences(of: ",", with: ""))
//           let result = formatter.string(from: NSNumber(value: number!))
//           textField.text = result!
       }
   }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //for avoiding retain cycle
    }
    
}



extension FirstCreateTotalPriceCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        mainView.layer.borderColor = UIColor.black.cgColor
        guard var texts = textView.text,let xx=texts.toInt() else { return  }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:xx))
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
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//            if ((string == "0" || string == "") && (textField.text! as NSString).range(of: ".").location < range.location) {
//                return true
//            }
//
//            // First check whether the replacement string's numeric...
//            let cs = NSCharacterSet(charactersIn: "0123456789.").inverted
//            let filtered = string.components(separatedBy: cs)
//            let component = filtered.joined(separator: "")
//            let isNumeric = string == component
//
//            // Then if the replacement string's numeric, or if it's
//            // a backspace, or if it's a decimal point and the text
//            // field doesn't already contain a decimal point,
//            // reformat the new complete number using
//            if isNumeric {
//                let formatter = NumberFormatter()
//                formatter.numberStyle = .decimal
//                formatter.maximumFractionDigits = 8
//                // Combine the new text with the old; then remove any
//                // commas from the textField before formatting
//                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//                let numberWithOutCommas = newString.replacingOccurrences(of: ",", with: "")
//                let number = formatter.number(from: numberWithOutCommas)
//                if number != nil {
//                    var formattedString = formatter.string(from: number!)
//                    // If the last entry was a decimal or a zero after a decimal,
//                    // re-add it here because the formatter will naturally remove
//                    // it.
//                    if string == "." && range.location == textField.text?.count {
//                        formattedString = formattedString?.appending(".")
//                    }
//                    textField.text = formattedString
//                } else {
//                    textField.text = nil
//                }
//            }
//            return false
//    }
   
}
    
