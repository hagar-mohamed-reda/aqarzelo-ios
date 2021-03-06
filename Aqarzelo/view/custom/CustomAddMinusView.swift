//
//  CustomAddMinusView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CustomAddMinusView: UIView {
    
    var count:Int = 0
    
    
    lazy var plusImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "plus"))// #imageLiteral(resourceName: "+"))
        im.isUserInteractionEnabled = true
        im.contentMode = .scaleAspectFit
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddOne)))
        im.clipsToBounds = true
        im.constrainWidth(constant: 30)
//        im.constrainWidth(constant: 10)

        return im
    }()
    
    lazy var background2ImageView:UIView = {
       let v = UIView(backgroundColor: #colorLiteral(red: 0.4343734086, green: 0.8606870174, blue: 0.7011793256, alpha: 1))
//        v.constrainWidth(constant: 60)
        v.constrainHeight(constant: 60)
        v.layer.cornerRadius = 30
        v.clipsToBounds=true
        return v
    }()
    
//    lazy var background2ImageView:UIImageView = {
//        let im = UIImageView(image: UIImage(named: "Ellipse 10"))
////        im.constrainHeight(constant: 50)
//
//                im.constrainHeight(constant: 60)
////               im.constrainWidth(constant: 60)
////        im.contentMode = .scaleToFill
////               im.clipsToBounds = true
////               im.layer.cornerRadius = dd/2
////               im.clipsToBounds=true
//        return im
//    }()
//    lazy var background2ImageView:UIView = {
//         let im = UIView(backgroundColor: #colorLiteral(red: 0.4343734086, green: 0.8606870174, blue: 0.7011793256, alpha: 1))
//        let dd = mainStack.frame.width/2
//         im.constrainHeight(constant: 50)
//        im.constrainWidth(constant: dd)
//        im.layer.cornerRadius = dd/2
//        im.clipsToBounds=true
//         return im
//     }()
    lazy var mainStack:UIStackView = {
        let d = getStack(views: minusImageView,background2ImageView,plusImageView, spacing: 0, distribution: .fill, axis: .horizontal)
//       let d =         hstack(minusImageView,background2ImageView,plusImageView,distribution:.fill).withMargins( .init(top: 0, left: 16, bottom: 0, right: 16))

        return d
    }()
    lazy var numberOfItemsLabel = UILabel(text: "\(count)", font: .systemFont(ofSize: 20), textColor: .white,textAlignment: .center)
    lazy var minusImageView:UIImageView = {
        let im = UIImageView(image:#imageLiteral(resourceName: "minus"))// #imageLiteral(resourceName: "-"))
        im.isUserInteractionEnabled = true
        im.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMinusOne)))
        im.clipsToBounds = true
        im.contentMode = .scaleAspectFit
        im.constrainWidth(constant: 30)
        return im
    }()
    
    var handleAddClousre:((Int)->Void)?
    var handleMinusClousre:((Int)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        background2ImageView.isUserInteractionEnabled = true
//        background2ImageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanned)))
        layer.cornerRadius = 24
        clipsToBounds = true
        setupViews()
    }
    
  
    
    func handleEnded(gesture:UIPanGestureRecognizer)  {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.plusImageView.isHide(false)
            self.minusImageView.isHide(false)
        })
    }
    
    func handelChanged(gesture:UIPanGestureRecognizer)  {
        let translationY = gesture.translation(in: self).y
    
        if translationY > 0 {
           count += 1
            hideViewWithAnimation(view: plusImageView)
        }else if translationY < 0 {
            count = max( 0,count-1)
            hideViewWithAnimation(view: minusImageView)
        }
        
    }
    
    func hideViewWithAnimation(view:UIView)  {
        
        numberOfItemsLabel.text = "\(count)"
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            view.isHide(true)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = #colorLiteral(red: 0.9591651559, green: 0.9593221545, blue: 0.9591317773, alpha: 1)
        background2ImageView.addSubview(numberOfItemsLabel)
        [plusImageView,minusImageView].forEach({$0.constrainWidth(constant: 30)})
//        hstack(minusImageView,background2ImageView,plusImageView,distribution:.fill).withMargins( .init(top: 0, left: 16, bottom: 0, right: 16))
        hstack(minusImageView,background2ImageView,plusImageView,spacing:8,distribution:.fill).withMargins( .init(top: 0, left: 16, bottom: 0, right: 16))
//        addSubview(mainStack)
//        mainStack.fillSuperview()
        numberOfItemsLabel.centerInSuperview()
    }
    
    @objc func handleAddOne()  {
        count += 1
        numberOfItemsLabel.text = "\(count)"
        handleAddClousre?(count)
    }
    
    @objc func handlePanned(gesture:UIPanGestureRecognizer)  {
       let translationY = gesture.translation(in: self).y
       print(translationY)
       switch gesture.state {
       case .changed:
           handelChanged(gesture: gesture)
       case .ended:
          handleEnded(gesture: gesture)
       default:
       ()
       }
       }
    
    @objc func handleMinusOne()  {
        count = max( 0,count-1)
        numberOfItemsLabel.text = "\(count)"
        handleMinusClousre?(count)
    }
}
