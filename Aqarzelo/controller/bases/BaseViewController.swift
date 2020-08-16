//
//  BaseViewController.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
    }
    
    func setupViews()  {
        view.backgroundColor = ColorConstant.mainBackgroundColor
    }
    
    func setupNavigation()  {
       
    }
}
