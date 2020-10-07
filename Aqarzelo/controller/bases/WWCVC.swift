//
//  WWCVC.swift
//  Aqarzelo
//
//  Created by Hossam on 10/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import SwiftUI

class WWCVC: BaseCollectionVC {
    
    fileprivate let cellId="cellId"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ZXC
        cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true

            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 1.0
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width-64, height: 120)
    }
    
    override func setupCollection() {
        collectionView.backgroundColor = .white
        collectionView.register(ZXC.self, forCellWithReuseIdentifier: cellId)
    }
}

class ZXC: BaseCollectionCell {
    
    lazy var sss:UIView = {
        let v = UIView(backgroundColor: .green)
//        v.layer.cornerRadius = 16
//        v.clipsToBounds=true
        return v
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        sss.setupShadow(opacity: 1, radius: 46, offset: .init(width: 0, height: 0), color: .red)
    }
    
    override func setupViews() {
        stack(sss)
    }
}




struct AAssA:UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return WWCVC()
    }
}

struct ContentViewsss : View {
    
    var body: some View {
        AAssA()
    }
}

struct SwiftUIView_Previewssss: PreviewProvider {
    static var previews: some View {
        ContentViewsss()
//            .previewLayout(.fixed(width: 400, height: 120))
    }
}
