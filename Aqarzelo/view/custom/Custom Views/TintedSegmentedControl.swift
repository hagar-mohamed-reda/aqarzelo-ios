//
//  TintedSegmentedControl.swift
//  Aqarzelo
//
//  Created by Hossam on 9/1/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class TintedSegmentedControl: UISegmentedControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 13.0, *) {
            setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            selectedSegmentTintColor = #colorLiteral(red: 0.4747212529, green: 0.2048208416, blue: 1, alpha: 1)
        } else {
            tintColor = UIColor.blue
        }
    }
}
