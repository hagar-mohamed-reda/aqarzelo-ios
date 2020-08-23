//
//  HorizentalCollectionContactUsVC.swift
//  Aqarzelo
//
//  Created by Hossam on 8/9/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit


class HorizentalCollectionContactUsVC: BaseCollectionVC {
    
    fileprivate let cellId = "cellId"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4 * 8) / 6
        
        return .init(width: width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                // Define the initial state (Before the animation)
                cell.alpha = 0

                // Define the final state (After the animation)
                UIView.animate(withDuration: 0.5, animations: { cell.alpha = 1 })
                
                
        //        // Define the initial state (Before the animation)
        //        let rotationAngleInRadians = 90.0 * CGFloat(Double.pi/180.0)
        //        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
        //        cell.layer.transform = rotationTransform
        //
        //        // Define the final state (After the animation)
        //        UIView.animate(withDuration: 1.0, animations: { cell.layer.transform = CATransform3DIdentity })
                
                
        //        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        //        UIView.animate(withDuration: 0.5, animations: { cell.layer.transform = rotationTransform })

    }
    
    //MARK:-User methods
    
    override func setupCollection() {
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsHorizontalScrollIndicator=false

    }
}
