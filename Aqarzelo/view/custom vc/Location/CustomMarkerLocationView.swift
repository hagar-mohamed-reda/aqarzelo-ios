//
//  CustomMarkerLocationView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CustomMarkerLocationView: CustomBaseView {
    
    var aqar:AqarModel? {
        didSet {
            guard let aqar = aqar else { return  }
            let km = aqar.price >= 1000000 ? "M".localized :  "K".localized
            let k = aqar.price >= 1000000 ? aqar.price / 1000000 : aqar.price / 1000
            distanceLabel.text = "\(k) "+"\(km)"
            distanceLabel.textAlignment = .center
        }
    }
   
    
    lazy var markerImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "Group 8"))
        i.contentMode = .scaleAspectFill
        i.clipsToBounds = true
        return i
    }()
    lazy var distanceLabel:UILabel = {
        let l = UILabel(text: "", font: .systemFont(ofSize: 18), textColor: .black)
     l.backgroundColor = .lightGray
        l.layer.cornerRadius = 8
        l.clipsToBounds = true
        return l
    }()
    
    override func setupViews() {
       
        stack(markerImageView,distanceLabel)
    }
}
