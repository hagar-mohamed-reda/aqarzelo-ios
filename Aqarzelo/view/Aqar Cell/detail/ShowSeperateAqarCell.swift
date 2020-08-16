//
//  ShowSeperateAqarCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import WebKit
//import CTPanoramaView

class ShowSeperateAqarCell: BaseCollectionCell {
    
    
    var img:ImageModel? {
        didSet{
            guard let img = img else { return }

            img.is360 == 1 ? load360Image() : loadNormalPhoto()
            
        }
    }
    
  
    lazy var mainWebView:WKWebView = {
        let v = WKWebView()
        v.uiDelegate = self
        v.isHide(true)
        return v
    }()
    lazy var mainImageView:UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "images (1)"))
        return i
    }()
//  let panaromaView = CTPanoramaView()

    
    
    override func setupViews() {
        backgroundColor = .white
       stack(mainImageView)
        stack(mainWebView)
    }
    
    func load360Image()  {
        
//        guard let img = img ,let url = URL(string: img.image) else { return  }
//              mainImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "58889593bc2fc2ef3a1860c1"))
//
//              mainImageView.isHide(false)
//
//              panaromaView.image=mainImageView.image ?? #imageLiteral(resourceName: "58889593bc2fc2ef3a1860c1")
        
        
        mainWebView.isHide(false)
        mainImageView.isHide(true)
        guard let img = img else { return }

        let ss = img.image.toSecrueHttps()
        guard let myURL = URL(string:"https://aqarzelo.com/public/panorama?image=\(ss)".toSecrueHttps()) else {return}
        let myRequest = URLRequest(url: myURL)
        mainWebView.load(myRequest)
    }
    
    func loadNormalPhoto()  {
        guard let img=img, let url = URL(string: img.image) else { return  }
        mainImageView.sd_setImage(with: url,placeholderImage: #imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))
        mainWebView.isHide(true)
        mainImageView.isHide(false)
    }
}

extension ShowSeperateAqarCell: WKUIDelegate {
    
}
