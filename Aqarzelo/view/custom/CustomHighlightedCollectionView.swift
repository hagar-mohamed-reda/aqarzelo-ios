//
//  CustomHighlightedCollectionView.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CustomHighlightedCollectionView: CustomBaseView {
    
    fileprivate let cellHidedId = "cellHidedId"
    var  aqarArray:[AqarModel] = [
    ]
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.delegate = self
        c.dataSource = self
        c.register(LocationCollectionCell.self, forCellWithReuseIdentifier: cellHidedId)
        c.constrainHeight(constant: 220)
        c.backgroundColor =  #colorLiteral(red: 0.207870394, green: 0.8542298079, blue: 0.7240723968, alpha: 1)
        return c
    }()
    
    override func setupViews() {
        addSubview(collectionView)
    }
}

extension CustomHighlightedCollectionView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aqarArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellHidedId, for: indexPath) as! LocationCollectionCell
        let aqar = aqarArray[indexPath.item]
        
        cell.aqar = aqar
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
