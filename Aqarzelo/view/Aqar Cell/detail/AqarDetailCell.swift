//
//  AqarDetailCell.swift
//  Aqarzelo
//
//  Created by Hossam on 8/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit
import SDWebImage
import WebKit
import MOLH
//import CTPanoramaView

class AqarDetailCell: BaseCollectionCell {
    
    var img:ImageModel? {
        didSet{
            guard let img = img else { return }
            img.is360  == 1 ? load360Image() : loadNormalPhoto()
            
            
        }
    }
    
    var aqar:AqarModel? {
        didSet{
            guard let aqar = aqar else { return }
            
            titleLabel.text = aqar.title
            let price = Int(aqar.price / 1000)
            let space = aqar.space
            
            priceLabel.text = "\(price) "+"EGY".localized
            distanceLabel.text = "\(space) "+"K".localized
            reviewLabel.text = "\(aqar.userReview.count) "+"Reviews".localized
            
            for(index,view) in starsStackView.arrangedSubviews.enumerated(){
                let ratingInt = Int(aqar.rate )
                view.alpha = index >= ratingInt ? 0 : 1
            }
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
        i.contentMode = .scaleAspectFill
        
        i.clipsToBounds = true
        return i
    }()
    lazy var titleLabel = UILabel(text: "Home", font: .systemFont(ofSize: 18), textColor: .white )
    lazy var priceLabel = UILabel(text: "10.000 EGY", font: .systemFont(ofSize: 16), textColor: .white )
    lazy var distanceLabel = UILabel(text: "23 M", font: .systemFont(ofSize: 20), textColor: .white )
    lazy var reviewLabel = UILabel(text: "24 reviews", font: .systemFont(ofSize: 14), textColor: .white,textAlignment: .left )
    lazy var rateButton = UIButton(title: "Rate", titleColor: ColorConstant.mainBackgroundColor, font: .systemFont(ofSize: 20), backgroundColor: .clear, target: self, action: #selector(handleRates))
    
    let starsStackView:UIStackView = {
        var arrangedViews = [ UIView]()
        (0..<5).forEach({ (_) in
            let im = UIImageView(image: #imageLiteral(resourceName: "star2"))
            im.constrainWidth(constant: 24)
            im.constrainHeight(constant: 24)
            arrangedViews.append(im)
        })
        arrangedViews.append(UIView())
        let stack = UIStackView(arrangedSubviews: arrangedViews)
        return stack
    }()
    //    let panaromaView = CTPanoramaView()
    
    
    override func setupViews() {
        backgroundColor = .white
        let leftStack = getStack(views: UIView(),titleLabel,priceLabel,distanceLabel, spacing: 8, distribution: .fill, axis: .vertical)
        [titleLabel,priceLabel,reviewLabel,distanceLabel].forEach({$0.textAlignment = MOLHLanguage.isRTLLanguage() ? .right : .left})
        let ss = MOLHLanguage.isRTLLanguage() ? getStack(views: rateButton,reviewLabel,UIView(), spacing: 8, distribution: .fill, axis: .horizontal) :  getStack(views: reviewLabel,rateButton,UIView(), spacing: 8, distribution: .fill, axis: .horizontal)
        
        addSubViews(views: mainImageView,mainWebView,leftStack,starsStackView,ss)//,reviewLabel,rateButton)
        
        mainImageView.fillSuperview()
        mainWebView.fillSuperview()
        //          backImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: 24, left: 32, bottom: 0, right: 0))
        //          logoImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,padding: .init(top: 24, left: 0, bottom: 0, right: 32))
        
        leftStack.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: .init(top: 0, left: 32, bottom: 48, right: 0))
        ss.anchor(top: starsStackView.bottomAnchor, leading: starsStackView.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 16, left: 0, bottom: 48, right: 0))
        starsStackView.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 74, right: 16))
    }
    
    func load360Image()  {
        mainWebView.isHide(false)
        mainImageView.isHide(true)
        
        guard let img = img else{return}
        let ss = img.image.toSecrueHttps()
        guard let myURL = URL(string:"https://aqarzelo.com/public/panorama?image=\(ss)".toSecrueHttps()) else {return}
        let myRequest = URLRequest(url: myURL)
        mainWebView.load(myRequest)
    }
    
    func loadNormalPhoto()  {
        
        guard  let img = img ,let url = URL(string: img.image) else { return  }
        mainImageView.sd_setImage(with: url,placeholderImage:#imageLiteral(resourceName: "Saratoga Farms 2403 _Ext_Rev_1200"))// #imageLiteral(resourceName: "58889593bc2fc2ef3a1860c1").withRenderingMode(.alwaysTemplate))
        mainWebView.isHide(true)
        mainImageView.isHide(false)
    }
    
    @objc  func handleRates()  {
        
    }
    
}

extension AqarDetailCell: WKUIDelegate {
    
}
