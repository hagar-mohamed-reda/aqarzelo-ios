//
//  CustomTopView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit


protocol CustomTopViewProtocolol {
    func openOne()
    func openSecond()
    func openThird()
}

class CustomTopView: UIView {
    
    
    var aqar:AqarModel? {
        didSet{
            //            [first3View,firstView,first2View].forEach({$0.isUserInteractionEnabled = true})
        }
    }
    
    var openFirst:Bool?{
        didSet{
            guard let openFirst = openFirst else { return  }
            firstView.isUserInteractionEnabled = openFirst ?  true : false
            first3View.isUserInteractionEnabled = openThird ?? false
        }
    }
    
    var openSecond:Bool?{
        didSet{
            guard let openSecond = openSecond else { return  }
            first2View.isUserInteractionEnabled = openSecond ?  true : false
        }
    }
    
    var openThird:Bool?{
        didSet{
            guard let openThird = openThird else { return  }
            first2View.isUserInteractionEnabled = true
            firstView.isUserInteractionEnabled = true
            first3View.isUserInteractionEnabled = openThird ?  true : false
        }
    }
    
    
    
    var handleOpenOnes:(()->Void)?
    var handleOpenSec:(()->Void)?
    var handleOpenThird:(()->Void)?
    var delgate:CustomTopViewProtocolol?
    
    lazy var first1Image:UIImageView = {
        let i = UIImageView(image:UIImage(named: "11"))
        //        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenOnth)))
        i.isHide(false)
        i.isUserInteractionEnabled = false
        return i
    }()
    lazy var first21Image:UIImageView = {
        let i = UIImageView(image:UIImage(named: "22"))
        //        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenSecond)))
        //        i.isHide(true)
        i.isUserInteractionEnabled = false
        return i
    }()
    lazy var first31Image:UIImageView = {
        let i = UIImageView(image: UIImage(named: "33"))
        //        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector( handleOpenthird)))
        //        i.isHide(true)
        i.isUserInteractionEnabled = false
        return i
    }()
    
    lazy var firstView:UIView = {
        let i = UIView(backgroundColor: ColorConstant.mainBackgroundColor)
        i.layer.cornerRadius = 16
        i.clipsToBounds = true
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenOnth)))
        i.isHide(false)
        i.addSubview(first1Image)
        //        i.isUserInteractionEnabled = false
        return i
    }()
    lazy var first2View:UIView = {
        let i = UIView(backgroundColor: #colorLiteral(red: 0.9283686876, green: 0.9285209179, blue: 0.9283363223, alpha: 1))
        i.layer.cornerRadius = 16
        i.clipsToBounds = true
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenSecond)))
        //        i.isHide(true)
        i.isUserInteractionEnabled = false
        i.addSubview(first21Image)
        return i
    }()
    lazy var first3View:UIView = {
        let i = UIView(backgroundColor: #colorLiteral(red: 0.9283686876, green: 0.9285209179, blue: 0.9283363223, alpha: 1))
        i.layer.cornerRadius = 16
        i.clipsToBounds = true
        i.isUserInteractionEnabled = false
        i.addSubview(first31Image)
        i.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector( handleOpenthird)))
        return i
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        [first3View,firstView,first2View].forEach({$0.isUserInteractionEnabled = false})
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .white
        let ss = getStack(views: firstView,first2View,first3View, spacing: -8, distribution: .fillEqually, axis: .horizontal)
        addSubview(ss)
        ss.fillSuperview()
        [first1Image,first21Image,first31Image].forEach({$0.centerInSuperview()})
        
        
    }
    
    @objc func handleOpenOnth()  {
        //        handleOpenOnes?()
        first3View.backgroundColor = #colorLiteral(red: 0.9283686876, green: 0.9285209179, blue: 0.9283363223, alpha: 1)
        first2View.backgroundColor = #colorLiteral(red: 0.9283686876, green: 0.9285209179, blue: 0.9283363223, alpha: 1)
        first21Image.image =  UIImage(named: "22")
        first31Image.image =  UIImage(named: "33")
        delgate?.openOne()
    }
    
    @objc func handleOpenSecond()  {
        //        handleOpenSec?()
        first2View.backgroundColor = ColorConstant.mainBackgroundColor
        first3View.backgroundColor = #colorLiteral(red: 0.9283686876, green: 0.9285209179, blue: 0.9283363223, alpha: 1)
        
        first21Image.image =  UIImage(named: "221")
        first31Image.image =  UIImage(named: "33")
        delgate?.openSecond()
    }
    
    @objc func handleOpenthird()  {
        //        handleOpenThird?()
        first3View.backgroundColor = ColorConstant.mainBackgroundColor
        first2View.backgroundColor = ColorConstant.mainBackgroundColor
        first21Image.image =  UIImage(named: "221")
        first31Image.image =  UIImage(named: "331")
        delgate?.openThird()
    }
    
}
