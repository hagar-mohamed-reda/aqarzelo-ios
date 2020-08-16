//
//  AppDetailRecommendHorizentalCollectionVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class AppDetailRecommendHorizentalCollectionVC: BaseCollectionVC {
    
    var aqarsArray = [AqarModel]()
    
    fileprivate let cellID = "cellID"
    var handleSelectedAqar:((AqarModel)->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollections()
        statusBarBackgroundColor()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.noDataFound(aqarsArray.count, text: "No Data Added Yet".localized)
        return aqarsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! LocationCollectionCell
        let aqar = aqarsArray[indexPath.item]
        
        cell.aqar = aqar
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aqar = aqarsArray[indexPath.item]
        handleSelectedAqar?(aqar)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2*8) / 3
        
        return .init(width: width, height: view.frame.height)
    }
    
    //MARK:-User methods
    
    func setupCollections() {
        collectionView.backgroundColor = .white
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.showsHorizontalScrollIndicator=false
        
        collectionView.backgroundColor = .white
        collectionView.register(LocationCollectionCell.self, forCellWithReuseIdentifier: cellID)
    }
}
