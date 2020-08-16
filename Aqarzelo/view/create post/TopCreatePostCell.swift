//
//  TopCreatePostCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class TopCreatePostCell: BaseCollectionCell {
    
    var isCellSelected = true
    
    
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Ellipse 11"))
        i.isUserInteractionEnabled = true
//                i.contentMode = .scaleAspectFit
        i.constrainWidth(constant: 30)
        i.constrainHeight(constant: 30)
        
        i.clipsToBounds = true
        return i
    }()
    lazy var mainView:UIView = {
       let v = UIView(backgroundColor: #colorLiteral(red: 0.2710898221, green: 0.868608892, blue: 0.7246435285, alpha: 1))
        v.addSubview(mainImageView)
        v.layer.cornerRadius = 28
        
        v.clipsToBounds = true
        v.layer.borderWidth = 1
        v.layer.borderColor = #colorLiteral(red: 0.1964736879, green: 0.8228260875, blue: 0.6873770356, alpha: 1).cgColor
        return v
    }()
    lazy var numberLabel = UILabel(text: "1", font: .systemFont(ofSize: 16), textColor: .black )
    
    override func setupViews() {
       
        backgroundColor = #colorLiteral(red: 0.2710898221, green: 0.868608892, blue: 0.7246435285, alpha: 1)
        
        
        addSubview(mainView)
        mainView.fillSuperview()
        mainImageView.centerInSuperview()
        
        mainImageView.addSubview(numberLabel)
        
    numberLabel.centerInSuperview()
    }
    
    func configureCell(selected:Bool,index:Int)  {
        if !selected {
             mainView.backgroundColor = #colorLiteral(red: 0.9352378249, green: 0.9353721738, blue: 0.9352084994, alpha: 1)
//             backgroundColor = #colorLiteral(red: 0.9352378249, green: 0.9353721738, blue: 0.9352084994, alpha: 1)
            mainImageView.image = #imageLiteral(resourceName: "Ellipse 88")
            numberLabel.textColor = .white
            numberLabel.text = String(index+1)
        }else {
             mainView.backgroundColor = #colorLiteral(red: 0.2710898221, green: 0.868608892, blue: 0.7246435285, alpha: 1)
             numberLabel.text = String(index+1)
//            backgroundColor = #colorLiteral(red: 0.2710898221, green: 0.868608892, blue: 0.7246435285, alpha: 1)
        }
    }
    
}
