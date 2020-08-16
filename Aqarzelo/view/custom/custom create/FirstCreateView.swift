//
//  FirstCreateView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class FirstCreateView: UIView {
    
    var isSelected:Bool = false
    
    lazy var titleImageView:UIImageView = {
       let i = UIImageView(image: #imageLiteral(resourceName: "Group 3926"))
        
        return i
    }()
    
    lazy var seperatorView:[UIView] = {
        var vv = [UIView ]()
        (0...5).forEach({ (_) in
            let v = UIView(backgroundColor: .green)
            v.constrainWidth(constant: 1)
           
            vv.append(v)
        })
        return vv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .white
    }
}
