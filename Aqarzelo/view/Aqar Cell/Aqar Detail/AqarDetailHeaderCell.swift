//
//  AqarDetailHeaderCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class AqarDetailHeaderCell: UICollectionReusableView {
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return }

            contactNumber = "0115999999"//aqar.contactPhone
        }
    }
    
    lazy var titleLabel = UILabel(text: "", font: .systemFont(ofSize: 20), textColor: .black )
    lazy var sendButton:UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "Group 3923-1"), for: .normal)
        b.constrainWidth(constant: 40)
         b.isHide(true)
//        b.constrainHeight(constant: 50)
        return b
    }()
   
    
    var index = 0
    var contactNumber:String = "0"
    var handleMakeContactUser:((String)->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMakeContact)))
        setupViews()
    }
    
   
    
  fileprivate  func setupViews()  {
        backgroundColor = .white
        
        hstack(sendButton,titleLabel,spacing:16).withMargins(.init(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    @objc func handleMakeContact()  {
        index == 2 ?  handleMakeContactUser?(contactNumber) : ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
