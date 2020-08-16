//
//  AqarDetailAveragePriceCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import MOLH

class AqarDetailAveragePriceCell: BaseCollectionCell {
    
    var chart:String?{
        didSet{
            guard let chart = chart else { return }

           aqarTitleLabel.text = chart
        }
    }
    
    var chartValue:Double?{
        didSet{
            guard let chartValue = chartValue else { return }

            aqarPriceLabel.text = String(describing: chartValue)
        }
    }
    
    
     lazy var aqarTitleLabel = UILabel(text: "Nasr city", font: .systemFont(ofSize: 16), textColor: .black )
     lazy var aqarPriceLabel = UILabel(text: "12000 K", font: .systemFont(ofSize: 16), textColor: .black )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
//        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 9, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        layer.cornerRadius = 8
        clipsToBounds = true
        
        [aqarPriceLabel,aqarTitleLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        
        hstack(aqarTitleLabel,aqarPriceLabel,alignment:.center).withMargins(.init(top: 8, left: 8, bottom: 8, right: 8))
    }
}
