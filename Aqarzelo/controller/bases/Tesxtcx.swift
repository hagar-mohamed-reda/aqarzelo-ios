//
//  Tesxtcx.swift
//  Aqarzelo
//
//  Created by Hossam on 9/20/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD
import NaturalLanguage
import MOLH

class Tesxtcx: UIViewController {
    
    
    
    lazy var asd = UILabel(text: "cutomtopView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 60, left: 0, bottom: 0, right: 0)) let ind = MyIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), image: #imageLiteral(resourceName: ))  view.addSubview(ind)  ind.startAnimating()  view.addSubview(logoImageView) logoImageView.centerInSuperview()", font: .systemFont(ofSize: 25), textColor: .black,numberOfLines: 0)
    
    lazy var ddd:ASD = {
       let t = ASD()
        t.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        t.modalTransitionStyle = .crossDissolve
        t.modalPresentationStyle = .overCurrentContext
        return t
    }()
    lazy var customAlerLoginView:CustomAlertForLoginView = {
        let v = CustomAlertForLoginView()
        v.setupAnimation(name: "4970-unapproved-cross")
        
//        v.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
//        v.signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return v
    }()
    lazy var textView:UITextView = {
        let tx = UITextView()
        tx.isScrollEnabled = false
        tx.font = UIFont.systemFont(ofSize: 16)
        //        tx.isHide(true)
        tx.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left
        tx.delegate = self
        tx.sizeToFit()
        return tx
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
       detectedLanguage(for: "asdfsafsaf")
        view.addSubview(textView)
        
        textView.centerInSuperview(size: .init(width: view.frame.width-64, height: 60))
//        ddd.addCustomViewInCenter(views: customAlerLoginView, height: 200)
//        self.customAlerLoginView.problemsView.play()
//
//        self.customAlerLoginView.problemsView.loopMode = .loop
//        present(ddd, animated: true)
    }
    
    func detectedLanguage(for string: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLanguage = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLanguage
    }

//    func detectLanguage<T: StringProtocol>(for text: T) -> String? {
//        let tagger = NSLinguisticTagger.init(tagSchemes: [.language], options: 0)
//        tagger.string = String(text)
//
//        guard let languageCode = tagger.tag(at: 0, scheme: .language, tokenRange: nil, sentenceRange: nil) else { return nil }
//        return Locale.current.localizedString(forIdentifier: languageCode)
//    }
    
    @objc fileprivate func handleDismiss()  {
        removeViewWithAnimation(vvv: customAlerLoginView)
        dismiss(animated: true, completion: nil)
    }
    
   
}

class ASD: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.alpha = 0.5
    }
}

extension Tesxtcx: UITextViewDelegate {
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let point = Locale.current.decimalSeparator!
        let decSep = Locale.current.groupingSeparator!
        
        
        let textss = textView.text!
        let textRange = Range(range, in: textss)!
        
        var fractionLength = 0
        var isRangeUpperPoint = false
        
        if let startPoint = textss.lastIndex(of: point.first!) {
            let end = textss.endIndex
            let str = String(textss[startPoint..<end])
            fractionLength = str.count
            isRangeUpperPoint = textRange.lowerBound >= startPoint
        }
        
        if  fractionLength == 3 && text != "" && isRangeUpperPoint {
            return false
        }
        
        let r = (textView.text! as NSString).range(of: point).location < range.location
        if (text == "0" || text == "") && r {
            return true
        }
        
        // First check whether the replacement string's numeric...
        let cs = NSCharacterSet(charactersIn: "0123456789\(point)").inverted
        let filtered = text.components(separatedBy: cs)
        let component = filtered.joined(separator: "")
        let isNumeric = text == component
        
        
        if isNumeric {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            
            let newString = textss.replacingCharacters(in: textRange,  with: text)
            
            
            let numberWithOutCommas = newString.replacingOccurrences(of: decSep, with: "")
            let number = formatter.number(from: numberWithOutCommas)
            if number != nil {
                var formattedString = formatter.string(from: number!)
                // If the last entry was a decimal or a zero after a decimal,
                // re-add it here because the formatter will naturally remove
                // it.
                if text == point && range.location == textView.text?.count {
                    formattedString = formattedString?.appending(point)
                }
                textView.text = formattedString
            } else {
                textView.text = nil
            }
        }
        return false
    }
   
//    func textView(_ textField: UITextView, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let point = Locale.current.decimalSeparator!
//           let decSep = Locale.current.groupingSeparator!
//
//
//           let text = textField.text!
//           let textRange = Range(range, in: text)!
//
//           var fractionLength = 0
//           var isRangeUpperPoint = false
//
//           if let startPoint = text.lastIndex(of: point.first!) {
//               let end = text.endIndex
//               let str = String(text[startPoint..<end])
//               fractionLength = str.count
//               isRangeUpperPoint = textRange.lowerBound >= startPoint
//           }
//
//           if  fractionLength == 3 && string != "" && isRangeUpperPoint {
//               return false
//           }
//
//           let r = (textField.text! as NSString).range(of: point).location < range.location
//           if (string == "0" || string == "") && r {
//               return true
//           }
//
//           // First check whether the replacement string's numeric...
//           let cs = NSCharacterSet(charactersIn: "0123456789\(point)").inverted
//           let filtered = string.components(separatedBy: cs)
//           let component = filtered.joined(separator: "")
//           let isNumeric = string == component
//
//
//           if isNumeric {
//               let formatter = NumberFormatter()
//               formatter.numberStyle = .decimal
//               formatter.maximumFractionDigits = 2
//
//               let newString = text.replacingCharacters(in: textRange,  with: string)
//
//
//               let numberWithOutCommas = newString.replacingOccurrences(of: decSep, with: "")
//               let number = formatter.number(from: numberWithOutCommas)
//               if number != nil {
//                   var formattedString = formatter.string(from: number!)
//                   // If the last entry was a decimal or a zero after a decimal,
//                   // re-add it here because the formatter will naturally remove
//                   // it.
//                   if string == point && range.location == textField.text?.count {
//                       formattedString = formattedString?.appending(point)
//                   }
//                   textField.text = formattedString
//               } else {
//                   textField.text = nil
//               }
//           }
//        return false
//    }
        //good solution
        
        //check if any numbers in the textField exist before editing
//        guard let textFieldHasText = (textField.text), !textFieldHasText.isEmpty else {
//            //early escape if nil
//            return true
//        }
//
//        let formatter = NumberFormatter()
//        formatter.numberStyle = NumberFormatter.Style.decimal
//        formatter.groupingSize = 3
//        formatter.groupingSeparator = ","
//        formatter.decimalSeparator = "."
////        formatter.decimalSeparator
//        formatter.maximumFractionDigits = 3
//        formatter.minimumFractionDigits = 3
////        formatter.minimumFractionDigits = 3
////        formatter.minimumFractionDigits = 3
//
//        //remove any existing commas
//        let textRemovedCommma = textFieldHasText.replacingOccurrences(of: ",", with: "")
//
//        //update the textField with commas
//        let formattedNum = formatter.string(from: NSNumber(value: Int(textRemovedCommma)!))
//        textField.text = formattedNum
//        return true

//        return false
//    }
    
}




