//
//  CustomStarViews.swift
//  Aqarzelo
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class  CustomStarViews: CustomBaseView {
    
    lazy var centerImageView:UIImageView = {
        let i = UIImageView(image:  UIImage(named: "house"))
        i.contentMode = .scaleToFill
       i.constrainWidth(constant: 100)
        i.constrainHeight(constant: 100)
        i.clipsToBounds = true
        return i
    }()
    
    lazy var doneButton:UIButton = {
        let b = UIButton()
        b.setTitle("Done".localized, for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1)
        b.constrainHeight(constant: 40)
        b.constrainWidth(constant: 100)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.borderWidth = 4
        b.layer.borderColor = #colorLiteral(red: 0.2100089788, green: 0.8682586551, blue: 0.7271742225, alpha: 1).cgColor
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    
    lazy var closeImageView:UIImageView = {
        let i = UIImageView(image: UIImage(named: "×-1")?.withRenderingMode(.alwaysOriginal))
        i.constrainWidth(constant: 20)
        i.constrainHeight(constant: 20)
        i.clipsToBounds = true
        i.isUserInteractionEnabled = true
        return i
    }()
    lazy var mainView:UIView = {
        let v = UIView(backgroundColor: .white)
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.gray.cgColor
        return v
    }()
    lazy var subView:UIView = {
        let v =  UIView(backgroundColor: .clear)
        return v
    }()
    lazy var mainStackView = getStack(views: firstBtn,first2Btn,first3Btn,first4Btn,first5Btn, spacing: 8, distribution: .fillEqually, axis: .horizontal)
    lazy var firstBtn = getButtons(img: #imageLiteral(resourceName: "star2") , tags: 1)
    lazy var first2Btn = getButtons(img: #imageLiteral(resourceName: "star2") , tags: 2)
    lazy var first3Btn = getButtons(img: #imageLiteral(resourceName: "star2") , tags: 3)
    lazy var first4Btn = getButtons(img: #imageLiteral(resourceName: "star2") , tags: 4)
    lazy var first5Btn = getButtons(img: #imageLiteral(resourceName: "star2") , tags: 5)
    
    var rating:Int = 0
    var handleRateValue:((Int)->Void)?
    
    
    override func setupViews()  {
        mainStackView.constrainWidth(constant: frame.width - 32)
        
        addSubViews(views: mainView,subView,doneButton)
        //        addSubViews(views: mainView,doneButton)
        mainView.fillSuperview(padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        subView.addSubViews(views: closeImageView,centerImageView,mainStackView)
        
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
                            centerImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ])
        subView.anchor(top: mainView.topAnchor, leading: mainView.leadingAnchor, bottom: mainView.bottomAnchor, trailing: mainView.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 40, right: 0))
        
        //            centerImageView.centerInSuperview()
        centerImageView.anchor(top: closeImageView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        closeImageView.anchor(top: subView.topAnchor, leading: nil, bottom: nil, trailing: subView.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 16))
        mainStackView.anchor(top: centerImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        doneButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 16, bottom: -16, right: 16))
    }
    
    func getButtons(img:UIImage,tags:Int) -> UIButton {
        let bt = UIButton()
        bt.setBackgroundImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
        bt.tag = tags
        bt.constrainHeight(constant: 30)
        bt.addTarget(self, action: #selector(handleFFF), for: .touchUpInside)
        return bt
    }
    
    @objc func handleFFF(sender:UIButton)  {
        let starButtons = [firstBtn,first2Btn,first3Btn,first4Btn,first5Btn]
        
        self.rating = sender.tag
        
        let ff = sender.tag
        
        let xxxx = ff == 1 ? "house" : ff == 2 ? "house2" : ff == 3 ? "house3" : ff == 4 ? "house4" : "house5"
        
        for  button in starButtons {
            let x = button.tag <= sender.tag
            
            makeAnimation(x: x, bbb: button, imgName: xxxx)
        }
    }
    
    func makeAnimation(x:Bool,bbb:UIButton,imgName:String)  {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            bbb.setBackgroundImage(x ? #imageLiteral(resourceName: "star2") : #imageLiteral(resourceName: "star2").withRenderingMode(.alwaysTemplate), for: .normal)
            
            self.centerImageView.image = UIImage(named: imgName)
        })
    }
}

