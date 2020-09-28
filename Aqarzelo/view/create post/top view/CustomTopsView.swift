////
////  CustomTopsView.swift
////  Aqarzelo
////
////  Created by Hossam on 9/28/20.
////  Copyright © 2020 Hossam. All rights reserved.
////
//
//import UIKit
//import SwiftUI
//
//class CustomTopsView: UIView {
//    
//    lazy var firstView:UIView = {
//       let v = UIView(backgroundColor: #colorLiteral(red: 0.4011510015, green: 0.8188247085, blue: 0.7169284225, alpha: 1))
//        v.isUserInteractionEnabled=true
//        v.layer.cornerRadius = 16
//        v.clipsToBounds=true
////        v.constrainWidth(constant: frame.width/3)
////        v.addSubview(subFirstView)
////        subFirstView.centerInSuperview()
//        return v
//    }()
//    lazy var subFirstView:UIView = {
//       let v = UIView(backgroundColor: #colorLiteral(red: 0.9999160171, green: 1, blue: 0.9998719096, alpha: 1))
////        v.constrainWidth(constant: 32)
////        v.constrainHeight(constant: 32)
//        v.layer.cornerRadius = 16
//        v.clipsToBounds=true
////        v.addSubview(firstLabel)
////        firstLabel.centerInSuperview()
//        return v
//    }()
//    lazy var firstLabel = UILabel(text: "1", font: .systemFont(ofSize: 16), textColor: .black)
//    lazy var secondView:UIView = {
//       let v = UIView(backgroundColor: #colorLiteral(red: 0.4011510015, green: 0.8188247085, blue: 0.7169284225, alpha: 1))
////        v.constrainWidth(constant: frame.width/3)
//        v.isUserInteractionEnabled=true
//        v.layer.cornerRadius = 16
//        v.clipsToBounds=true
////        v.addSubview(subSecondView)
////        subSecondView.centerInSuperview()
//        return v
//    }()
//    lazy var subSecondView:UIView = {
//       let v = UIView(backgroundColor: #colorLiteral(red: 0.4391762614, green: 0.4392417669, blue: 0.4391556382, alpha: 1))
////        v.constrainWidth(constant: 32)
////        v.constrainHeight(constant: 32)
//        v.layer.cornerRadius = 16
//        v.clipsToBounds=true
////        v.addSubview(secondLabel)
////        secondLabel.centerInSuperview()
//        return v
//    }()
//    lazy var secondLabel = UILabel(text: "2", font: .systemFont(ofSize: 16), textColor: .white)
//
//    lazy var thirdView:UIView = {
//       let v = UIView(backgroundColor: #colorLiteral(red: 0.9254121184, green: 0.9255419374, blue: 0.9253712296, alpha: 1))
////        v.constrainWidth(constant: frame.width/3)
//        v.isUserInteractionEnabled=true
//        v.layer.cornerRadius = 16
//        v.clipsToBounds=true
////        v.addSubview(subThirdView)
////        subThirdView.centerInSuperview()
//        return v
//    }()
//    lazy var subThirdView:UIView = {
//       let v = UIView(backgroundColor: #colorLiteral(red: 0.4391762614, green: 0.4392417669, blue: 0.4391556382, alpha: 1))
////        v.constrainWidth(constant: 32)
////        v.constrainHeight(constant: 32)
//        v.layer.cornerRadius = 16
//        v.clipsToBounds=true
////        v.addSubview(thirdLabel)
////        thirdLabel.centerInSuperview()
//        return v
//    }()
//    lazy var thirdLabel = UILabel(text: "3", font: .systemFont(ofSize: 16), textColor: .white)
//
//    lazy var mainStack = getStack(views: firstView,secondView,thirdView, spacing: -8, distribution: .fillEqually, axis: .horizontal)
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//    func setupViews()  {
//        backgroundColor = .blue
//        stack(mainStack)
////        firstView.constrainWidth(constant: frame.width/2)
//////        hstack(firstView,UIView(backgroundColor: .red))//,secondView,thirdView)
////        addSubViews(views: firstView)//,secondView,thirdView)
////////
////        firstView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
////        secondView.anchor(top: topAnchor, leading: firstView.trailingAnchor, bottom: bottomAnchor, trailing: nil)
////        thirdView.anchor(top: topAnchor, leading: secondView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
//
//    }
//}
//
//
//struct SSS:UIViewRepresentable {
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        
//    }
//    
//    
//    func makeUIView(context: Context) -> some UIView {
//        return CustomTopsView()
//    }
//}
//
//struct ContentViewS : View {
//    
//    var body: some View {
//        SSS()
//    }
//}
//
//struct SwiftUIView_PreviewsSS: PreviewProvider {
//    static var previews: some View {
//        ContentViewS()
//            .previewLayout(.fixed(width: 400, height: 100))
//    }
//}
