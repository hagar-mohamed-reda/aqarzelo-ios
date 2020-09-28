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
    
    lazy var logoImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "يبير"))
        i.constrainHeight(constant: 128)
        i.constrainWidth(constant: 101)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.spin(duration: 2.0)
        return i
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
//        let ind = MyIndicator(frame: CGRect(x: 0, y: 0, width: 100, height: 100), image: #imageLiteral(resourceName: "يبير"))
//        view.addSubview(ind)
//        ind.startAnimating()
//        view.addSubview(logoImageView)
//
//        logoImageView.centerInSuperview()
    }
    
    @objc  func handleDismiss()  {
        dismiss(animated: true)
    }
    
   
}
