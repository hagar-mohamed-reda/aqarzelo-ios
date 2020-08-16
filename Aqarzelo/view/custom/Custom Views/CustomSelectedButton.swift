//
//  CustomSelectedButton.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CustomSelectedButton: UIButton {
    override var isSelected: Bool {
        
        willSet {
            
            self.setImage(#imageLiteral(resourceName: "Rectangle 159"), for: .normal)
        }
        
        didSet {
            self.setImage(#imageLiteral(resourceName: "Rectangle 155-1"), for: .normal)
        }
    }
}
