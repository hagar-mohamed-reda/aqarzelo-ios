//
//  AqarDetailInfoCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class AqarDetailInfoCell: BaseCollectionCell {
    
  
   let aqarDetailInfoView = AqarDetailInfoView()
    
    
       override func setupViews()  {
            backgroundColor = .white
            stack(aqarDetailInfoView)
        }
}
