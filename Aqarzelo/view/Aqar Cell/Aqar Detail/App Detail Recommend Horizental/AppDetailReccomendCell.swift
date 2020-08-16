//
//  AppDetailReccomendCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class AppDetailReccomendCell: BaseCollectionCell {
    
    let appDetailRecommendHorizentalVC = AppDetailRecommendHorizentalCollectionVC()
    
    
    override func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
        setupShadow()
        stack(appDetailRecommendHorizentalVC.view).withMargins(.init(top: 0, left: 0, bottom: 0, right: 0))
    }
}
