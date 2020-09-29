//
//  BaseCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/15/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class BaseCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        setupNavigation()
    }
    
    func setupNavigation()  {
        
    }
    
    func setupCollection()  {
        
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
