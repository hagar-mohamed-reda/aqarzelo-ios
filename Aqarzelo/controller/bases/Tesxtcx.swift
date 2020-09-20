//
//  Tesxtcx.swift
//  Aqarzelo
//
//  Created by Hossam on 9/20/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SVProgressHUD

class Tesxtcx: UIViewController {
    
    lazy var myActivityIndicator:UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        v.color = .red
        
        v.constrainHeight(constant: 60)
        v.constrainWidth(constant: 60)
        return v
    }()
    
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        progressHudProperties()
    }
}
