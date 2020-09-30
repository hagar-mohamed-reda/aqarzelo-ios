//
//  SecondCreateBuildDateCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class SecondCreateBuildDateCell: BaseCollectionCell {
    
    var categroy_id:Int? {
        didSet{
            guard let categroy_id = categroy_id else { return  }
            let x = categroy_id == 2 || categroy_id == 6 || categroy_id == 7 ? true : false
            
            if x {
                seperatorView.isHide(true)
               ss =  stack(iconImageView,UIView(),alignment:.center)
                setupViews()
            }else {
                seperatorView.isHide(false)
               ss =  stack(iconImageView,seperatorView,alignment:.center)
                setupViews()
            }
           
        }
    }
    var aqar:AqarModel?{
        didSet{
            guard let aqar = aqar else { return  }
            iconImageView.image = #imageLiteral(resourceName: "Group 3943")
            iconImageView.isUserInteractionEnabled = true
            dateTextField.text = aqar.buildDate
            handleTextContents?(aqar.buildDate,true)
        }
    }
    
    lazy var iconImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Group 3950"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowViews)))
        return im
    }()
    
    lazy var seperatorView:UIView = {
        let v = UIView(backgroundColor: .gray)
        v.constrainWidth(constant: 4)
        
        return v
    }()
    
    lazy var categoryLabel = UILabel(text: "Year of Building".localized, font: .systemFont(ofSize: 20), textColor: .black)
    lazy var questionLabel:UILabel = {
        let l = UILabel(text: "What is the creation date ?".localized, font: .systemFont(ofSize: 16), textColor: .black)
        //        l.constrainHeight(constant: 20)
        l.isHide(true)
        return l
    }()
    
    lazy var mainView:UIView = {
        let l = UIView(backgroundColor: .white)
        l.layer.cornerRadius = 8
        l.layer.borderWidth = 1
        l.layer.borderColor = #colorLiteral(red: 0.4835817814, green: 0.4836651683, blue: 0.4835640788, alpha: 1).cgColor
        l.constrainWidth(constant: frame.width - 126)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHide(true)
        return l
    }()
    lazy var dateTextField:UITextField = {
        let t = UITextField()
        t.placeholder = "enter date".localized
        t.isHide(true)
        t.textAlignment = .center
        t.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    lazy var ss = UIStackView()
    var index:Int!
    var handleHidePreviousCell:((Int)->Void)?
    var handleTextContents:((String?,Bool)->Void)?
    weak var createSecondListCollectionVC:CreateSecondListCollectionVC?
    
    override func setupViews() {
        backgroundColor = .white
        
        mainView.addSubview(dateTextField)
        dateTextField.centerInSuperview()
        let ddd = hstack(mainView,UIView())
        
        
        [questionLabel,categoryLabel].forEach{($0.textAlignment = MOLHLanguage.isRTLLanguage()  ? .right : .left)}
        
        
        let second = stack(categoryLabel,questionLabel,ddd,UIView(),spacing:8)
        
        hstack(ss,second,UIView(),spacing:16).withMargins(.init(top: 0, left: 36, bottom: 0, right: 8))
    }
    
    @objc func handleShowViews()  {
        if self.createSecondListCollectionVC?.is4CellIsError == false {
            self.createSecondListCollectionVC?.creatMainSnackBar(message: "Address Should Be Filled First...".localized)
            return
        }
        showHidingViews(views: questionLabel,mainView,dateTextField, imageView: iconImageView, image: #imageLiteral(resourceName: "Group 3942"), seperator: seperatorView)
        handleHidePreviousCell?(index)
    }
    
    @objc func tapDone(sender: Any, datePicker1: UIDatePicker) {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker { // 2.1
            datePicker.datePickerMode = UIDatePicker.Mode.date
            let dateformatter = DateFormatter() // 2.2
            dateformatter.setLocalizedDateFormatFromTemplate("yyyy")// 2.3
            self.dateTextField.text = dateformatter.string(from: datePicker.date) //2.4
            self.handleTextContents?(dateTextField.text ?? "",true)
        }
        self.dateTextField.resignFirstResponder() // 2.5
    }
}
